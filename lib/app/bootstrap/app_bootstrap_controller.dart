import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/constants/app_constants.dart';
import '../../core/local_storage/guest_local_store.dart';
import '../../core/preferences/app_preference_snapshot.dart';
import '../../core/session/app_session_snapshot.dart';
import '../../features/auth/domain/models/auth_action_result.dart';
import '../../features/auth/domain/models/user_profile_record.dart';
import '../../features/auth/domain/repositories/session_repository.dart';
import '../../features/auth/domain/repositories/user_preferences_repository.dart';
import '../../features/auth/domain/repositories/user_profile_repository.dart';
import '../../features/global_settings/data/platform/method_channel_widget_plugin_bridge.dart';
import '../../features/global_settings/domain/repositories/widget_plugin_bridge.dart';
import '../../features/today/data/local/local_today_widget_data_bridge.dart';
import '../../features/today/data/public/supabase_today_repository.dart';
import '../../features/today/domain/repositories/today_repository.dart';
import '../../features/today/domain/repositories/widget_data_bridge.dart';
import '../router/app_routes.dart';

class AppBootstrapController extends ChangeNotifier {
  AppBootstrapController({
    required GuestLocalStore guestLocalStore,
    required SessionRepository sessionRepository,
    required UserProfileRepository profileRepository,
    required UserPreferencesRepository preferencesRepository,
    TodayRepository? todayRepository,
    WidgetDataBridge? widgetDataBridge,
    WidgetPluginBridge? widgetPluginBridge,
  }) : _guestLocalStore = guestLocalStore,
       _sessionRepository = sessionRepository,
       _profileRepository = profileRepository,
       _preferencesRepository = preferencesRepository,
       _todayRepository = todayRepository ?? SupabaseTodayRepository(),
       _widgetDataBridge = widgetDataBridge ?? LocalTodayWidgetDataBridge(),
       _widgetPluginBridge =
           widgetPluginBridge ?? MethodChannelWidgetPluginBridge();

  final GuestLocalStore _guestLocalStore;
  final SessionRepository _sessionRepository;
  final UserProfileRepository _profileRepository;
  final UserPreferencesRepository _preferencesRepository;
  final TodayRepository _todayRepository;
  final WidgetDataBridge _widgetDataBridge;
  final WidgetPluginBridge _widgetPluginBridge;

  AppPreferenceSnapshot _preferences = AppPreferenceSnapshot.defaults();
  AppSessionSnapshot _session = AppSessionSnapshot.guest();
  UserProfileRecord? _profile;
  StreamSubscription<AppSessionSnapshot>? _sessionSubscription;

  bool _isInitializing = false;
  String? _initializationError;
  bool _authBusy = false;
  String? _authFeedbackMessage;
  String? _pendingAuthRedirect;
  String? _hydratedAccountUserId;

  bool get isInitializing => _isInitializing;
  String? get initializationError => _initializationError;
  bool get authBusy => _authBusy;
  String? get authFeedbackMessage => _authFeedbackMessage;
  bool get cloudSyncAvailable => _sessionRepository.isConfigured;
  bool get isGuestMode => !_session.isAuthenticated;
  bool get isAuthenticated => _session.isAuthenticated;
  String? get accountEmail => _session.email;
  String? get accountDisplayName =>
      _profile?.displayName ?? _session.displayName ?? 'Account user';
  String? get pendingAuthRedirect => _pendingAuthRedirect;

  bool get onboardingCompleted => _preferences.onboardingCompleted;
  bool get notificationsEnabled => _preferences.notificationsEnabled;
  TimeOfDay get dailyNotificationTime => _preferences.dailyNotificationTime;
  List<String> get selectedCategories => _preferences.selectedCategories;
  List<String> get availableCategories => AppConstants.v1Categories;
  String get preferredTranslationCode => _preferences.preferredTranslationCode;
  String get preferredTranslationLabel =>
      AppConstants.translationOptionFor(_preferences.preferredTranslationCode).label;
  SupportState get supportState => _preferences.supportState;
  WidgetPreviewStyle get widgetPreviewStyle => _preferences.widgetPreviewStyle;
  bool get widgetShowReference => _preferences.widgetShowReference;
  bool get widgetShowCategory => _preferences.widgetShowCategory;
  bool get widgetShowDate => _preferences.widgetShowDate;

  String get dailyNotificationLabel {
    final int hour = _preferences.dailyNotificationTime.hourOfPeriod == 0
        ? 12
        : _preferences.dailyNotificationTime.hourOfPeriod;
    final String minute = _preferences.dailyNotificationTime.minute.toString().padLeft(
      2,
      '0',
    );
    final String period =
        _preferences.dailyNotificationTime.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  Future<void> initialize() async {
    _isInitializing = true;
    _initializationError = null;
    notifyListeners();

    try {
      _preferences = await _guestLocalStore.load();
      _session = await _sessionRepository.getCurrentSession();
      await _loadActiveProfileAndPreferences();
      await _hydrateAccountBackedData();
      await _sessionSubscription?.cancel();
      _sessionSubscription = _sessionRepository.watchSessionChanges().listen(
        (AppSessionSnapshot snapshot) {
          unawaited(_handleSessionSnapshot(snapshot));
        },
      );
      await _syncWidgetPayload();
    } catch (error) {
      _initializationError =
          'Backend foundation bootstrap failed: ${error.toString()}';
    }

    _isInitializing = false;
    notifyListeners();
  }

  Future<void> _handleSessionSnapshot(AppSessionSnapshot snapshot) async {
    _session = snapshot;

    switch (snapshot.event) {
      case AppAuthEvent.passwordRecovery:
        _pendingAuthRedirect = AppRoutes.authResetPassword;
        _authFeedbackMessage = 'Set a new password to finish recovery.';
        break;
      case AppAuthEvent.signedIn:
        _pendingAuthRedirect = null;
        _authFeedbackMessage =
            'Signed in successfully. Refreshing account-backed preferences and today assignment on this device.';
        break;
      case AppAuthEvent.signedOut:
        _pendingAuthRedirect = null;
        _hydratedAccountUserId = null;
        _authFeedbackMessage =
            'Signed out. This device stays available in guest mode.';
        break;
      default:
        break;
    }

    await _loadActiveProfileAndPreferences();
    await _hydrateAccountBackedData(force: snapshot.event == AppAuthEvent.signedIn);
    await _syncWidgetPayload();
    notifyListeners();
  }

  Future<void> _loadActiveProfileAndPreferences() async {
    if (_session.isAuthenticated && _session.userId != null) {
      final String userId = _session.userId!;
      _profile = await _profileRepository.getProfile(userId);
      final AppPreferenceSnapshot? remoteSnapshot =
          await _preferencesRepository.getSnapshot(userId);
      if (remoteSnapshot != null) {
        _preferences = remoteSnapshot.copyWith(
          supportState: _preferences.supportState,
        );
        await _guestLocalStore.save(_preferences);
      }
      return;
    }

    _profile = null;
    _hydratedAccountUserId = null;
    _preferences = await _guestLocalStore.load();
  }

  Future<void> _hydrateAccountBackedData({bool force = false}) async {
    final String? userId = _session.userId;
    if (!_session.isAuthenticated || userId == null) {
      _hydratedAccountUserId = null;
      return;
    }

    if (!force && _hydratedAccountUserId == userId) {
      return;
    }

    try {
      await _todayRepository.syncTodayAssignment(
        selectedCategories: _preferences.selectedCategories,
        dailyRefreshTime: _preferences.dailyNotificationTime,
        preferredTranslationCode: _preferences.preferredTranslationCode,
      );
      _hydratedAccountUserId = userId;
    } catch (_) {
      if (force) {
        _authFeedbackMessage =
            'Signed in successfully. Account preferences loaded, and today will finish syncing the next time it resolves.';
      }
    }
  }

  void clearPendingAuthRedirect() {
    _pendingAuthRedirect = null;
    notifyListeners();
  }

  void clearAuthFeedback() {
    _authFeedbackMessage = null;
    notifyListeners();
  }

  void toggleCategory(String category) {
    final List<String> next = List<String>.from(_preferences.selectedCategories);
    if (next.contains(category)) {
      if (next.length == 1) return;
      next.remove(category);
    } else {
      next.add(category);
    }

    _preferences = _preferences.copyWith(selectedCategories: next);
    notifyListeners();
    unawaited(_persistPreferences());
  }

  void setDailyNotificationTime(TimeOfDay value) {
    _preferences = _preferences.copyWith(dailyNotificationTime: value);
    notifyListeners();
    unawaited(_persistPreferences());
  }

  void setNotificationsEnabled(bool value) {
    _preferences = _preferences.copyWith(notificationsEnabled: value);
    notifyListeners();
    unawaited(_persistPreferences());
  }

  void setPreferredTranslationCode(String value) {
    _preferences = _preferences.copyWith(
      preferredTranslationCode: AppConstants.sanitizeTranslationCode(value),
    );
    notifyListeners();
    unawaited(_persistPreferences());
  }

  void setWidgetPreviewStyle(WidgetPreviewStyle value) {
    _preferences = _preferences.copyWith(widgetPreviewStyle: value);
    notifyListeners();
    unawaited(_persistPreferences());
  }

  void setWidgetShowReference(bool value) {
    _preferences = _preferences.copyWith(widgetShowReference: value);
    notifyListeners();
    unawaited(_persistPreferences());
  }

  void setWidgetShowCategory(bool value) {
    _preferences = _preferences.copyWith(widgetShowCategory: value);
    notifyListeners();
    unawaited(_persistPreferences());
  }

  void setWidgetShowDate(bool value) {
    _preferences = _preferences.copyWith(widgetShowDate: value);
    notifyListeners();
    unawaited(_persistPreferences());
  }

  void completeOnboarding() {
    _preferences = _preferences.copyWith(onboardingCompleted: true);
    notifyListeners();
    unawaited(_persistPreferences());
  }

  void resetOnboarding() {
    _preferences = AppPreferenceSnapshot.defaults().copyWith(
      supportState: _preferences.supportState,
    );
    notifyListeners();
    unawaited(_persistPreferences());
  }

  void toggleSupportState() {
    _preferences = _preferences.copyWith(
      supportState: _preferences.supportState == SupportState.open
          ? SupportState.closed
          : SupportState.open,
    );
    notifyListeners();
    unawaited(_guestLocalStore.save(_preferences));
  }

  Future<AuthActionResult> signInWithEmail({
    required String email,
    required String password,
  }) async {
    return _runAuthAction(
      () => _sessionRepository.signInWithEmail(email: email, password: password),
    );
  }

  Future<AuthActionResult> signUpWithEmail({
    required String displayName,
    required String email,
    required String password,
  }) async {
    return _runAuthAction(
      () => _sessionRepository.signUpWithEmail(
        email: email,
        password: password,
        displayName: displayName,
      ),
    );
  }

  Future<AuthActionResult> sendPasswordResetEmail(String email) async {
    return _runAuthAction(() => _sessionRepository.sendPasswordResetEmail(email));
  }

  Future<AuthActionResult> updatePassword(String password) async {
    return _runAuthAction(() => _sessionRepository.updatePassword(password));
  }

  Future<AuthActionResult> signOut() async {
    return _runAuthAction(_sessionRepository.signOut);
  }

  Future<AuthActionResult> _runAuthAction(
    Future<AuthActionResult> Function() action,
  ) async {
    _authBusy = true;
    _authFeedbackMessage = null;
    notifyListeners();

    try {
      final AuthActionResult result = await action();
      _authFeedbackMessage = result.message;
      return result;
    } finally {
      _authBusy = false;
      notifyListeners();
    }
  }

  Future<void> _persistPreferences() async {
    await _guestLocalStore.save(_preferences);

    if (_session.isAuthenticated && _session.userId != null) {
      await _preferencesRepository.saveSnapshot(_session.userId!, _preferences);
    }

    await _syncWidgetPayload();
  }

  Future<void> _syncWidgetPayload() async {
    try {
      final payload = await _widgetDataBridge.getPayload(
        preferences: _preferences,
      );
      await _widgetPluginBridge.syncDailyVersePayload(payload: payload);
    } catch (_) {
      // Widget sync should never block app bootstrap or preference persistence.
    }
  }

  @override
  void dispose() {
    unawaited(_sessionSubscription?.cancel());
    super.dispose();
  }
}

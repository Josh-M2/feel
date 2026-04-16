import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/constants/app_constants.dart';
import '../../core/notifications/local_notification_scheduler.dart';
import '../../core/local_storage/guest_local_store.dart';
import '../../core/preferences/app_preference_snapshot.dart';
import '../../core/preferences/app_preference_sync_models.dart';
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

class AppBootstrapController extends ChangeNotifier with WidgetsBindingObserver {
  AppBootstrapController({
    required GuestLocalStore guestLocalStore,
    required SessionRepository sessionRepository,
    required UserProfileRepository profileRepository,
    required UserPreferencesRepository preferencesRepository,
    TodayRepository? todayRepository,
    WidgetDataBridge? widgetDataBridge,
    WidgetPluginBridge? widgetPluginBridge,
    LocalNotificationScheduler? notificationScheduler,
  }) : _guestLocalStore = guestLocalStore,
       _sessionRepository = sessionRepository,
       _profileRepository = profileRepository,
       _preferencesRepository = preferencesRepository,
       _todayRepository = todayRepository ?? SupabaseTodayRepository(),
       _widgetDataBridge = widgetDataBridge ?? LocalTodayWidgetDataBridge(),
       _notificationScheduler =
           notificationScheduler ?? LocalNotificationScheduler(),
       _widgetPluginBridge =
           widgetPluginBridge ?? MethodChannelWidgetPluginBridge();

  final GuestLocalStore _guestLocalStore;
  final SessionRepository _sessionRepository;
  final UserProfileRepository _profileRepository;
  final UserPreferencesRepository _preferencesRepository;
  final TodayRepository _todayRepository;
  final WidgetDataBridge _widgetDataBridge;
  final LocalNotificationScheduler _notificationScheduler;
  final WidgetPluginBridge _widgetPluginBridge;

  AppPreferenceSnapshot _preferences = AppPreferenceSnapshot.defaults();
  AppPreferenceLocalState _preferenceState = AppPreferenceLocalState.defaults();
  AppSessionSnapshot _session = AppSessionSnapshot.guest();
  UserProfileRecord? _profile;
  StreamSubscription<AppSessionSnapshot>? _sessionSubscription;
  Timer? _pendingPreferenceSyncTimer;
  final StreamController<String> _navigationRequests =
      StreamController<String>.broadcast();

  bool _isInitializing = false;
  String? _initializationError;
  bool _authBusy = false;
  String? _authFeedbackMessage;
  String? _pendingAuthRedirect;
  String? _hydratedAccountUserId;
  bool _reconcilingPreferences = false;
  bool _widgetObserverRegistered = false;
  String? _queuedNavigationRoute;

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
  WidgetAccentTone get widgetAccentTone => _preferences.widgetAccentTone;
  bool get widgetShowReference => _preferences.widgetShowReference;
  bool get widgetShowCategory => _preferences.widgetShowCategory;
  bool get widgetShowDate => _preferences.widgetShowDate;
  Stream<String> get navigationRequests => _navigationRequests.stream;

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
      if (!_widgetObserverRegistered) {
        WidgetsBinding.instance.addObserver(this);
        _widgetObserverRegistered = true;
      }

      await _notificationScheduler.initialize(
        onRouteSelected: _queueNavigationRoute,
      );

      _preferenceState = await _guestLocalStore.load();
      _preferences = _preferenceState.snapshot;
      _session = await _sessionRepository.getCurrentSession();

      await _loadActiveProfile();
      await _reconcileSignedInPreferences(reason: 'bootstrap');
      await _hydrateAccountBackedData();
      await _sessionSubscription?.cancel();
      _sessionSubscription = _sessionRepository.watchSessionChanges().listen(
        (AppSessionSnapshot snapshot) {
          unawaited(_handleSessionSnapshot(snapshot));
        },
      );
      _configurePendingPreferenceSyncRetry();
      await _syncWidgetPayload();
      await _syncDailyNotifications();
    } catch (error) {
      _initializationError =
          'Backend foundation bootstrap failed: ${error.toString()}';
    }

    _isInitializing = false;
    notifyListeners();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      unawaited(_reconcileSignedInPreferences(reason: 'app-resumed'));
      // Rebuild local reminders when the app returns so device-local time and
      // timezone changes are reflected without needing a backend round trip.
      unawaited(_syncDailyNotifications());
    }
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

    if (_session.isAuthenticated) {
      await _loadActiveProfile();
      await _reconcileSignedInPreferences(
        reason: 'session-${snapshot.event.name}',
      );
      await _hydrateAccountBackedData(force: snapshot.event == AppAuthEvent.signedIn);
    } else {
      _profile = null;
      _hydratedAccountUserId = null;
      _preferenceState = await _guestLocalStore.load();
      _preferences = _preferenceState.snapshot;
    }

    _configurePendingPreferenceSyncRetry();
    await _syncWidgetPayload();
    await _syncDailyNotifications();
    notifyListeners();
  }

  Future<void> _loadActiveProfile() async {
    if (_session.isAuthenticated && _session.userId != null) {
      try {
        _profile = await _profileRepository.getProfile(_session.userId!);
      } catch (_) {
        _profile = null;
      }
      return;
    }

    _profile = null;
    _hydratedAccountUserId = null;
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

    _applyPreferenceMutation(
      nextPreferences: _preferences.copyWith(selectedCategories: next),
      domains: const <AppPreferenceDomain>{AppPreferenceDomain.content},
    );
  }

  void setDailyNotificationTime(TimeOfDay value) {
    _applyPreferenceMutation(
      nextPreferences: _preferences.copyWith(dailyNotificationTime: value),
      domains: const <AppPreferenceDomain>{AppPreferenceDomain.notifications},
    );
  }

  Future<void> setNotificationsEnabled(bool value) async {
    if (value) {
      final bool granted = await _notificationScheduler.requestPermissions();
      if (!granted) {
        _authFeedbackMessage =
            'Notification permission is still off on this device, so reminders could not be enabled yet.';
        notifyListeners();
        return;
      }
    }

    _applyPreferenceMutation(
      nextPreferences: _preferences.copyWith(notificationsEnabled: value),
      domains: const <AppPreferenceDomain>{AppPreferenceDomain.notifications},
    );
  }

  void setPreferredTranslationCode(String value) {
    _applyPreferenceMutation(
      nextPreferences: _preferences.copyWith(
        preferredTranslationCode: AppConstants.sanitizeTranslationCode(value),
      ),
      domains: const <AppPreferenceDomain>{AppPreferenceDomain.content},
    );
  }

  void setWidgetPreviewStyle(WidgetPreviewStyle value) {
    _applyPreferenceMutation(
      nextPreferences: _preferences.copyWith(widgetPreviewStyle: value),
      domains: const <AppPreferenceDomain>{AppPreferenceDomain.widget},
    );
  }

  void setWidgetAccentTone(WidgetAccentTone value) {
    _applyPreferenceMutation(
      nextPreferences: _preferences.copyWith(widgetAccentTone: value),
      domains: const <AppPreferenceDomain>{AppPreferenceDomain.widget},
    );
  }

  void setWidgetShowReference(bool value) {
    _applyPreferenceMutation(
      nextPreferences: _preferences.copyWith(widgetShowReference: value),
      domains: const <AppPreferenceDomain>{AppPreferenceDomain.widget},
    );
  }

  void setWidgetShowCategory(bool value) {
    _applyPreferenceMutation(
      nextPreferences: _preferences.copyWith(widgetShowCategory: value),
      domains: const <AppPreferenceDomain>{AppPreferenceDomain.widget},
    );
  }

  void setWidgetShowDate(bool value) {
    _applyPreferenceMutation(
      nextPreferences: _preferences.copyWith(widgetShowDate: value),
      domains: const <AppPreferenceDomain>{AppPreferenceDomain.widget},
    );
  }

  void completeOnboarding() {
    _applyPreferenceMutation(
      nextPreferences: _preferences.copyWith(onboardingCompleted: true),
      domains: const <AppPreferenceDomain>{AppPreferenceDomain.content},
    );
  }

  void resetOnboarding() {
    _applyPreferenceMutation(
      nextPreferences: AppPreferenceSnapshot.defaults().copyWith(
        supportState: _preferences.supportState,
      ),
      domains: const <AppPreferenceDomain>{
        AppPreferenceDomain.content,
        AppPreferenceDomain.notifications,
        AppPreferenceDomain.widget,
      },
    );
  }

  void toggleSupportState() {
    _preferences = _preferences.copyWith(
      supportState: _preferences.supportState == SupportState.open
          ? SupportState.closed
          : SupportState.open,
    );
    _preferenceState = _preferenceState.copyWith(snapshot: _preferences);
    notifyListeners();
    unawaited(_persistLocalPreferenceState());
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

  void _applyPreferenceMutation({
    required AppPreferenceSnapshot nextPreferences,
    required Set<AppPreferenceDomain> domains,
  }) {
    final DateTime timestamp = DateTime.now().toUtc();
    _preferences = nextPreferences;

    AppPreferenceLocalState nextState = _preferenceState.copyWith(
      snapshot: nextPreferences,
    );
    for (final AppPreferenceDomain domain in domains) {
      nextState = nextState.markLocalChange(
        domain: domain,
        timestamp: timestamp,
        pendingUserId: _session.isAuthenticated ? _session.userId : null,
        snapshot: nextPreferences,
      );
    }

    _preferenceState = nextState;
    notifyListeners();
    unawaited(_persistPreferences(domains: domains));
  }

  Future<void> _persistPreferences({
    required Set<AppPreferenceDomain> domains,
  }) async {
    await _persistLocalPreferenceState();
    if (_session.isAuthenticated && _session.userId != null) {
      await _reconcileSignedInPreferences(
        reason: 'local-${domains.map((AppPreferenceDomain item) => item.name).join('-')}',
      );
    } else {
      _configurePendingPreferenceSyncRetry();
    }
    await _syncWidgetPayload();
    await _syncDailyNotifications();
  }

  Future<void> _persistLocalPreferenceState() async {
    await _guestLocalStore.save(_preferenceState.copyWith(snapshot: _preferences));
  }

  Future<void> _reconcileSignedInPreferences({
    required String reason,
  }) async {
    final String? userId = _session.userId;
    if (!_session.isAuthenticated || userId == null || _reconcilingPreferences) {
      return;
    }

    _reconcilingPreferences = true;
    try {
      AccountPreferenceSyncSnapshot? remoteSnapshot;
      try {
        remoteSnapshot = await _preferencesRepository.getSyncSnapshot(userId);
      } catch (_) {
        remoteSnapshot = null;
      }

      AppPreferenceSnapshot mergedPreferences = _preferences;
      AppPreferenceLocalState mergedState = _preferenceState.copyWith(
        snapshot: _preferences,
      );
      final Set<AppPreferenceDomain> domainsToPush = <AppPreferenceDomain>{};

      if (remoteSnapshot != null) {
        for (final AppPreferenceDomain domain in AppPreferenceDomain.values) {
          final AppPreferenceDomainSyncState localDomainState = mergedState.stateFor(
            domain,
          );
          final DateTime? remoteUpdatedAt = remoteSnapshot.updatedAtFor(domain);
          final bool localPending = localDomainState.hasPendingSyncForUser(userId);

          if (remoteUpdatedAt == null) {
            if (localPending) {
              domainsToPush.add(domain);
            }
            continue;
          }

          if (localPending && localDomainState.updatedAt.isAfter(remoteUpdatedAt)) {
            domainsToPush.add(domain);
            continue;
          }

          mergedPreferences = mergedPreferences.copyDomainFrom(
            other: remoteSnapshot.snapshot,
            domain: domain,
          );
          mergedState = mergedState.markSynced(
            domain: domain,
            timestamp: remoteUpdatedAt,
            userId: userId,
            snapshot: mergedPreferences,
          );
        }
      } else {
        for (final AppPreferenceDomain domain in AppPreferenceDomain.values) {
          if (mergedState.stateFor(domain).hasPendingSyncForUser(userId)) {
            domainsToPush.add(domain);
          }
        }
      }

      _preferences = mergedPreferences;
      _preferenceState = mergedState.copyWith(snapshot: mergedPreferences);
      await _persistLocalPreferenceState();

      if (domainsToPush.isNotEmpty) {
        final AccountPreferenceSyncSnapshot? savedSnapshot =
            await _preferencesRepository.saveSnapshot(
              userId: userId,
              snapshot: _preferences,
              domains: domainsToPush,
            );
        if (savedSnapshot != null) {
          _applyRemotePreferenceSnapshot(savedSnapshot, userId: userId);
          await _persistLocalPreferenceState();
        }
      }
    } catch (_) {
      // Signed-in offline mode should keep the local cache usable without surfacing sync failures.
    } finally {
      _reconcilingPreferences = false;
      _configurePendingPreferenceSyncRetry();
      notifyListeners();
    }
  }

  void _applyRemotePreferenceSnapshot(
    AccountPreferenceSyncSnapshot remoteSnapshot, {
    required String userId,
  }) {
    AppPreferenceSnapshot nextPreferences = _preferences;
    AppPreferenceLocalState nextState = _preferenceState.copyWith(
      snapshot: _preferences,
    );

    for (final AppPreferenceDomain domain in AppPreferenceDomain.values) {
      final DateTime? remoteUpdatedAt = remoteSnapshot.updatedAtFor(domain);
      if (remoteUpdatedAt == null) {
        continue;
      }

      nextPreferences = nextPreferences.copyDomainFrom(
        other: remoteSnapshot.snapshot,
        domain: domain,
      );
      nextState = nextState.markSynced(
        domain: domain,
        timestamp: remoteUpdatedAt,
        userId: userId,
        snapshot: nextPreferences,
      );
    }

    _preferences = nextPreferences;
    _preferenceState = nextState.copyWith(snapshot: nextPreferences);
  }

  void _configurePendingPreferenceSyncRetry() {
    _pendingPreferenceSyncTimer?.cancel();
    _pendingPreferenceSyncTimer = null;

    if (!_preferenceState.hasPendingSyncForUser(_session.userId)) {
      return;
    }

    _pendingPreferenceSyncTimer = Timer.periodic(
      const Duration(seconds: 45),
      (_) {
        if (_reconcilingPreferences) {
          return;
        }
        unawaited(_reconcileSignedInPreferences(reason: 'retry'));
      },
    );
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

  Future<void> _syncDailyNotifications() async {
    try {
      String? lockedTodayCategory;
      if (_preferences.notificationsEnabled) {
        final todayVerse = await _todayRepository.getTodayVerse(
          selectedCategories: _preferences.selectedCategories,
          dailyRefreshTime: _preferences.dailyNotificationTime,
          preferredTranslationCode: _preferences.preferredTranslationCode,
        );
        lockedTodayCategory = todayVerse.category;
      }

      await _notificationScheduler.syncDailyReminders(
        DailyReminderScheduleRequest(
          enabled: _preferences.notificationsEnabled,
          localTime: _preferences.dailyNotificationTime,
          selectedCategories: _preferences.selectedCategories,
          lockedTodayCategory: lockedTodayCategory,
        ),
      );
    } catch (_) {
      // Reminder scheduling should not block app use if permissions or platform APIs fail.
    }
  }

  void _queueNavigationRoute(String route) {
    final String normalized = route.trim();
    if (normalized.isEmpty) {
      return;
    }
    _queuedNavigationRoute = normalized;
    if (!_navigationRequests.isClosed) {
      _navigationRequests.add(normalized);
    }
  }

  String? consumeQueuedNavigationRoute() {
    final String? route = _queuedNavigationRoute;
    _queuedNavigationRoute = null;
    return route;
  }

  @override
  void dispose() {
    if (_widgetObserverRegistered) {
      WidgetsBinding.instance.removeObserver(this);
    }
    _pendingPreferenceSyncTimer?.cancel();
    unawaited(_navigationRequests.close());
    unawaited(_sessionSubscription?.cancel());
    super.dispose();
  }
}

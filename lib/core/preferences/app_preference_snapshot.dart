import 'package:flutter/material.dart';

import '../constants/app_constants.dart';

enum SupportState { open, closed }

enum WidgetPreviewStyle { cozy, minimal }

enum AppPreferenceDomain { content, notifications, widget }

class AppPreferenceSnapshot {
  const AppPreferenceSnapshot({
    required this.onboardingCompleted,
    required this.notificationsEnabled,
    required this.dailyNotificationTime,
    required this.selectedCategories,
    required this.preferredTranslationCode,
    required this.supportState,
    required this.widgetPreviewStyle,
    required this.widgetShowReference,
    required this.widgetShowCategory,
    required this.widgetShowDate,
  });

  final bool onboardingCompleted;
  final bool notificationsEnabled;
  final TimeOfDay dailyNotificationTime;
  final List<String> selectedCategories;
  final String preferredTranslationCode;
  final SupportState supportState;
  final WidgetPreviewStyle widgetPreviewStyle;
  final bool widgetShowReference;
  final bool widgetShowCategory;
  final bool widgetShowDate;

  factory AppPreferenceSnapshot.defaults() {
    return const AppPreferenceSnapshot(
      onboardingCompleted: false,
      notificationsEnabled: false,
      dailyNotificationTime: TimeOfDay(hour: 7, minute: 0),
      selectedCategories: <String>['Guidance', 'Hope', 'Strength'],
      preferredTranslationCode: AppConstants.defaultTranslationCode,
      supportState: SupportState.open,
      widgetPreviewStyle: WidgetPreviewStyle.cozy,
      widgetShowReference: true,
      widgetShowCategory: true,
      widgetShowDate: true,
    );
  }

  AppPreferenceSnapshot copyWith({
    bool? onboardingCompleted,
    bool? notificationsEnabled,
    TimeOfDay? dailyNotificationTime,
    List<String>? selectedCategories,
    String? preferredTranslationCode,
    SupportState? supportState,
    WidgetPreviewStyle? widgetPreviewStyle,
    bool? widgetShowReference,
    bool? widgetShowCategory,
    bool? widgetShowDate,
  }) {
    return AppPreferenceSnapshot(
      onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      dailyNotificationTime: dailyNotificationTime ?? this.dailyNotificationTime,
      selectedCategories: List<String>.unmodifiable(
        selectedCategories ?? this.selectedCategories,
      ),
      preferredTranslationCode: AppConstants.sanitizeTranslationCode(
        preferredTranslationCode ?? this.preferredTranslationCode,
      ),
      supportState: supportState ?? this.supportState,
      widgetPreviewStyle: widgetPreviewStyle ?? this.widgetPreviewStyle,
      widgetShowReference: widgetShowReference ?? this.widgetShowReference,
      widgetShowCategory: widgetShowCategory ?? this.widgetShowCategory,
      widgetShowDate: widgetShowDate ?? this.widgetShowDate,
    );
  }

  Map<String, dynamic> toLocalJson() {
    return <String, dynamic>{
      'onboardingCompleted': onboardingCompleted,
      'notificationsEnabled': notificationsEnabled,
      'dailyNotificationHour': dailyNotificationTime.hour,
      'dailyNotificationMinute': dailyNotificationTime.minute,
      'selectedCategories': selectedCategories,
      'preferredTranslationCode': preferredTranslationCode,
      'supportState': supportState.name,
      'widgetPreviewStyle': widgetPreviewStyle.name,
      'widgetShowReference': widgetShowReference,
      'widgetShowCategory': widgetShowCategory,
      'widgetShowDate': widgetShowDate,
    };
  }

  factory AppPreferenceSnapshot.fromLocalJson(Map<String, dynamic> json) {
    final List<String> selected = _sanitizeCategories(
      (json['selectedCategories'] as List<dynamic>? ?? const <dynamic>[])
          .map((dynamic item) => item.toString())
          .toList(),
    );

    return AppPreferenceSnapshot(
      onboardingCompleted: json['onboardingCompleted'] == true,
      notificationsEnabled: json['notificationsEnabled'] == true,
      dailyNotificationTime: TimeOfDay(
        hour: (json['dailyNotificationHour'] as int?) ?? 7,
        minute: (json['dailyNotificationMinute'] as int?) ?? 0,
      ),
      selectedCategories: selected,
      preferredTranslationCode: AppConstants.sanitizeTranslationCode(
        json['preferredTranslationCode']?.toString(),
      ),
      supportState: _supportStateFromName(json['supportState']?.toString()),
      widgetPreviewStyle: _widgetPreviewStyleFromName(
        json['widgetPreviewStyle']?.toString(),
      ),
      widgetShowReference: json['widgetShowReference'] != false,
      widgetShowCategory: json['widgetShowCategory'] != false,
      widgetShowDate: json['widgetShowDate'] != false,
    );
  }

  Map<String, dynamic> toUserContentPreferencesRow({required String userId}) {
    return <String, dynamic>{
      'user_id': userId,
      'onboarding_completed': onboardingCompleted,
      'preferred_translation_code': preferredTranslationCode,
    };
  }

  Map<String, dynamic> toUserNotificationPreferencesRow({
    required String userId,
  }) {
    return <String, dynamic>{
      'user_id': userId,
      'notifications_enabled': notificationsEnabled,
      'notification_time_local':
          '${dailyNotificationTime.hour.toString().padLeft(2, '0')}:${dailyNotificationTime.minute.toString().padLeft(2, '0')}:00',
    };
  }

  Map<String, dynamic> toUserWidgetPreferencesRow({required String userId}) {
    return <String, dynamic>{
      'user_id': userId,
      'widget_preview_style': widgetPreviewStyle.name,
      'widget_show_reference': widgetShowReference,
      'widget_show_category': widgetShowCategory,
      'widget_show_date': widgetShowDate,
    };
  }

  factory AppPreferenceSnapshot.fromRemote({
    Map<String, dynamic>? contentRow,
    Map<String, dynamic>? notificationRow,
    Map<String, dynamic>? widgetRow,
    required List<String> categories,
    SupportState supportState = SupportState.open,
  }) {
    final Map<String, dynamic> resolvedContentRow =
        contentRow ?? const <String, dynamic>{};
    final Map<String, dynamic> resolvedNotificationRow =
        notificationRow ?? const <String, dynamic>{};
    final Map<String, dynamic> resolvedWidgetRow =
        widgetRow ?? const <String, dynamic>{};
    return AppPreferenceSnapshot(
      onboardingCompleted: resolvedContentRow['onboarding_completed'] == true,
      notificationsEnabled:
          resolvedNotificationRow['notifications_enabled'] == true,
      dailyNotificationTime: _timeOfDayFromRemote(
        resolvedNotificationRow['notification_time_local']?.toString(),
      ),
      selectedCategories: _sanitizeCategories(categories),
      preferredTranslationCode: AppConstants.sanitizeTranslationCode(
        resolvedContentRow['preferred_translation_code']?.toString(),
      ),
      supportState: supportState,
      widgetPreviewStyle: _widgetPreviewStyleFromName(
        resolvedWidgetRow['widget_preview_style']?.toString(),
      ),
      widgetShowReference: resolvedWidgetRow['widget_show_reference'] != false,
      widgetShowCategory: resolvedWidgetRow['widget_show_category'] != false,
      widgetShowDate: resolvedWidgetRow['widget_show_date'] != false,
    );
  }

  AppPreferenceSnapshot copyDomainFrom({
    required AppPreferenceSnapshot other,
    required AppPreferenceDomain domain,
  }) {
    switch (domain) {
      case AppPreferenceDomain.content:
        return copyWith(
          onboardingCompleted: other.onboardingCompleted,
          selectedCategories: other.selectedCategories,
          preferredTranslationCode: other.preferredTranslationCode,
        );
      case AppPreferenceDomain.notifications:
        return copyWith(
          notificationsEnabled: other.notificationsEnabled,
          dailyNotificationTime: other.dailyNotificationTime,
        );
      case AppPreferenceDomain.widget:
        return copyWith(
          widgetPreviewStyle: other.widgetPreviewStyle,
          widgetShowReference: other.widgetShowReference,
          widgetShowCategory: other.widgetShowCategory,
          widgetShowDate: other.widgetShowDate,
        );
    }
  }

  static TimeOfDay _timeOfDayFromRemote(String? value) {
    if (value == null || value.isEmpty) {
      return const TimeOfDay(hour: 7, minute: 0);
    }

    final List<String> parts = value.split(':');
    if (parts.length < 2) {
      return const TimeOfDay(hour: 7, minute: 0);
    }

    return TimeOfDay(
      hour: int.tryParse(parts[0]) ?? 7,
      minute: int.tryParse(parts[1]) ?? 0,
    );
  }

  static List<String> _sanitizeCategories(List<String> raw) {
    final Set<String> allowed = AppConstants.v1Categories.toSet();
    final List<String> selected = raw.where(allowed.contains).toList();
    if (selected.isEmpty) {
      return const <String>['Guidance', 'Hope', 'Strength'];
    }
    return List<String>.unmodifiable(selected);
  }

  static SupportState _supportStateFromName(String? name) {
    return SupportState.values.firstWhere(
      (SupportState value) => value.name == name,
      orElse: () => SupportState.open,
    );
  }

  static WidgetPreviewStyle _widgetPreviewStyleFromName(String? name) {
    return WidgetPreviewStyle.values.firstWhere(
      (WidgetPreviewStyle value) => value.name == name,
      orElse: () => WidgetPreviewStyle.cozy,
    );
  }
}

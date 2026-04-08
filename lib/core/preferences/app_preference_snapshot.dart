import 'package:flutter/material.dart';

import '../constants/app_constants.dart';

enum SupportState { open, closed }

enum WidgetPreviewStyle { cozy, minimal }

class AppPreferenceSnapshot {
  const AppPreferenceSnapshot({
    required this.onboardingCompleted,
    required this.notificationsEnabled,
    required this.dailyNotificationTime,
    required this.selectedCategories,
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
      supportState: _supportStateFromName(json['supportState']?.toString()),
      widgetPreviewStyle: _widgetPreviewStyleFromName(
        json['widgetPreviewStyle']?.toString(),
      ),
      widgetShowReference: json['widgetShowReference'] != false,
      widgetShowCategory: json['widgetShowCategory'] != false,
      widgetShowDate: json['widgetShowDate'] != false,
    );
  }

  Map<String, dynamic> toUserPreferencesRow({required String userId}) {
    return <String, dynamic>{
      'user_id': userId,
      'onboarding_completed': onboardingCompleted,
      'notifications_enabled': notificationsEnabled,
      'notification_time_local':
          '${dailyNotificationTime.hour.toString().padLeft(2, '0')}:${dailyNotificationTime.minute.toString().padLeft(2, '0')}:00',
      'widget_preview_style': widgetPreviewStyle.name,
      'widget_show_reference': widgetShowReference,
      'widget_show_category': widgetShowCategory,
      'widget_show_date': widgetShowDate,
    };
  }

  factory AppPreferenceSnapshot.fromRemote({
    required Map<String, dynamic> row,
    required List<String> categories,
    SupportState supportState = SupportState.open,
  }) {
    return AppPreferenceSnapshot(
      onboardingCompleted: row['onboarding_completed'] == true,
      notificationsEnabled: row['notifications_enabled'] == true,
      dailyNotificationTime: _timeOfDayFromRemote(
        row['notification_time_local']?.toString(),
      ),
      selectedCategories: _sanitizeCategories(categories),
      supportState: supportState,
      widgetPreviewStyle: _widgetPreviewStyleFromName(
        row['widget_preview_style']?.toString(),
      ),
      widgetShowReference: row['widget_show_reference'] != false,
      widgetShowCategory: row['widget_show_category'] != false,
      widgetShowDate: row['widget_show_date'] != false,
    );
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

import 'package:flutter/material.dart';

import '../../core/constants/app_constants.dart';

enum SupportState { open, closed }

enum WidgetPreviewStyle { cozy, minimal }

class AppBootstrapController extends ChangeNotifier {
  bool _onboardingCompleted = false;
  bool _notificationsEnabled = false;
  TimeOfDay _dailyNotificationTime = const TimeOfDay(hour: 7, minute: 0);
  final Set<String> _selectedCategories = <String>{
    'Guidance',
    'Hope',
    'Strength',
  };
  SupportState _supportState = SupportState.open;

  WidgetPreviewStyle _widgetPreviewStyle = WidgetPreviewStyle.cozy;
  bool _widgetShowReference = true;
  bool _widgetShowCategory = true;
  bool _widgetShowDate = true;

  bool get onboardingCompleted => _onboardingCompleted;
  bool get notificationsEnabled => _notificationsEnabled;
  TimeOfDay get dailyNotificationTime => _dailyNotificationTime;
  List<String> get selectedCategories =>
      _selectedCategories.toList(growable: false);
  List<String> get availableCategories => AppConstants.v1Categories;
  SupportState get supportState => _supportState;
  bool get isGuestMode => true;

  WidgetPreviewStyle get widgetPreviewStyle => _widgetPreviewStyle;
  bool get widgetShowReference => _widgetShowReference;
  bool get widgetShowCategory => _widgetShowCategory;
  bool get widgetShowDate => _widgetShowDate;

  String get dailyNotificationLabel {
    final int hour = _dailyNotificationTime.hourOfPeriod == 0
        ? 12
        : _dailyNotificationTime.hourOfPeriod;
    final String minute = _dailyNotificationTime.minute.toString().padLeft(
      2,
      '0',
    );
    final String period = _dailyNotificationTime.period == DayPeriod.am
        ? 'AM'
        : 'PM';
    return '$hour:$minute $period';
  }

  void toggleCategory(String category) {
    if (_selectedCategories.contains(category)) {
      if (_selectedCategories.length == 1) return;
      _selectedCategories.remove(category);
    } else {
      _selectedCategories.add(category);
    }
    notifyListeners();
  }

  void setDailyNotificationTime(TimeOfDay value) {
    _dailyNotificationTime = value;
    notifyListeners();
  }

  void setNotificationsEnabled(bool value) {
    _notificationsEnabled = value;
    notifyListeners();
  }

  void setWidgetPreviewStyle(WidgetPreviewStyle value) {
    _widgetPreviewStyle = value;
    notifyListeners();
  }

  void setWidgetShowReference(bool value) {
    _widgetShowReference = value;
    notifyListeners();
  }

  void setWidgetShowCategory(bool value) {
    _widgetShowCategory = value;
    notifyListeners();
  }

  void setWidgetShowDate(bool value) {
    _widgetShowDate = value;
    notifyListeners();
  }

  void completeOnboarding() {
    _onboardingCompleted = true;
    notifyListeners();
  }

  void resetOnboarding() {
    _onboardingCompleted = false;
    _notificationsEnabled = false;
    _dailyNotificationTime = const TimeOfDay(hour: 7, minute: 0);
    _selectedCategories
      ..clear()
      ..addAll(<String>{'Guidance', 'Hope', 'Strength'});
    _widgetPreviewStyle = WidgetPreviewStyle.cozy;
    _widgetShowReference = true;
    _widgetShowCategory = true;
    _widgetShowDate = true;
    notifyListeners();
  }

  void toggleSupportState() {
    _supportState = _supportState == SupportState.open
        ? SupportState.closed
        : SupportState.open;
    notifyListeners();
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../../app/router/app_routes.dart';
import 'daily_notification_copy_bank.dart';

class DailyReminderScheduleRequest {
  const DailyReminderScheduleRequest({
    required this.enabled,
    required this.localTime,
    required this.selectedCategories,
    this.lockedTodayCategory,
  });

  final bool enabled;
  // Local device wall-clock time chosen by the user for reminders.
  final TimeOfDay localTime;
  final List<String> selectedCategories;
  final String? lockedTodayCategory;
}

class LocalNotificationScheduler {
  LocalNotificationScheduler({FlutterLocalNotificationsPlugin? plugin})
    : _plugin = plugin ?? _sharedPlugin;

  final FlutterLocalNotificationsPlugin _plugin;
  static final FlutterLocalNotificationsPlugin _sharedPlugin =
      FlutterLocalNotificationsPlugin();

  static const String _channelId = 'daily_verse_reminders';
  static const String _channelName = 'Daily verse reminders';
  static const String _channelDescription =
      'Daily reminders that open the Today experience.';
  static const int _notificationIdBase = 41000;
  static const int _debugNotificationNowId = 51001;
  static const int _debugNotificationScheduledId = 51002;
  static const int _scheduledDays = 14;
  static const String _defaultRoutePayload = AppRoutes.todayHome;

  static bool _sharedInitialized = false;
  static const Map<int, String> _timezoneOffsetFallbacks = <int, String>{
    -660: 'Pacific/Pago_Pago',
    -600: 'Pacific/Honolulu',
    -540: 'America/Anchorage',
    -480: 'America/Los_Angeles',
    -420: 'America/Denver',
    -360: 'America/Chicago',
    -300: 'America/New_York',
    -240: 'America/Halifax',
    -210: 'America/St_Johns',
    -180: 'America/Sao_Paulo',
    -60: 'Atlantic/Azores',
    0: 'UTC',
    60: 'Europe/Paris',
    120: 'Europe/Helsinki',
    180: 'Europe/Moscow',
    210: 'Asia/Tehran',
    240: 'Asia/Dubai',
    270: 'Asia/Kabul',
    330: 'Asia/Kolkata',
    345: 'Asia/Kathmandu',
    390: 'Asia/Yangon',
    420: 'Asia/Bangkok',
    480: 'Asia/Singapore',
    540: 'Asia/Tokyo',
    570: 'Australia/Darwin',
    600: 'Australia/Brisbane',
    630: 'Australia/Adelaide',
    660: 'Pacific/Guadalcanal',
    720: 'Pacific/Auckland',
  };

  Future<void> initialize({
    required void Function(String route) onRouteSelected,
  }) async {
    if (!_sharedInitialized) {
      tz.initializeTimeZones();
      final tz.Location localLocation = await _resolveLocalLocation();
      tz.setLocalLocation(localLocation);
      debugPrint('Notification scheduler DateTime.now(): ${DateTime.now()}');
      debugPrint('Notification scheduler tz.local: ${localLocation.name}');
      debugPrint(
        'Notification scheduler local now: ${tz.TZDateTime.now(tz.local)}',
      );

      const InitializationSettings initializationSettings =
          InitializationSettings(
            android: AndroidInitializationSettings('@mipmap/ic_launcher'),
            iOS: DarwinInitializationSettings(
              requestAlertPermission: false,
              requestBadgePermission: false,
              requestSoundPermission: false,
            ),
          );

      await _plugin.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: (NotificationResponse response) {
          onRouteSelected(_routeFromPayload(response.payload));
        },
      );

      final NotificationAppLaunchDetails? launchDetails = await _plugin
          .getNotificationAppLaunchDetails();
      if (launchDetails?.didNotificationLaunchApp == true) {
        onRouteSelected(
          _routeFromPayload(launchDetails?.notificationResponse?.payload),
        );
      }
      _sharedInitialized = true;
    }

    final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
        _plugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >();
    await androidImplementation?.createNotificationChannel(
      const AndroidNotificationChannel(
        _channelId,
        _channelName,
        description: _channelDescription,
        importance: Importance.high,
      ),
    );
  }

  Future<bool> requestPermissions() async {
    bool granted = true;

    final dynamic androidImplementation = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    final bool? androidGranted = await androidImplementation
        ?.requestNotificationsPermission();
    if (androidGranted != null) {
      granted = granted && androidGranted;
    }
    try {
      final bool? exactAlarmGranted =
          await androidImplementation?.requestExactAlarmsPermission();
      if (exactAlarmGranted != null) {
        granted = granted && exactAlarmGranted;
      }
    } catch (_) {
      // Older plugin/platform combinations may not expose exact-alarm prompts.
    }

    final IOSFlutterLocalNotificationsPlugin? iosImplementation = _plugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >();
    final bool? iosGranted = await iosImplementation?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
    if (iosGranted != null) {
      granted = granted && iosGranted;
    }

    final MacOSFlutterLocalNotificationsPlugin? macosImplementation = _plugin
        .resolvePlatformSpecificImplementation<
          MacOSFlutterLocalNotificationsPlugin
        >();
    final bool? macosGranted = await macosImplementation?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
    if (macosGranted != null) {
      granted = granted && macosGranted;
    }

    return granted;
  }

  Future<void> syncDailyReminders(DailyReminderScheduleRequest request) async {
    await _cancelScheduledReminders();
    if (!request.enabled) {
      return;
    }

    for (int offset = 0; offset < _scheduledDays; offset++) {
      final tz.TZDateTime scheduledAt = _scheduledDateForOffset(
        offset: offset,
        localTime: request.localTime,
      );
      debugPrint(
        'Scheduling daily reminder offset=$offset at $scheduledAt '
        'for local time ${request.localTime.hour}:${request.localTime.minute.toString().padLeft(2, '0')} '
        'categories=${request.selectedCategories}',
      );
      final DailyNotificationCopy copy = DailyNotificationCopyBank.resolve(
        selectedCategories: request.selectedCategories,
        date: scheduledAt,
        lockedCategory: offset == 0 ? request.lockedTodayCategory : null,
      );
      final AndroidScheduleMode scheduleMode =
          await _resolveAndroidScheduleMode();
      debugPrint(
        'Scheduling daily reminder offset=$offset using Android mode '
        '$scheduleMode',
      );

      await _plugin.zonedSchedule(
        _notificationIdBase + offset,
        copy.title,
        copy.body,
        scheduledAt,
        _notificationDetails(),
        androidScheduleMode: scheduleMode,
        payload: _defaultRoutePayload,
      );
    }
  }

  Future<void> cancelAll() async {
    await _cancelScheduledReminders();
  }

  Future<void> showTestNotificationNow({
    required List<String> selectedCategories,
    String? lockedCategory,
  }) async {
    final DailyNotificationCopy copy = DailyNotificationCopyBank.resolve(
      selectedCategories: selectedCategories,
      date: DateTime.now(),
      lockedCategory: lockedCategory,
    );

    await _plugin.cancel(_debugNotificationNowId);
    await _plugin.show(
      _debugNotificationNowId,
      copy.title,
      copy.body,
      _notificationDetails(),
      payload: _defaultRoutePayload,
    );
  }

  Future<void> scheduleTestNotificationInTenSeconds({
    required List<String> selectedCategories,
    String? lockedCategory,
  }) async {
    final tz.TZDateTime scheduledAt = tz.TZDateTime.now(
      tz.local,
    ).add(const Duration(seconds: 10));
    final DailyNotificationCopy copy = DailyNotificationCopyBank.resolve(
      selectedCategories: selectedCategories,
      date: scheduledAt,
      lockedCategory: lockedCategory,
    );
    final AndroidScheduleMode scheduleMode = await _resolveAndroidScheduleMode();
    debugPrint('scheduleTestNotificationInTenSeconds at $scheduledAt: $copy');
    debugPrint(
      'scheduleTestNotificationInTenSeconds using Android mode $scheduleMode',
    );

    await _plugin.cancel(_debugNotificationScheduledId);
    await _plugin.zonedSchedule(
      _debugNotificationScheduledId,
      copy.title,
      copy.body,
      scheduledAt,
      _notificationDetails(),
      androidScheduleMode: scheduleMode,
      payload: _defaultRoutePayload,
    );
  }

  Future<void> _cancelScheduledReminders() async {
    for (int offset = 0; offset < _scheduledDays; offset++) {
      await _plugin.cancel(_notificationIdBase + offset);
    }
  }

  NotificationDetails _notificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        _channelId,
        _channelName,
        channelDescription: _channelDescription,
        importance: Importance.high,
        priority: Priority.high,
        category: AndroidNotificationCategory.reminder,
      ),
      iOS: DarwinNotificationDetails(),
    );
  }

  tz.TZDateTime _scheduledDateForOffset({
    required int offset,
    required TimeOfDay localTime,
  }) {
    final DateTime deviceNow = DateTime.now();
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduled = tz.TZDateTime(
      tz.local,
      deviceNow.year,
      deviceNow.month,
      deviceNow.day,
      localTime.hour,
      localTime.minute,
    );

    if (!scheduled.isAfter(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }

    if (offset == 0) {
      return scheduled;
    }

    return scheduled.add(Duration(days: offset));
  }

  String _routeFromPayload(String? payload) {
    final String value = (payload ?? '').trim();
    return value.isEmpty ? _defaultRoutePayload : value;
  }

  Future<tz.Location> _resolveLocalLocation() async {
    final String rawTimezone = await FlutterTimezone.getLocalTimezone();
    debugPrint('Notification scheduler raw timezone: $rawTimezone');

    for (final String candidate in _timezoneCandidates(rawTimezone)) {
      try {
        final tz.Location location = tz.getLocation(candidate);
        if (candidate != rawTimezone) {
          debugPrint(
            'Notification scheduler normalized timezone '
            'from $rawTimezone to ${location.name}',
          );
        }
        return location;
      } catch (_) {
        // Try the next candidate before falling back to a representative zone.
      }
    }

    final Duration offset = DateTime.now().timeZoneOffset;
    final String? fallbackName = _timezoneOffsetFallbacks[offset.inMinutes];
    if (fallbackName != null) {
      debugPrint(
        'Notification scheduler falling back from $rawTimezone '
        'to $fallbackName for offset $offset',
      );
      return tz.getLocation(fallbackName);
    }

    debugPrint(
      'Notification scheduler no timezone match for $rawTimezone '
      'with offset $offset, falling back to UTC',
    );
    return tz.UTC;
  }

  List<String> _timezoneCandidates(String rawTimezone) {
    final String value = rawTimezone.trim();
    if (value.isEmpty) {
      return const <String>[];
    }

    final List<String> candidates = <String>[value];
    final int? explicitOffsetMinutes = _parseOffsetMinutes(value);
    if (explicitOffsetMinutes != null) {
      final String? fallbackName = _timezoneOffsetFallbacks[explicitOffsetMinutes];
      if (fallbackName != null && !candidates.contains(fallbackName)) {
        candidates.add(fallbackName);
      }
    }

    return candidates;
  }

  int? _parseOffsetMinutes(String rawTimezone) {
    final RegExpMatch? match = RegExp(
      r'^(?:GMT|UTC)\s*([+-])(\d{1,2})(?::?(\d{2}))?$',
      caseSensitive: false,
    ).firstMatch(rawTimezone);
    if (match == null) {
      return null;
    }

    final String signToken = match.group(1) ?? '+';
    final int hours = int.tryParse(match.group(2) ?? '') ?? 0;
    final int minutes = int.tryParse(match.group(3) ?? '0') ?? 0;
    final int totalMinutes = (hours * 60) + minutes;
    return signToken == '-' ? -totalMinutes : totalMinutes;
  }

  Future<AndroidScheduleMode> _resolveAndroidScheduleMode() async {
    final dynamic androidImplementation = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    if (androidImplementation == null) {
      return AndroidScheduleMode.exactAllowWhileIdle;
    }

    try {
      final bool? canScheduleExact =
          await androidImplementation.canScheduleExactNotifications();
      if (canScheduleExact == false) {
        return AndroidScheduleMode.inexactAllowWhileIdle;
      }
    } catch (_) {
      // Some plugin/platform combinations do not expose this capability check.
    }

    return AndroidScheduleMode.exactAllowWhileIdle;
  }
}

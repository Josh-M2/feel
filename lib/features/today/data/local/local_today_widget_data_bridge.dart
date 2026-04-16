import 'package:flutter/material.dart';

import '../../../../core/preferences/app_preference_snapshot.dart';
import '../../domain/models/widget_daily_verse_payload.dart';
import '../../domain/repositories/today_repository.dart';
import '../../domain/repositories/widget_data_bridge.dart';
import '../public/supabase_today_repository.dart';

class LocalTodayWidgetDataBridge implements WidgetDataBridge {
  LocalTodayWidgetDataBridge({TodayRepository? todayRepository})
      : _todayRepository = todayRepository ?? SupabaseTodayRepository();

  final TodayRepository _todayRepository;

  @override
  Future<WidgetDailyVersePayload> getPayload({
    required AppPreferenceSnapshot preferences,
  }) async {
    await _todayRepository.syncTodayAssignment(
      selectedCategories: preferences.selectedCategories,
      dailyRefreshTime: preferences.dailyNotificationTime,
      preferredTranslationCode: preferences.preferredTranslationCode,
    );
    final verse = await _todayRepository.getTodayVerse(
      selectedCategories: preferences.selectedCategories,
      dailyRefreshTime: preferences.dailyNotificationTime,
      preferredTranslationCode: preferences.preferredTranslationCode,
    );

    return WidgetDailyVersePayload(
      verseText: verse.verseText,
      reference: verse.reference,
      categoryLabel: verse.category,
      translationLabel: verse.translationLabel,
      effectiveDateKey:
          verse.assignmentDateKey.isNotEmpty
              ? verse.assignmentDateKey
              : _effectiveDateKey(preferences.dailyNotificationTime),
      updateTimeLabel:
          verse.assignmentTimeLabel.isNotEmpty
              ? verse.assignmentTimeLabel
              : _timeLabel(preferences.dailyNotificationTime),
      refreshHour: preferences.dailyNotificationTime.hour,
      refreshMinute: preferences.dailyNotificationTime.minute,
      previewStyle: preferences.widgetPreviewStyle.name,
      accentTone: preferences.widgetAccentTone.name,
      showReference: preferences.widgetShowReference,
      showCategory: preferences.widgetShowCategory,
      showDate: preferences.widgetShowDate,
    );
  }

  String _effectiveDateKey(TimeOfDay refreshTime) {
    final DateTime now = DateTime.now();
    final DateTime refreshMoment = DateTime(
      now.year,
      now.month,
      now.day,
      refreshTime.hour,
      refreshTime.minute,
    );
    final DateTime effectiveDate = now.isBefore(refreshMoment)
        ? now.subtract(const Duration(days: 1))
        : now;
    final String month = effectiveDate.month.toString().padLeft(2, '0');
    final String day = effectiveDate.day.toString().padLeft(2, '0');
    return '${effectiveDate.year}-$month-$day';
  }

  String _timeLabel(TimeOfDay time) {
    final int hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final String minute = time.minute.toString().padLeft(2, '0');
    final String period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }
}

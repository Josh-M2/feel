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
    final now = DateTime.now();
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
          '${now.year.toString().padLeft(4, '0')}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}',
      updateTimeLabel: _timeLabel(preferences.dailyNotificationTime),
      showReference: preferences.widgetShowReference,
      showCategory: preferences.widgetShowCategory,
      showDate: preferences.widgetShowDate,
    );
  }

  String _timeLabel(TimeOfDay time) {
    final int hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final String minute = time.minute.toString().padLeft(2, '0');
    final String period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }
}

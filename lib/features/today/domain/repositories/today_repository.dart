import 'package:flutter/material.dart';

import '../models/today_verse.dart';

abstract class TodayRepository {
  Future<TodayVerse> getTodayVerse({
    required List<String> selectedCategories,
    required TimeOfDay dailyRefreshTime,
    required String preferredTranslationCode,
  });

  Future<void> markTodayOpened({
    required List<String> selectedCategories,
    required TimeOfDay dailyRefreshTime,
    required String preferredTranslationCode,
  });

  Future<void> syncTodayAssignment({
    required List<String> selectedCategories,
    required TimeOfDay dailyRefreshTime,
    required String preferredTranslationCode,
  });
}

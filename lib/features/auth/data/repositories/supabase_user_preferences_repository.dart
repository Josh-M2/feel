import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/preferences/app_preference_snapshot.dart';
import '../../domain/repositories/user_preferences_repository.dart';

class SupabaseUserPreferencesRepository implements UserPreferencesRepository {
  const SupabaseUserPreferencesRepository({required SupabaseClient? client})
    : _client = client;

  final SupabaseClient? _client;

  @override
  Future<AppPreferenceSnapshot?> getSnapshot(String userId) async {
    if (_client == null) {
      return null;
    }

    final dynamic contentRow = await _client!
        .from('user_content_preferences')
        .select('user_id, onboarding_completed, preferred_translation_code')
        .eq('user_id', userId)
        .maybeSingle();
    final dynamic notificationRow = await _client!
        .from('user_notification_preferences')
        .select('user_id, notifications_enabled, notification_time_local')
        .eq('user_id', userId)
        .maybeSingle();
    final dynamic widgetRow = await _client!
        .from('user_widget_preferences')
        .select(
          'user_id, widget_preview_style, widget_show_reference, widget_show_category, widget_show_date',
        )
        .eq('user_id', userId)
        .maybeSingle();

    if (contentRow == null && notificationRow == null && widgetRow == null) {
      return null;
    }

    final List<dynamic> categoryRows = await _client
        !
        .from('user_category_preferences')
        .select('category_key, position')
        .eq('user_id', userId)
        .order('position');

    final List<String> categories = categoryRows
        .map((dynamic item) => Map<String, dynamic>.from(item as Map))
        .map((Map<String, dynamic> item) => item['category_key'].toString())
        .toList();

    return AppPreferenceSnapshot.fromRemote(
      contentRow:
          contentRow == null ? null : Map<String, dynamic>.from(contentRow as Map),
      notificationRow:
          notificationRow == null
              ? null
              : Map<String, dynamic>.from(notificationRow as Map),
      widgetRow:
          widgetRow == null ? null : Map<String, dynamic>.from(widgetRow as Map),
      categories: categories,
    );
  }

  @override
  Future<void> saveSnapshot(String userId, AppPreferenceSnapshot snapshot) async {
    if (_client == null) {
      return;
    }

    await _client!.from('user_content_preferences').upsert(
      snapshot.toUserContentPreferencesRow(userId: userId),
      onConflict: 'user_id',
    );

    await _client!.from('user_notification_preferences').upsert(
      snapshot.toUserNotificationPreferencesRow(userId: userId),
      onConflict: 'user_id',
    );

    await _client!.from('user_widget_preferences').upsert(
      snapshot.toUserWidgetPreferencesRow(userId: userId),
      onConflict: 'user_id',
    );

    await _client!
        .from('user_category_preferences')
        .delete()
        .eq('user_id', userId);

    final List<Map<String, dynamic>> categoryRows = snapshot.selectedCategories
        .asMap()
        .entries
        .map(
          (MapEntry<int, String> entry) => <String, dynamic>{
            'user_id': userId,
            'category_key': entry.value,
            'position': entry.key,
          },
        )
        .toList(growable: false);

    if (categoryRows.isNotEmpty) {
      await _client!
          .from('user_category_preferences')
          .insert(categoryRows);
    }
  }
}

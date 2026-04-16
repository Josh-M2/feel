import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/preferences/app_preference_snapshot.dart';
import '../../../../core/preferences/app_preference_sync_models.dart';
import '../../domain/repositories/user_preferences_repository.dart';

class SupabaseUserPreferencesRepository implements UserPreferencesRepository {
  const SupabaseUserPreferencesRepository({required SupabaseClient? client})
    : _client = client;

  final SupabaseClient? _client;

  @override
  Future<AccountPreferenceSyncSnapshot?> getSyncSnapshot(String userId) async {
    if (_client == null) {
      return null;
    }

    final dynamic contentRow = await _client!
        .from('user_content_preferences')
        .select(
          'user_id, onboarding_completed, preferred_translation_code, updated_at',
        )
        .eq('user_id', userId)
        .maybeSingle();
    final dynamic notificationRow = await _client!
        .from('user_notification_preferences')
        .select(
          'user_id, notifications_enabled, notification_time_local, updated_at',
        )
        .eq('user_id', userId)
        .maybeSingle();
    final dynamic widgetRow = await _client!
        .from('user_widget_preferences')
        .select(
          'user_id, widget_preview_style, widget_show_reference, widget_show_category, widget_show_date, updated_at',
        )
        .eq('user_id', userId)
        .maybeSingle();

    if (contentRow == null && notificationRow == null && widgetRow == null) {
      return null;
    }

    final List<dynamic> categoryRows = await _client
        !
        .from('user_category_preferences')
        .select('category_key, position, created_at')
        .eq('user_id', userId)
        .order('position');

    final List<Map<String, dynamic>> mappedCategoryRows = categoryRows
        .map((dynamic item) => Map<String, dynamic>.from(item as Map))
        .toList(growable: false);

    final List<String> categories = mappedCategoryRows
        .map((Map<String, dynamic> item) => item['category_key'].toString())
        .toList(growable: false);

    final Map<String, dynamic>? resolvedContentRow =
        contentRow == null ? null : Map<String, dynamic>.from(contentRow as Map);
    final Map<String, dynamic>? resolvedNotificationRow = notificationRow == null
        ? null
        : Map<String, dynamic>.from(notificationRow as Map);
    final Map<String, dynamic>? resolvedWidgetRow =
        widgetRow == null ? null : Map<String, dynamic>.from(widgetRow as Map);

    return AccountPreferenceSyncSnapshot(
      snapshot: AppPreferenceSnapshot.fromRemote(
        contentRow: resolvedContentRow,
        notificationRow: resolvedNotificationRow,
        widgetRow: resolvedWidgetRow,
        categories: categories,
      ),
      contentUpdatedAt: _maxTimestamp(
        <DateTime?>[
          _parseTimestamp(resolvedContentRow?['updated_at']),
          ...mappedCategoryRows.map(
            (Map<String, dynamic> item) => _parseTimestamp(item['created_at']),
          ),
        ],
      ),
      notificationsUpdatedAt: _parseTimestamp(
        resolvedNotificationRow?['updated_at'],
      ),
      widgetUpdatedAt: _parseTimestamp(resolvedWidgetRow?['updated_at']),
    );
  }

  @override
  Future<AccountPreferenceSyncSnapshot?> saveSnapshot({
    required String userId,
    required AppPreferenceSnapshot snapshot,
    required Set<AppPreferenceDomain> domains,
  }) async {
    if (_client == null) {
      return null;
    }

    if (domains.contains(AppPreferenceDomain.content)) {
      await _client!.from('user_content_preferences').upsert(
        snapshot.toUserContentPreferencesRow(userId: userId),
        onConflict: 'user_id',
      );

      await _client!.from('user_category_preferences').delete().eq('user_id', userId);

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
        await _client!.from('user_category_preferences').insert(categoryRows);
      }
    }

    if (domains.contains(AppPreferenceDomain.notifications)) {
      await _client!.from('user_notification_preferences').upsert(
        snapshot.toUserNotificationPreferencesRow(userId: userId),
        onConflict: 'user_id',
      );
    }

    if (domains.contains(AppPreferenceDomain.widget)) {
      await _client!.from('user_widget_preferences').upsert(
        snapshot.toUserWidgetPreferencesRow(userId: userId),
        onConflict: 'user_id',
      );
    }

    return getSyncSnapshot(userId);
  }

  DateTime? _parseTimestamp(dynamic value) {
    if (value == null) {
      return null;
    }
    return DateTime.tryParse(value.toString())?.toUtc();
  }

  DateTime? _maxTimestamp(Iterable<DateTime?> timestamps) {
    DateTime? latest;
    for (final DateTime? candidate in timestamps) {
      if (candidate == null) {
        continue;
      }
      if (latest == null || candidate.isAfter(latest)) {
        latest = candidate;
      }
    }
    return latest;
  }
}

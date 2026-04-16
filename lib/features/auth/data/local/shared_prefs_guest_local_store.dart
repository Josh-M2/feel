import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/local_storage/guest_local_store.dart';
import '../../../../core/preferences/app_preference_snapshot.dart';
import '../../../../core/preferences/app_preference_sync_models.dart';

class SharedPrefsGuestLocalStore implements GuestLocalStore {
  static const String _key = 'guest_preference_snapshot_v1';

  @override
  Future<AppPreferenceLocalState> load() async {
    final SharedPreferencesAsync prefs = SharedPreferencesAsync();
    final String? raw = await prefs.getString(_key);
    if (raw == null || raw.isEmpty) {
      return AppPreferenceLocalState.defaults();
    }

    try {
      final Map<String, dynamic> json =
          jsonDecode(raw) as Map<String, dynamic>;
      if (json.containsKey('snapshot')) {
        return AppPreferenceLocalState.fromJson(json);
      }
      return AppPreferenceLocalState.fromLegacySnapshot(
        AppPreferenceSnapshot.fromLocalJson(json),
      );
    } catch (_) {
      return AppPreferenceLocalState.defaults();
    }
  }

  @override
  Future<void> save(AppPreferenceLocalState state) async {
    final SharedPreferencesAsync prefs = SharedPreferencesAsync();
    final String raw = jsonEncode(state.toJson());
    await prefs.setString(_key, raw);
  }

  @override
  Future<void> clear() async {
    final SharedPreferencesAsync prefs = SharedPreferencesAsync();
    await prefs.remove(_key);
  }
}

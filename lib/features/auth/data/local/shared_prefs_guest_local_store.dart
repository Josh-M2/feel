import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/local_storage/guest_local_store.dart';
import '../../../../core/preferences/app_preference_snapshot.dart';

class SharedPrefsGuestLocalStore implements GuestLocalStore {
  static const String _key = 'guest_preference_snapshot_v1';

  @override
  Future<AppPreferenceSnapshot> load() async {
    final SharedPreferencesAsync prefs = SharedPreferencesAsync();
    final String? raw = await prefs.getString(_key);
    if (raw == null || raw.isEmpty) {
      return AppPreferenceSnapshot.defaults();
    }

    try {
      final Map<String, dynamic> json =
          jsonDecode(raw) as Map<String, dynamic>;
      return AppPreferenceSnapshot.fromLocalJson(json);
    } catch (_) {
      return AppPreferenceSnapshot.defaults();
    }
  }

  @override
  Future<void> save(AppPreferenceSnapshot snapshot) async {
    final SharedPreferencesAsync prefs = SharedPreferencesAsync();
    final String raw = jsonEncode(snapshot.toLocalJson());
    await prefs.setString(_key, raw);
  }

  @override
  Future<void> clear() async {
    final SharedPreferencesAsync prefs = SharedPreferencesAsync();
    await prefs.remove(_key);
  }
}

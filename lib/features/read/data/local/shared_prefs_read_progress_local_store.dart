import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'read_progress_local_snapshot.dart';
import 'read_progress_local_store.dart';

class SharedPrefsReadProgressLocalStore implements ReadProgressLocalStore {
  static const String _key = 'read_progress_local_snapshot_v1';

  @override
  Future<ReadProgressLocalSnapshot> load() async {
    final SharedPreferencesAsync prefs = SharedPreferencesAsync();
    final String? raw = await prefs.getString(_key);
    if (raw == null || raw.isEmpty) {
      return ReadProgressLocalSnapshot.empty();
    }

    try {
      final Map<String, dynamic> json =
          jsonDecode(raw) as Map<String, dynamic>;
      return ReadProgressLocalSnapshot.fromJson(json);
    } catch (_) {
      return ReadProgressLocalSnapshot.empty();
    }
  }

  @override
  Future<void> save(ReadProgressLocalSnapshot snapshot) async {
    final SharedPreferencesAsync prefs = SharedPreferencesAsync();
    final String raw = jsonEncode(snapshot.toJson());
    await prefs.setString(_key, raw);
  }

  @override
  Future<void> clear() async {
    final SharedPreferencesAsync prefs = SharedPreferencesAsync();
    await prefs.remove(_key);
  }
}

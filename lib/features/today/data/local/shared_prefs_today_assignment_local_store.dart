import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'today_assignment_local_snapshot.dart';
import 'today_assignment_local_store.dart';

class SharedPrefsTodayAssignmentLocalStore implements TodayAssignmentLocalStore {
  static const String _key = 'today_assignment_local_snapshot_v1';

  @override
  Future<TodayAssignmentLocalSnapshot> load() async {
    final SharedPreferencesAsync prefs = SharedPreferencesAsync();
    final String? raw = await prefs.getString(_key);
    if (raw == null || raw.isEmpty) {
      return TodayAssignmentLocalSnapshot.empty();
    }

    try {
      final Map<String, dynamic> json =
          jsonDecode(raw) as Map<String, dynamic>;
      return TodayAssignmentLocalSnapshot.fromJson(json);
    } catch (_) {
      return TodayAssignmentLocalSnapshot.empty();
    }
  }

  @override
  Future<void> save(TodayAssignmentLocalSnapshot snapshot) async {
    final SharedPreferencesAsync prefs = SharedPreferencesAsync();
    await prefs.setString(_key, jsonEncode(snapshot.toJson()));
  }

  @override
  Future<void> clear() async {
    final SharedPreferencesAsync prefs = SharedPreferencesAsync();
    await prefs.remove(_key);
  }
}

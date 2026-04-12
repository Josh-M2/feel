import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'plan_progress_local_snapshot.dart';
import 'plan_progress_local_store.dart';

class SharedPrefsPlanProgressLocalStore implements PlanProgressLocalStore {
  static const String _key = 'plans_progress_local_snapshot_v1';

  @override
  Future<PlanProgressLocalSnapshot> load() async {
    final SharedPreferencesAsync prefs = SharedPreferencesAsync();
    final String? raw = await prefs.getString(_key);
    if (raw == null || raw.isEmpty) {
      return PlanProgressLocalSnapshot.empty();
    }

    try {
      final Map<String, dynamic> json =
          jsonDecode(raw) as Map<String, dynamic>;
      return PlanProgressLocalSnapshot.fromJson(json);
    } catch (_) {
      return PlanProgressLocalSnapshot.empty();
    }
  }

  @override
  Future<void> save(PlanProgressLocalSnapshot snapshot) async {
    final SharedPreferencesAsync prefs = SharedPreferencesAsync();
    await prefs.setString(_key, jsonEncode(snapshot.toJson()));
  }

  @override
  Future<void> clear() async {
    final SharedPreferencesAsync prefs = SharedPreferencesAsync();
    await prefs.remove(_key);
  }
}

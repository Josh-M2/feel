import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/models/saved_library_local_snapshot.dart';
import '../../domain/repositories/saved_local_store.dart';

class SharedPrefsSavedLocalStore implements SavedLocalStore {
  static const String _key = 'saved_library_local_snapshot_v1';

  @override
  Future<SavedLibraryLocalSnapshot> load() async {
    final SharedPreferencesAsync prefs = SharedPreferencesAsync();
    final String? raw = await prefs.getString(_key);
    if (raw == null || raw.isEmpty) {
      return SavedLibraryLocalSnapshot.empty();
    }

    try {
      final Map<String, dynamic> json =
          jsonDecode(raw) as Map<String, dynamic>;
      return SavedLibraryLocalSnapshot.fromJson(json);
    } catch (_) {
      return SavedLibraryLocalSnapshot.empty();
    }
  }

  @override
  Future<void> save(SavedLibraryLocalSnapshot snapshot) async {
    final SharedPreferencesAsync prefs = SharedPreferencesAsync();
    await prefs.setString(_key, jsonEncode(snapshot.toJson()));
  }

  @override
  Future<void> clear() async {
    final SharedPreferencesAsync prefs = SharedPreferencesAsync();
    await prefs.remove(_key);
  }
}

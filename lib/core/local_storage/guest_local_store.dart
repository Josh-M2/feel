import '../preferences/app_preference_snapshot.dart';

abstract class GuestLocalStore {
  Future<AppPreferenceSnapshot> load();
  Future<void> save(AppPreferenceSnapshot snapshot);
  Future<void> clear();
}

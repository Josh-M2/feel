import '../preferences/app_preference_sync_models.dart';

abstract class GuestLocalStore {
  Future<AppPreferenceLocalState> load();
  Future<void> save(AppPreferenceLocalState state);
  Future<void> clear();
}

import '../../../../core/preferences/app_preference_snapshot.dart';

abstract class UserPreferencesRepository {
  Future<AppPreferenceSnapshot?> getSnapshot(String userId);
  Future<void> saveSnapshot(String userId, AppPreferenceSnapshot snapshot);
}

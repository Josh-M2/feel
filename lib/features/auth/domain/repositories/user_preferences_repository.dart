import '../../../../core/preferences/app_preference_snapshot.dart';
import '../../../../core/preferences/app_preference_sync_models.dart';

abstract class UserPreferencesRepository {
  Future<AccountPreferenceSyncSnapshot?> getSyncSnapshot(String userId);
  Future<AccountPreferenceSyncSnapshot?> saveSnapshot({
    required String userId,
    required AppPreferenceSnapshot snapshot,
    required Set<AppPreferenceDomain> domains,
  });
}

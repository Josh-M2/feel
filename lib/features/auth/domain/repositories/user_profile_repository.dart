import '../models/user_profile_record.dart';

abstract class UserProfileRepository {
  Future<UserProfileRecord?> getProfile(String userId);
}

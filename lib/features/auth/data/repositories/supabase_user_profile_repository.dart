import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/models/user_profile_record.dart';
import '../../domain/repositories/user_profile_repository.dart';

class SupabaseUserProfileRepository implements UserProfileRepository {
  const SupabaseUserProfileRepository({required SupabaseClient? client})
    : _client = client;

  final SupabaseClient? _client;

  @override
  Future<UserProfileRecord?> getProfile(String userId) async {
    if (_client == null) {
      return null;
    }

    final dynamic row = await _client
        !
        .from('user_profiles')
        .select('user_id, display_name, primary_timezone')
        .eq('user_id', userId)
        .maybeSingle();

    if (row == null) {
      return null;
    }

    return UserProfileRecord.fromRow(Map<String, dynamic>.from(row as Map));
  }
}

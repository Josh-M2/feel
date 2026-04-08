import '../../../../core/session/app_session_snapshot.dart';
import '../models/auth_action_result.dart';

abstract class SessionRepository {
  bool get isConfigured;

  Future<AppSessionSnapshot> getCurrentSession();
  Stream<AppSessionSnapshot> watchSessionChanges();

  Future<AuthActionResult> signUpWithEmail({
    required String email,
    required String password,
    required String displayName,
  });

  Future<AuthActionResult> signInWithEmail({
    required String email,
    required String password,
  });

  Future<AuthActionResult> sendPasswordResetEmail(String email);
  Future<AuthActionResult> updatePassword(String password);
  Future<AuthActionResult> signOut();
}

import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/session/app_session_snapshot.dart';
import '../../../../core/supabase/supabase_deep_link_builder.dart';
import '../../domain/models/auth_action_result.dart';
import '../../domain/repositories/session_repository.dart';

class SupabaseSessionRepository implements SessionRepository {
  SupabaseSessionRepository({
    required SupabaseClient? client,
    required SupabaseDeepLinkBuilder deepLinks,
  }) : _client = client,
       _deepLinks = deepLinks;

  final SupabaseClient? _client;
  final SupabaseDeepLinkBuilder _deepLinks;

  @override
  bool get isConfigured => _client != null;

  @override
  Future<AppSessionSnapshot> getCurrentSession() async {
    if (_client == null) {
      return AppSessionSnapshot.guest();
    }

    return _mapSession(
      session: _client.auth.currentSession,
      event: AppAuthEvent.initialSession,
    );
  }

  @override
  Stream<AppSessionSnapshot> watchSessionChanges() {
    if (_client == null) {
      return const Stream<AppSessionSnapshot>.empty();
    }

    return _client.auth.onAuthStateChange.map((AuthState data) {
      return _mapSession(
        session: data.session,
        event: _mapEvent(data.event),
      );
    });
  }

  @override
  Future<AuthActionResult> signUpWithEmail({
    required String email,
    required String password,
    required String displayName,
  }) async {
    if (_client == null) {
      return const AuthActionResult(
        success: false,
        message:
            'Supabase is not configured yet. Add your project URL and anon key first.',
      );
    }

    try {
      final AuthResponse response = await _client.auth.signUp(
        email: email,
        password: password,
        emailRedirectTo: _deepLinks.emailConfirmationUri.toString(),
        data: <String, dynamic>{'display_name': displayName.trim()},
      );

      if (response.session == null) {
        return const AuthActionResult(
          success: true,
          needsEmailConfirmation: true,
          message:
              'Check your email to confirm the account before signing in on another device.',
        );
      }

      return const AuthActionResult(
        success: true,
        message: 'Your account is ready and signed in on this device.',
      );
    } on AuthException catch (error) {
      return AuthActionResult(success: false, message: error.message);
    } catch (_) {
      return const AuthActionResult(
        success: false,
        message: 'Sign up could not be completed right now.',
      );
    }
  }

  @override
  Future<AuthActionResult> signInWithEmail({
    required String email,
    required String password,
  }) async {
    if (_client == null) {
      return const AuthActionResult(
        success: false,
        message:
            'Supabase is not configured yet. Add your project URL and anon key first.',
      );
    }

    try {
      await _client.auth.signInWithPassword(email: email, password: password);
      return const AuthActionResult(
        success: true,
        message: 'Signed in successfully.',
      );
    } on AuthException catch (error) {
      return AuthActionResult(success: false, message: error.message);
    } catch (_) {
      return const AuthActionResult(
        success: false,
        message: 'Sign in could not be completed right now.',
      );
    }
  }

  @override
  Future<AuthActionResult> sendPasswordResetEmail(String email) async {
    if (_client == null) {
      return const AuthActionResult(
        success: false,
        message:
            'Supabase is not configured yet. Add your project URL and anon key first.',
      );
    }

    try {
      await _client.auth.resetPasswordForEmail(
        email,
        redirectTo: _deepLinks.passwordRecoveryUri.toString(),
      );
      return const AuthActionResult(
        success: true,
        message: 'Password recovery email sent. Follow the email link to continue.',
      );
    } on AuthException catch (error) {
      return AuthActionResult(success: false, message: error.message);
    } catch (_) {
      return const AuthActionResult(
        success: false,
        message: 'Password recovery could not be started right now.',
      );
    }
  }

  @override
  Future<AuthActionResult> updatePassword(String password) async {
    if (_client == null) {
      return const AuthActionResult(
        success: false,
        message:
            'Supabase is not configured yet. Add your project URL and anon key first.',
      );
    }

    try {
      await _client.auth.updateUser(UserAttributes(password: password));
      return const AuthActionResult(
        success: true,
        message: 'Your password has been updated.',
      );
    } on AuthException catch (error) {
      return AuthActionResult(success: false, message: error.message);
    } catch (_) {
      return const AuthActionResult(
        success: false,
        message: 'Password update could not be completed right now.',
      );
    }
  }

  @override
  Future<AuthActionResult> signOut() async {
    if (_client == null) {
      return const AuthActionResult(
        success: true,
        message: 'You are already using the app in guest mode.',
      );
    }

    try {
      await _client.auth.signOut();
      return const AuthActionResult(
        success: true,
        message: 'Signed out. This device remains usable in guest mode.',
      );
    } on AuthException catch (error) {
      return AuthActionResult(success: false, message: error.message);
    } catch (_) {
      return const AuthActionResult(
        success: false,
        message: 'Sign out could not be completed right now.',
      );
    }
  }

  AppSessionSnapshot _mapSession({
    required Session? session,
    required AppAuthEvent event,
  }) {
    if (session == null) {
      return AppSessionSnapshot.guest(event: event);
    }

    final User user = session.user;
    final Map<String, dynamic> metadata = user.userMetadata ?? <String, dynamic>{};

    return AppSessionSnapshot.account(
      userId: user.id,
      email: user.email,
      displayName: metadata['display_name']?.toString(),
      event: event,
    );
  }

  AppAuthEvent _mapEvent(AuthChangeEvent event) {
    switch (event) {
      case AuthChangeEvent.initialSession:
        return AppAuthEvent.initialSession;
      case AuthChangeEvent.signedIn:
        return AppAuthEvent.signedIn;
      case AuthChangeEvent.signedOut:
        return AppAuthEvent.signedOut;
      case AuthChangeEvent.passwordRecovery:
        return AppAuthEvent.passwordRecovery;
      case AuthChangeEvent.tokenRefreshed:
        return AppAuthEvent.tokenRefreshed;
      case AuthChangeEvent.userUpdated:
        return AppAuthEvent.userUpdated;
      case AuthChangeEvent.userDeleted:
        return AppAuthEvent.userDeleted;
      case AuthChangeEvent.mfaChallengeVerified:
        return AppAuthEvent.mfaChallengeVerified;
    }
  }
}

enum SessionMode { guest, account }

enum AppAuthEvent {
  initialSession,
  signedIn,
  signedOut,
  passwordRecovery,
  tokenRefreshed,
  userUpdated,
  userDeleted,
  mfaChallengeVerified,
  unknown,
}

class AppSessionSnapshot {
  const AppSessionSnapshot({
    required this.mode,
    required this.event,
    this.userId,
    this.email,
    this.displayName,
  });

  final SessionMode mode;
  final AppAuthEvent event;
  final String? userId;
  final String? email;
  final String? displayName;

  bool get isAuthenticated => mode == SessionMode.account && userId != null;

  factory AppSessionSnapshot.guest({
    AppAuthEvent event = AppAuthEvent.initialSession,
  }) {
    return AppSessionSnapshot(mode: SessionMode.guest, event: event);
  }

  factory AppSessionSnapshot.account({
    required String userId,
    required AppAuthEvent event,
    String? email,
    String? displayName,
  }) {
    return AppSessionSnapshot(
      mode: SessionMode.account,
      event: event,
      userId: userId,
      email: email,
      displayName: displayName,
    );
  }
}

class SupabaseDeepLinkBuilder {
  const SupabaseDeepLinkBuilder({
    this.scheme = 'feelapp',
    this.callbackHost = 'auth-callback',
    this.recoveryHost = 'auth-recovery',
  });

  final String scheme;
  final String callbackHost;
  final String recoveryHost;

  Uri get emailConfirmationUri => Uri(scheme: scheme, host: callbackHost);
  Uri get passwordRecoveryUri => Uri(scheme: scheme, host: recoveryHost);
}

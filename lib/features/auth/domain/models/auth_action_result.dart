class AuthActionResult {
  const AuthActionResult({
    required this.success,
    required this.message,
    this.needsEmailConfirmation = false,
  });

  final bool success;
  final String message;
  final bool needsEmailConfirmation;
}

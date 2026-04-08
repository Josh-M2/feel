class WidgetShellSyncResult {
  const WidgetShellSyncResult({
    required this.didSendPayload,
    required this.didRequestPin,
    required this.message,
  });

  final bool didSendPayload;
  final bool didRequestPin;
  final String message;
}

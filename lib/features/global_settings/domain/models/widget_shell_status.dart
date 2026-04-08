class WidgetShellStatus {
  const WidgetShellStatus({
    required this.isSupported,
    required this.isConfigured,
    required this.canRequestPin,
    required this.statusLabel,
    required this.message,
  });

  final bool isSupported;
  final bool isConfigured;
  final bool canRequestPin;
  final String statusLabel;
  final String message;
}

import 'package:flutter/services.dart';

import '../../../today/domain/models/widget_daily_verse_payload.dart';
import '../../domain/models/widget_shell_status.dart';
import '../../domain/models/widget_shell_sync_result.dart';
import '../../domain/repositories/widget_plugin_bridge.dart';

class MethodChannelWidgetPluginBridge implements WidgetPluginBridge {
  MethodChannelWidgetPluginBridge({MethodChannel? channel})
    : _channel = channel ?? const MethodChannel('feel/widget_bridge');

  final MethodChannel _channel;

  @override
  Future<WidgetShellStatus> getStatus() async {
    try {
      final Map<dynamic, dynamic>? raw = await _channel.invokeMapMethod<dynamic, dynamic>(
        'getWidgetSupportStatus',
      );
      final Map<String, dynamic> data = <String, dynamic>{
        for (final MapEntry<dynamic, dynamic> entry in (raw ?? const <dynamic, dynamic>{}).entries)
          entry.key.toString(): entry.value,
      };
      final bool isSupported = data['isSupported'] == true;
      final bool isConfigured = data['isConfigured'] == true;
      final bool canRequestPin = data['canRequestPin'] != false;
      final String statusLabel = data['statusLabel']?.toString() ?? (isSupported ? 'Connected' : 'Shell only');
      final String message = data['message']?.toString() ?? (isSupported
          ? 'The native widget bridge is available on this device.'
          : 'The Flutter method-channel shell is ready, but the native widget implementation is not wired yet.');
      return WidgetShellStatus(
        isSupported: isSupported,
        isConfigured: isConfigured,
        canRequestPin: canRequestPin,
        statusLabel: statusLabel,
        message: message,
      );
    } on MissingPluginException {
      return const WidgetShellStatus(
        isSupported: false,
        isConfigured: false,
        canRequestPin: false,
        statusLabel: 'Shell only',
        message: 'No native widget plugin is connected yet. The integration shell is ready for Android and iOS wiring.',
      );
    } catch (error) {
      return WidgetShellStatus(
        isSupported: false,
        isConfigured: false,
        canRequestPin: false,
        statusLabel: 'Unavailable',
        message: error.toString(),
      );
    }
  }

  @override
  Future<WidgetShellSyncResult> syncDailyVersePayload({
    required WidgetDailyVersePayload payload,
    bool requestPin = false,
  }) async {
    try {
      await _channel.invokeMethod<void>('syncDailyVersePayload', payload.toJson());
      bool didRequestPin = false;
      if (requestPin) {
        final bool? pinResult = await _channel.invokeMethod<bool>(
          'requestPinWidget',
          payload.toJson(),
        );
        didRequestPin = pinResult == true;
      }
      return WidgetShellSyncResult(
        didSendPayload: true,
        didRequestPin: didRequestPin,
        message: didRequestPin
            ? 'The latest daily verse payload was sent to the widget shell and a pin request was attempted.'
            : 'The latest daily verse payload was sent to the widget shell.',
      );
    } on MissingPluginException {
      return const WidgetShellSyncResult(
        didSendPayload: false,
        didRequestPin: false,
        message: 'No native widget plugin is connected yet. The Flutter shell is ready, but native widget code still needs to be added.',
      );
    } catch (error) {
      return WidgetShellSyncResult(
        didSendPayload: false,
        didRequestPin: false,
        message: error.toString(),
      );
    }
  }
}

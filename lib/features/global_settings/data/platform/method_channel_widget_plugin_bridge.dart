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
      final Map<dynamic, dynamic>? raw = await _channel
          .invokeMapMethod<dynamic, dynamic>('getWidgetSupportStatus');
      final Map<String, dynamic> data = <String, dynamic>{
        for (final MapEntry<dynamic, dynamic> entry
            in (raw ?? const <dynamic, dynamic>{}).entries)
          entry.key.toString(): entry.value,
      };
      final bool isSupported = data['isSupported'] == true;
      final bool isConfigured = data['isConfigured'] == true;
      final bool canRequestPin = data['canRequestPin'] != false;
      final String statusLabel =
          data['statusLabel']?.toString() ??
          (isSupported ? 'Connected' : 'Shell only');
      final String message =
          data['message']?.toString() ??
          (isSupported
              ? 'Widget support is available on this device.'
              : 'Widget setup is still in progress on this device.');
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
        message: 'Widget setup is still in progress on this device.',
      );
    } catch (error) {
      return WidgetShellStatus(
        isSupported: false,
        isConfigured: false,
        canRequestPin: false,
        statusLabel: 'Unavailable',
        message: 'Widget availability could not be checked right now.',
      );
    }
  }

  @override
  Future<WidgetShellSyncResult> syncDailyVersePayload({
    required WidgetDailyVersePayload payload,
    bool requestPin = false,
  }) async {
    try {
      await _channel.invokeMethod<void>(
        'syncDailyVersePayload',
        payload.toJson(),
      );
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
            ? 'Your latest daily verse was sent to the widget and a request to add it to the Home Screen was made.'
            : 'Your latest daily verse was sent to the widget.',
      );
    } on MissingPluginException {
      return const WidgetShellSyncResult(
        didSendPayload: false,
        didRequestPin: false,
        message: 'Widget setup is still in progress on this device.',
      );
    } catch (error) {
      return WidgetShellSyncResult(
        didSendPayload: false,
        didRequestPin: false,
        message: 'The widget could not be updated right now.',
      );
    }
  }
}

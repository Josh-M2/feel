import '../../../today/domain/models/widget_daily_verse_payload.dart';
import '../models/widget_shell_status.dart';
import '../models/widget_shell_sync_result.dart';

abstract class WidgetPluginBridge {
  Future<WidgetShellStatus> getStatus();

  Future<WidgetShellSyncResult> syncDailyVersePayload({
    required WidgetDailyVersePayload payload,
    bool requestPin = false,
  });
}

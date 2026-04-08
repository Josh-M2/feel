import '../../../../core/preferences/app_preference_snapshot.dart';
import '../models/widget_daily_verse_payload.dart';

abstract class WidgetDataBridge {
  Future<WidgetDailyVersePayload> getPayload({
    required AppPreferenceSnapshot preferences,
  });
}

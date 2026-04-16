class WidgetDailyVersePayload {
  const WidgetDailyVersePayload({
    required this.verseText,
    required this.reference,
    required this.categoryLabel,
    required this.translationLabel,
    required this.effectiveDateKey,
    required this.updateTimeLabel,
    required this.refreshHour,
    required this.refreshMinute,
    required this.previewStyle,
    required this.accentTone,
    required this.showReference,
    required this.showCategory,
    required this.showDate,
  });

  final String verseText;
  final String reference;
  final String categoryLabel;
  final String translationLabel;
  final String effectiveDateKey;
  final String updateTimeLabel;
  final int refreshHour;
  final int refreshMinute;
  final String previewStyle;
  final String accentTone;
  final bool showReference;
  final bool showCategory;
  final bool showDate;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'verseText': verseText,
      'reference': reference,
      'categoryLabel': categoryLabel,
      'translationLabel': translationLabel,
      'effectiveDateKey': effectiveDateKey,
      'updateTimeLabel': updateTimeLabel,
      'refreshHour': refreshHour,
      'refreshMinute': refreshMinute,
      'previewStyle': previewStyle,
      'accentTone': accentTone,
      'showReference': showReference,
      'showCategory': showCategory,
      'showDate': showDate,
    };
  }
}

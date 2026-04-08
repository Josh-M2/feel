class WidgetDailyVersePayload {
  const WidgetDailyVersePayload({
    required this.verseText,
    required this.reference,
    required this.categoryLabel,
    required this.translationLabel,
    required this.effectiveDateKey,
    required this.updateTimeLabel,
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
      'showReference': showReference,
      'showCategory': showCategory,
      'showDate': showDate,
    };
  }
}

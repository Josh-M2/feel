class TodayVerse {
  const TodayVerse({
    required this.dateLabel,
    required this.category,
    required this.reference,
    required this.translationLabel,
    required this.verseText,
    required this.reflectionPrompt,
    required this.encouragementLine,
    required this.contextSummary,
    required this.contextSections,
    required this.relatedPassages,
    required this.keyInsights,
    required this.prayer,
    this.sourceLabel = 'Curated daily assignment',
    this.assignmentDateKey = '',
    this.assignmentTimeLabel = '',
    this.widgetSyncLabel = '',
  });

  final String dateLabel;
  final String category;
  final String reference;
  final String translationLabel;
  final String verseText;
  final String reflectionPrompt;
  final String encouragementLine;
  final String contextSummary;
  final List<VerseContextSection> contextSections;
  final List<RelatedPassagePreview> relatedPassages;
  final List<String> keyInsights;
  final String prayer;
  final String sourceLabel;
  final String assignmentDateKey;
  final String assignmentTimeLabel;
  final String widgetSyncLabel;
}

class VerseContextSection {
  const VerseContextSection({required this.title, required this.body});

  final String title;
  final String body;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{'title': title, 'body': body};
  }

  factory VerseContextSection.fromJson(Map<String, dynamic> json) {
    return VerseContextSection(
      title: json['title']?.toString() ?? '',
      body: json['body']?.toString() ?? '',
    );
  }
}

class RelatedPassagePreview {
  const RelatedPassagePreview({required this.reference, required this.note});

  final String reference;
  final String note;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{'reference': reference, 'note': note};
  }

  factory RelatedPassagePreview.fromJson(Map<String, dynamic> json) {
    return RelatedPassagePreview(
      reference: json['reference']?.toString() ?? '',
      note: json['note']?.toString() ?? '',
    );
  }
}

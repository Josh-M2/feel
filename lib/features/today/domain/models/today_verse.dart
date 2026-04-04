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
}

class VerseContextSection {
  const VerseContextSection({required this.title, required this.body});

  final String title;
  final String body;
}

class RelatedPassagePreview {
  const RelatedPassagePreview({required this.reference, required this.note});

  final String reference;
  final String note;
}

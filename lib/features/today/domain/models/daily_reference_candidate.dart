import 'today_verse.dart';

class DailyReferenceCandidate {
  const DailyReferenceCandidate({
    required this.category,
    required this.reference,
    required this.translationCode,
    required this.fallbackVerseText,
    required this.translationLabel,
    required this.reflectionPrompt,
    required this.encouragementLine,
    required this.contextSummary,
    required this.contextSections,
    required this.relatedPassages,
    required this.keyInsights,
    required this.prayer,
  });

  final String category;
  final String reference;
  final String translationCode;
  final String fallbackVerseText;
  final String translationLabel;
  final String reflectionPrompt;
  final String encouragementLine;
  final String contextSummary;
  final List<VerseContextSection> contextSections;
  final List<RelatedPassagePreview> relatedPassages;
  final List<String> keyInsights;
  final String prayer;
}

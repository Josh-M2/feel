import 'today_verse.dart';

class DailyVersePoolEntry {
  const DailyVersePoolEntry({
    required this.id,
    required this.category,
    required this.reference,
    required this.translationCode,
    required this.bookId,
    required this.chapterNumber,
    required this.verseStart,
    required this.verseEnd,
    this.verseTextFallback = '',
    required this.reflectionPrompt,
    required this.encouragementLine,
    required this.contextSummary,
    required this.contextSections,
    required this.relatedPassages,
    required this.keyInsights,
    required this.prayer,
    this.sortOrder = 0,
  });

  final String id;
  final String category;
  final String reference;
  final String translationCode;
  final String bookId;
  final int chapterNumber;
  final int verseStart;
  final int verseEnd;
  final String verseTextFallback;
  final String reflectionPrompt;
  final String encouragementLine;
  final String contextSummary;
  final List<VerseContextSection> contextSections;
  final List<RelatedPassagePreview> relatedPassages;
  final List<String> keyInsights;
  final String prayer;
  final int sortOrder;
  bool get hasNormalizedReference =>
      bookId.isNotEmpty &&
      chapterNumber > 0 &&
      verseStart > 0 &&
      verseEnd >= verseStart;

  factory DailyVersePoolEntry.fromSupabaseRow(Map<String, dynamic> row) {
    List<VerseContextSection> contextSections = const <VerseContextSection>[];
    final dynamic contextRaw = row['context_sections'];
    if (contextRaw is List<dynamic>) {
      contextSections = contextRaw
          .map(
            (dynamic item) => VerseContextSection.fromJson(
              Map<String, dynamic>.from(item as Map),
            ),
          )
          .toList(growable: false);
    }

    List<RelatedPassagePreview> relatedPassages =
        const <RelatedPassagePreview>[];
    final dynamic relatedRaw = row['related_passages'];
    if (relatedRaw is List<dynamic>) {
      relatedPassages = relatedRaw
          .map(
            (dynamic item) => RelatedPassagePreview.fromJson(
              Map<String, dynamic>.from(item as Map),
            ),
          )
          .toList(growable: false);
    }

    final List<String> keyInsights =
        (row['key_insights'] as List<dynamic>? ?? const <dynamic>[])
            .map((dynamic item) => item.toString())
            .toList(growable: false);

    return DailyVersePoolEntry(
      id: row['id']?.toString() ?? '',
      category: row['category_label']?.toString() ?? 'Guidance',
      reference: row['reference_label']?.toString() ?? '',
      translationCode: row['translation_code']?.toString() ?? 'kjv',
      bookId: row['book_id']?.toString() ?? '',
      chapterNumber: (row['chapter_number'] as num?)?.toInt() ?? 0,
      verseStart: (row['verse_start'] as num?)?.toInt() ?? 0,
      verseEnd:
          (row['verse_end'] as num?)?.toInt() ??
          (row['verse_start'] as num?)?.toInt() ??
          0,
      verseTextFallback: row['verse_text_fallback']?.toString() ?? '',
      reflectionPrompt: row['reflection_prompt']?.toString() ?? '',
      encouragementLine: row['encouragement_line']?.toString() ?? '',
      contextSummary: row['context_summary']?.toString() ?? '',
      contextSections: contextSections,
      relatedPassages: relatedPassages,
      keyInsights: keyInsights,
      prayer: row['prayer']?.toString() ?? '',
      sortOrder: (row['sort_order'] as num?)?.toInt() ?? 0,
    );
  }
}

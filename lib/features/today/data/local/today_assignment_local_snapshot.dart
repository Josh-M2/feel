import '../../domain/models/today_verse.dart';

class TodayAssignmentLocalRecord {
  const TodayAssignmentLocalRecord({
    required this.dateKey,
    required this.category,
    required this.reference,
    required this.translationCode,
    required this.translationLabel,
    required this.verseText,
    required this.reflectionPrompt,
    required this.encouragementLine,
    required this.contextSummary,
    required this.contextSections,
    required this.relatedPassages,
    required this.keyInsights,
    required this.prayer,
    required this.assignedAtIso,
    this.openedAtIso,
  });

  final String dateKey;
  final String category;
  final String reference;
  final String translationCode;
  final String translationLabel;
  final String verseText;
  final String reflectionPrompt;
  final String encouragementLine;
  final String contextSummary;
  final List<VerseContextSection> contextSections;
  final List<RelatedPassagePreview> relatedPassages;
  final List<String> keyInsights;
  final String prayer;
  final String assignedAtIso;
  final String? openedAtIso;

  TodayAssignmentLocalRecord copyWith({String? openedAtIso}) {
    return TodayAssignmentLocalRecord(
      dateKey: dateKey,
      category: category,
      reference: reference,
      translationCode: translationCode,
      translationLabel: translationLabel,
      verseText: verseText,
      reflectionPrompt: reflectionPrompt,
      encouragementLine: encouragementLine,
      contextSummary: contextSummary,
      contextSections: contextSections,
      relatedPassages: relatedPassages,
      keyInsights: keyInsights,
      prayer: prayer,
      assignedAtIso: assignedAtIso,
      openedAtIso: openedAtIso ?? this.openedAtIso,
    );
  }

  TodayVerse toTodayVerse() {
    return TodayVerse(
      dateLabel: 'Assigned for today',
      category: category,
      reference: reference,
      translationLabel: translationLabel,
      verseText: verseText,
      reflectionPrompt: reflectionPrompt,
      encouragementLine: encouragementLine,
      contextSummary: contextSummary,
      contextSections: contextSections,
      relatedPassages: relatedPassages,
      keyInsights: keyInsights,
      prayer: prayer,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'dateKey': dateKey,
      'category': category,
      'reference': reference,
      'translationCode': translationCode,
      'translationLabel': translationLabel,
      'verseText': verseText,
      'reflectionPrompt': reflectionPrompt,
      'encouragementLine': encouragementLine,
      'contextSummary': contextSummary,
      'contextSections': contextSections
          .map((VerseContextSection item) => item.toJson())
          .toList(growable: false),
      'relatedPassages': relatedPassages
          .map((RelatedPassagePreview item) => item.toJson())
          .toList(growable: false),
      'keyInsights': keyInsights,
      'prayer': prayer,
      'assignedAtIso': assignedAtIso,
      'openedAtIso': openedAtIso,
    };
  }

  factory TodayAssignmentLocalRecord.fromJson(Map<String, dynamic> json) {
    return TodayAssignmentLocalRecord(
      dateKey: json['dateKey']?.toString() ?? '',
      category: json['category']?.toString() ?? 'Guidance',
      reference: json['reference']?.toString() ?? '',
      translationCode: json['translationCode']?.toString() ?? 'kjv',
      translationLabel: json['translationLabel']?.toString() ?? 'KJV',
      verseText: json['verseText']?.toString() ?? '',
      reflectionPrompt: json['reflectionPrompt']?.toString() ?? '',
      encouragementLine: json['encouragementLine']?.toString() ?? '',
      contextSummary: json['contextSummary']?.toString() ?? '',
      contextSections:
          (json['contextSections'] as List<dynamic>? ?? const <dynamic>[])
              .map(
                (dynamic item) => VerseContextSection.fromJson(
                  Map<String, dynamic>.from(item as Map),
                ),
              )
              .toList(growable: false),
      relatedPassages:
          (json['relatedPassages'] as List<dynamic>? ?? const <dynamic>[])
              .map(
                (dynamic item) => RelatedPassagePreview.fromJson(
                  Map<String, dynamic>.from(item as Map),
                ),
              )
              .toList(growable: false),
      keyInsights: (json['keyInsights'] as List<dynamic>? ?? const <dynamic>[])
          .map((dynamic item) => item.toString())
          .toList(growable: false),
      prayer: json['prayer']?.toString() ?? '',
      assignedAtIso: json['assignedAtIso']?.toString() ?? '',
      openedAtIso: json['openedAtIso']?.toString(),
    );
  }
}

class TodayAssignmentLocalSnapshot {
  const TodayAssignmentLocalSnapshot({required this.assignments});

  final List<TodayAssignmentLocalRecord> assignments;

  factory TodayAssignmentLocalSnapshot.empty() {
    return const TodayAssignmentLocalSnapshot(
      assignments: <TodayAssignmentLocalRecord>[],
    );
  }

  TodayAssignmentLocalRecord? findByDateKey(String dateKey) {
    for (final TodayAssignmentLocalRecord record in assignments) {
      if (record.dateKey == dateKey) return record;
    }
    return null;
  }

  List<String> recentReferences({required int limit}) {
    final List<TodayAssignmentLocalRecord> sorted =
        List<TodayAssignmentLocalRecord>.from(assignments)
          ..sort(
            (TodayAssignmentLocalRecord a, TodayAssignmentLocalRecord b) =>
                b.dateKey.compareTo(a.dateKey),
          );

    return sorted
        .take(limit)
        .map((TodayAssignmentLocalRecord item) => item.reference)
        .toList(growable: false);
  }

  TodayAssignmentLocalSnapshot upsert(TodayAssignmentLocalRecord record) {
    final List<TodayAssignmentLocalRecord> next = assignments
        .where((TodayAssignmentLocalRecord item) => item.dateKey != record.dateKey)
        .toList(growable: true)
      ..add(record)
      ..sort(
        (TodayAssignmentLocalRecord a, TodayAssignmentLocalRecord b) =>
            b.dateKey.compareTo(a.dateKey),
      );

    return TodayAssignmentLocalSnapshot(
      assignments: next.take(30).toList(growable: false),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'assignments': assignments
          .map((TodayAssignmentLocalRecord item) => item.toJson())
          .toList(growable: false),
    };
  }

  factory TodayAssignmentLocalSnapshot.fromJson(Map<String, dynamic> json) {
    return TodayAssignmentLocalSnapshot(
      assignments: (json['assignments'] as List<dynamic>? ?? const <dynamic>[])
          .map(
            (dynamic item) => TodayAssignmentLocalRecord.fromJson(
              Map<String, dynamic>.from(item as Map),
            ),
          )
          .toList(growable: false),
    );
  }
}

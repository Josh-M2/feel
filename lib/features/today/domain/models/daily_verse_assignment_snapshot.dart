import 'today_verse.dart';

class DailyVerseAssignmentSnapshot {
  const DailyVerseAssignmentSnapshot({
    required this.dateKey,
    required this.category,
    required this.reference,
    required this.translationCode,
    required this.translationLabel,
    required this.verseText,
    required this.sourceLabel,
    required this.assignmentTimeLabel,
    required this.widgetSyncLabel,
    required this.reflectionPrompt,
    required this.encouragementLine,
    required this.contextSummary,
    required this.contextSections,
    required this.relatedPassages,
    required this.keyInsights,
    required this.prayer,
    required this.assignedAtIso,
  });

  final String dateKey;
  final String category;
  final String reference;
  final String translationCode;
  final String translationLabel;
  final String verseText;
  final String sourceLabel;
  final String assignmentTimeLabel;
  final String widgetSyncLabel;
  final String reflectionPrompt;
  final String encouragementLine;
  final String contextSummary;
  final List<VerseContextSection> contextSections;
  final List<RelatedPassagePreview> relatedPassages;
  final List<String> keyInsights;
  final String prayer;
  final String assignedAtIso;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'dateKey': dateKey,
      'category': category,
      'reference': reference,
      'translationCode': translationCode,
      'translationLabel': translationLabel,
      'verseText': verseText,
      'sourceLabel': sourceLabel,
      'assignmentTimeLabel': assignmentTimeLabel,
      'widgetSyncLabel': widgetSyncLabel,
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
    };
  }

  factory DailyVerseAssignmentSnapshot.fromJson(Map<String, dynamic> json) {
    return DailyVerseAssignmentSnapshot(
      dateKey: json['dateKey']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      reference: json['reference']?.toString() ?? '',
      translationCode: json['translationCode']?.toString() ?? 'kjv',
      translationLabel: json['translationLabel']?.toString() ?? 'KJV',
      verseText: json['verseText']?.toString() ?? '',
      sourceLabel: json['sourceLabel']?.toString() ?? 'Curated daily assignment',
      assignmentTimeLabel: json['assignmentTimeLabel']?.toString() ?? '',
      widgetSyncLabel: json['widgetSyncLabel']?.toString() ?? '',
      reflectionPrompt: json['reflectionPrompt']?.toString() ?? '',
      encouragementLine: json['encouragementLine']?.toString() ?? '',
      contextSummary: json['contextSummary']?.toString() ?? '',
      contextSections: (json['contextSections'] as List<dynamic>? ?? const <dynamic>[])
          .map(
            (dynamic item) => VerseContextSection.fromJson(
              Map<String, dynamic>.from(item as Map),
            ),
          )
          .toList(growable: false),
      relatedPassages: (json['relatedPassages'] as List<dynamic>? ?? const <dynamic>[])
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
      sourceLabel: sourceLabel,
      assignmentDateKey: dateKey,
      assignmentTimeLabel: assignmentTimeLabel,
      widgetSyncLabel: widgetSyncLabel,
    );
  }
}

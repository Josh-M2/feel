class ReadProgressLocalRecord {
  const ReadProgressLocalRecord({
    required this.bookId,
    required this.bookName,
    required this.chapterNumber,
    required this.chapterTitle,
    required this.focusLine,
    required this.openedAtIso,
    this.versionCode = 'kjv',
    this.versionLabel = 'KJV',
  });

  final String bookId;
  final String bookName;
  final int chapterNumber;
  final String chapterTitle;
  final String focusLine;
  final String openedAtIso;
  final String versionCode;
  final String versionLabel;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'bookId': bookId,
      'bookName': bookName,
      'chapterNumber': chapterNumber,
      'chapterTitle': chapterTitle,
      'focusLine': focusLine,
      'openedAtIso': openedAtIso,
      'versionCode': versionCode,
      'versionLabel': versionLabel,
    };
  }

  factory ReadProgressLocalRecord.fromJson(Map<String, dynamic> json) {
    return ReadProgressLocalRecord(
      bookId: json['bookId']?.toString() ?? '',
      bookName: json['bookName']?.toString() ?? '',
      chapterNumber: (json['chapterNumber'] as num?)?.toInt() ?? 1,
      chapterTitle: json['chapterTitle']?.toString() ?? '',
      focusLine: json['focusLine']?.toString() ?? '',
      openedAtIso: json['openedAtIso']?.toString() ?? '',
      versionCode: json['versionCode']?.toString() ?? 'kjv',
      versionLabel: json['versionLabel']?.toString() ?? 'KJV',
    );
  }
}

class ReadProgressLocalSnapshot {
  const ReadProgressLocalSnapshot({required this.entries});

  final List<ReadProgressLocalRecord> entries;

  factory ReadProgressLocalSnapshot.empty() {
    return const ReadProgressLocalSnapshot(entries: <ReadProgressLocalRecord>[]);
  }

  ReadProgressLocalSnapshot copyWith({
    List<ReadProgressLocalRecord>? entries,
  }) {
    return ReadProgressLocalSnapshot(entries: entries ?? this.entries);
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'entries': entries
          .map((ReadProgressLocalRecord item) => item.toJson())
          .toList(growable: false),
    };
  }

  factory ReadProgressLocalSnapshot.fromJson(Map<String, dynamic> json) {
    return ReadProgressLocalSnapshot(
      entries: (json['entries'] as List<dynamic>? ?? const <dynamic>[])
          .map(
            (dynamic item) => ReadProgressLocalRecord.fromJson(
              Map<String, dynamic>.from(item as Map),
            ),
          )
          .toList(growable: false),
    );
  }
}

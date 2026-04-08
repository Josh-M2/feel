class SavedReferenceAnchor {
  const SavedReferenceAnchor({
    required this.versionCode,
    required this.bookId,
    required this.bookName,
    required this.chapterStart,
    required this.verseStart,
    required this.chapterEnd,
    required this.verseEnd,
    required this.referenceLabel,
    required this.verseTextSnapshot,
  });

  final String versionCode;
  final String bookId;
  final String bookName;
  final int chapterStart;
  final int verseStart;
  final int chapterEnd;
  final int verseEnd;
  final String referenceLabel;
  final String verseTextSnapshot;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'versionCode': versionCode,
      'bookId': bookId,
      'bookName': bookName,
      'chapterStart': chapterStart,
      'verseStart': verseStart,
      'chapterEnd': chapterEnd,
      'verseEnd': verseEnd,
      'referenceLabel': referenceLabel,
      'verseTextSnapshot': verseTextSnapshot,
    };
  }

  factory SavedReferenceAnchor.fromJson(Map<String, dynamic> json) {
    return SavedReferenceAnchor(
      versionCode: json['versionCode']?.toString() ?? 'kjv',
      bookId: json['bookId']?.toString() ?? '',
      bookName: json['bookName']?.toString() ?? '',
      chapterStart: (json['chapterStart'] as num?)?.toInt() ?? 1,
      verseStart: (json['verseStart'] as num?)?.toInt() ?? 1,
      chapterEnd: (json['chapterEnd'] as num?)?.toInt() ?? 1,
      verseEnd: (json['verseEnd'] as num?)?.toInt() ?? 1,
      referenceLabel: json['referenceLabel']?.toString() ?? '',
      verseTextSnapshot: json['verseTextSnapshot']?.toString() ?? '',
    );
  }
}

class SavedBookmarkLocalRecord {
  const SavedBookmarkLocalRecord({
    required this.id,
    required this.anchor,
    required this.categoryLabel,
    required this.savedAtIso,
    required this.reflection,
    required this.highlightCount,
  });

  final String id;
  final SavedReferenceAnchor anchor;
  final String categoryLabel;
  final String savedAtIso;
  final String? reflection;
  final int highlightCount;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'anchor': anchor.toJson(),
      'categoryLabel': categoryLabel,
      'savedAtIso': savedAtIso,
      'reflection': reflection,
      'highlightCount': highlightCount,
    };
  }

  factory SavedBookmarkLocalRecord.fromJson(Map<String, dynamic> json) {
    return SavedBookmarkLocalRecord(
      id: json['id']?.toString() ?? '',
      anchor: SavedReferenceAnchor.fromJson(
        Map<String, dynamic>.from(json['anchor'] as Map? ?? const <String, dynamic>{}),
      ),
      categoryLabel: json['categoryLabel']?.toString() ?? '',
      savedAtIso: json['savedAtIso']?.toString() ?? '',
      reflection: json['reflection']?.toString(),
      highlightCount: (json['highlightCount'] as num?)?.toInt() ?? 0,
    );
  }
}

class SavedHighlightLocalRecord {
  const SavedHighlightLocalRecord({
    required this.id,
    required this.anchor,
    required this.selectedText,
    required this.colorKey,
    required this.savedAtIso,
    required this.notePreview,
  });

  final String id;
  final SavedReferenceAnchor anchor;
  final String selectedText;
  final String colorKey;
  final String savedAtIso;
  final String? notePreview;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'anchor': anchor.toJson(),
      'selectedText': selectedText,
      'colorKey': colorKey,
      'savedAtIso': savedAtIso,
      'notePreview': notePreview,
    };
  }

  factory SavedHighlightLocalRecord.fromJson(Map<String, dynamic> json) {
    return SavedHighlightLocalRecord(
      id: json['id']?.toString() ?? '',
      anchor: SavedReferenceAnchor.fromJson(
        Map<String, dynamic>.from(json['anchor'] as Map? ?? const <String, dynamic>{}),
      ),
      selectedText: json['selectedText']?.toString() ?? '',
      colorKey: json['colorKey']?.toString() ?? 'warm_amber',
      savedAtIso: json['savedAtIso']?.toString() ?? '',
      notePreview: json['notePreview']?.toString(),
    );
  }
}

class SavedNoteLocalRecord {
  const SavedNoteLocalRecord({
    required this.id,
    required this.anchor,
    required this.title,
    required this.body,
    required this.createdAtIso,
    required this.updatedAtIso,
    required this.isPinned,
  });

  final String id;
  final SavedReferenceAnchor anchor;
  final String title;
  final String body;
  final String createdAtIso;
  final String updatedAtIso;
  final bool isPinned;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'anchor': anchor.toJson(),
      'title': title,
      'body': body,
      'createdAtIso': createdAtIso,
      'updatedAtIso': updatedAtIso,
      'isPinned': isPinned,
    };
  }

  factory SavedNoteLocalRecord.fromJson(Map<String, dynamic> json) {
    return SavedNoteLocalRecord(
      id: json['id']?.toString() ?? '',
      anchor: SavedReferenceAnchor.fromJson(
        Map<String, dynamic>.from(json['anchor'] as Map? ?? const <String, dynamic>{}),
      ),
      title: json['title']?.toString() ?? '',
      body: json['body']?.toString() ?? '',
      createdAtIso: json['createdAtIso']?.toString() ?? '',
      updatedAtIso: json['updatedAtIso']?.toString() ?? '',
      isPinned: json['isPinned'] == true,
    );
  }
}

class SavedHistoryLocalRecord {
  const SavedHistoryLocalRecord({
    required this.id,
    required this.kind,
    required this.title,
    required this.subtitle,
    required this.occurredAtIso,
  });

  final String id;
  final String kind;
  final String title;
  final String subtitle;
  final String occurredAtIso;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'kind': kind,
      'title': title,
      'subtitle': subtitle,
      'occurredAtIso': occurredAtIso,
    };
  }

  factory SavedHistoryLocalRecord.fromJson(Map<String, dynamic> json) {
    return SavedHistoryLocalRecord(
      id: json['id']?.toString() ?? '',
      kind: json['kind']?.toString() ?? 'verse_viewed',
      title: json['title']?.toString() ?? '',
      subtitle: json['subtitle']?.toString() ?? '',
      occurredAtIso: json['occurredAtIso']?.toString() ?? '',
    );
  }
}

class SavedLibraryLocalSnapshot {
  const SavedLibraryLocalSnapshot({
    required this.bookmarks,
    required this.highlights,
    required this.notes,
    required this.history,
  });

  final List<SavedBookmarkLocalRecord> bookmarks;
  final List<SavedHighlightLocalRecord> highlights;
  final List<SavedNoteLocalRecord> notes;
  final List<SavedHistoryLocalRecord> history;

  factory SavedLibraryLocalSnapshot.empty() {
    return const SavedLibraryLocalSnapshot(
      bookmarks: <SavedBookmarkLocalRecord>[],
      highlights: <SavedHighlightLocalRecord>[],
      notes: <SavedNoteLocalRecord>[],
      history: <SavedHistoryLocalRecord>[],
    );
  }


  SavedLibraryLocalSnapshot copyWith({
    List<SavedBookmarkLocalRecord>? bookmarks,
    List<SavedHighlightLocalRecord>? highlights,
    List<SavedNoteLocalRecord>? notes,
    List<SavedHistoryLocalRecord>? history,
  }) {
    return SavedLibraryLocalSnapshot(
      bookmarks: bookmarks ?? this.bookmarks,
      highlights: highlights ?? this.highlights,
      notes: notes ?? this.notes,
      history: history ?? this.history,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'bookmarks': bookmarks.map((SavedBookmarkLocalRecord item) => item.toJson()).toList(growable: false),
      'highlights': highlights.map((SavedHighlightLocalRecord item) => item.toJson()).toList(growable: false),
      'notes': notes.map((SavedNoteLocalRecord item) => item.toJson()).toList(growable: false),
      'history': history.map((SavedHistoryLocalRecord item) => item.toJson()).toList(growable: false),
    };
  }

  factory SavedLibraryLocalSnapshot.fromJson(Map<String, dynamic> json) {
    return SavedLibraryLocalSnapshot(
      bookmarks: (json['bookmarks'] as List<dynamic>? ?? const <dynamic>[])
          .map((dynamic item) => SavedBookmarkLocalRecord.fromJson(Map<String, dynamic>.from(item as Map)))
          .toList(growable: false),
      highlights: (json['highlights'] as List<dynamic>? ?? const <dynamic>[])
          .map((dynamic item) => SavedHighlightLocalRecord.fromJson(Map<String, dynamic>.from(item as Map)))
          .toList(growable: false),
      notes: (json['notes'] as List<dynamic>? ?? const <dynamic>[])
          .map((dynamic item) => SavedNoteLocalRecord.fromJson(Map<String, dynamic>.from(item as Map)))
          .toList(growable: false),
      history: (json['history'] as List<dynamic>? ?? const <dynamic>[])
          .map((dynamic item) => SavedHistoryLocalRecord.fromJson(Map<String, dynamic>.from(item as Map)))
          .toList(growable: false),
    );
  }
}

class SavedBookmark {
  const SavedBookmark({
    required this.id,
    required this.reference,
    required this.verseText,
    required this.categoryLabel,
    required this.savedAtLabel,
    required this.translationLabel,
    required this.hasReflection,
    required this.highlightCount,
    required this.reflectionPreview,
  });

  final String id;
  final String reference;
  final String verseText;
  final String categoryLabel;
  final String savedAtLabel;
  final String translationLabel;
  final bool hasReflection;
  final int highlightCount;
  final String? reflectionPreview;
}

class SavedHighlight {
  const SavedHighlight({
    required this.id,
    required this.reference,
    required this.verseText,
    required this.highlightedText,
    required this.colorLabel,
    required this.savedAtLabel,
    required this.notePreview,
  });

  final String id;
  final String reference;
  final String verseText;
  final String highlightedText;
  final String colorLabel;
  final String savedAtLabel;
  final String? notePreview;
}

class SavedNote {
  const SavedNote({
    required this.id,
    required this.reference,
    required this.verseText,
    required this.title,
    required this.body,
    required this.lastEditedLabel,
    required this.isPinned,
  });

  final String id;
  final String reference;
  final String verseText;
  final String title;
  final String body;
  final String lastEditedLabel;
  final bool isPinned;
}

class SavedLibrarySummary {
  const SavedLibrarySummary({
    required this.bookmarkCount,
    required this.highlightCount,
    required this.noteCount,
  });

  final int bookmarkCount;
  final int highlightCount;
  final int noteCount;
}

enum SavedHistoryKind {
  verseViewed,
  chapterRead,
  planOpened,
  bookmarkSaved,
  highlightSaved,
  noteWritten,
}

class SavedHistoryEntry {
  const SavedHistoryEntry({
    required this.id,
    required this.kind,
    required this.title,
    required this.subtitle,
    required this.timeLabel,
  });

  final String id;
  final SavedHistoryKind kind;
  final String title;
  final String subtitle;
  final String timeLabel;
}

import '../../domain/models/saved_item.dart';
import '../../domain/models/saved_library_local_snapshot.dart';
import '../../domain/repositories/saved_library_repository.dart';
import '../../domain/repositories/saved_local_store.dart';
import '../mock/mock_saved_repository.dart';
import 'shared_prefs_saved_local_store.dart';

class LocalFirstSavedLibraryRepository implements SavedLibraryRepository {
  LocalFirstSavedLibraryRepository({
    SavedLocalStore? localStore,
    MockSavedRepository? fallback,
  }) : _localStore = localStore ?? SharedPrefsSavedLocalStore(),
       _fallback = fallback ?? const MockSavedRepository();

  final SavedLocalStore _localStore;
  final MockSavedRepository _fallback;

  @override
  Future<List<SavedBookmark>> getBookmarks() async {
    final SavedLibraryLocalSnapshot snapshot = await _loadSnapshot();
    return snapshot.bookmarks.map(_mapBookmark).toList(growable: false);
  }

  @override
  Future<List<SavedHighlight>> getHighlights() async {
    final SavedLibraryLocalSnapshot snapshot = await _loadSnapshot();
    return snapshot.highlights.map(_mapHighlight).toList(growable: false);
  }

  @override
  Future<List<SavedNote>> getNotes() async {
    final SavedLibraryLocalSnapshot snapshot = await _loadSnapshot();
    return snapshot.notes.map(_mapNote).toList(growable: false);
  }

  @override
  Future<List<SavedNote>> getPinnedNotes() async {
    final List<SavedNote> notes = await getNotes();
    return notes.where((SavedNote note) => note.isPinned).toList(growable: false);
  }

  @override
  Future<List<SavedHistoryEntry>> getHistory() async {
    final SavedLibraryLocalSnapshot snapshot = await _loadSnapshot();
    return snapshot.history.map(_mapHistory).toList(growable: false);
  }

  @override
  Future<SavedLibrarySummary> getSummary() async {
    final SavedLibraryLocalSnapshot snapshot = await _loadSnapshot();
    return SavedLibrarySummary(
      bookmarkCount: snapshot.bookmarks.length,
      highlightCount: snapshot.highlights.length,
      noteCount: snapshot.notes.length,
    );
  }

  Future<SavedLibraryLocalSnapshot> _loadSnapshot() async {
    final SavedLibraryLocalSnapshot snapshot = await _localStore.load();
    if (_hasContent(snapshot)) {
      return snapshot;
    }

    final SavedLibraryLocalSnapshot seeded = _buildSeedSnapshot();
    await _localStore.save(seeded);
    return seeded;
  }

  bool _hasContent(SavedLibraryLocalSnapshot snapshot) {
    return snapshot.bookmarks.isNotEmpty ||
        snapshot.highlights.isNotEmpty ||
        snapshot.notes.isNotEmpty ||
        snapshot.history.isNotEmpty;
  }

  SavedLibraryLocalSnapshot _buildSeedSnapshot() {
    final DateTime now = DateTime.now();
    final List<SavedBookmark> bookmarks = _fallback.getBookmarks();
    final List<SavedHighlight> highlights = _fallback.getHighlights();
    final List<SavedNote> notes = _fallback.getNotes();
    final List<SavedHistoryEntry> history = _fallback.getHistory();

    DateTime bookmarkTime(int index) => now.subtract(Duration(days: _bookmarkOffset(index)));
    DateTime highlightTime(int index) => now.subtract(Duration(days: _highlightOffset(index)));
    DateTime noteTime(int index) => now.subtract(Duration(days: _noteOffset(index)));
    DateTime historyTime(int index) => now.subtract(Duration(days: _historyOffset(index)));

    return SavedLibraryLocalSnapshot(
      bookmarks: <SavedBookmarkLocalRecord>[
        for (int index = 0; index < bookmarks.length; index++)
          _bookmarkToLocal(bookmarks[index], bookmarkTime(index)),
      ],
      highlights: <SavedHighlightLocalRecord>[
        for (int index = 0; index < highlights.length; index++)
          _highlightToLocal(highlights[index], highlightTime(index)),
      ],
      notes: <SavedNoteLocalRecord>[
        for (int index = 0; index < notes.length; index++)
          _noteToLocal(notes[index], noteTime(index)),
      ],
      history: <SavedHistoryLocalRecord>[
        for (int index = 0; index < history.length; index++)
          _historyToLocal(history[index], historyTime(index)),
      ],
    );
  }

  SavedBookmark _mapBookmark(SavedBookmarkLocalRecord record) {
    return SavedBookmark(
      id: record.id,
      reference: record.anchor.referenceLabel,
      verseText: record.anchor.verseTextSnapshot,
      categoryLabel: record.categoryLabel,
      savedAtLabel: _relativeLabel(
        DateTime.tryParse(record.savedAtIso),
        prefix: 'Saved',
      ),
      translationLabel: record.anchor.versionCode.toUpperCase(),
      hasReflection: (record.reflection ?? '').trim().isNotEmpty,
      highlightCount: record.highlightCount,
      reflectionPreview: record.reflection,
    );
  }

  SavedHighlight _mapHighlight(SavedHighlightLocalRecord record) {
    return SavedHighlight(
      id: record.id,
      reference: record.anchor.referenceLabel,
      verseText: record.anchor.verseTextSnapshot,
      highlightedText: record.selectedText,
      colorLabel: _labelForColor(record.colorKey),
      savedAtLabel: _relativeLabel(
        DateTime.tryParse(record.savedAtIso),
        prefix: 'Highlighted',
      ),
      notePreview: record.notePreview,
    );
  }

  SavedNote _mapNote(SavedNoteLocalRecord record) {
    return SavedNote(
      id: record.id,
      reference: record.anchor.referenceLabel,
      verseText: record.anchor.verseTextSnapshot,
      title: record.title,
      body: record.body,
      lastEditedLabel: _relativeLabel(
        DateTime.tryParse(record.updatedAtIso),
        prefix: 'Edited',
      ),
      isPinned: record.isPinned,
    );
  }

  SavedHistoryEntry _mapHistory(SavedHistoryLocalRecord record) {
    return SavedHistoryEntry(
      id: record.id,
      kind: _kindFromString(record.kind),
      title: record.title,
      subtitle: record.subtitle,
      timeLabel: _relativeLabel(DateTime.tryParse(record.occurredAtIso)),
    );
  }

  SavedBookmarkLocalRecord _bookmarkToLocal(
    SavedBookmark bookmark,
    DateTime savedAt,
  ) {
    return SavedBookmarkLocalRecord(
      id: bookmark.id,
      anchor: _anchorFromReference(
        reference: bookmark.reference,
        verseText: bookmark.verseText,
        translationLabel: bookmark.translationLabel,
      ),
      categoryLabel: bookmark.categoryLabel,
      savedAtIso: savedAt.toUtc().toIso8601String(),
      reflection: bookmark.reflectionPreview,
      highlightCount: bookmark.highlightCount,
    );
  }

  SavedHighlightLocalRecord _highlightToLocal(
    SavedHighlight highlight,
    DateTime savedAt,
  ) {
    return SavedHighlightLocalRecord(
      id: highlight.id,
      anchor: _anchorFromReference(
        reference: highlight.reference,
        verseText: highlight.verseText,
      ),
      selectedText: highlight.highlightedText,
      colorKey: _colorKeyFromLabel(highlight.colorLabel),
      savedAtIso: savedAt.toUtc().toIso8601String(),
      notePreview: highlight.notePreview,
    );
  }

  SavedNoteLocalRecord _noteToLocal(SavedNote note, DateTime updatedAt) {
    final DateTime createdAt = updatedAt.subtract(const Duration(hours: 4));
    return SavedNoteLocalRecord(
      id: note.id,
      anchor: _anchorFromReference(
        reference: note.reference,
        verseText: note.verseText,
      ),
      title: note.title,
      body: note.body,
      createdAtIso: createdAt.toUtc().toIso8601String(),
      updatedAtIso: updatedAt.toUtc().toIso8601String(),
      isPinned: note.isPinned,
    );
  }

  SavedHistoryLocalRecord _historyToLocal(
    SavedHistoryEntry entry,
    DateTime occurredAt,
  ) {
    return SavedHistoryLocalRecord(
      id: entry.id,
      kind: _kindToString(entry.kind),
      title: entry.title,
      subtitle: entry.subtitle,
      occurredAtIso: occurredAt.toUtc().toIso8601String(),
    );
  }

  SavedReferenceAnchor _anchorFromReference({
    required String reference,
    required String verseText,
    String translationLabel = 'KJV',
  }) {
    final RegExp matchExp = RegExp(
      r'^(.*?)\s+(\d+):(\d+)(?:[–-](\d+))?$',
    );
    final Match? match = matchExp.firstMatch(
      reference.replaceAll('—', '–').trim(),
    );
    final String bookName = match?.group(1)?.trim() ?? reference;
    final int chapter = int.tryParse(match?.group(2) ?? '') ?? 1;
    final int verseStart = int.tryParse(match?.group(3) ?? '') ?? 1;
    final int verseEnd = int.tryParse(match?.group(4) ?? '') ?? verseStart;

    return SavedReferenceAnchor(
      versionCode: translationLabel.toLowerCase(),
      bookId: _bookIdFromName(bookName),
      bookName: bookName,
      chapterStart: chapter,
      verseStart: verseStart,
      chapterEnd: chapter,
      verseEnd: verseEnd,
      referenceLabel: reference,
      verseTextSnapshot: verseText,
    );
  }

  String _bookIdFromName(String bookName) {
    return bookName
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '_')
        .replaceAll(RegExp(r'^_+|_+$'), '');
  }

  String _relativeLabel(DateTime? value, {String? prefix}) {
    if (value == null) {
      return prefix == null ? 'Recently' : '$prefix recently';
    }

    final Duration difference = DateTime.now().difference(value.toLocal());
    final int days = difference.inDays;

    String label;
    if (days <= 0) {
      label = 'today';
    } else if (days == 1) {
      label = 'yesterday';
    } else if (days < 7) {
      label = '$days days ago';
    } else {
      final int weeks = (days / 7).floor();
      label = weeks <= 1 ? '1 week ago' : '$weeks weeks ago';
    }

    if (prefix == null || prefix.isEmpty) {
      return _capitalize(label);
    }

    return '$prefix ${label.toLowerCase()}';
  }

  String _labelForColor(String colorKey) {
    switch (colorKey) {
      case 'warm_amber':
        return 'Warm amber';
      case 'soft_olive':
        return 'Soft olive';
      case 'dusty_rose':
        return 'Dusty rose';
      default:
        return _capitalize(colorKey.replaceAll('_', ' '));
    }
  }

  String _colorKeyFromLabel(String label) {
    return label.toLowerCase().replaceAll(' ', '_');
  }

  SavedHistoryKind _kindFromString(String kind) {
    switch (kind) {
      case 'chapter_read':
        return SavedHistoryKind.chapterRead;
      case 'plan_opened':
        return SavedHistoryKind.planOpened;
      case 'bookmark_saved':
        return SavedHistoryKind.bookmarkSaved;
      case 'highlight_saved':
        return SavedHistoryKind.highlightSaved;
      case 'note_written':
        return SavedHistoryKind.noteWritten;
      case 'verse_viewed':
      default:
        return SavedHistoryKind.verseViewed;
    }
  }

  String _kindToString(SavedHistoryKind kind) {
    switch (kind) {
      case SavedHistoryKind.chapterRead:
        return 'chapter_read';
      case SavedHistoryKind.planOpened:
        return 'plan_opened';
      case SavedHistoryKind.bookmarkSaved:
        return 'bookmark_saved';
      case SavedHistoryKind.highlightSaved:
        return 'highlight_saved';
      case SavedHistoryKind.noteWritten:
        return 'note_written';
      case SavedHistoryKind.verseViewed:
        return 'verse_viewed';
    }
  }

  String _capitalize(String value) {
    if (value.isEmpty) return value;
    return value[0].toUpperCase() + value.substring(1);
  }

  int _bookmarkOffset(int index) => const <int>[0, 1, 3, 7][index % 4];
  int _highlightOffset(int index) => const <int>[0, 1, 4, 7][index % 4];
  int _noteOffset(int index) => const <int>[0, 1, 3, 7][index % 4];
  int _historyOffset(int index) => const <int>[0, 0, 1, 1, 3, 7][index % 6];
}

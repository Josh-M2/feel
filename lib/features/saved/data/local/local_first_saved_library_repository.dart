import 'package:flutter/foundation.dart';

import '../../domain/models/saved_item.dart';
import '../../domain/models/saved_library_local_snapshot.dart';
import '../../domain/repositories/saved_library_repository.dart';
import '../../domain/repositories/saved_local_store.dart';
import 'shared_prefs_saved_local_store.dart';

class LocalFirstSavedLibraryRepository implements SavedLibraryRepository {
  LocalFirstSavedLibraryRepository({
    SavedLocalStore? localStore,
  }) : _localStore = localStore ?? SharedPrefsSavedLocalStore();

  static final ValueNotifier<int> _libraryRevision = ValueNotifier<int>(0);

  static ValueListenable<int> get libraryRevisionListenable => _libraryRevision;

  final SavedLocalStore _localStore;

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
    return notes
        .where((SavedNote note) => note.isPinned)
        .toList(growable: false);
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

  @override
  Future<SavedBookmark> saveBookmark({
    required SavedReferenceAnchor anchor,
    String categoryLabel = 'Reading',
    String? reflection,
  }) async {
    final SavedLibraryLocalSnapshot snapshot = await _loadSnapshot();
    final SavedReferenceAnchor normalizedAnchor = _normalizeAnchor(anchor);
    final DateTime now = DateTime.now().toUtc();
    final int existingIndex = snapshot.bookmarks.indexWhere(
      (SavedBookmarkLocalRecord item) =>
          item.anchor.referenceLabel == normalizedAnchor.referenceLabel,
    );

    late final SavedBookmarkLocalRecord record;
    final List<SavedBookmarkLocalRecord> nextBookmarks =
        List<SavedBookmarkLocalRecord>.from(snapshot.bookmarks);

    if (existingIndex >= 0) {
      final SavedBookmarkLocalRecord existing =
          nextBookmarks.removeAt(existingIndex);
      record = SavedBookmarkLocalRecord(
        id: existing.id,
        anchor: normalizedAnchor,
        categoryLabel: categoryLabel,
        savedAtIso: existing.savedAtIso,
        reflection: (reflection ?? '').trim().isEmpty
            ? existing.reflection
            : reflection,
        highlightCount: _countHighlightsForReference(
          snapshot.highlights,
          normalizedAnchor.referenceLabel,
        ),
      );
    } else {
      record = SavedBookmarkLocalRecord(
        id: _nextId('bookmark'),
        anchor: normalizedAnchor,
        categoryLabel: categoryLabel,
        savedAtIso: now.toIso8601String(),
        reflection: reflection,
        highlightCount: _countHighlightsForReference(
          snapshot.highlights,
          normalizedAnchor.referenceLabel,
        ),
      );
    }

    nextBookmarks.insert(0, record);
    await _localStore.save(
      snapshot.copyWith(
        bookmarks: nextBookmarks,
        history: _prependHistory(
          snapshot.history,
          SavedHistoryLocalRecord(
            id: _nextId('history'),
            kind: 'bookmark_saved',
            title: 'Bookmark saved',
            subtitle: normalizedAnchor.referenceLabel,
            occurredAtIso: now.toIso8601String(),
          ),
        ),
      ),
    );
    _notifyLibraryChanged();

    return _mapBookmark(record);
  }

  @override
  Future<SavedHighlight> saveHighlight({
    required SavedReferenceAnchor anchor,
    required String highlightedText,
    String colorKey = 'warm_amber',
    String? notePreview,
  }) async {
    final SavedLibraryLocalSnapshot snapshot = await _loadSnapshot();
    final SavedReferenceAnchor normalizedAnchor = _normalizeAnchor(anchor);
    final DateTime now = DateTime.now().toUtc();
    final List<SavedHighlightLocalRecord> nextHighlights =
        List<SavedHighlightLocalRecord>.from(snapshot.highlights)
          ..removeWhere(
            (SavedHighlightLocalRecord item) =>
                item.anchor.referenceLabel ==
                    normalizedAnchor.referenceLabel &&
                item.selectedText == highlightedText,
          );

    final SavedHighlightLocalRecord record = SavedHighlightLocalRecord(
      id: _nextId('highlight'),
      anchor: normalizedAnchor,
      selectedText: highlightedText,
      colorKey: colorKey,
      savedAtIso: now.toIso8601String(),
      notePreview: notePreview,
    );

    nextHighlights.insert(0, record);
    final int highlightCount = _countHighlightsForReference(
      nextHighlights,
      normalizedAnchor.referenceLabel,
    );
    final List<SavedBookmarkLocalRecord> nextBookmarks = snapshot.bookmarks
        .map((SavedBookmarkLocalRecord item) {
          if (item.anchor.referenceLabel != normalizedAnchor.referenceLabel) {
            return item;
          }

          return SavedBookmarkLocalRecord(
            id: item.id,
            anchor: _normalizeAnchor(item.anchor),
            categoryLabel: item.categoryLabel,
            savedAtIso: item.savedAtIso,
            reflection: item.reflection,
            highlightCount: highlightCount,
          );
        })
        .toList(growable: false);

    await _localStore.save(
      snapshot.copyWith(
        bookmarks: nextBookmarks,
        highlights: nextHighlights,
        history: _prependHistory(
          snapshot.history,
          SavedHistoryLocalRecord(
            id: _nextId('history'),
            kind: 'highlight_saved',
            title: 'Highlight saved',
            subtitle: normalizedAnchor.referenceLabel,
            occurredAtIso: now.toIso8601String(),
          ),
        ),
      ),
    );
    _notifyLibraryChanged();

    return _mapHighlight(record);
  }

  @override
  Future<SavedNote> saveNote({
    required SavedReferenceAnchor anchor,
    required String title,
    required String body,
    bool isPinned = false,
  }) async {
    final SavedLibraryLocalSnapshot snapshot = await _loadSnapshot();
    final SavedReferenceAnchor normalizedAnchor = _normalizeAnchor(anchor);
    final DateTime now = DateTime.now().toUtc();
    final SavedNoteLocalRecord record = SavedNoteLocalRecord(
      id: _nextId('saved_note'),
      anchor: normalizedAnchor,
      title: title,
      body: body,
      createdAtIso: now.toIso8601String(),
      updatedAtIso: now.toIso8601String(),
      isPinned: isPinned,
    );

    final List<SavedNoteLocalRecord> nextNotes = <SavedNoteLocalRecord>[
      record,
      ...snapshot.notes,
    ];
    await _localStore.save(
      snapshot.copyWith(
        notes: nextNotes,
        history: _prependHistory(
          snapshot.history,
          SavedHistoryLocalRecord(
            id: _nextId('history'),
            kind: 'note_written',
            title: 'Note added',
            subtitle: normalizedAnchor.referenceLabel,
            occurredAtIso: now.toIso8601String(),
          ),
        ),
      ),
    );
    _notifyLibraryChanged();

    return _mapNote(record);
  }

  Future<SavedLibraryLocalSnapshot> _loadSnapshot() async {
    final SavedLibraryLocalSnapshot snapshot = await _localStore.load();
    final SavedLibraryLocalSnapshot cleaned = _stripLegacySeedRecords(snapshot);
    if (_didSnapshotChange(snapshot, cleaned)) {
      await _localStore.save(cleaned);
      _notifyLibraryChanged();
    }
    return cleaned;
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

  SavedReferenceAnchor _normalizeAnchor(SavedReferenceAnchor anchor) {
    final String normalizedReference = _normalizeSavedReferenceDelimiters(
      anchor.referenceLabel,
    );
    final RegExp sameChapterExp = RegExp(r'^(.*?)\s+(\d+):(\d+)(?:-(\d+))?$');
    final Match? sameChapterMatch = sameChapterExp.firstMatch(
      normalizedReference,
    );

    String bookName = anchor.bookName.trim();
    int chapterStart = anchor.chapterStart;
    int verseStart = anchor.verseStart;
    int chapterEnd = anchor.chapterEnd;
    int verseEnd = anchor.verseEnd;

    if (sameChapterMatch != null) {
      bookName = sameChapterMatch.group(1)!.trim();
      chapterStart = int.tryParse(sameChapterMatch.group(2)!) ?? chapterStart;
      verseStart = int.tryParse(sameChapterMatch.group(3)!) ?? verseStart;
      verseEnd = int.tryParse(sameChapterMatch.group(4) ?? '') ?? verseEnd;
      chapterEnd = chapterStart;
    }

    return SavedReferenceAnchor(
      versionCode: _normalizeVersionCode(anchor.versionCode),
      bookId: _bookIdFromName(bookName),
      bookName: bookName,
      chapterStart: chapterStart,
      verseStart: verseStart,
      chapterEnd: chapterEnd,
      verseEnd: verseEnd,
      referenceLabel: normalizedReference,
      verseTextSnapshot: anchor.verseTextSnapshot.trim(),
    );
  }

  String _normalizeVersionCode(String value) {
    final String normalized = value.trim().toLowerCase();
    if (normalized.contains('web')) {
      return 'web';
    }
    return 'kjv';
  }

  SavedLibraryLocalSnapshot _stripLegacySeedRecords(
    SavedLibraryLocalSnapshot snapshot,
  ) {
    return snapshot.copyWith(
      bookmarks: snapshot.bookmarks
          .where(
            (SavedBookmarkLocalRecord item) => !_isLegacySeedId(
              item.id,
              prefix: 'bm_',
            ),
          )
          .toList(growable: false),
      highlights: snapshot.highlights
          .where(
            (SavedHighlightLocalRecord item) => !_isLegacySeedId(
              item.id,
              prefix: 'hl_',
            ),
          )
          .toList(growable: false),
      notes: snapshot.notes
          .where(
            (SavedNoteLocalRecord item) => !_isLegacySeedId(
              item.id,
              prefix: 'note_',
            ),
          )
          .toList(growable: false),
      history: snapshot.history
          .where(
            (SavedHistoryLocalRecord item) => !_isLegacySeedId(
              item.id,
              prefix: 'hist_',
            ),
          )
          .toList(growable: false),
    );
  }

  bool _didSnapshotChange(
    SavedLibraryLocalSnapshot original,
    SavedLibraryLocalSnapshot next,
  ) {
    return original.bookmarks.length != next.bookmarks.length ||
        original.highlights.length != next.highlights.length ||
        original.notes.length != next.notes.length ||
        original.history.length != next.history.length;
  }

  bool _isLegacySeedId(String value, {required String prefix}) {
    if (!value.startsWith(prefix) || value.length <= prefix.length) {
      return false;
    }

    final String suffix = value.substring(prefix.length);
    return suffix.length <= 2 && int.tryParse(suffix) != null;
  }

  String _normalizeSavedReferenceDelimiters(String value) {
    return value
        .trim()
        .replaceAll('\u2013', '-')
        .replaceAll('\u2014', '-')
        .replaceAll('\u00e2\u20ac\u201c', '-')
        .replaceAll('\u00e2\u20ac\u201d', '-');
  }

  String _bookIdFromName(String bookName) {
    return bookName
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '_')
        .replaceAll(RegExp(r'^_+|_+$'), '');
  }

  int _countHighlightsForReference(
    List<SavedHighlightLocalRecord> highlights,
    String referenceLabel,
  ) {
    return highlights
        .where(
          (SavedHighlightLocalRecord item) =>
              item.anchor.referenceLabel == referenceLabel,
        )
        .length;
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

  String _capitalize(String value) {
    if (value.isEmpty) return value;
    return value[0].toUpperCase() + value.substring(1);
  }

  List<SavedHistoryLocalRecord> _prependHistory(
    List<SavedHistoryLocalRecord> current,
    SavedHistoryLocalRecord entry,
  ) {
    return <SavedHistoryLocalRecord>[
      entry,
      ...current,
    ].take(40).toList(growable: false);
  }

  String _nextId(String prefix) {
    return '${prefix}_${DateTime.now().microsecondsSinceEpoch}';
  }

  void _notifyLibraryChanged() {
    _libraryRevision.value++;
  }
}

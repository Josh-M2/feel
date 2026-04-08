import '../models/saved_item.dart';
import '../models/saved_library_local_snapshot.dart';

abstract class SavedLibraryRepository {
  Future<SavedLibrarySummary> getSummary();
  Future<List<SavedBookmark>> getBookmarks();
  Future<List<SavedHighlight>> getHighlights();
  Future<List<SavedNote>> getNotes();
  Future<List<SavedNote>> getPinnedNotes();
  Future<List<SavedHistoryEntry>> getHistory();

  Future<SavedBookmark> saveBookmark({
    required SavedReferenceAnchor anchor,
    String categoryLabel,
    String? reflection,
  });

  Future<SavedHighlight> saveHighlight({
    required SavedReferenceAnchor anchor,
    required String highlightedText,
    String colorKey,
    String? notePreview,
  });

  Future<SavedNote> saveNote({
    required SavedReferenceAnchor anchor,
    required String title,
    required String body,
    bool isPinned,
  });
}

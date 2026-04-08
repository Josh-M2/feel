import '../models/saved_item.dart';

abstract class SavedLibraryRepository {
  Future<SavedLibrarySummary> getSummary();
  Future<List<SavedBookmark>> getBookmarks();
  Future<List<SavedHighlight>> getHighlights();
  Future<List<SavedNote>> getNotes();
  Future<List<SavedNote>> getPinnedNotes();
  Future<List<SavedHistoryEntry>> getHistory();
}

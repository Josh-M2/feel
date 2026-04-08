import '../models/read_book.dart';
import '../models/read_continue_point.dart';
import '../models/read_reference_search_result.dart';

abstract class ReadRepository {
  Future<List<ReadBook>> getBooks();
  Future<ReadBook> getBookById(String? bookId);
  Future<ReadBook> getContinueReadingBook();
  Future<ReadChapter> getChapter({required String bookId, int? chapterNumber});
  Future<ReadChapter?> getPreviousChapter({
    required String bookId,
    required int chapterNumber,
  });
  Future<ReadChapter?> getNextChapter({
    required String bookId,
    required int chapterNumber,
  });
  Future<List<ReadReferenceSearchResult>> searchReferences(String query);
  Future<List<ReadContinuePoint>> getContinueReadingQueue();
  Future<void> recordChapterOpened({
    required String bookId,
    required int chapterNumber,
    String? bookName,
    String? chapterTitle,
    String? focusLine,
  });
}

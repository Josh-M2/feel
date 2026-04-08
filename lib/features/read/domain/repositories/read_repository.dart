import '../models/read_book.dart';
import '../models/read_continue_point.dart';
import '../models/read_reference_search_result.dart';

abstract class ReadRepository {
  Future<List<ReadBook>> getBooks();
  Future<ReadBook> getBookById(String? bookId);
  Future<ReadBook> getContinueReadingBook({String? versionCode});
  Future<ReadChapter> getChapter({
    required String bookId,
    int? chapterNumber,
    String? versionCode,
  });
  Future<ReadChapter?> getPreviousChapter({
    required String bookId,
    required int chapterNumber,
    String? versionCode,
  });
  Future<ReadChapter?> getNextChapter({
    required String bookId,
    required int chapterNumber,
    String? versionCode,
  });
  Future<List<ReadReferenceSearchResult>> searchReferences(
    String query, {
    String? versionCode,
  });
  Future<List<ReadContinuePoint>> getContinueReadingQueue({String? versionCode});
  Future<void> recordChapterOpened({
    required String bookId,
    required int chapterNumber,
    String? bookName,
    String? chapterTitle,
    String? focusLine,
    String? versionCode,
    String? versionLabel,
  });
}

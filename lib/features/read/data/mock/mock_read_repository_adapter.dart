import '../../domain/models/read_book.dart';
import '../../domain/models/read_continue_point.dart';
import '../../domain/models/read_reference_search_result.dart';
import '../../domain/repositories/read_repository.dart';
import 'mock_read_repository.dart';

class MockReadRepositoryAdapter implements ReadRepository {
  const MockReadRepositoryAdapter({MockReadRepository? source})
    : _source = source ?? const MockReadRepository();

  final MockReadRepository _source;

  @override
  Future<List<ReadBook>> getBooks() async => _source.getBooks();

  @override
  Future<ReadBook> getBookById(String? bookId) async => _source.getBookById(bookId);

  @override
  Future<ReadBook> getContinueReadingBook() async => _source.getContinueReadingBook();

  @override
  Future<ReadChapter> getChapter({required String bookId, int? chapterNumber}) async =>
      _source.getChapter(bookId: bookId, chapterNumber: chapterNumber);

  @override
  Future<ReadChapter?> getPreviousChapter({
    required String bookId,
    required int chapterNumber,
  }) async => _source.getPreviousMockChapter(bookId: bookId, chapterNumber: chapterNumber);

  @override
  Future<ReadChapter?> getNextChapter({
    required String bookId,
    required int chapterNumber,
  }) async => _source.getNextMockChapter(bookId: bookId, chapterNumber: chapterNumber);

  @override
  Future<List<ReadReferenceSearchResult>> searchReferences(String query) async {
    final String normalized = query.trim().toLowerCase();
    if (normalized.isEmpty) return const <ReadReferenceSearchResult>[];

    final RegExp digitExp = RegExp(r'(\d+)');
    final Match? digitMatch = digitExp.firstMatch(normalized);
    final int? requestedChapter =
        digitMatch != null ? int.tryParse(digitMatch.group(1)!) : null;

    final List<ReadReferenceSearchResult> results = <ReadReferenceSearchResult>[];
    final Set<String> seen = <String>{};

    bool matchesBook(ReadBook book) {
      final String name = book.name.toLowerCase();
      if (normalized.contains(name)) return true;

      final List<String> words = name.split(' ');
      for (final String word in words) {
        if (word.isNotEmpty && normalized.contains(word)) return true;
      }

      return name.startsWith(normalized);
    }

    for (final ReadBook book in _source.getBooks()) {
      final bool bookMatched = matchesBook(book);
      final Iterable<ReadChapter> chapters = requestedChapter != null
          ? book.mockChapters.where((ReadChapter chapter) => chapter.number == requestedChapter)
          : book.mockChapters;

      for (final ReadChapter chapter in chapters) {
        final bool chapterMatchedByNumber =
            requestedChapter != null && chapter.number == requestedChapter;
        final bool chapterMatchedByText =
            chapter.title.toLowerCase().contains(normalized) ||
            chapter.introduction.toLowerCase().contains(normalized) ||
            chapter.focusLine.toLowerCase().contains(normalized) ||
            chapter.blocks.any(
              (ReadPassageBlock block) =>
                  block.rangeLabel.toLowerCase().contains(normalized) ||
                  block.heading.toLowerCase().contains(normalized) ||
                  block.verses.any(
                    (ReadVerseLine verse) => verse.text.toLowerCase().contains(normalized),
                  ),
            );

        if (!bookMatched && !chapterMatchedByNumber && !chapterMatchedByText) {
          continue;
        }

        final String key = '${book.id}-${chapter.number}';
        if (!seen.add(key)) continue;

        results.add(
          ReadReferenceSearchResult(
            bookId: book.id,
            bookName: book.name,
            chapterNumber: chapter.number,
            chapterTitle: chapter.title,
            subtitle: chapter.focusLine,
          ),
        );
      }
    }

    return results;
  }

  @override
  Future<List<ReadContinuePoint>> getContinueReadingQueue() async {
    final ReadBook continueBook = _source.getContinueReadingBook();
    final ReadChapter continueChapter = _source.getChapter(
      bookId: continueBook.id,
      chapterNumber: continueBook.continueChapterNumber,
    );

    return <ReadContinuePoint>[
      ReadContinuePoint(
        bookId: continueBook.id,
        bookName: continueBook.name,
        chapterNumber: continueChapter.number,
        chapterTitle: continueChapter.title,
        label: 'Most recent',
        focusLine: continueChapter.focusLine,
      ),
      for (final ReadBook book in _source.getBooks().where((ReadBook item) => item.id != continueBook.id).take(3))
        ReadContinuePoint(
          bookId: book.id,
          bookName: book.name,
          chapterNumber: book.continueChapterNumber,
          chapterTitle: _source.getChapter(
            bookId: book.id,
            chapterNumber: book.continueChapterNumber,
          ).title,
          label: 'Recent reading',
          focusLine: _source.getChapter(
            bookId: book.id,
            chapterNumber: book.continueChapterNumber,
          ).focusLine,
        ),
    ];
  }

  @override
  Future<void> recordChapterOpened({
    required String bookId,
    required int chapterNumber,
    String? bookName,
    String? chapterTitle,
    String? focusLine,
  }) async {}
}

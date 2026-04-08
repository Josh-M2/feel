import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/models/read_book.dart';
import '../../domain/models/read_continue_point.dart';
import '../../domain/models/read_reference_search_result.dart';
import '../../domain/repositories/read_repository.dart';
import '../mock/mock_read_repository.dart';
import '../mock/mock_read_repository_adapter.dart';

class SupabasePublicReadRepository implements ReadRepository {
  SupabasePublicReadRepository({SupabaseClient? client})
    : _client = _resolveClient(client);

  final SupabaseClient? _client;
  static const MockReadRepository _fallback = MockReadRepository();

  static SupabaseClient? _resolveClient(SupabaseClient? client) {
    if (client != null) return client;

    try {
      return Supabase.instance.client;
    } catch (_) {
      return null;
    }
  }

  bool get _isConfigured => _client != null;

  @override
  Future<List<ReadBook>> getBooks() async {
    if (!_isConfigured) {
      return _fallback.getBooks();
    }

    final List<dynamic> rows = await _client!
        .from('content_bible_books')
        .select(
          'id, name, testament, chapter_count, short_description, overview, why_read, key_themes, preferred_continue_chapter',
        )
        .eq('is_active', true)
        .order('sort_order');

    if (rows.isEmpty) {
      return _fallback.getBooks();
    }

    final List<ReadBook> books = <ReadBook>[];
    for (final dynamic item in rows) {
      final Map<String, dynamic> row = Map<String, dynamic>.from(item as Map);
      books.add(await _mapBookRow(row));
    }
    return books;
  }

  @override
  Future<ReadBook> getBookById(String? bookId) async {
    if (!_isConfigured || bookId == null || bookId.trim().isEmpty) {
      return _fallback.getBookById(bookId);
    }

    final dynamic row = await _client!
        .from('content_bible_books')
        .select(
          'id, name, testament, chapter_count, short_description, overview, why_read, key_themes, preferred_continue_chapter',
        )
        .eq('id', bookId.trim().toLowerCase())
        .eq('is_active', true)
        .maybeSingle();

    if (row == null) {
      return _fallback.getBookById(bookId);
    }

    return _mapBookRow(Map<String, dynamic>.from(row as Map));
  }

  @override
  Future<ReadBook> getContinueReadingBook() async {
    if (!_isConfigured) {
      return _fallback.getContinueReadingBook();
    }

    final dynamic featured = await _client!
        .from('content_bible_books')
        .select(
          'id, name, testament, chapter_count, short_description, overview, why_read, key_themes, preferred_continue_chapter',
        )
        .eq('is_active', true)
        .eq('is_featured_default', true)
        .maybeSingle();

    if (featured != null) {
      return _mapBookRow(Map<String, dynamic>.from(featured as Map));
    }

    final List<ReadBook> books = await getBooks();
    return books.isEmpty ? _fallback.getContinueReadingBook() : books.first;
  }

  @override
  Future<ReadChapter> getChapter({required String bookId, int? chapterNumber}) async {
    if (!_isConfigured) {
      return _fallback.getChapter(bookId: bookId, chapterNumber: chapterNumber);
    }

    final ReadBook book = await getBookById(bookId);
    final int targetChapter = chapterNumber ?? book.continueChapterNumber;

    final dynamic chapterRow = await _client!
        .from('content_bible_chapters')
        .select('chapter_number, title, introduction, focus_line')
        .eq('book_id', book.id)
        .eq('chapter_number', targetChapter)
        .maybeSingle();

    if (chapterRow == null) {
      return _fallback.getChapter(bookId: bookId, chapterNumber: chapterNumber);
    }

    final List<dynamic> sectionRows = await _client!
        .from('content_chapter_sections')
        .select('heading, verse_start, verse_end, sort_order')
        .eq('book_id', book.id)
        .eq('chapter_number', targetChapter)
        .order('sort_order');

    final List<dynamic> verseRows = await _client!
        .from('content_bible_verses')
        .select('verse_number, verse_text')
        .eq('book_id', book.id)
        .eq('version_id', 'kjv')
        .eq('chapter_number', targetChapter)
        .order('verse_number');

    return _mapChapterRow(
      bookName: book.name,
      chapterRow: Map<String, dynamic>.from(chapterRow as Map),
      sectionRows: sectionRows,
      verseRows: verseRows,
    );
  }

  @override
  Future<ReadChapter?> getPreviousChapter({
    required String bookId,
    required int chapterNumber,
  }) async {
    if (!_isConfigured) {
      return _fallback.getPreviousMockChapter(
        bookId: bookId,
        chapterNumber: chapterNumber,
      );
    }

    final dynamic row = await _client!
        .from('content_bible_chapters')
        .select('chapter_number')
        .eq('book_id', bookId)
        .lt('chapter_number', chapterNumber)
        .order('chapter_number', ascending: false)
        .limit(1)
        .maybeSingle();

    if (row == null) return null;

    final int previousNumber = (row['chapter_number'] as num).toInt();
    return getChapter(bookId: bookId, chapterNumber: previousNumber);
  }

  @override
  Future<ReadChapter?> getNextChapter({
    required String bookId,
    required int chapterNumber,
  }) async {
    if (!_isConfigured) {
      return _fallback.getNextMockChapter(
        bookId: bookId,
        chapterNumber: chapterNumber,
      );
    }

    final dynamic row = await _client!
        .from('content_bible_chapters')
        .select('chapter_number')
        .eq('book_id', bookId)
        .gt('chapter_number', chapterNumber)
        .order('chapter_number')
        .limit(1)
        .maybeSingle();

    if (row == null) return null;

    final int nextNumber = (row['chapter_number'] as num).toInt();
    return getChapter(bookId: bookId, chapterNumber: nextNumber);
  }

  @override
  Future<List<ReadReferenceSearchResult>> searchReferences(String query) async {
    if (!_isConfigured) {
      return const MockReadRepositoryAdapter().searchReferences(query);
    }

    final String normalized = query.trim().toLowerCase();
    if (normalized.isEmpty) return const <ReadReferenceSearchResult>[];

    final RegExp digitExp = RegExp(r'(\d+)');
    final Match? digitMatch = digitExp.firstMatch(normalized);
    final int? requestedChapter =
        digitMatch != null ? int.tryParse(digitMatch.group(1)!) : null;

    final List<ReadBook> books = await getBooks();
    final List<Map<String, dynamic>> aliasRows = (await _client!
            .from('content_book_aliases')
            .select('book_id, alias'))
        .map((dynamic item) => Map<String, dynamic>.from(item as Map))
        .toList();

    bool matchesBook(ReadBook book) {
      final String name = book.name.toLowerCase();
      if (normalized.contains(name)) return true;
      final Iterable<String> aliases = aliasRows
          .where((Map<String, dynamic> row) => row['book_id'] == book.id)
          .map(
            (Map<String, dynamic> row) => row['alias'].toString().toLowerCase(),
          );
      for (final String alias in aliases) {
        if (alias.isNotEmpty && normalized.contains(alias)) return true;
      }
      return name.startsWith(normalized);
    }

    final List<ReadReferenceSearchResult> results =
        <ReadReferenceSearchResult>[];
    final Set<String> seen = <String>{};

    for (final ReadBook book in books) {
      final bool bookMatched = matchesBook(book);
      final List<dynamic> chapterRows = await _client!
          .from('content_bible_chapters')
          .select('chapter_number, title, introduction, focus_line')
          .eq('book_id', book.id)
          .order('chapter_number');

      for (final dynamic item in chapterRows) {
        final Map<String, dynamic> row = Map<String, dynamic>.from(item as Map);
        final int chapter = (row['chapter_number'] as num).toInt();
        if (requestedChapter != null && chapter != requestedChapter && !bookMatched) {
          continue;
        }

        final bool chapterMatchedByText =
            row['title'].toString().toLowerCase().contains(normalized) ||
            row['introduction'].toString().toLowerCase().contains(normalized) ||
            row['focus_line'].toString().toLowerCase().contains(normalized);
        final bool chapterMatchedByNumber =
            requestedChapter != null && chapter == requestedChapter;

        if (!bookMatched && !chapterMatchedByText && !chapterMatchedByNumber) {
          continue;
        }

        final String key = '${book.id}-$chapter';
        if (!seen.add(key)) continue;

        results.add(
          ReadReferenceSearchResult(
            bookId: book.id,
            bookName: book.name,
            chapterNumber: chapter,
            chapterTitle: row['title']?.toString() ?? 'Chapter $chapter',
            subtitle: row['focus_line']?.toString() ?? '',
          ),
        );
      }
    }

    if (results.isEmpty) {
      return const MockReadRepositoryAdapter().searchReferences(query);
    }

    return results;
  }

  @override
  Future<List<ReadContinuePoint>> getContinueReadingQueue() async {
    if (!_isConfigured) {
      return const MockReadRepositoryAdapter().getContinueReadingQueue();
    }

    final List<ReadBook> books = await getBooks();
    if (books.isEmpty) {
      return const MockReadRepositoryAdapter().getContinueReadingQueue();
    }

    final List<ReadContinuePoint> queue = <ReadContinuePoint>[];
    for (final ReadBook book in books.take(4)) {
      final ReadChapter chapter = await getChapter(
        bookId: book.id,
        chapterNumber: book.continueChapterNumber,
      );
      queue.add(
        ReadContinuePoint(
          bookId: book.id,
          bookName: book.name,
          chapterNumber: chapter.number,
          chapterTitle: chapter.title,
          label: queue.isEmpty ? 'Featured reading' : 'Suggested return',
          focusLine: chapter.focusLine,
        ),
      );
    }
    return queue;
  }

  Future<ReadBook> _mapBookRow(Map<String, dynamic> row) async {
    final String bookId = row['id'].toString();
    final List<dynamic> chapterRows = await _client!
        .from('content_bible_chapters')
        .select('chapter_number, title, introduction, focus_line')
        .eq('book_id', bookId)
        .order('chapter_number');

    final List<ReadChapter> chapters = <ReadChapter>[];
    for (final dynamic item in chapterRows) {
      final Map<String, dynamic> chapterRow = Map<String, dynamic>.from(item as Map);
      final int chapterNumber = (chapterRow['chapter_number'] as num).toInt();
      final List<dynamic> sectionRows = await _client!
          .from('content_chapter_sections')
          .select('heading, verse_start, verse_end, sort_order')
          .eq('book_id', bookId)
          .eq('chapter_number', chapterNumber)
          .order('sort_order');
      final List<dynamic> verseRows = await _client!
          .from('content_bible_verses')
          .select('verse_number, verse_text')
          .eq('book_id', bookId)
          .eq('version_id', 'kjv')
          .eq('chapter_number', chapterNumber)
          .order('verse_number');

      chapters.add(
        _mapChapterRow(
          bookName: row['name']?.toString() ?? '',
          chapterRow: chapterRow,
          sectionRows: sectionRows,
          verseRows: verseRows,
        ),
      );
    }

    final int continueChapterNumber =
        (row['preferred_continue_chapter'] as num?)?.toInt() ??
        (chapters.isEmpty ? 1 : chapters.first.number);

    return ReadBook(
      id: bookId,
      name: row['name']?.toString() ?? '',
      testament: row['testament']?.toString() ?? 'New Testament',
      chapterCount: (row['chapter_count'] as num?)?.toInt() ?? chapters.length,
      shortDescription: row['short_description']?.toString() ?? '',
      overview: row['overview']?.toString() ?? '',
      whyRead: row['why_read']?.toString() ?? '',
      keyThemes: (row['key_themes'] as List<dynamic>? ?? const <dynamic>[])
          .map((dynamic item) => item.toString())
          .toList(growable: false),
      continueChapterNumber: continueChapterNumber,
      mockChapters: chapters,
    );
  }

  ReadChapter _mapChapterRow({
    required String bookName,
    required Map<String, dynamic> chapterRow,
    required List<dynamic> sectionRows,
    required List<dynamic> verseRows,
  }) {
    final int chapterNumber = (chapterRow['chapter_number'] as num?)?.toInt() ?? 1;
    final List<Map<String, dynamic>> normalizedVerses = verseRows
        .map((dynamic item) => Map<String, dynamic>.from(item as Map))
        .toList(growable: false);

    final List<ReadPassageBlock> blocks = sectionRows.isEmpty
        ? <ReadPassageBlock>[
            ReadPassageBlock(
              heading: '$bookName $chapterNumber',
              rangeLabel: '$bookName $chapterNumber',
              verses: normalizedVerses
                  .map(
                    (Map<String, dynamic> verse) => ReadVerseLine(
                      number: (verse['verse_number'] as num?)?.toInt() ?? 1,
                      text: verse['verse_text']?.toString() ?? '',
                    ),
                  )
                  .toList(growable: false),
            ),
          ]
        : sectionRows.map((dynamic item) {
            final Map<String, dynamic> row = Map<String, dynamic>.from(item as Map);
            final int verseStart = (row['verse_start'] as num?)?.toInt() ?? 1;
            final int verseEnd = (row['verse_end'] as num?)?.toInt() ?? verseStart;
            final List<ReadVerseLine> verses = normalizedVerses
                .where(
                  (Map<String, dynamic> verse) {
                    final int verseNumber = (verse['verse_number'] as num?)?.toInt() ?? 1;
                    return verseNumber >= verseStart && verseNumber <= verseEnd;
                  },
                )
                .map(
                  (Map<String, dynamic> verse) => ReadVerseLine(
                    number: (verse['verse_number'] as num?)?.toInt() ?? 1,
                    text: verse['verse_text']?.toString() ?? '',
                  ),
                )
                .toList(growable: false);

            return ReadPassageBlock(
              heading: row['heading']?.toString() ?? '$bookName $chapterNumber',
              rangeLabel: '$bookName $chapterNumber:$verseStart${verseEnd == verseStart ? '' : '–$verseEnd'}',
              verses: verses,
            );
          }).toList(growable: false);

    return ReadChapter(
      number: chapterNumber,
      title: chapterRow['title']?.toString() ?? 'Chapter $chapterNumber',
      introduction: chapterRow['introduction']?.toString() ?? '',
      focusLine: chapterRow['focus_line']?.toString() ?? '',
      blocks: blocks,
    );
  }
}

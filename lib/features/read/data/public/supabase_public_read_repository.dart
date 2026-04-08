import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../today/domain/models/bible_source_passage.dart';
import '../../../today/domain/repositories/bible_source_adapter.dart';
import '../../../today/data/source/configurable_bible_source_adapter.dart';

import '../../domain/models/read_book.dart';
import '../../domain/models/read_continue_point.dart';
import '../../domain/models/read_reference_search_result.dart';
import '../../domain/repositories/read_repository.dart';
import '../local/read_progress_local_snapshot.dart';
import '../local/read_progress_local_store.dart';
import '../local/shared_prefs_read_progress_local_store.dart';
import '../mock/mock_read_repository.dart';
import '../mock/mock_read_repository_adapter.dart';

class SupabasePublicReadRepository implements ReadRepository {
  SupabasePublicReadRepository({
    SupabaseClient? client,
    ReadProgressLocalStore? localStore,
    BibleSourceAdapter? bibleSourceAdapter,
  }) : _client = _resolveClient(client),
       _localStore = localStore ?? SharedPrefsReadProgressLocalStore(),
       _bibleSourceAdapter = bibleSourceAdapter ?? ConfigurableBibleSourceAdapter();

  final SupabaseClient? _client;
  final ReadProgressLocalStore _localStore;
  final BibleSourceAdapter _bibleSourceAdapter;
  static const MockReadRepository _fallback = MockReadRepository();
  static const int _localQueueLimit = 5;

  static SupabaseClient? _resolveClient(SupabaseClient? client) {
    if (client != null) return client;

    try {
      return Supabase.instance.client;
    } catch (_) {
      return null;
    }
  }

  bool get _isConfigured => _client != null;
  String? get _authenticatedUserId => _client?.auth.currentUser?.id;

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
  Future<ReadBook> getContinueReadingBook({String? versionCode}) async {
    final List<ReadContinuePoint> queue = await getContinueReadingQueue(versionCode: versionCode);
    if (queue.isEmpty) {
      return _fallback.getContinueReadingBook();
    }

    try {
      return await getBookById(queue.first.bookId);
    } catch (_) {
      return _fallback.getContinueReadingBook();
    }
  }

  @override
  Future<ReadChapter> getChapter({required String bookId, int? chapterNumber, String? versionCode}) async {
    final String effectiveVersionCode = _sanitizeVersionCode(versionCode);
    if (!_isConfigured) {
      return const MockReadRepositoryAdapter().getChapter(
        bookId: bookId,
        chapterNumber: chapterNumber,
        versionCode: effectiveVersionCode,
      );
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
      return const MockReadRepositoryAdapter().getChapter(
        bookId: bookId,
        chapterNumber: chapterNumber,
        versionCode: effectiveVersionCode,
      );
    }

    final List<dynamic> sectionRows = await _client!
        .from('content_chapter_sections')
        .select('heading, verse_start, verse_end, sort_order')
        .eq('book_id', book.id)
        .eq('chapter_number', targetChapter)
        .order('sort_order');

    final List<dynamic> requestedVerseRows = await _loadVerseRows(
      bookId: book.id,
      chapterNumber: targetChapter,
      versionCode: effectiveVersionCode,
    );

    String appliedTranslationCode = effectiveVersionCode;
    String appliedTranslationLabel = _translationLabelFor(effectiveVersionCode);
    bool isFallbackTranslation = false;
    List<dynamic> verseRows = requestedVerseRows;

    if (verseRows.isEmpty && effectiveVersionCode != 'kjv') {
      final BibleSourcePassage? livePassage = await _bibleSourceAdapter.fetchPassageByReference(
        reference: '${book.name} $targetChapter',
        translationCode: effectiveVersionCode,
      );
      if (livePassage != null && livePassage.verses.isNotEmpty) {
        verseRows = livePassage.verses
            .map(
              (BibleSourcePassageVerse verse) => <String, dynamic>{
                'verse_number': verse.number,
                'verse_text': verse.text,
              },
            )
            .toList(growable: false);
        appliedTranslationLabel = livePassage.translationLabel;
      }
    }

    if (verseRows.isEmpty) {
      verseRows = await _loadVerseRows(
        bookId: book.id,
        chapterNumber: targetChapter,
        versionCode: 'kjv',
      );
      appliedTranslationCode = 'kjv';
      appliedTranslationLabel = effectiveVersionCode == 'kjv'
          ? _translationLabelFor('kjv')
          : '${_translationLabelFor(effectiveVersionCode)} requested • KJV fallback';
      isFallbackTranslation = effectiveVersionCode != 'kjv';
    }

    return _mapChapterRow(
      bookName: book.name,
      chapterRow: Map<String, dynamic>.from(chapterRow as Map),
      sectionRows: sectionRows,
      verseRows: verseRows,
      translationCode: appliedTranslationCode,
      translationLabel: appliedTranslationLabel,
      isTranslationFallback: isFallbackTranslation,
    );
  }

  @override
  Future<ReadChapter?> getPreviousChapter({
    required String bookId,
    required int chapterNumber,
    String? versionCode,
  }) async {
    if (!_isConfigured) {
      return const MockReadRepositoryAdapter().getPreviousChapter(
        bookId: bookId,
        chapterNumber: chapterNumber,
        versionCode: versionCode,
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
    return getChapter(bookId: bookId, chapterNumber: previousNumber, versionCode: versionCode);
  }

  @override
  Future<ReadChapter?> getNextChapter({
    required String bookId,
    required int chapterNumber,
    String? versionCode,
  }) async {
    if (!_isConfigured) {
      return const MockReadRepositoryAdapter().getNextChapter(
        bookId: bookId,
        chapterNumber: chapterNumber,
        versionCode: versionCode,
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
    return getChapter(bookId: bookId, chapterNumber: nextNumber, versionCode: versionCode);
  }

  @override
  Future<List<ReadReferenceSearchResult>> searchReferences(String query, {String? versionCode}) async {
    if (!_isConfigured) {
      return const MockReadRepositoryAdapter().searchReferences(query, versionCode: versionCode);
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
      return const MockReadRepositoryAdapter().searchReferences(query, versionCode: versionCode);
    }

    return results;
  }

  @override
  Future<List<ReadContinuePoint>> getContinueReadingQueue({String? versionCode}) async {
    final String? userId = _authenticatedUserId;
    if (userId != null) {
      final List<ReadContinuePoint> remoteQueue = await _loadRemoteQueue(userId);
      if (remoteQueue.isNotEmpty) {
        return remoteQueue;
      }
    }

    final List<ReadContinuePoint> localQueue = await _loadLocalQueue();
    if (localQueue.isNotEmpty) {
      return localQueue;
    }

    if (_isConfigured) {
      final List<ReadBook> books = await getBooks();
      if (books.isNotEmpty) {
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
    }

    return const MockReadRepositoryAdapter().getContinueReadingQueue(versionCode: versionCode);
  }

  @override
  Future<void> recordChapterOpened({
    required String bookId,
    required int chapterNumber,
    String? bookName,
    String? chapterTitle,
    String? focusLine,
    String? versionCode,
    String? versionLabel,
  }) async {
    String resolvedBookName = bookName ?? '';
    String resolvedChapterTitle = chapterTitle ?? '';
    String resolvedFocusLine = focusLine ?? '';

    if (resolvedBookName.isEmpty ||
        resolvedChapterTitle.isEmpty ||
        resolvedFocusLine.isEmpty) {
      try {
        final ReadBook book = await getBookById(bookId);
        final ReadChapter chapter = await getChapter(
          bookId: bookId,
          chapterNumber: chapterNumber,
          versionCode: versionCode,
        );
        resolvedBookName = resolvedBookName.isEmpty ? book.name : resolvedBookName;
        resolvedChapterTitle = resolvedChapterTitle.isEmpty
            ? chapter.title
            : resolvedChapterTitle;
        resolvedFocusLine = resolvedFocusLine.isEmpty
            ? chapter.focusLine
            : resolvedFocusLine;
      } catch (_) {
        resolvedBookName = resolvedBookName.isEmpty ? bookId : resolvedBookName;
        resolvedChapterTitle = resolvedChapterTitle.isEmpty
            ? 'Chapter $chapterNumber'
            : resolvedChapterTitle;
      }
    }

    final ReadProgressLocalRecord entry = ReadProgressLocalRecord(
      bookId: bookId,
      bookName: resolvedBookName,
      chapterNumber: chapterNumber,
      chapterTitle: resolvedChapterTitle,
      focusLine: resolvedFocusLine,
      openedAtIso: DateTime.now().toUtc().toIso8601String(),
      versionCode: _sanitizeVersionCode(versionCode),
      versionLabel: versionLabel ?? _translationLabelFor(_sanitizeVersionCode(versionCode)),
    );

    await _saveLocalEntry(entry);

    final String? userId = _authenticatedUserId;
    if (!_isConfigured || userId == null) {
      return;
    }

    try {
      await _client!
          .from('user_read_progress')
          .upsert(
            <String, dynamic>{
              'user_id': userId,
              'book_id': bookId,
              'chapter_number': chapterNumber,
              'book_name': resolvedBookName,
              'chapter_title': resolvedChapterTitle,
              'focus_line': resolvedFocusLine,
              'version_code': entry.versionCode,
              'version_label': entry.versionLabel,
              'last_opened_at': DateTime.now().toUtc().toIso8601String(),
            },
            onConflict: 'user_id,book_id,chapter_number',
          );
    } catch (_) {
      // Local persistence already succeeded. Remote sync can be retried later.
    }
  }

  Future<List<ReadContinuePoint>> _loadRemoteQueue(String userId) async {
    try {
      final List<dynamic> rows = await _client!
          .from('user_read_progress')
          .select(
            'book_id, chapter_number, book_name, chapter_title, focus_line, version_code, version_label, last_opened_at',
          )
          .eq('user_id', userId)
          .order('last_opened_at', ascending: false)
          .limit(_localQueueLimit);

      return rows.asMap().entries.map((MapEntry<int, dynamic> entry) {
        final Map<String, dynamic> row = Map<String, dynamic>.from(entry.value as Map);
        final int chapterNumber = (row['chapter_number'] as num?)?.toInt() ?? 1;
        return ReadContinuePoint(
          bookId: row['book_id']?.toString() ?? '',
          bookName: row['book_name']?.toString() ?? row['book_id']?.toString() ?? '',
          chapterNumber: chapterNumber,
          chapterTitle:
              row['chapter_title']?.toString() ?? 'Chapter $chapterNumber',
          label: entry.key == 0 ? 'Most recent' : 'Recent reading',
          focusLine: row['focus_line']?.toString() ?? '',
          versionCode: row['version_code']?.toString() ?? 'kjv',
          versionLabel: row['version_label']?.toString() ?? 'KJV',
        );
      }).toList(growable: false);
    } catch (_) {
      return const <ReadContinuePoint>[];
    }
  }

  Future<List<ReadContinuePoint>> _loadLocalQueue() async {
    final ReadProgressLocalSnapshot snapshot = await _localStore.load();
    if (snapshot.entries.isEmpty) {
      return const <ReadContinuePoint>[];
    }

    final List<ReadProgressLocalRecord> sorted = List<ReadProgressLocalRecord>.from(
      snapshot.entries,
    )..sort((ReadProgressLocalRecord a, ReadProgressLocalRecord b) {
        final DateTime aTime = DateTime.tryParse(a.openedAtIso) ?? DateTime.fromMillisecondsSinceEpoch(0);
        final DateTime bTime = DateTime.tryParse(b.openedAtIso) ?? DateTime.fromMillisecondsSinceEpoch(0);
        return bTime.compareTo(aTime);
      });

    return sorted.take(_localQueueLimit).toList(growable: false).asMap().entries.map(
      (MapEntry<int, ReadProgressLocalRecord> entry) {
        final ReadProgressLocalRecord item = entry.value;
        return ReadContinuePoint(
          bookId: item.bookId,
          bookName: item.bookName,
          chapterNumber: item.chapterNumber,
          chapterTitle: item.chapterTitle,
          label: entry.key == 0 ? 'Most recent' : 'Recent reading',
          focusLine: item.focusLine,
          versionCode: item.versionCode,
          versionLabel: item.versionLabel,
        );
      },
    ).toList(growable: false);
  }

  Future<void> _saveLocalEntry(ReadProgressLocalRecord entry) async {
    final ReadProgressLocalSnapshot snapshot = await _localStore.load();
    final List<ReadProgressLocalRecord> next = <ReadProgressLocalRecord>[
      entry,
      ...snapshot.entries.where(
        (ReadProgressLocalRecord item) =>
            item.bookId != entry.bookId || item.chapterNumber != entry.chapterNumber,
      ),
    ];

    await _localStore.save(
      snapshot.copyWith(entries: next.take(_localQueueLimit).toList(growable: false)),
    );
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

  Future<List<dynamic>> _loadVerseRows({
    required String bookId,
    required int chapterNumber,
    required String versionCode,
  }) async {
    return _client!
        .from('content_bible_verses')
        .select('verse_number, verse_text')
        .eq('book_id', bookId)
        .eq('version_id', versionCode)
        .eq('chapter_number', chapterNumber)
        .order('verse_number');
  }

  String _sanitizeVersionCode(String? value) {
    return AppConstants.sanitizeTranslationCode(value);
  }

  String _translationLabelFor(String versionCode) {
    return AppConstants.translationOptionFor(versionCode).label;
  }

  ReadChapter _mapChapterRow({
    required String bookName,
    required Map<String, dynamic> chapterRow,
    required List<dynamic> sectionRows,
    required List<dynamic> verseRows,
    String translationCode = 'kjv',
    String translationLabel = 'KJV',
    bool isTranslationFallback = false,
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
      translationCode: translationCode,
      translationLabel: translationLabel,
      isTranslationFallback: isTranslationFallback,
    );
  }
}

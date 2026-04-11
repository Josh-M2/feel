import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/bootstrap/app_bootstrap_controller.dart';
import '../../../../app/router/app_routes.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radii.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/app_screen_scaffold.dart';
import '../../../saved/data/local/local_first_saved_library_repository.dart';
import '../../../saved/domain/models/saved_library_local_snapshot.dart';
import '../../../saved/domain/repositories/saved_library_repository.dart';
import '../../data/public/supabase_public_read_repository.dart';
import '../../domain/models/read_book.dart';
import '../../domain/models/read_continue_point.dart';
import '../../domain/models/read_reference_search_result.dart';
import '../../domain/repositories/read_repository.dart';
import '../widgets/read_book_list_card.dart';
import '../widgets/read_info_card.dart';
import '../widgets/read_passage_block_card.dart';

final ReadRepository _repository = SupabasePublicReadRepository();
final SavedLibraryRepository _savedRepository =
    LocalFirstSavedLibraryRepository();

class ReadBooksScreen extends StatelessWidget {
  const ReadBooksScreen({super.key, required this.bootstrap});

  final AppBootstrapController bootstrap;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<_ReadBooksScreenData>(
      future: _loadReadBooksScreenData(),
      builder: (context, snapshot) {
        return _buildReadScaffold(
          context: context,
          title: 'Read',
          subtitle: 'Books, chapters, references, and resume reading',
          snapshot: snapshot,
          dataBuilder: (context, data) => ListView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
            children: <Widget>[
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Continue reading',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Chip(label: Text(bootstrap.preferredTranslationLabel)),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      '${data.continueBook.name} ${data.continueChapter.number}',
                      style: Theme.of(
                        context,
                      ).textTheme.headlineMedium?.copyWith(fontSize: 30),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      data.continueChapter.title,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      data.continueChapter.focusLine,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: () {
                          context.push(
                            AppRoutes.readChapterRead,
                            extra: ChapterReadRouteArgs(
                              bookId: data.continueBook.id,
                              chapterNumber: data.continueChapter.number,
                            ),
                          );
                        },
                        child: const Text('Resume chapter'),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              ReadInfoCard(
                title: 'How to use Read',
                subtitle:
                    'Browse books, jump to a chapter, or return to where you left off.',
                icon: Icons.menu_book_outlined,
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _ReadBullet(
                      text: 'Browse books in a calm, library-style flow.',
                    ),
                    _ReadBullet(
                      text: 'Open a book before moving into chapter reading.',
                    ),
                    _ReadBullet(
                      text:
                          'Use reference search when you already know where you want to go.',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text('Books', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: AppSpacing.md),
              ...data.books.map(
                (ReadBook book) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: ReadBookListCard(
                    book: book,
                    onTap: () {
                      context.push(
                        AppRoutes.readBookDetail,
                        extra: ReadBookRouteArgs(bookId: book.id),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<_ReadBooksScreenData> _loadReadBooksScreenData() async {
    final List<ReadBook> books = await _repository.getBooks();
    final List<ReadContinuePoint> queue = await _repository
        .getContinueReadingQueue(
          versionCode: bootstrap.preferredTranslationCode,
        );

    late final ReadBook continueBook;
    late final ReadChapter continueChapter;

    if (queue.isNotEmpty) {
      final ReadContinuePoint continuePoint = queue.first;
      continueBook = await _repository.getBookById(continuePoint.bookId);
      continueChapter = await _repository.getChapter(
        bookId: continuePoint.bookId,
        chapterNumber: continuePoint.chapterNumber,
        versionCode: bootstrap.preferredTranslationCode,
      );
    } else {
      continueBook = await _repository.getContinueReadingBook(
        versionCode: bootstrap.preferredTranslationCode,
      );
      continueChapter = await _repository.getChapter(
        bookId: continueBook.id,
        chapterNumber: continueBook.continueChapterNumber,
        versionCode: bootstrap.preferredTranslationCode,
      );
    }

    return _ReadBooksScreenData(
      books: books,
      continueBook: continueBook,
      continueChapter: continueChapter,
    );
  }
}

class ReadBookDetailScreen extends StatelessWidget {
  const ReadBookDetailScreen({super.key, required this.bootstrap, this.bookId});

  final AppBootstrapController bootstrap;
  final String? bookId;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ReadBook>(
      future: _repository.getBookById(bookId),
      builder: (context, snapshot) {
        return _buildReadScaffold(
          context: context,
          title: 'Book detail',
          subtitle: 'Read',
          showBackButton: true,
          snapshot: snapshot,
          dataBuilder: (context, book) => ListView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
            children: <Widget>[
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: <Widget>[
                        Chip(label: Text(book.testament)),
                        Chip(label: Text('${book.chapterCount} chapters')),
                        const Chip(label: Text('Reading')),
                        Chip(label: Text(bootstrap.preferredTranslationLabel)),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Text(
                      book.name,
                      style: Theme.of(
                        context,
                      ).textTheme.headlineMedium?.copyWith(fontSize: 32),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      book.shortDescription,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: FilledButton(
                            onPressed: () {
                              context.push(
                                AppRoutes.readChapterRead,
                                extra: ChapterReadRouteArgs(
                                  bookId: book.id,
                                  chapterNumber: book.mockChapters.first.number,
                                ),
                              );
                            },
                            child: Text(
                              'Read chapter ${book.mockChapters.first.number}',
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              context.push(
                                AppRoutes.readChapterRead,
                                extra: ChapterReadRouteArgs(
                                  bookId: book.id,
                                  chapterNumber: book.continueChapterNumber,
                                ),
                              );
                            },
                            child: const Text('Continue'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              ReadInfoCard(
                title: 'Overview',
                subtitle:
                    'A short introduction to the book before you begin reading.',
                icon: Icons.description_outlined,
                child: Text(
                  book.overview,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              ReadInfoCard(
                title: 'Why read this book',
                icon: Icons.lightbulb_outline_rounded,
                child: Text(
                  book.whyRead,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              ReadInfoCard(
                title: 'Key themes',
                icon: Icons.local_offer_outlined,
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: book.keyThemes
                      .map((String theme) => Chip(label: Text(theme)))
                      .toList(),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              ReadInfoCard(
                title: 'Chapters in this reading set',
                subtitle: 'Choose a chapter to begin or return to.',
                icon: Icons.view_list_outlined,
                child: Column(
                  children: book.mockChapters
                      .map(
                        (ReadChapter chapter) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _ChapterTile(
                            chapter: chapter,
                            onTap: () {
                              context.push(
                                AppRoutes.readChapterRead,
                                extra: ChapterReadRouteArgs(
                                  bookId: book.id,
                                  chapterNumber: chapter.number,
                                ),
                              );
                            },
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'More ways to continue',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () =>
                            context.push(AppRoutes.readReferenceSearch),
                        child: const Text('Search by reference'),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () =>
                            context.push(AppRoutes.readContinueReading),
                        child: const Text('Continue reading'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class ChapterReadScreen extends StatefulWidget {
  const ChapterReadScreen({
    super.key,
    required this.bootstrap,
    this.bookId,
    this.chapterNumber,
  });

  final AppBootstrapController bootstrap;
  final String? bookId;
  final int? chapterNumber;

  @override
  State<ChapterReadScreen> createState() => _ChapterReadScreenState();
}

class _ChapterReadScreenState extends State<ChapterReadScreen> {
  late final Future<_ChapterReadScreenData> _screenDataFuture;
  bool _recordedOpen = false;
  bool _saveBusy = false;

  @override
  void initState() {
    super.initState();
    _screenDataFuture = _loadChapterReadScreenData();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<_ChapterReadScreenData>(
      future: _screenDataFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          _recordChapterOpened(snapshot.data!);
        }

        return _buildReadScaffold(
          context: context,
          title: 'Chapter read',
          subtitle: 'Read',
          showBackButton: true,
          snapshot: snapshot,
          dataBuilder: (context, data) => ListView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
            children: <Widget>[
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: <Widget>[
                        Chip(label: Text(data.book.name)),
                        Chip(label: Text('Chapter ${data.chapter.number}')),
                        Chip(label: Text(data.chapter.translationLabel)),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Text(
                      '${data.book.name} ${data.chapter.number}',
                      style: Theme.of(
                        context,
                      ).textTheme.headlineMedium?.copyWith(fontSize: 32),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      data.chapter.title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      data.chapter.introduction,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    if (data.chapter.isTranslationFallback) ...<Widget>[
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        'The requested translation was not available for this chapter yet, so the reading surface fell back to the seeded KJV scaffold.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              ReadInfoCard(
                title: 'Reading focus',
                subtitle: 'A single thought to carry through the chapter.',
                icon: Icons.center_focus_strong_outlined,
                child: Text(
                  data.chapter.focusLine,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              ...data.chapter.blocks.map(
                (ReadPassageBlock block) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: ReadPassageBlockCard(block: block),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              ReadInfoCard(
                title: 'Save from this chapter',
                subtitle:
                    'Bookmark it, save a key highlight, or add a private note.',
                icon: Icons.bookmark_outline_rounded,
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: _saveBusy ? null : () => _saveBookmark(data),
                        icon: const Icon(Icons.bookmark_add_outlined),
                        label: const Text('Save bookmark'),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: _saveBusy
                            ? null
                            : () => _saveHighlight(data),
                        icon: const Icon(Icons.highlight_alt_outlined),
                        label: const Text('Save highlight'),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: _saveBusy
                            ? null
                            : () => _showNoteComposer(data),
                        icon: const Icon(Icons.edit_note_outlined),
                        label: const Text('Add note'),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              ReadInfoCard(
                title: 'Keep reading',
                icon: Icons.auto_awesome_outlined,
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () {
                          context.push(
                            AppRoutes.readBookDetail,
                            extra: ReadBookRouteArgs(bookId: data.book.id),
                          );
                        },
                        child: const Text('Back to book detail'),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: OutlinedButton(
                            onPressed: data.previousChapter == null
                                ? null
                                : () {
                                    context.push(
                                      AppRoutes.readChapterRead,
                                      extra: ChapterReadRouteArgs(
                                        bookId: data.book.id,
                                        chapterNumber:
                                            data.previousChapter!.number,
                                      ),
                                    );
                                  },
                            child: const Text('Previous'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: data.nextChapter == null
                                ? null
                                : () {
                                    context.push(
                                      AppRoutes.readChapterRead,
                                      extra: ChapterReadRouteArgs(
                                        bookId: data.book.id,
                                        chapterNumber: data.nextChapter!.number,
                                      ),
                                    );
                                  },
                            child: const Text('Next'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'More ways to move through scripture',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () =>
                            context.push(AppRoutes.readReferenceSearch),
                        child: const Text('Search by reference'),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () =>
                            context.push(AppRoutes.readContinueReading),
                        child: const Text('Continue reading'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<_ChapterReadScreenData> _loadChapterReadScreenData() async {
    final String resolvedBookId = widget.bookId ?? 'john';
    final ReadBook book = await _repository.getBookById(resolvedBookId);
    final ReadChapter chapter = await _repository.getChapter(
      bookId: book.id,
      chapterNumber: widget.chapterNumber,
      versionCode: widget.bootstrap.preferredTranslationCode,
    );
    final ReadChapter? previousChapter = await _repository.getPreviousChapter(
      bookId: book.id,
      chapterNumber: chapter.number,
      versionCode: widget.bootstrap.preferredTranslationCode,
    );
    final ReadChapter? nextChapter = await _repository.getNextChapter(
      bookId: book.id,
      chapterNumber: chapter.number,
      versionCode: widget.bootstrap.preferredTranslationCode,
    );

    return _ChapterReadScreenData(
      book: book,
      chapter: chapter,
      previousChapter: previousChapter,
      nextChapter: nextChapter,
    );
  }

  void _recordChapterOpened(_ChapterReadScreenData data) {
    if (_recordedOpen) return;
    _recordedOpen = true;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _repository.recordChapterOpened(
        bookId: data.book.id,
        chapterNumber: data.chapter.number,
        bookName: data.book.name,
        chapterTitle: data.chapter.title,
        focusLine: data.chapter.focusLine,
        versionCode: data.chapter.translationCode,
        versionLabel: data.chapter.translationLabel,
      );
    });
  }

  Future<void> _saveBookmark(_ChapterReadScreenData data) async {
    await _runSaveAction(() async {
      await _savedRepository.saveBookmark(
        anchor: _buildChapterAnchor(data),
        categoryLabel: 'Reading',
      );
      _showSnackBar('Bookmark saved to Saved.');
    });
  }

  Future<void> _saveHighlight(_ChapterReadScreenData data) async {
    await _runSaveAction(() async {
      final String highlightedText = _highlightTextForChapter(data);
      await _savedRepository.saveHighlight(
        anchor: _buildChapterAnchor(data),
        highlightedText: highlightedText,
        notePreview: data.chapter.focusLine,
      );
      _showSnackBar('Highlight saved to Saved.');
    });
  }

  Future<void> _showNoteComposer(_ChapterReadScreenData data) async {
    final TextEditingController titleController = TextEditingController(
      text: '${data.book.name} ${data.chapter.number}',
    );
    final TextEditingController bodyController = TextEditingController();

    final bool? submitted = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Add note'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    hintText: 'Chapter note title',
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                TextField(
                  controller: bodyController,
                  minLines: 4,
                  maxLines: 6,
                  decoration: const InputDecoration(
                    labelText: 'Note',
                    hintText: 'Write a private reflection for this chapter.',
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('Save note'),
            ),
          ],
        );
      },
    );

    if (submitted != true) {
      titleController.dispose();
      bodyController.dispose();
      return;
    }

    final String title = titleController.text.trim();
    final String body = bodyController.text.trim();
    titleController.dispose();
    bodyController.dispose();

    if (body.isEmpty) {
      _showSnackBar('Write a note before saving.');
      return;
    }

    await _runSaveAction(() async {
      await _savedRepository.saveNote(
        anchor: _buildChapterAnchor(data),
        title: title.isEmpty
            ? '${data.book.name} ${data.chapter.number}'
            : title,
        body: body,
      );
      _showSnackBar('Note saved to Saved.');
    });
  }

  Future<void> _runSaveAction(Future<void> Function() action) async {
    if (_saveBusy) return;
    setState(() => _saveBusy = true);
    try {
      await action();
    } finally {
      if (mounted) {
        setState(() => _saveBusy = false);
      }
    }
  }

  SavedReferenceAnchor _buildChapterAnchor(_ChapterReadScreenData data) {
    final List<ReadVerseLine> verses = data.chapter.blocks
        .expand((ReadPassageBlock block) => block.verses)
        .toList(growable: false);
    final int verseStart = verses.isEmpty ? 1 : verses.first.number;
    final int verseEnd = verses.isEmpty ? verseStart : verses.last.number;
    final String referenceLabel =
        '${data.book.name} ${data.chapter.number}:$verseStart${verseEnd == verseStart ? '' : '–$verseEnd'}';
    final String normalizedReferenceLabel = referenceLabel
        .replaceAll('\u2013', '-')
        .replaceAll('\u2014', '-')
        .replaceAll('\u00e2\u20ac\u201c', '-')
        .replaceAll('\u00e2\u20ac\u201d', '-');
    final String verseTextSnapshot = verses
        .take(2)
        .map((ReadVerseLine verse) => '${verse.number}. ${verse.text}')
        .join(' ')
        .trim();

    return SavedReferenceAnchor(
      versionCode: data.chapter.translationCode,
      bookId: data.book.id,
      bookName: data.book.name,
      chapterStart: data.chapter.number,
      verseStart: verseStart,
      chapterEnd: data.chapter.number,
      verseEnd: verseEnd,
      referenceLabel: normalizedReferenceLabel,
      verseTextSnapshot: verseTextSnapshot.isEmpty
          ? data.chapter.focusLine
          : verseTextSnapshot,
    );
  }

  String _highlightTextForChapter(_ChapterReadScreenData data) {
    final List<ReadVerseLine> verses = data.chapter.blocks
        .expand((ReadPassageBlock block) => block.verses)
        .toList(growable: false);
    if (verses.isEmpty) {
      return data.chapter.focusLine;
    }

    final ReadVerseLine verse = verses.first;
    return '${verse.number}. ${verse.text}';
  }

  void _showSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }
}

class ReadReferenceSearchScreen extends StatefulWidget {
  const ReadReferenceSearchScreen({super.key, required this.bootstrap});

  final AppBootstrapController bootstrap;

  @override
  State<ReadReferenceSearchScreen> createState() =>
      _ReadReferenceSearchScreenState();
}

class _ReadReferenceSearchScreenState extends State<ReadReferenceSearchScreen> {
  late final TextEditingController _controller;
  String _query = '';
  Future<List<ReadReferenceSearchResult>>? _searchFuture;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onQueryChanged(String value) {
    setState(() {
      _query = value;
      _searchFuture = value.trim().isEmpty
          ? null
          : _repository.searchReferences(
              value,
              versionCode: widget.bootstrap.preferredTranslationCode,
            );
    });
  }

  void _applySuggestion(String value) {
    _controller.text = value;
    _controller.selection = TextSelection.fromPosition(
      TextPosition(offset: _controller.text.length),
    );
    _onQueryChanged(value);
  }

  @override
  Widget build(BuildContext context) {
    return TabScreenScaffold(
      title: 'Reference search',
      subtitle: 'Read',
      showBackButton: true,
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
        children: <Widget>[
          ReadInfoCard(
            title: 'Search by reference',
            subtitle:
                'Go straight to a chapter by entering a book and chapter.',
            icon: Icons.search_rounded,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextField(
                  controller: _controller,
                  onChanged: _onQueryChanged,
                  textInputAction: TextInputAction.search,
                  decoration: const InputDecoration(
                    hintText: 'Try: John 3, Psalm 23, Philippians 4',
                    prefixIcon: Icon(Icons.search_rounded),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Chip(
                    label: Text(widget.bootstrap.preferredTranslationLabel),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: <Widget>[
                    _SuggestionChip(
                      label: 'John 3',
                      onTap: () => _applySuggestion('John 3'),
                    ),
                    _SuggestionChip(
                      label: 'Psalm 23',
                      onTap: () => _applySuggestion('Psalm 23'),
                    ),
                    _SuggestionChip(
                      label: 'Philippians 4',
                      onTap: () => _applySuggestion('Philippians 4'),
                    ),
                    _SuggestionChip(
                      label: 'born again',
                      onTap: () => _applySuggestion('born again'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          if (_query.trim().isEmpty)
            ReadInfoCard(
              title: 'Quick references',
              subtitle: 'Choose a familiar chapter to jump in right away.',
              icon: Icons.flash_on_outlined,
              child: Column(
                children: <Widget>[
                  _QuickReferenceTile(
                    title: 'John 3',
                    subtitle: 'You must be born again',
                    onTap: () {
                      context.push(
                        AppRoutes.readChapterRead,
                        extra: const ChapterReadRouteArgs(
                          bookId: 'john',
                          chapterNumber: 3,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  _QuickReferenceTile(
                    title: 'Psalm 23',
                    subtitle: 'The Lord my shepherd',
                    onTap: () {
                      context.push(
                        AppRoutes.readChapterRead,
                        extra: const ChapterReadRouteArgs(
                          bookId: 'psalms',
                          chapterNumber: 23,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  _QuickReferenceTile(
                    title: 'Philippians 4',
                    subtitle: 'Prayer and peace',
                    onTap: () {
                      context.push(
                        AppRoutes.readChapterRead,
                        extra: const ChapterReadRouteArgs(
                          bookId: 'philippians',
                          chapterNumber: 4,
                        ),
                      );
                    },
                  ),
                ],
              ),
            )
          else
            FutureBuilder<List<ReadReferenceSearchResult>>(
              future: _searchFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const _InlineLoadingCard(
                    title: 'Searching references',
                    subtitle: 'Looking for matching chapters in your library.',
                  );
                }

                if (snapshot.hasError) {
                  return _InlineStateCard(
                    title: 'Search unavailable',
                    subtitle:
                        'The reference search could not load right now. Try again in a moment.',
                    icon: Icons.search_off_rounded,
                  );
                }

                final List<ReadReferenceSearchResult> matches =
                    snapshot.data ?? const <ReadReferenceSearchResult>[];

                if (matches.isEmpty) {
                  return _InlineStateCard(
                    title: 'No matching result',
                    subtitle:
                        'Try another reference or choose one of the suggestions above.',
                    icon: Icons.search_off_rounded,
                    body:
                        'A short list of chapter suggestions is a good place to start if you are not sure where to go next.',
                  );
                }

                return ReadInfoCard(
                  title: 'Search results',
                  subtitle:
                      '${matches.length} matching chapter${matches.length == 1 ? '' : 's'}.',
                  icon: Icons.menu_book_outlined,
                  child: Column(
                    children: matches
                        .map(
                          (ReadReferenceSearchResult match) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: _SearchResultTile(match: match),
                          ),
                        )
                        .toList(),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}

class ReadContinueReadingScreen extends StatelessWidget {
  const ReadContinueReadingScreen({super.key, required this.bootstrap});

  final AppBootstrapController bootstrap;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ReadContinuePoint>>(
      future: _repository.getContinueReadingQueue(
        versionCode: bootstrap.preferredTranslationCode,
      ),
      builder: (context, snapshot) {
        return _buildReadScaffold(
          context: context,
          title: 'Continue reading',
          subtitle: 'Read',
          showBackButton: true,
          snapshot: snapshot,
          dataBuilder: (context, queue) {
            final ReadContinuePoint continuePoint = queue.first;

            return ListView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
              children: <Widget>[
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Return to where you left off',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Chip(label: Text(bootstrap.preferredTranslationLabel)),
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        '${continuePoint.bookName} ${continuePoint.chapterNumber}',
                        style: Theme.of(
                          context,
                        ).textTheme.headlineMedium?.copyWith(fontSize: 30),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        continuePoint.chapterTitle,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        continuePoint.focusLine,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: () {
                            context.push(
                              AppRoutes.readChapterRead,
                              extra: ChapterReadRouteArgs(
                                bookId: continuePoint.bookId,
                                chapterNumber: continuePoint.chapterNumber,
                              ),
                            );
                          },
                          child: const Text('Resume reading'),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                ReadInfoCard(
                  title: 'Pick up again',
                  subtitle: 'A simple way to return to recent reading points.',
                  icon: Icons.history_edu_outlined,
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      _ReadBullet(
                        text:
                            'Return to the last chapter that was most recently opened.',
                      ),
                      _ReadBullet(
                        text:
                            'Keep the choices few so the screen stays calm and easy to use.',
                      ),
                      _ReadBullet(
                        text:
                            'Move back into reading without needing to search again.',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                ReadInfoCard(
                  title: 'Recent reading points',
                  subtitle: 'A short list of meaningful places to return to.',
                  icon: Icons.schedule_rounded,
                  child: Column(
                    children: queue
                        .map(
                          (ReadContinuePoint item) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: _ContinueReadingTile(item: item),
                          ),
                        )
                        .toList(),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'More ways to continue',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () =>
                              context.push(AppRoutes.readReferenceSearch),
                          child: const Text('Search by reference'),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () => context.push(
                            AppRoutes.readBookDetail,
                            extra: ReadBookRouteArgs(
                              bookId: continuePoint.bookId,
                            ),
                          ),
                          child: Text('Open ${continuePoint.bookName} details'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

Widget _buildReadScaffold<T>({
  required BuildContext context,
  required String title,
  required String subtitle,
  required AsyncSnapshot<T> snapshot,
  required Widget Function(BuildContext context, T data) dataBuilder,
  bool showBackButton = false,
}) {
  return TabScreenScaffold(
    title: title,
    subtitle: subtitle,
    showBackButton: showBackButton,
    body: Builder(
      builder: (context) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const _ReadLoadingBody();
        }

        if (snapshot.hasError) {
          return _ReadFailureBody(error: snapshot.error);
        }

        final T? data = snapshot.data;
        if (data == null) {
          return const _ReadFailureBody();
        }

        if (data is List && data.isEmpty) {
          return const _ReadEmptyBody();
        }

        return dataBuilder(context, data);
      },
    ),
  );
}

class _ReadLoadingBody extends StatelessWidget {
  const _ReadLoadingBody();

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: AppColors.surfaceSoft,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.border),
                ),
                alignment: Alignment.center,
                child: const SizedBox(
                  width: 28,
                  height: 28,
                  child: CircularProgressIndicator(strokeWidth: 3),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                'Loading reading content...',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Preparing books, chapters, and your recent reading state.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ReadFailureBody extends StatelessWidget {
  const _ReadFailureBody({this.error});

  final Object? error;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
      children: <Widget>[
        ReadInfoCard(
          title: 'Read is unavailable right now',
          subtitle:
              'The repository could not return reading data for this screen.',
          icon: Icons.error_outline_rounded,
          child: Text(
            error?.toString() ??
                'Try again after checking your seed data or Supabase connection.',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
      ],
    );
  }
}

class _ReadEmptyBody extends StatelessWidget {
  const _ReadEmptyBody();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
      children: const <Widget>[
        _InlineStateCard(
          title: 'No reading content yet',
          subtitle: 'Seed the public scripture tables to populate this screen.',
          icon: Icons.menu_book_outlined,
        ),
      ],
    );
  }
}

class _InlineLoadingCard extends StatelessWidget {
  const _InlineLoadingCard({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const CircularProgressIndicator(),
          const SizedBox(height: AppSpacing.lg),
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: AppSpacing.sm),
          Text(subtitle, style: Theme.of(context).textTheme.bodyLarge),
        ],
      ),
    );
  }
}

class _InlineStateCard extends StatelessWidget {
  const _InlineStateCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    this.body,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final String? body;

  @override
  Widget build(BuildContext context) {
    return ReadInfoCard(
      title: title,
      subtitle: subtitle,
      icon: icon,
      child: Text(
        body ?? subtitle,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
    );
  }
}

class _ReadBooksScreenData {
  const _ReadBooksScreenData({
    required this.books,
    required this.continueBook,
    required this.continueChapter,
  });

  final List<ReadBook> books;
  final ReadBook continueBook;
  final ReadChapter continueChapter;
}

class _ChapterReadScreenData {
  const _ChapterReadScreenData({
    required this.book,
    required this.chapter,
    required this.previousChapter,
    required this.nextChapter,
  });

  final ReadBook book;
  final ReadChapter chapter;
  final ReadChapter? previousChapter;
  final ReadChapter? nextChapter;
}

class _ReadBullet extends StatelessWidget {
  const _ReadBullet({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.only(top: 6),
            child: Icon(Icons.circle, size: 8, color: AppColors.accent),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(text, style: Theme.of(context).textTheme.bodyLarge),
          ),
        ],
      ),
    );
  }
}

class _ChapterTile extends StatelessWidget {
  const _ChapterTile({required this.chapter, required this.onTap});

  final ReadChapter chapter;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surfaceSoft,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        onTap: onTap,
        title: Text(
          'Chapter ${chapter.number}',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Text(chapter.title),
        ),
        trailing: const Icon(Icons.arrow_forward_rounded),
      ),
    );
  }
}

class _SearchResultTile extends StatelessWidget {
  const _SearchResultTile({required this.match});

  final ReadReferenceSearchResult match;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surfaceSoft,
        borderRadius: BorderRadius.circular(AppRadii.xl),
        border: Border.all(color: AppColors.border),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        onTap: () {
          context.push(
            AppRoutes.readChapterRead,
            extra: ChapterReadRouteArgs(
              bookId: match.bookId,
              chapterNumber: match.chapterNumber,
            ),
          );
        },
        title: Text(
          '${match.bookName} ${match.chapterNumber}',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Text(match.subtitle),
        ),
        trailing: const Icon(Icons.arrow_forward_rounded),
      ),
    );
  }
}

class _QuickReferenceTile extends StatelessWidget {
  const _QuickReferenceTile({
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surfaceSoft,
        borderRadius: BorderRadius.circular(AppRadii.xl),
        border: Border.all(color: AppColors.border),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        onTap: onTap,
        title: Text(title, style: Theme.of(context).textTheme.titleMedium),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Text(subtitle),
        ),
        trailing: const Icon(Icons.arrow_forward_rounded),
      ),
    );
  }
}

class _SuggestionChip extends StatelessWidget {
  const _SuggestionChip({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      onPressed: onTap,
      label: Text(label),
      avatar: const Icon(Icons.search_rounded, size: 16),
    );
  }
}

class _ContinueReadingTile extends StatelessWidget {
  const _ContinueReadingTile({required this.item});

  final ReadContinuePoint item;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surfaceSoft,
        borderRadius: BorderRadius.circular(AppRadii.xl),
        border: Border.all(color: AppColors.border),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        onTap: () {
          context.push(
            AppRoutes.readChapterRead,
            extra: ChapterReadRouteArgs(
              bookId: item.bookId,
              chapterNumber: item.chapterNumber,
            ),
          );
        },
        leading: DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.surfaceMuted,
            borderRadius: BorderRadius.circular(AppRadii.lg),
          ),
          child: const SizedBox(
            width: 42,
            height: 42,
            child: Icon(Icons.menu_book_outlined, color: AppColors.primary),
          ),
        ),
        title: Text(
          '${item.bookName} ${item.chapterNumber}',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Text('${item.label} · ${item.chapterTitle}'),
        ),
        trailing: const Icon(Icons.arrow_forward_rounded),
      ),
    );
  }
}

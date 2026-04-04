import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radii.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/app_screen_scaffold.dart';
import '../../data/mock/mock_read_repository.dart';
import '../../domain/models/read_book.dart';
import '../widgets/read_book_list_card.dart';
import '../widgets/read_info_card.dart';
import '../widgets/read_passage_block_card.dart';

class ReadBooksScreen extends StatelessWidget {
  const ReadBooksScreen({super.key});

  static const MockReadRepository _repository = MockReadRepository();

  @override
  Widget build(BuildContext context) {
    final List<ReadBook> books = _repository.getBooks();
    final ReadBook continueBook = _repository.getContinueReadingBook();
    final ReadChapter continueChapter = _repository.getChapter(
      bookId: continueBook.id,
      chapterNumber: continueBook.continueChapterNumber,
    );

    return TabScreenScaffold(
      title: 'Read',
      subtitle: 'Books, chapters, references, and resume reading',
      body: ListView(
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
                const SizedBox(height: AppSpacing.md),
                Text(
                  '${continueBook.name} ${continueChapter.number}',
                  style: Theme.of(
                    context,
                  ).textTheme.headlineMedium?.copyWith(fontSize: 30),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  continueChapter.title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  continueChapter.focusLine,
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
                          bookId: continueBook.id,
                          chapterNumber: continueChapter.number,
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
          ...books.map(
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
  }
}

class ReadBookDetailScreen extends StatelessWidget {
  const ReadBookDetailScreen({super.key, this.bookId});

  static const MockReadRepository _repository = MockReadRepository();

  final String? bookId;

  @override
  Widget build(BuildContext context) {
    final ReadBook book = _repository.getBookById(bookId);

    return TabScreenScaffold(
      title: 'Book detail',
      subtitle: 'Read',
      showBackButton: true,
      body: ListView(
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
  }
}

class ChapterReadScreen extends StatelessWidget {
  const ChapterReadScreen({super.key, this.bookId, this.chapterNumber});

  static const MockReadRepository _repository = MockReadRepository();

  final String? bookId;
  final int? chapterNumber;

  @override
  Widget build(BuildContext context) {
    final ReadBook book = _repository.getBookById(bookId);
    final ReadChapter chapter = _repository.getChapter(
      bookId: book.id,
      chapterNumber: chapterNumber,
    );
    final ReadChapter? previousChapter = _repository.getPreviousMockChapter(
      bookId: book.id,
      chapterNumber: chapter.number,
    );
    final ReadChapter? nextChapter = _repository.getNextMockChapter(
      bookId: book.id,
      chapterNumber: chapter.number,
    );

    return TabScreenScaffold(
      title: 'Chapter read',
      subtitle: 'Read',
      showBackButton: true,
      body: ListView(
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
                    Chip(label: Text(book.name)),
                    Chip(label: Text('Chapter ${chapter.number}')),
                    const Chip(label: Text('KJV')),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  '${book.name} ${chapter.number}',
                  style: Theme.of(
                    context,
                  ).textTheme.headlineMedium?.copyWith(fontSize: 32),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  chapter.title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  chapter.introduction,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          ReadInfoCard(
            title: 'Reading focus',
            subtitle: 'A single thought to carry through the chapter.',
            icon: Icons.center_focus_strong_outlined,
            child: Text(
              chapter.focusLine,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          ...chapter.blocks.map(
            (ReadPassageBlock block) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: ReadPassageBlockCard(block: block),
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
                        extra: ReadBookRouteArgs(bookId: book.id),
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
                        onPressed: previousChapter == null
                            ? null
                            : () {
                                context.push(
                                  AppRoutes.readChapterRead,
                                  extra: ChapterReadRouteArgs(
                                    bookId: book.id,
                                    chapterNumber: previousChapter.number,
                                  ),
                                );
                              },
                        child: const Text('Previous'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: nextChapter == null
                            ? null
                            : () {
                                context.push(
                                  AppRoutes.readChapterRead,
                                  extra: ChapterReadRouteArgs(
                                    bookId: book.id,
                                    chapterNumber: nextChapter.number,
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
  }
}

class ReadReferenceSearchScreen extends StatefulWidget {
  const ReadReferenceSearchScreen({super.key});

  @override
  State<ReadReferenceSearchScreen> createState() =>
      _ReadReferenceSearchScreenState();
}

class _ReadReferenceSearchScreenState extends State<ReadReferenceSearchScreen> {
  static const MockReadRepository _repository = MockReadRepository();

  late final TextEditingController _controller;
  String _query = '';

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

  List<_ReferenceMatch> _buildMatches(String rawQuery) {
    final String query = rawQuery.trim().toLowerCase();
    if (query.isEmpty) return const <_ReferenceMatch>[];

    final List<ReadBook> books = _repository.getBooks();
    final RegExp digitExp = RegExp(r'(\d+)');
    final Match? digitMatch = digitExp.firstMatch(query);
    final int? requestedChapter = digitMatch != null
        ? int.tryParse(digitMatch.group(1)!)
        : null;

    final List<_ReferenceMatch> results = <_ReferenceMatch>[];
    final Set<String> seen = <String>{};

    bool matchesBook(ReadBook book) {
      final String name = book.name.toLowerCase();
      if (query.contains(name)) return true;

      final List<String> words = name.split(' ');
      for (final String word in words) {
        if (word.isNotEmpty && query.contains(word)) return true;
      }

      if (name.startsWith(query)) return true;
      return false;
    }

    for (final ReadBook book in books) {
      final bool bookMatched = matchesBook(book);
      final Iterable<ReadChapter> chapters = requestedChapter != null
          ? book.mockChapters.where(
              (chapter) => chapter.number == requestedChapter,
            )
          : book.mockChapters;

      for (final ReadChapter chapter in chapters) {
        final bool chapterMatchedByNumber =
            requestedChapter != null && chapter.number == requestedChapter;
        final bool chapterMatchedByText =
            chapter.title.toLowerCase().contains(query) ||
            chapter.introduction.toLowerCase().contains(query) ||
            chapter.focusLine.toLowerCase().contains(query) ||
            chapter.blocks.any(
              (block) =>
                  block.rangeLabel.toLowerCase().contains(query) ||
                  block.heading.toLowerCase().contains(query) ||
                  block.verses.any(
                    (verse) => verse.text.toLowerCase().contains(query),
                  ),
            );

        if (bookMatched || chapterMatchedByNumber || chapterMatchedByText) {
          final String key = '${book.id}-${chapter.number}';
          if (seen.contains(key)) continue;
          seen.add(key);

          results.add(
            _ReferenceMatch(
              book: book,
              chapter: chapter,
              subtitle: chapter.focusLine,
            ),
          );
        }
      }
    }

    return results;
  }

  void _applySuggestion(String value) {
    setState(() {
      _query = value;
      _controller.text = value;
      _controller.selection = TextSelection.fromPosition(
        TextPosition(offset: _controller.text.length),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<_ReferenceMatch> matches = _buildMatches(_query);

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
                  onChanged: (value) => setState(() => _query = value),
                  textInputAction: TextInputAction.search,
                  decoration: const InputDecoration(
                    hintText: 'Try: John 3, Psalm 23, Philippians 4',
                    prefixIcon: Icon(Icons.search_rounded),
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
          else if (matches.isEmpty)
            ReadInfoCard(
              title: 'No matching result',
              subtitle:
                  'Try another reference or choose one of the suggestions above.',
              icon: Icons.search_off_rounded,
              child: Text(
                'A short list of chapter suggestions is a good place to start if you are not sure where to go next.',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            )
          else
            ReadInfoCard(
              title: 'Search results',
              subtitle:
                  '${matches.length} matching chapter${matches.length == 1 ? '' : 's'}.',
              icon: Icons.menu_book_outlined,
              child: Column(
                children: matches
                    .map(
                      (_ReferenceMatch match) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _SearchResultTile(match: match),
                      ),
                    )
                    .toList(),
              ),
            ),
        ],
      ),
    );
  }
}

class ReadContinueReadingScreen extends StatelessWidget {
  const ReadContinueReadingScreen({super.key});

  static const MockReadRepository _repository = MockReadRepository();

  @override
  Widget build(BuildContext context) {
    final ReadBook continueBook = _repository.getContinueReadingBook();
    final ReadChapter continueChapter = _repository.getChapter(
      bookId: continueBook.id,
      chapterNumber: continueBook.continueChapterNumber,
    );

    final List<_ContinueItem> recentItems = <_ContinueItem>[
      _ContinueItem(
        book: continueBook,
        chapter: continueChapter,
        label: 'Most recent',
      ),
      _ContinueItem(
        book: _repository.getBookById('philippians'),
        chapter: _repository.getChapter(
          bookId: 'philippians',
          chapterNumber: 4,
        ),
        label: 'Prayer and peace',
      ),
      _ContinueItem(
        book: _repository.getBookById('psalms'),
        chapter: _repository.getChapter(bookId: 'psalms', chapterNumber: 23),
        label: 'Comfort reading',
      ),
      _ContinueItem(
        book: _repository.getBookById('john'),
        chapter: _repository.getChapter(bookId: 'john', chapterNumber: 1),
        label: 'Earlier reading',
      ),
    ];

    return TabScreenScaffold(
      title: 'Continue reading',
      subtitle: 'Read',
      showBackButton: true,
      body: ListView(
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
                const SizedBox(height: AppSpacing.md),
                Text(
                  '${continueBook.name} ${continueChapter.number}',
                  style: Theme.of(
                    context,
                  ).textTheme.headlineMedium?.copyWith(fontSize: 30),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  continueChapter.title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  continueChapter.focusLine,
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
                          bookId: continueBook.id,
                          chapterNumber: continueChapter.number,
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
              children: recentItems
                  .map(
                    (_ContinueItem item) => Padding(
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
                      extra: ReadBookRouteArgs(bookId: continueBook.id),
                    ),
                    child: Text('Open ${continueBook.name} details'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
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

class _ReferenceMatch {
  const _ReferenceMatch({
    required this.book,
    required this.chapter,
    required this.subtitle,
  });

  final ReadBook book;
  final ReadChapter chapter;
  final String subtitle;
}

class _SearchResultTile extends StatelessWidget {
  const _SearchResultTile({required this.match});

  final _ReferenceMatch match;

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
              bookId: match.book.id,
              chapterNumber: match.chapter.number,
            ),
          );
        },
        title: Text(
          '${match.book.name} ${match.chapter.number}',
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

class _ContinueItem {
  const _ContinueItem({
    required this.book,
    required this.chapter,
    required this.label,
  });

  final ReadBook book;
  final ReadChapter chapter;
  final String label;
}

class _ContinueReadingTile extends StatelessWidget {
  const _ContinueReadingTile({required this.item});

  final _ContinueItem item;

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
              bookId: item.book.id,
              chapterNumber: item.chapter.number,
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
          '${item.book.name} ${item.chapter.number}',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Text('${item.label} · ${item.chapter.title}'),
        ),
        trailing: const Icon(Icons.arrow_forward_rounded),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../app/theme/app_colors.dart';
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
      subtitle: 'Books, chapters, references, and resume flow',
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
            title: 'How the Read tab is shaped',
            subtitle:
                'Built for calm reading first, then later for real source integration and richer verse actions.',
            icon: Icons.menu_book_outlined,
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _ReadBullet(
                  text: 'Browse books in a calm, clean library-style flow.',
                ),
                _ReadBullet(
                  text: 'Open a book detail page before jumping into reading.',
                ),
                _ReadBullet(
                  text:
                      'Enter chapter reading with space for later verse interactions.',
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
                    Chip(label: const Text('Mock reading source')),
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
                'A simple book-level entry point before deeper reading features exist.',
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
            title: 'Mock chapters available in this build',
            subtitle:
                'These are the chapters currently mocked for UI-first reading.',
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
                  'Related routes',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: AppSpacing.lg),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () =>
                        context.push(AppRoutes.readReferenceSearch),
                    child: const Text('Open reference search'),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () =>
                        context.push(AppRoutes.readContinueReading),
                    child: const Text('Open continue reading route'),
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
                    const Chip(label: Text('KJV mock preview')),
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
            subtitle:
                'This keeps the reading calm and guided without becoming cluttered.',
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
            title: 'Next reading actions',
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
                  'Design note for later',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'This screen is intentionally structured so real verse actions, highlights, notes, bookmarks, reading progress, translation switching, and source-backed text can be added later without changing the route shell.',
                  style: Theme.of(context).textTheme.bodyMedium,
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

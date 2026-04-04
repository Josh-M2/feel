import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radii.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/app_screen_scaffold.dart';
import '../../data/mock/mock_saved_repository.dart';
import '../../domain/models/saved_item.dart';
import '../widgets/saved_bookmark_card.dart';
import '../widgets/saved_highlight_card.dart';
import '../widgets/saved_info_card.dart';
import '../widgets/saved_note_card.dart';

class SavedBookmarksScreen extends StatelessWidget {
  const SavedBookmarksScreen({super.key});

  static const MockSavedRepository _repository = MockSavedRepository();

  @override
  Widget build(BuildContext context) {
    final SavedLibrarySummary summary = _repository.getSummary();
    final List<SavedBookmark> bookmarks = _repository.getBookmarks();
    final List<SavedNote> pinnedNotes = _repository.getPinnedNotes();

    return TabScreenScaffold(
      title: 'Saved',
      subtitle: 'Bookmarks, notes, reflections, and history',
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
        children: <Widget>[
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Your saved library',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  'A calm place for verses worth returning to',
                  style: Theme.of(
                    context,
                  ).textTheme.headlineMedium?.copyWith(fontSize: 30),
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  'Saved is structured to remain useful in guest-first mode now, while staying ready for optional sync later.',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: AppSpacing.lg),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: <Widget>[
                    _SummaryPill(
                      label: 'Bookmarks',
                      value: '${summary.bookmarkCount}',
                    ),
                    _SummaryPill(
                      label: 'Highlights',
                      value: '${summary.highlightCount}',
                    ),
                    _SummaryPill(label: 'Notes', value: '${summary.noteCount}'),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          SavedInfoCard(
            title: 'Quick routes',
            subtitle:
                'Bookmarks acts as the entry view, while Highlights and Notes become focused library screens.',
            icon: Icons.auto_awesome_outlined,
            child: Column(
              children: <Widget>[
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () => context.push(AppRoutes.savedHighlights),
                    child: const Text('Open highlights'),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => context.push(AppRoutes.savedNotes),
                    child: const Text('Open notes'),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => context.push(AppRoutes.savedHistory),
                    child: const Text('Open history route'),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          if (pinnedNotes.isNotEmpty) ...<Widget>[
            SavedInfoCard(
              title: 'Pinned reflections',
              subtitle:
                  'A lightweight way to surface the notes most worth revisiting.',
              icon: Icons.push_pin_outlined,
              child: Column(
                children: pinnedNotes
                    .take(2)
                    .map(
                      (SavedNote note) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: SavedNoteCard(note: note),
                      ),
                    )
                    .toList(),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
          ],
          Text(
            'Recent bookmarks',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: AppSpacing.md),
          ...bookmarks.map(
            (SavedBookmark bookmark) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: SavedBookmarkCard(bookmark: bookmark),
            ),
          ),
        ],
      ),
    );
  }
}

class SavedHighlightsScreen extends StatelessWidget {
  const SavedHighlightsScreen({super.key});

  static const MockSavedRepository _repository = MockSavedRepository();

  @override
  Widget build(BuildContext context) {
    final List<SavedHighlight> highlights = _repository.getHighlights();

    return TabScreenScaffold(
      title: 'Highlights',
      subtitle: 'Saved',
      showBackButton: true,
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
        children: <Widget>[
          SavedInfoCard(
            title: 'Highlights library',
            subtitle:
                'This screen keeps highlighted phrases readable and reflection-aware instead of feeling like raw marked text.',
            icon: Icons.highlight_alt_rounded,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: const <Widget>[
                    Chip(label: Text('Warm amber')),
                    Chip(label: Text('Soft olive')),
                    Chip(label: Text('Dusty rose')),
                    Chip(label: Text('Most recent')),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  'In a later phase, these can become real filters without changing the layout structure.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          ...highlights.map(
            (SavedHighlight highlight) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: SavedHighlightCard(highlight: highlight),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Related route',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: AppSpacing.lg),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => context.push(AppRoutes.savedNotes),
                    child: const Text('Open notes'),
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

class SavedNotesScreen extends StatelessWidget {
  const SavedNotesScreen({super.key});

  static const MockSavedRepository _repository = MockSavedRepository();

  @override
  Widget build(BuildContext context) {
    final List<SavedNote> notes = _repository.getNotes();
    final List<SavedNote> pinnedNotes = _repository.getPinnedNotes();
    final List<SavedNote> regularNotes = notes
        .where((SavedNote note) => !note.isPinned)
        .toList();

    return TabScreenScaffold(
      title: 'Notes',
      subtitle: 'Saved',
      showBackButton: true,
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
        children: <Widget>[
          SavedInfoCard(
            title: 'Private verse reflections',
            subtitle:
                'Notes stay connected to scripture and remain readable even before sync, folders, or richer journaling features exist.',
            icon: Icons.edit_note_rounded,
            child: Text(
              'This screen is shaped to support timestamped, editable reflections later while already feeling calm and personal now.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          if (pinnedNotes.isNotEmpty) ...<Widget>[
            const SizedBox(height: AppSpacing.lg),
            Text('Pinned', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: AppSpacing.md),
            ...pinnedNotes.map(
              (SavedNote note) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: SavedNoteCard(note: note),
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.lg),
          Text('All notes', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: AppSpacing.md),
          ...regularNotes.map(
            (SavedNote note) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: SavedNoteCard(note: note),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Related route',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: AppSpacing.lg),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => context.push(AppRoutes.savedHighlights),
                    child: const Text('Open highlights'),
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

class SavedHistoryScreen extends StatelessWidget {
  const SavedHistoryScreen({super.key});

  static const MockSavedRepository _repository = MockSavedRepository();

  @override
  Widget build(BuildContext context) {
    final List<SavedHistoryEntry> history = _repository.getHistory();
    final int todayCount = history.where((SavedHistoryEntry entry) {
      return entry.occurredAtLabel.toLowerCase().contains('today');
    }).length;
    final int reflectionCount = history.where((SavedHistoryEntry entry) {
      return entry.kind == SavedHistoryKind.wroteNote;
    }).length;
    final int readingCount = history.where((SavedHistoryEntry entry) {
      return entry.kind == SavedHistoryKind.readChapter ||
          entry.kind == SavedHistoryKind.viewedVerse ||
          entry.kind == SavedHistoryKind.openedPlanDay;
    }).length;

    return TabScreenScaffold(
      title: 'History',
      subtitle: 'Saved',
      showBackButton: true,
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
        children: <Widget>[
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Recent activity history',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  'A gentle memory of where you have been in the app',
                  style: Theme.of(
                    context,
                  ).textTheme.headlineMedium?.copyWith(fontSize: 30),
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  'History should help the user return to meaningful reading moments without making the app feel noisy or over-tracked.',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: AppSpacing.lg),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: <Widget>[
                    _SummaryPill(label: 'Entries', value: '${history.length}'),
                    _SummaryPill(label: 'Today', value: '$todayCount'),
                    _SummaryPill(label: 'Reading', value: '$readingCount'),
                    _SummaryPill(
                      label: 'Reflections',
                      value: '$reflectionCount',
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          SavedInfoCard(
            title: 'Why history matters in V1',
            subtitle:
                'This keeps history useful even before real persistence and sync are added.',
            icon: Icons.history_rounded,
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _HistoryBullet(
                  text:
                      'It helps the user return to verses, reading sessions, and plan days worth revisiting.',
                ),
                _HistoryBullet(
                  text:
                      'It can later become a smarter resume layer without changing the screen structure.',
                ),
                _HistoryBullet(
                  text:
                      'The tone stays reflective instead of making activity feel overly quantified.',
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text('Recent entries', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: AppSpacing.md),
          ...history.map(
            (SavedHistoryEntry entry) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _SavedHistoryCard(entry: entry),
            ),
          ),
        ],
      ),
    );
  }
}

class _SavedHistoryCard extends StatelessWidget {
  const _SavedHistoryCard({required this.entry});

  final SavedHistoryEntry entry;

  IconData get _icon {
    switch (entry.kind) {
      case SavedHistoryKind.viewedVerse:
        return Icons.wb_sunny_outlined;
      case SavedHistoryKind.readChapter:
        return Icons.menu_book_outlined;
      case SavedHistoryKind.openedPlanDay:
        return Icons.event_note_outlined;
      case SavedHistoryKind.savedVerse:
        return Icons.bookmark_outline_rounded;
      case SavedHistoryKind.wroteNote:
        return Icons.edit_note_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          DecoratedBox(
            decoration: BoxDecoration(
              color: AppColors.surfaceMuted,
              borderRadius: BorderRadius.circular(AppRadii.lg),
            ),
            child: SizedBox(
              width: 44,
              height: 44,
              child: Icon(_icon, color: AppColors.primary),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: <Widget>[
                    _MiniBadge(label: entry.sourceLabel),
                    _MiniBadge(label: entry.occurredAtLabel),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  entry.title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  entry.reference,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  entry.detail,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryPill extends StatelessWidget {
  const _SummaryPill({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surfaceMuted,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              value,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppColors.textPrimary),
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniBadge extends StatelessWidget {
  const _MiniBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surfaceSoft,
        borderRadius: BorderRadius.circular(AppRadii.pill),
        border: Border.all(color: AppColors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _HistoryBullet extends StatelessWidget {
  const _HistoryBullet({required this.text});

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

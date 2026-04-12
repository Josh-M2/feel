import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radii.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/app_screen_scaffold.dart';
import '../../data/local/local_first_saved_library_repository.dart';
import '../../domain/models/saved_item.dart';
import '../../domain/repositories/saved_library_repository.dart';
import '../widgets/saved_bookmark_card.dart';
import '../widgets/saved_highlight_card.dart';
import '../widgets/saved_info_card.dart';
import '../widgets/saved_note_card.dart';

final SavedLibraryRepository _savedRepository =
    LocalFirstSavedLibraryRepository();

class SavedBookmarksScreen extends StatelessWidget {
  const SavedBookmarksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: LocalFirstSavedLibraryRepository.libraryRevisionListenable,
      builder: (BuildContext context, int _, Widget? child) {
        return FutureBuilder<_SavedBookmarksScreenData>(
          future: _loadSavedBookmarksScreenData(),
          builder: (context, snapshot) {
            return _buildSavedScaffold(
              context: context,
              title: 'Saved',
              subtitle: 'Bookmarks, highlights, notes, and history',
              snapshot: snapshot,
              dataBuilder: (context, data) => ListView(
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
                      'A calm place to return to verses that stayed with you',
                      style: Theme.of(
                        context,
                      ).textTheme.headlineMedium?.copyWith(fontSize: 30),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      'Keep important verses, highlights, and reflections together in one simple space.',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: <Widget>[
                        _SummaryPill(
                          label: 'Bookmarks',
                          value: '${data.summary.bookmarkCount}',
                        ),
                        _SummaryPill(
                          label: 'Highlights',
                          value: '${data.summary.highlightCount}',
                        ),
                        _SummaryPill(
                          label: 'Notes',
                          value: '${data.summary.noteCount}',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              SavedInfoCard(
                title: 'Quick routes',
                subtitle:
                    'Move easily between bookmarks, highlights, notes, and recent activity.',
                icon: Icons.auto_awesome_outlined,
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: () =>
                            context.push(AppRoutes.savedHighlights),
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
                        child: const Text('Open history'),
                      ),
                    ),
                  ],
                ),
              ),
              if (data.pinnedNotes.isNotEmpty) ...<Widget>[
                const SizedBox(height: AppSpacing.lg),
                SavedInfoCard(
                  title: 'Pinned reflections',
                  subtitle:
                      'A few thoughts worth returning to again and again.',
                  icon: Icons.push_pin_outlined,
                  child: Column(
                    children: data.pinnedNotes
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
              ],
              const SizedBox(height: AppSpacing.lg),
              Text(
                'Recent bookmarks',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: AppSpacing.md),
              ...data.bookmarks.map(
                (SavedBookmark bookmark) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: SavedBookmarkCard(bookmark: bookmark),
                ),
              ),
            ],
              ),
            );
          },
        );
      },
    );
  }

  Future<_SavedBookmarksScreenData> _loadSavedBookmarksScreenData() async {
    final SavedLibrarySummary summary = await _savedRepository.getSummary();
    final List<SavedBookmark> bookmarks = await _savedRepository.getBookmarks();
    final List<SavedNote> pinnedNotes = await _savedRepository.getPinnedNotes();

    return _SavedBookmarksScreenData(
      summary: summary,
      bookmarks: bookmarks,
      pinnedNotes: pinnedNotes,
    );
  }
}

class SavedHighlightsScreen extends StatelessWidget {
  const SavedHighlightsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: LocalFirstSavedLibraryRepository.libraryRevisionListenable,
      builder: (BuildContext context, int _, Widget? child) {
        return FutureBuilder<List<SavedHighlight>>(
          future: _savedRepository.getHighlights(),
          builder: (context, snapshot) {
            return _buildSavedScaffold(
              context: context,
              title: 'Highlights',
              subtitle: 'Saved',
              showBackButton: true,
              snapshot: snapshot,
              dataBuilder: (context, highlights) => ListView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
            children: <Widget>[
              SavedInfoCard(
                title: 'Highlighted verses',
                subtitle:
                    'Use highlights to return to the lines that stayed with you most.',
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
                      'Highlights can help you revisit a passage quickly and remember what first drew your attention.',
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
                      'Keep going',
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
          },
        );
      },
    );
  }
}

class SavedNotesScreen extends StatelessWidget {
  const SavedNotesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: LocalFirstSavedLibraryRepository.libraryRevisionListenable,
      builder: (BuildContext context, int _, Widget? child) {
        return FutureBuilder<_SavedNotesScreenData>(
          future: _loadSavedNotesScreenData(),
          builder: (context, snapshot) {
            return _buildSavedScaffold(
              context: context,
              title: 'Notes',
              subtitle: 'Saved',
              showBackButton: true,
              snapshot: snapshot,
              dataBuilder: (context, data) => ListView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
            children: <Widget>[
              SavedInfoCard(
                title: 'Private reflections',
                subtitle:
                    'A quiet place to keep personal thoughts connected to scripture.',
                icon: Icons.edit_note_rounded,
                child: Text(
                  'Notes can help turn reading into something more personal, memorable, and prayerful.',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              if (data.pinnedNotes.isNotEmpty) ...<Widget>[
                const SizedBox(height: AppSpacing.lg),
                Text('Pinned', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: AppSpacing.md),
                ...data.pinnedNotes.map(
                  (SavedNote note) => Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: SavedNoteCard(note: note),
                  ),
                ),
              ],
              const SizedBox(height: AppSpacing.lg),
              Text('All notes', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: AppSpacing.md),
              ...data.regularNotes.map(
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
                      'Keep going',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () =>
                            context.push(AppRoutes.savedHighlights),
                        child: const Text('Open highlights'),
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
      },
    );
  }

  Future<_SavedNotesScreenData> _loadSavedNotesScreenData() async {
    final List<SavedNote> notes = await _savedRepository.getNotes();
    final List<SavedNote> pinnedNotes = notes
        .where((SavedNote note) => note.isPinned)
        .toList(growable: false);
    final List<SavedNote> regularNotes = notes
        .where((SavedNote note) => !note.isPinned)
        .toList(growable: false);

    return _SavedNotesScreenData(
      pinnedNotes: pinnedNotes,
      regularNotes: regularNotes,
    );
  }
}

class SavedHistoryScreen extends StatelessWidget {
  const SavedHistoryScreen({super.key});

  IconData _iconForKind(SavedHistoryKind kind) {
    switch (kind) {
      case SavedHistoryKind.verseViewed:
        return Icons.visibility_outlined;
      case SavedHistoryKind.chapterRead:
        return Icons.menu_book_outlined;
      case SavedHistoryKind.planOpened:
        return Icons.event_note_outlined;
      case SavedHistoryKind.bookmarkSaved:
        return Icons.bookmark_border_rounded;
      case SavedHistoryKind.highlightSaved:
        return Icons.highlight_alt_rounded;
      case SavedHistoryKind.noteWritten:
        return Icons.edit_note_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: LocalFirstSavedLibraryRepository.libraryRevisionListenable,
      builder: (BuildContext context, int _, Widget? child) {
        return FutureBuilder<List<SavedHistoryEntry>>(
          future: _savedRepository.getHistory(),
          builder: (context, snapshot) {
            return _buildSavedScaffold(
              context: context,
              title: 'History',
              subtitle: 'Saved',
              showBackButton: true,
              snapshot: snapshot,
              dataBuilder: (context, entries) => ListView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
            children: <Widget>[
              SavedInfoCard(
                title: 'Recent activity',
                subtitle:
                    'A simple timeline of where you have been reading, saving, and reflecting.',
                icon: Icons.history_rounded,
                child: Text(
                  'Use this to quickly remember the verses, notes, and reading moments you have revisited recently.',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              ...entries.map(
                (SavedHistoryEntry entry) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: AppColors.surfaceSoft,
                      borderRadius: BorderRadius.circular(AppRadii.xl),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      leading: DecoratedBox(
                        decoration: BoxDecoration(
                          color: AppColors.surfaceMuted,
                          borderRadius: BorderRadius.circular(AppRadii.lg),
                        ),
                        child: SizedBox(
                          width: 42,
                          height: 42,
                          child: Icon(
                            _iconForKind(entry.kind),
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      title: Text(
                        entry.title,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Text('${entry.subtitle} · ${entry.timeLabel}'),
                      ),
                    ),
                  ),
                ),
              ),
            ],
              ),
            );
          },
        );
      },
    );
  }
}

Widget _buildSavedScaffold<T>({
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
          return const _SavedLoadingBody();
        }

        if (snapshot.hasError) {
          return _SavedFailureBody(error: snapshot.error);
        }

        final T? data = snapshot.data;
        if (data == null) {
          return const _SavedFailureBody();
        }

        if (data is List && data.isEmpty) {
          return const _SavedEmptyBody();
        }

        return dataBuilder(context, data);
      },
    ),
  );
}

class _SavedLoadingBody extends StatelessWidget {
  const _SavedLoadingBody();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
      children: const <Widget>[
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              CircularProgressIndicator(),
              SizedBox(height: AppSpacing.lg),
              Text('Loading saved library...'),
            ],
          ),
        ),
      ],
    );
  }
}

class _SavedFailureBody extends StatelessWidget {
  const _SavedFailureBody({this.error});

  final Object? error;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
      children: <Widget>[
        SavedInfoCard(
          title: 'Saved library unavailable',
          subtitle:
              'The local saved library could not be loaded for this screen.',
          icon: Icons.error_outline_rounded,
          child: Text(
            error?.toString() ??
                'Try again after checking your local store and package setup.',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
      ],
    );
  }
}

class _SavedEmptyBody extends StatelessWidget {
  const _SavedEmptyBody();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
      children: <Widget>[
        SavedInfoCard(
          title: 'Nothing saved yet',
          subtitle:
              'Bookmarks, highlights, notes, and history will appear here.',
          icon: Icons.bookmark_border_rounded,
          child: Text(
            'This screen is now wired to the local saved store, so once records are added they will appear here instead of staying mock-only.',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
      ],
    );
  }
}

class _SavedBookmarksScreenData {
  const _SavedBookmarksScreenData({
    required this.summary,
    required this.bookmarks,
    required this.pinnedNotes,
  });

  final SavedLibrarySummary summary;
  final List<SavedBookmark> bookmarks;
  final List<SavedNote> pinnedNotes;
}

class _SavedNotesScreenData {
  const _SavedNotesScreenData({
    required this.pinnedNotes,
    required this.regularNotes,
  });

  final List<SavedNote> pinnedNotes;
  final List<SavedNote> regularNotes;
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

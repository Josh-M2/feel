import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/bootstrap/app_bootstrap_controller.dart';
import '../../../../app/router/app_routes.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radii.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/app_page_loader.dart';
import '../../../../shared/widgets/app_reveal.dart';
import '../../../../shared/widgets/app_screen_scaffold.dart';
import '../../../saved/data/local/local_first_saved_library_repository.dart';
import '../../../saved/domain/models/saved_library_local_snapshot.dart';
import '../../../saved/domain/repositories/saved_library_repository.dart';
import '../../data/public/supabase_today_repository.dart';
import '../../domain/models/today_verse.dart';
import '../../domain/repositories/today_repository.dart';
import '../widgets/today_badge.dart';
import '../widgets/today_info_card.dart';
import '../widgets/today_verse_hero_card.dart';

final TodayRepository _todayRepository = SupabaseTodayRepository();
final SavedLibraryRepository _savedRepository =
    LocalFirstSavedLibraryRepository();

class TodayHomeScreen extends StatelessWidget {
  const TodayHomeScreen({super.key, required this.bootstrap});

  final AppBootstrapController bootstrap;

  @override
  Widget build(BuildContext context) {
    return TabScreenScaffold(
      title: 'Today',
      subtitle: 'Daily verse, reflection, and encouragement',
      body: _TodayVerseLoader(
        bootstrap: bootstrap,
        markAsOpened: true,
        builder: (BuildContext context, TodayVerse verse) {
          return AppReveal(
            duration: const Duration(milliseconds: 320),
            offsetY: 0.02,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
              children: <Widget>[
              AppReveal(
                duration: const Duration(milliseconds: 360),
                offsetY: 0.03,
                child: TodayVerseHeroCard(
                  verse: verse,
                  compact: true,
                  onTap: () => context.push(AppRoutes.todayVerseDetail),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              AppReveal(
                delay: const Duration(milliseconds: 70),
                child: TodayInfoCard(
                  title: 'A gentle focus for today',
                  subtitle:
                      'Your verse is assigned from your selected categories and stays aligned with the same daily refresh time used by the widget.',
                  icon: Icons.light_mode_outlined,
                  child: Text(
                    verse.encouragementLine,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              TodayInfoCard(
                title: 'Open today’s verse',
                icon: Icons.auto_awesome_outlined,
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: () => context.push(AppRoutes.todayVerseDetail),
                        child: const Text('Open verse detail'),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () => context.push(AppRoutes.todayVerseContext),
                        child: const Text('Read verse context'),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => context.push(AppRoutes.todayVerseAiExplain),
                            child: const Text('AI explain'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => context.push(AppRoutes.todaySharePreview),
                            child: const Text('Share preview'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              TodayInfoCard(
                title: 'Reflection prompt',
                subtitle: 'A calm question to carry into prayer or journaling.',
                icon: Icons.edit_note_rounded,
                child: Text(
                  verse.reflectionPrompt,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              TodayInfoCard(
                title: 'Context preview',
                subtitle:
                    'Your daily assignment keeps the verse anchored in its wider message instead of treating it like an isolated quote.',
                icon: Icons.menu_book_outlined,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      verse.contextSummary,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () => context.push(AppRoutes.todayVerseContext),
                        icon: const Icon(Icons.arrow_forward_rounded),
                        label: const Text('Read context'),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              TodayInfoCard(
                title: 'A simple rhythm for today',
                icon: Icons.self_improvement_outlined,
                child: const Column(
                  children: <Widget>[
                    _TodayStepRow(
                      index: '1',
                      title: 'Read slowly',
                      description:
                          'Sit with the verse before rushing into explanation.',
                    ),
                    SizedBox(height: 12),
                    _TodayStepRow(
                      index: '2',
                      title: 'Pray honestly',
                      description:
                          'Bring the real burden of the day to God in plain words.',
                    ),
                    SizedBox(height: 12),
                    _TodayStepRow(
                      index: '3',
                      title: 'Carry one thought',
                      description:
                          'Take one line from the verse into the rest of the day.',
                    ),
                  ],
                ),
              ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class TodayVerseDetailScreen extends StatelessWidget {
  const TodayVerseDetailScreen({super.key, required this.bootstrap});

  final AppBootstrapController bootstrap;

  @override
  Widget build(BuildContext context) {
    return TabScreenScaffold(
      title: 'Verse detail',
      subtitle: 'Today',
      showBackButton: true,
      body: _TodayVerseLoader(
        bootstrap: bootstrap,
        markAsOpened: true,
        builder: (BuildContext context, TodayVerse verse) {
          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
            children: <Widget>[
              TodayVerseHeroCard(verse: verse),
              const SizedBox(height: AppSpacing.lg),
              TodayInfoCard(
                title: 'What this verse invites today',
                subtitle:
                    'A short reading companion to help the verse land gently.',
                icon: Icons.favorite_border_rounded,
                child: Text(
                  verse.encouragementLine,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              TodayInfoCard(
                title: 'Key insights',
                icon: Icons.check_circle_outline_rounded,
                child: Column(
                  children: verse.keyInsights
                      .map(
                        (String item) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _InsightRow(text: item),
                        ),
                      )
                      .toList(),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              TodayInfoCard(
                title: 'Reflection prompt',
                subtitle: 'A quiet question to stay with through the day.',
                icon: Icons.rate_review_outlined,
                child: Text(
                  verse.reflectionPrompt,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              TodayInfoCard(
                title: 'Prayer',
                icon: Icons.volunteer_activism_outlined,
                child: Text(
                  verse.prayer,
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(fontStyle: FontStyle.italic),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              TodayInfoCard(
                title: 'Save from today',
                subtitle:
                    'Save the verse now or add a private reflection that shows up in Saved.',
                icon: Icons.bookmark_add_outlined,
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: () => _saveTodayBookmark(context, verse),
                        icon: const Icon(Icons.bookmark_add_outlined),
                        label: const Text('Save verse'),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () => _showTodayReflectionComposer(context, verse),
                        icon: const Icon(Icons.edit_note_outlined),
                        label: const Text('Add reflection'),
                      ),
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
                      'Keep reading',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: () => context.push(AppRoutes.todayVerseContext),
                        child: const Text('Read verse context'),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => context.push(AppRoutes.todaySharePreview),
                            child: const Text('Share preview'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => context.push(AppRoutes.todayVerseAiExplain),
                            child: const Text('AI explain'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: <Widget>[
                        TodayBadge(
                          label: verse.category,
                          icon: Icons.local_offer_outlined,
                        ),
                        TodayBadge(
                          label: verse.translationLabel,
                          icon: Icons.translate_rounded,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class TodayVerseContextScreen extends StatelessWidget {
  const TodayVerseContextScreen({super.key, required this.bootstrap});

  final AppBootstrapController bootstrap;

  @override
  Widget build(BuildContext context) {
    return TabScreenScaffold(
      title: 'Verse context',
      subtitle: 'Today',
      showBackButton: true,
      body: _TodayVerseLoader(
        bootstrap: bootstrap,
        markAsOpened: true,
        builder: (BuildContext context, TodayVerse verse) {
          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
            children: <Widget>[
              TodayInfoCard(
                title: verse.reference,
                subtitle: verse.category,
                icon: Icons.menu_book_outlined,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      verse.contextSummary,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: <Widget>[
                        TodayBadge(
                          label: verse.translationLabel,
                          icon: Icons.translate_rounded,
                        ),
                        const TodayBadge(
                          label: 'Read in context',
                          icon: Icons.search_rounded,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              TodayInfoCard(
                title: 'Context sections',
                subtitle:
                    'These notes help the verse stay connected to the larger passage.',
                icon: Icons.view_agenda_outlined,
                child: Column(
                  children: verse.contextSections
                      .map(
                        (VerseContextSection section) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _ContextSectionTile(section: section),
                        ),
                      )
                      .toList(),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              TodayInfoCard(
                title: 'Related passages',
                subtitle: 'Companion passages that can deepen the same theme.',
                icon: Icons.link_rounded,
                child: Column(
                  children: verse.relatedPassages
                      .map(
                        (RelatedPassagePreview passage) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _RelatedPassageTile(passage: passage),
                        ),
                      )
                      .toList(),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              TodayInfoCard(
                title: 'Reading posture',
                icon: Icons.spa_outlined,
                child: Text(
                  'Reading in context can slow the heart down and help the verse stay rooted in its fuller message.',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => context.push(AppRoutes.todayVerseDetail),
                  icon: const Icon(Icons.arrow_back_rounded),
                  label: const Text('Back to verse detail'),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class TodayVerseAiExplainScreen extends StatelessWidget {
  const TodayVerseAiExplainScreen({super.key, required this.bootstrap});

  final AppBootstrapController bootstrap;

  @override
  Widget build(BuildContext context) {
    return TabScreenScaffold(
      title: 'AI explain',
      subtitle: 'Today',
      showBackButton: true,
      body: _TodayVerseLoader(
        bootstrap: bootstrap,
        markAsOpened: true,
        builder: (BuildContext context, TodayVerse verse) {
          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
            children: <Widget>[
              TodayInfoCard(
                title: 'A gentle explanation',
                subtitle:
                    'LLM stays in a support role here. It helps explain the assigned verse, but it does not choose scripture for you.',
                icon: Icons.auto_awesome_outlined,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: <Widget>[
                        TodayBadge(
                          label: verse.reference,
                          icon: Icons.menu_book_outlined,
                        ),
                        TodayBadge(
                          label: verse.category,
                          icon: Icons.local_offer_outlined,
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Text(
                      verse.encouragementLine,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              TodayInfoCard(
                title: 'What the verse is saying',
                subtitle:
                    'A simple breakdown to make the message easier to hold onto.',
                icon: Icons.lightbulb_outline_rounded,
                child: Column(
                  children: verse.keyInsights.isEmpty
                      ? const <Widget>[
                          _ExplainPointTile(
                            title: 'Read the central movement',
                            body:
                                'Look for what the verse reveals about God, the heart, and the faithful response it invites.',
                          ),
                        ]
                      : verse.keyInsights
                          .asMap()
                          .entries
                          .map(
                            (MapEntry<int, String> entry) => Padding(
                              padding: EdgeInsets.only(
                                bottom: entry.key == verse.keyInsights.length - 1
                                    ? 0
                                    : 12,
                              ),
                              child: _ExplainPointTile(
                                title: 'Key insight ${entry.key + 1}',
                                body: entry.value,
                              ),
                            ),
                          )
                          .toList(growable: false),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              TodayInfoCard(
                title: 'Keep scripture central',
                subtitle:
                    'Explanation is most helpful when it leads the reader back to the verse itself.',
                icon: Icons.menu_book_rounded,
                child: Column(
                  children: const <Widget>[
                    _ExplainPointTile(
                      title: 'Read the verse again slowly',
                      body:
                          'Let explanation support your reading rather than replace it.',
                    ),
                    SizedBox(height: 12),
                    _ExplainPointTile(
                      title: 'Notice what stands out',
                      body:
                          'Pay attention to a word or phrase that feels especially alive today.',
                    ),
                    SizedBox(height: 12),
                    _ExplainPointTile(
                      title: 'Carry one thought forward',
                      body:
                          'Take one simple truth from the verse into prayer, work, and the rest of the day.',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              TodayInfoCard(
                title: 'Reflection prompts',
                subtitle:
                    'Questions to help the explanation turn into prayerful reflection.',
                icon: Icons.rate_review_outlined,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _ReflectionPromptCard(prompt: verse.reflectionPrompt),
                    const SizedBox(height: 12),
                    _ReflectionPromptCard(
                      prompt:
                          'What does this verse show you about God’s character or care today?',
                    ),
                    const SizedBox(height: 12),
                    _ReflectionPromptCard(
                      prompt:
                          'What faithful response does this verse seem to invite from you today?',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              TodayInfoCard(
                title: 'Keep reading',
                subtitle: 'Move easily between explanation, scripture, and context.',
                icon: Icons.swap_horiz_rounded,
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () => context.push(AppRoutes.todayVerseDetail),
                        child: const Text('Back to verse detail'),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () => context.push(AppRoutes.todayVerseContext),
                        child: const Text('Read verse context'),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () => context.push(AppRoutes.todaySharePreview),
                        child: const Text('Open share preview'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class TodaySharePreviewScreen extends StatelessWidget {
  const TodaySharePreviewScreen({super.key, required this.bootstrap});

  final AppBootstrapController bootstrap;

  @override
  Widget build(BuildContext context) {
    return TabScreenScaffold(
      title: 'Share preview',
      subtitle: 'Today',
      showBackButton: true,
      body: _TodayVerseLoader(
        bootstrap: bootstrap,
        markAsOpened: true,
        builder: (BuildContext context, TodayVerse verse) {
          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
            children: <Widget>[
              TodayInfoCard(
                title: 'See how today’s verse can look when shared',
                subtitle:
                    'A calm layout that keeps scripture central and easy to read.',
                icon: Icons.ios_share_rounded,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: <Widget>[
                        TodayBadge(
                          label: verse.reference,
                          icon: Icons.menu_book_outlined,
                        ),
                        TodayBadge(
                          label: verse.category,
                          icon: Icons.local_offer_outlined,
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Text(
                      'The preview reflects the same assigned verse your app and future widget use for this day window.',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              TodayInfoCard(
                title: 'Square layout',
                subtitle: 'A balanced card shape for a feed-style post.',
                icon: Icons.crop_square_rounded,
                child: _SharePreviewSurface(
                  verse: verse,
                  variant: _ShareVariant.square,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              TodayInfoCard(
                title: 'Story layout',
                subtitle: 'A taller layout for a story-style share.',
                icon: Icons.stay_current_portrait_rounded,
                child: _SharePreviewSurface(
                  verse: verse,
                  variant: _ShareVariant.story,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              TodayInfoCard(
                title: 'Keep reading',
                subtitle:
                    'Sharing works best when it grows out of reading, reflection, and prayer.',
                icon: Icons.favorite_border_rounded,
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () => context.push(AppRoutes.todayVerseDetail),
                        child: const Text('Back to verse detail'),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () => context.push(AppRoutes.todayVerseAiExplain),
                        child: const Text('Open AI explain'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}


Future<void> _saveTodayBookmark(BuildContext context, TodayVerse verse) async {
  await _savedRepository.saveBookmark(
    anchor: _buildTodayAnchor(verse),
    categoryLabel: verse.category,
  );
  if (context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Verse saved to Saved.')),
    );
  }
}

Future<void> _showTodayReflectionComposer(
  BuildContext context,
  TodayVerse verse,
) async {
  final _TodayReflectionDraft? draft = await showDialog<_TodayReflectionDraft>(
    context: context,
    builder: (BuildContext dialogContext) {
      return _TodayReflectionDialog(
        initialTitle: '${verse.reference} reflection',
      );
    },
  );

  if (draft == null) {
    return;
  }

  final String title = draft.title.trim();
  final String body = draft.body.trim();

  if (body.isEmpty) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Write a reflection before saving.')),
      );
    }
    return;
  }

  final SavedReferenceAnchor anchor = _buildTodayAnchor(verse);
  await _savedRepository.saveBookmark(
    anchor: anchor,
    categoryLabel: verse.category,
    reflection: body,
  );
  await _savedRepository.saveNote(
    anchor: anchor,
    title: title.isEmpty ? '${verse.reference} reflection' : title,
    body: body,
  );

  if (context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Reflection saved to Saved.')),
    );
  }
}

SavedReferenceAnchor _buildTodayAnchor(TodayVerse verse) {
  final String normalizedReference = _normalizeSavedReferenceDelimiters(
    verse.reference,
  );
  final _ParsedReference parsed = _parseTodayReference(normalizedReference);
  return SavedReferenceAnchor(
    versionCode: _todayVersionCodeFor(verse.translationLabel),
    bookId: parsed.bookId,
    bookName: parsed.bookName,
    chapterStart: parsed.chapterStart,
    verseStart: parsed.verseStart,
    chapterEnd: parsed.chapterEnd,
    verseEnd: parsed.verseEnd,
    referenceLabel: normalizedReference,
    verseTextSnapshot: verse.verseText,
  );
}

_ParsedReference _parseTodayReference(String reference) {
  final String normalizedReference = _normalizeSavedReferenceDelimiters(
    reference,
  );
  final Match? sameChapterMatch = RegExp(
    r'^(.+?)\s+(\d+):(\d+)(?:-(\d+))?$',
  ).firstMatch(normalizedReference);
  if (sameChapterMatch != null) {
    final String bookName = sameChapterMatch.group(1)!.trim();
    final int chapter = int.tryParse(sameChapterMatch.group(2)!) ?? 1;
    final int verseStart =
        int.tryParse(sameChapterMatch.group(3)!) ?? 1;
    final int verseEnd =
        int.tryParse(sameChapterMatch.group(4) ?? '') ?? verseStart;
    return _ParsedReference(
      bookName: bookName,
      bookId: _bookIdFromName(bookName),
      chapterStart: chapter,
      verseStart: verseStart,
      chapterEnd: chapter,
      verseEnd: verseEnd,
    );
  }

  final RegExp chapterOnlyExp = RegExp(r'^(.+?)\s+(\d+)$');
  final Match? chapterOnlyMatch = chapterOnlyExp.firstMatch(
    normalizedReference,
  );
  if (chapterOnlyMatch != null) {
    final String bookName = chapterOnlyMatch.group(1)!.trim();
    final int chapter = int.tryParse(chapterOnlyMatch.group(2)!) ?? 1;
    return _ParsedReference(
      bookName: bookName,
      bookId: _bookIdFromName(bookName),
      chapterStart: chapter,
      verseStart: 1,
      chapterEnd: chapter,
      verseEnd: 1,
    );
  }

  return _ParsedReference(
    bookName: normalizedReference,
    bookId: _bookIdFromName(normalizedReference),
    chapterStart: 1,
    verseStart: 1,
    chapterEnd: 1,
    verseEnd: 1,
  );
}

String _todayVersionCodeFor(String translationLabel) {
  return translationLabel.toLowerCase().contains('web') ? 'web' : 'kjv';
}

String _normalizeSavedReferenceDelimiters(String value) {
  return value
      .trim()
      .replaceAll('\u2013', '-')
      .replaceAll('\u2014', '-')
      .replaceAll('\u00e2\u20ac\u201c', '-')
      .replaceAll('\u00e2\u20ac\u201d', '-');
}

String _bookIdFromName(String bookName) {
  return bookName
      .trim()
      .toLowerCase()
      .replaceAll(RegExp(r'[^a-z0-9]+'), '_')
      .replaceAll(RegExp(r'^_+|_+$'), '');
}

class _ParsedReference {
  const _ParsedReference({
    required this.bookName,
    required this.bookId,
    required this.chapterStart,
    required this.verseStart,
    required this.chapterEnd,
    required this.verseEnd,
  });

  final String bookName;
  final String bookId;
  final int chapterStart;
  final int verseStart;
  final int chapterEnd;
  final int verseEnd;
}

class _TodayReflectionDraft {
  const _TodayReflectionDraft({
    required this.title,
    required this.body,
  });

  final String title;
  final String body;
}

class _TodayReflectionDialog extends StatefulWidget {
  const _TodayReflectionDialog({required this.initialTitle});

  final String initialTitle;

  @override
  State<_TodayReflectionDialog> createState() => _TodayReflectionDialogState();
}

class _TodayReflectionDialogState extends State<_TodayReflectionDialog> {
  late final TextEditingController _titleController;
  late final TextEditingController _bodyController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialTitle);
    _bodyController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add reflection'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                hintText: 'Today reflection',
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            TextField(
              controller: _bodyController,
              minLines: 4,
              maxLines: 6,
              decoration: const InputDecoration(
                labelText: 'Reflection',
                hintText: 'Write a private reflection connected to today\'s verse.',
              ),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(
            _TodayReflectionDraft(
              title: _titleController.text,
              body: _bodyController.text,
            ),
          ),
          child: const Text('Save reflection'),
        ),
      ],
    );
  }
}

class _TodayVerseLoader extends StatelessWidget {
  const _TodayVerseLoader({
    required this.bootstrap,
    required this.builder,
    this.markAsOpened = false,
  });

  final AppBootstrapController bootstrap;
  final Widget Function(BuildContext context, TodayVerse verse) builder;
  final bool markAsOpened;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<TodayVerse>(
      future: () async {
        if (markAsOpened) {
          await _todayRepository.markTodayOpened(
            selectedCategories: bootstrap.selectedCategories,
            dailyRefreshTime: bootstrap.dailyNotificationTime,
            preferredTranslationCode: bootstrap.preferredTranslationCode,
          );
        }
        return _todayRepository.getTodayVerse(
          selectedCategories: bootstrap.selectedCategories,
          dailyRefreshTime: bootstrap.dailyNotificationTime,
          preferredTranslationCode: bootstrap.preferredTranslationCode,
        );
      }(),
      builder: (BuildContext context, AsyncSnapshot<TodayVerse> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const AppPageLoader(
            title: 'Loading today’s verse',
            subtitle:
                'Resolving the current daily assignment and keeping it aligned with your configured daily time.',
            icon: Icons.wb_sunny_outlined,
          );
        }

        if (snapshot.connectionState != ConnectionState.done) {
          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
            children: <Widget>[
              TodayInfoCard(
                title: 'Loading today’s verse',
                subtitle:
                    'Resolving the current daily assignment and keeping it aligned with your configured daily time.',
                icon: Icons.hourglass_top_rounded,
                child: Center(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: AppColors.surfaceSoft,
                      borderRadius: BorderRadius.circular(AppRadii.lg),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: const SizedBox(
                      width: 56,
                      height: 56,
                      child: Center(
                        child: SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(strokeWidth: 2.5),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        }

        if (snapshot.hasError || !snapshot.hasData) {
          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
            children: <Widget>[
              TodayInfoCard(
                title: 'Unable to load today’s verse',
                subtitle:
                    'The assignment pipeline can fall back to local content, but this screen still needs a valid verse payload to continue.',
                icon: Icons.error_outline_rounded,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      snapshot.error?.toString() ?? 'No verse available right now.',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
            ],
          );
        }

        return builder(context, snapshot.data!);
      },
    );
  }
}

class _TodayStepRow extends StatelessWidget {
  const _TodayStepRow({
    required this.index,
    required this.title,
    required this.description,
  });

  final String index;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        DecoratedBox(
          decoration: const BoxDecoration(
            color: AppColors.surfaceMuted,
            shape: BoxShape.circle,
          ),
          child: SizedBox(
            width: 32,
            height: 32,
            child: Center(
              child: Text(
                index,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(title, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 4),
              Text(description, style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
        ),
      ],
    );
  }
}

class _InsightRow extends StatelessWidget {
  const _InsightRow({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Padding(
          padding: EdgeInsets.only(top: 4),
          child: Icon(
            Icons.check_circle_rounded,
            size: 18,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(text, style: Theme.of(context).textTheme.bodyLarge),
        ),
      ],
    );
  }
}

class _ContextSectionTile extends StatelessWidget {
  const _ContextSectionTile({required this.section});

  final VerseContextSection section;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surfaceSoft,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(section.title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(section.body, style: Theme.of(context).textTheme.bodyLarge),
          ],
        ),
      ),
    );
  }
}

class _RelatedPassageTile extends StatelessWidget {
  const _RelatedPassageTile({required this.passage});

  final RelatedPassagePreview passage;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surfaceSoft,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Icon(Icons.bookmark_add_outlined, color: AppColors.primary),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    passage.reference,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    passage.note,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ExplainPointTile extends StatelessWidget {
  const _ExplainPointTile({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surfaceSoft,
        borderRadius: BorderRadius.circular(AppRadii.xl),
        border: Border.all(color: AppColors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: AppSpacing.sm),
            Text(body, style: Theme.of(context).textTheme.bodyLarge),
          ],
        ),
      ),
    );
  }
}

class _ReflectionPromptCard extends StatelessWidget {
  const _ReflectionPromptCard({required this.prompt});

  final String prompt;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surfaceSoft,
        borderRadius: BorderRadius.circular(AppRadii.xl),
        border: Border.all(color: AppColors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.only(top: 2),
              child: Icon(
                Icons.edit_note_rounded,
                size: 18,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(prompt, style: Theme.of(context).textTheme.bodyLarge),
            ),
          ],
        ),
      ),
    );
  }
}

enum _ShareVariant { square, story }

class _SharePreviewSurface extends StatelessWidget {
  const _SharePreviewSurface({required this.verse, required this.variant});

  final TodayVerse verse;
  final _ShareVariant variant;

  @override
  Widget build(BuildContext context) {
    final bool isStory = variant == _ShareVariant.story;

    return Center(
      child: Container(
        width: isStory ? 230 : 280,
        constraints: BoxConstraints(minHeight: isStory ? 420 : 280),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: AppColors.borderStrong),
          gradient: const LinearGradient(
            colors: <Color>[Color(0xFFF7EFE7), Color(0xFFFDF9F5)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 18,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(isStory ? 20 : 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Bible App',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.3,
                ),
              ),
              const SizedBox(height: 12),
              DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(AppRadii.lg),
                  border: Border.all(color: AppColors.border),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  child: Text(
                    verse.category,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Text(
                verse.verseText,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  height: 1.3,
                  color: AppColors.textPrimary,
                ),
                maxLines: isStory ? 9 : 6,
                overflow: TextOverflow.ellipsis,
              ),
              const Spacer(),
              Text(
                verse.reference,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Daily verse',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

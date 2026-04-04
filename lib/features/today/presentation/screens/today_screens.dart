import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/app_screen_scaffold.dart';
import '../../data/mock/mock_today_repository.dart';
import '../../domain/models/today_verse.dart';
import '../widgets/today_badge.dart';
import '../widgets/today_info_card.dart';
import '../widgets/today_verse_hero_card.dart';

class TodayHomeScreen extends StatelessWidget {
  const TodayHomeScreen({super.key});

  static const MockTodayRepository _repository = MockTodayRepository();

  @override
  Widget build(BuildContext context) {
    final TodayVerse verse = _repository.getTodayVerse();

    return TabScreenScaffold(
      title: 'Today',
      subtitle: 'Daily verse, reflection, and calm encouragement',
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
        children: <Widget>[
          TodayVerseHeroCard(
            verse: verse,
            compact: true,
            onTap: () => context.push(AppRoutes.todayVerseDetail),
          ),
          const SizedBox(height: AppSpacing.lg),
          TodayInfoCard(
            title: 'A gentle focus for today',
            subtitle:
                'Your daily assignment is matched to a chosen category in the UI-first mock flow.',
            icon: Icons.light_mode_outlined,
            child: Text(
              verse.encouragementLine,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          TodayInfoCard(
            title: 'Quick actions',
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
                    child: const Text('Open verse context'),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () =>
                            context.push(AppRoutes.todayVerseAiExplain),
                        child: const Text('AI explain'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () =>
                            context.push(AppRoutes.todaySharePreview),
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
            subtitle: 'A calm journaling entry point for the verse of the day.',
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
                'This helps the user move beyond a single isolated verse while keeping scripture central.',
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
            title: 'A simple rhythm for this verse',
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
  }
}

class TodayVerseDetailScreen extends StatelessWidget {
  const TodayVerseDetailScreen({super.key});

  static const MockTodayRepository _repository = MockTodayRepository();

  @override
  Widget build(BuildContext context) {
    final TodayVerse verse = _repository.getTodayVerse();

    return TabScreenScaffold(
      title: 'Verse detail',
      subtitle: 'Today',
      showBackButton: true,
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
        children: <Widget>[
          TodayVerseHeroCard(verse: verse),
          const SizedBox(height: AppSpacing.lg),
          TodayInfoCard(
            title: 'What this verse is inviting today',
            subtitle:
                'A short product-level framing that keeps the verse central without replacing it.',
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
            subtitle:
                'This can later connect to saved/private reflection flows.',
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
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(fontStyle: FontStyle.italic),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Next actions',
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
                        onPressed: () =>
                            context.push(AppRoutes.todaySharePreview),
                        child: const Text('Share preview'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () =>
                            context.push(AppRoutes.todayVerseAiExplain),
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
      ),
    );
  }
}

class TodayVerseContextScreen extends StatelessWidget {
  const TodayVerseContextScreen({super.key});

  static const MockTodayRepository _repository = MockTodayRepository();

  @override
  Widget build(BuildContext context) {
    final TodayVerse verse = _repository.getTodayVerse();

    return TabScreenScaffold(
      title: 'Verse context',
      subtitle: 'Today',
      showBackButton: true,
      body: ListView(
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
                      label: 'Context-first reading',
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
                'Designed to keep the reading calm, clear, and non-academic for V1.',
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
            subtitle:
                'Helpful companion references that support the theme without replacing the main passage.',
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
              'Context does not compete with scripture. It simply helps the user read more faithfully, more calmly, and with less risk of pulling one line away from its surrounding thought.',
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
      ),
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

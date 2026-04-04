import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radii.dart';
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

class TodayVerseAiExplainScreen extends StatelessWidget {
  const TodayVerseAiExplainScreen({super.key});

  static const MockTodayRepository _repository = MockTodayRepository();

  @override
  Widget build(BuildContext context) {
    final TodayVerse verse = _repository.getTodayVerse();

    return TabScreenScaffold(
      title: 'AI explain',
      subtitle: 'Today',
      showBackButton: true,
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
        children: <Widget>[
          TodayInfoCard(
            title: 'Support-only explanation',
            subtitle:
                'This screen should help the user understand the verse more clearly without replacing scripture or deciding truth for them.',
            icon: Icons.auto_awesome_outlined,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: <Widget>[
                    const TodayBadge(
                      label: 'LLM support only',
                      icon: Icons.shield_outlined,
                    ),
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
                  'In plain language, this verse invites the reader to bring anxiety into honest prayer, stay grateful while speaking to God, and trust Him to guard the inner life with peace that goes beyond normal explanation.',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          TodayInfoCard(
            title: 'What the verse is saying',
            subtitle:
                'A simple breakdown for users who want clarity without a heavy theological wall of text.',
            icon: Icons.lightbulb_outline_rounded,
            child: Column(
              children: const <Widget>[
                _ExplainPointTile(
                  title: 'Bring the burden to God',
                  body:
                      'The verse moves the reader away from carrying everything internally and toward active prayer.',
                ),
                SizedBox(height: 12),
                _ExplainPointTile(
                  title: 'Thanksgiving matters',
                  body:
                      'Gratitude changes the posture of the heart even before the situation changes.',
                ),
                SizedBox(height: 12),
                _ExplainPointTile(
                  title: 'Peace is described as protection',
                  body:
                      'God’s peace is pictured as guarding the heart and mind, not merely offering a pleasant feeling.',
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          TodayInfoCard(
            title: 'What this verse is not saying',
            subtitle:
                'This helps avoid common misunderstandings while staying gentle and readable.',
            icon: Icons.rule_outlined,
            child: Column(
              children: const <Widget>[
                _ExplainPointTile(
                  title: 'It is not telling people to pretend nothing is wrong',
                  body:
                      'The verse redirects worry into prayer. It does not deny the reality of pain, stress, or uncertainty.',
                ),
                SizedBox(height: 12),
                _ExplainPointTile(
                  title: 'It is not promising instant life change',
                  body:
                      'The emphasis is on God’s guarding peace, not on immediate removal of every hard situation.',
                ),
                SizedBox(height: 12),
                _ExplainPointTile(
                  title: 'It is not replacing scripture with AI',
                  body:
                      'This explanation is only a support layer. The verse itself remains central and authoritative in the reading experience.',
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          TodayInfoCard(
            title: 'Reflection prompts',
            subtitle:
                'These prompts help the user slow down instead of just consuming explanation.',
            icon: Icons.rate_review_outlined,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _ReflectionPromptCard(
                  prompt:
                      'What specific burden would it look like to name honestly before God today?',
                ),
                const SizedBox(height: 12),
                _ReflectionPromptCard(
                  prompt:
                      'What might gratitude sound like in prayer even before the situation changes?',
                ),
                const SizedBox(height: 12),
                _ReflectionPromptCard(
                  prompt:
                      'Where do you most need God to guard your heart and mind right now?',
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          TodayInfoCard(
            title: 'Move between scripture and support',
            subtitle:
                'The design should keep the user close to the verse and context, not trapped inside explanation.',
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
      ),
    );
  }
}

class TodaySharePreviewScreen extends StatelessWidget {
  const TodaySharePreviewScreen({super.key});

  static const MockTodayRepository _repository = MockTodayRepository();

  @override
  Widget build(BuildContext context) {
    final TodayVerse verse = _repository.getTodayVerse();

    return TabScreenScaffold(
      title: 'Share preview',
      subtitle: 'Today',
      showBackButton: true,
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
        children: <Widget>[
          TodayInfoCard(
            title: 'Share preview',
            subtitle:
                'This screen previews how a verse card could look before real export and native share actions are added.',
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
                    const TodayBadge(
                      label: 'Preview only',
                      icon: Icons.visibility_outlined,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  'The goal is a calm, readable share style that still feels like the app and keeps scripture central.',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          TodayInfoCard(
            title: 'Square post preview',
            subtitle: 'A balanced card shape for feed-style sharing later.',
            icon: Icons.crop_square_rounded,
            child: _SharePreviewSurface(
              verse: verse,
              variant: _ShareVariant.square,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          TodayInfoCard(
            title: 'Story preview',
            subtitle: 'A taller layout for story-style sharing later.',
            icon: Icons.stay_current_portrait_rounded,
            child: _SharePreviewSurface(
              verse: verse,
              variant: _ShareVariant.story,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          TodayInfoCard(
            title: 'What real sharing will add later',
            subtitle: 'This keeps the screen honest during the current phase.',
            icon: Icons.info_outline_rounded,
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _ShareBullet(
                  text:
                      'Real export and native share actions are still future work.',
                ),
                _ShareBullet(
                  text:
                      'Theme variations, image backgrounds, and typography presets can be added later.',
                ),
                _ShareBullet(
                  text:
                      'The current screen exists so the sharing UX can already be designed without backend or platform wiring.',
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
                  'Related Today routes',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: AppSpacing.lg),
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
                    onPressed: () =>
                        context.push(AppRoutes.todayVerseAiExplain),
                    child: const Text('Open AI explain'),
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
                'Bible App V1',
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
                'Daily verse preview',
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

class _ShareBullet extends StatelessWidget {
  const _ShareBullet({required this.text});

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

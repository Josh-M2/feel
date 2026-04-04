import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/app_screen_scaffold.dart';
import '../../data/mock/mock_plans_repository.dart';
import '../../domain/models/reading_plan.dart';
import '../widgets/plan_day_focus_card.dart';
import '../widgets/plan_info_card.dart';
import '../widgets/plan_list_card.dart';

class PlansListScreen extends StatelessWidget {
  const PlansListScreen({super.key});

  static const MockPlansRepository _repository = MockPlansRepository();

  @override
  Widget build(BuildContext context) {
    final List<ReadingPlan> plans = _repository.getPlans();
    final ReadingPlan continuePlan = _repository.getContinuePlan();
    final PlanDay currentDay = _repository.getPlanDay(
      planId: continuePlan.id,
      dayNumber: continuePlan.currentDayNumber,
    );

    return TabScreenScaffold(
      title: 'Plans',
      subtitle: 'Simple, supportive reading plans',
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
        children: <Widget>[
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Continue your current plan',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  continuePlan.title,
                  style: Theme.of(
                    context,
                  ).textTheme.headlineMedium?.copyWith(fontSize: 30),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  continuePlan.progressLabel,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  currentDay.focusLine,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: AppSpacing.lg),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () {
                      context.push(
                        AppRoutes.plansDayRead,
                        extra: PlanDayReadRouteArgs(
                          planId: continuePlan.id,
                          dayNumber: currentDay.dayNumber,
                        ),
                      );
                    },
                    child: const Text('Continue today'),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          PlanInfoCard(
            title: 'How plans are framed in V1',
            subtitle:
                'The goal is encouragement and consistency, not pressure-heavy productivity.',
            icon: Icons.event_note_outlined,
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _PlanBullet(
                  text:
                      'Plans are short, approachable, and supportive for daily use.',
                ),
                _PlanBullet(
                  text:
                      'Progress language stays gentle and calm instead of stressful.',
                ),
                _PlanBullet(
                  text:
                      'Each day keeps one main focus, one reflection prompt, and one prayer prompt.',
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text('Reading plans', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: AppSpacing.md),
          ...plans.map(
            (ReadingPlan plan) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: PlanListCard(
                plan: plan,
                onTap: () {
                  context.push(
                    AppRoutes.plansPlanDetail,
                    extra: PlanDetailRouteArgs(planId: plan.id),
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

class PlanDetailScreen extends StatelessWidget {
  const PlanDetailScreen({super.key, this.planId});

  static const MockPlansRepository _repository = MockPlansRepository();

  final String? planId;

  @override
  Widget build(BuildContext context) {
    final ReadingPlan plan = _repository.getPlanById(planId);
    final PlanDay currentDay = _repository.getPlanDay(
      planId: plan.id,
      dayNumber: plan.currentDayNumber,
    );

    return TabScreenScaffold(
      title: 'Plan detail',
      subtitle: 'Plans',
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
                    Chip(label: Text(plan.categoryLabel)),
                    Chip(label: Text('${plan.durationDays} days')),
                    Chip(label: Text(plan.progressLabel)),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  plan.title,
                  style: Theme.of(
                    context,
                  ).textTheme.headlineMedium?.copyWith(fontSize: 32),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  plan.subtitle,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: AppSpacing.lg),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: FilledButton(
                        onPressed: () {
                          context.push(
                            AppRoutes.plansDayRead,
                            extra: PlanDayReadRouteArgs(
                              planId: plan.id,
                              dayNumber: currentDay.dayNumber,
                            ),
                          );
                        },
                        child: Text('Open ${plan.progressLabel}'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          context.push(
                            AppRoutes.plansDayRead,
                            extra: PlanDayReadRouteArgs(
                              planId: plan.id,
                              dayNumber: plan.days.first.dayNumber,
                            ),
                          );
                        },
                        child: const Text('Start from day 1'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          PlanInfoCard(
            title: 'Overview',
            subtitle:
                'A calm explanation of what the plan is meant to help with.',
            icon: Icons.description_outlined,
            child: Text(
              plan.description,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          PlanInfoCard(
            title: 'Why this plan helps',
            icon: Icons.lightbulb_outline_rounded,
            child: Text(
              plan.whyItHelps,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          PlanInfoCard(
            title: 'Current day focus',
            subtitle:
                'A quick preview of where the reader currently is in the plan.',
            icon: Icons.play_circle_outline_rounded,
            child: PlanDayFocusCard(day: currentDay),
          ),
          const SizedBox(height: AppSpacing.lg),
          PlanInfoCard(
            title: 'Days in this plan',
            subtitle:
                'Each day stays short and readable so the flow remains approachable.',
            icon: Icons.view_list_outlined,
            child: Column(
              children: plan.days
                  .map(
                    (PlanDay day) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _PlanDayTile(
                        day: day,
                        isCurrent: day.dayNumber == plan.currentDayNumber,
                        onTap: () {
                          context.push(
                            AppRoutes.plansDayRead,
                            extra: PlanDayReadRouteArgs(
                              planId: plan.id,
                              dayNumber: day.dayNumber,
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
                    onPressed: () => context.push(AppRoutes.plansProgress),
                    child: const Text('Open progress route'),
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

class PlanDayReadScreen extends StatelessWidget {
  const PlanDayReadScreen({super.key, this.planId, this.dayNumber});

  static const MockPlansRepository _repository = MockPlansRepository();

  final String? planId;
  final int? dayNumber;

  @override
  Widget build(BuildContext context) {
    final ReadingPlan plan = _repository.getPlanById(planId);
    final PlanDay day = _repository.getPlanDay(
      planId: plan.id,
      dayNumber: dayNumber,
    );
    final PlanDay? previousDay = _repository.getPreviousDay(
      planId: plan.id,
      dayNumber: day.dayNumber,
    );
    final PlanDay? nextDay = _repository.getNextDay(
      planId: plan.id,
      dayNumber: day.dayNumber,
    );

    return TabScreenScaffold(
      title: 'Day read',
      subtitle: 'Plans',
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
                    Chip(label: Text(plan.title)),
                    Chip(label: Text('Day ${day.dayNumber}')),
                    Chip(label: Text('${plan.durationDays} days total')),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  'Day ${day.dayNumber}',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  day.title,
                  style: Theme.of(
                    context,
                  ).textTheme.headlineMedium?.copyWith(fontSize: 32),
                ),
                const SizedBox(height: AppSpacing.md),
                Text(day.summary, style: Theme.of(context).textTheme.bodyLarge),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          PlanInfoCard(
            title: 'Today’s focus',
            subtitle:
                'One main thought to carry through the reading instead of too many tasks.',
            icon: Icons.center_focus_strong_outlined,
            child: Text(
              day.focusLine,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          PlanInfoCard(
            title: 'Passage references',
            subtitle:
                'In this UI-first phase, references are shown cleanly and can later connect to full reading screens.',
            icon: Icons.menu_book_outlined,
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: day.passageRefs
                  .map((String ref) => Chip(label: Text(ref)))
                  .toList(),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          PlanInfoCard(
            title: 'Reflection prompt',
            icon: Icons.edit_note_rounded,
            child: Text(
              day.reflectionPrompt,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          PlanInfoCard(
            title: 'Prayer prompt',
            icon: Icons.volunteer_activism_outlined,
            child: Text(
              day.prayerPrompt,
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(fontStyle: FontStyle.italic),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          PlanInfoCard(
            title: 'Next reading actions',
            icon: Icons.auto_awesome_outlined,
            child: Column(
              children: <Widget>[
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      context.push(
                        AppRoutes.plansPlanDetail,
                        extra: PlanDetailRouteArgs(planId: plan.id),
                      );
                    },
                    child: const Text('Back to plan detail'),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: OutlinedButton(
                        onPressed: previousDay == null
                            ? null
                            : () {
                                context.push(
                                  AppRoutes.plansDayRead,
                                  extra: PlanDayReadRouteArgs(
                                    planId: plan.id,
                                    dayNumber: previousDay.dayNumber,
                                  ),
                                );
                              },
                        child: const Text('Previous'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: nextDay == null
                            ? null
                            : () {
                                context.push(
                                  AppRoutes.plansDayRead,
                                  extra: PlanDayReadRouteArgs(
                                    planId: plan.id,
                                    dayNumber: nextDay.dayNumber,
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
                  'This screen is intentionally shaped so full passage reading, completion check-ins, note-saving, streaks, and real progress state can be added later without changing the route shell.',
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

class _PlanBullet extends StatelessWidget {
  const _PlanBullet({required this.text});

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

class _PlanDayTile extends StatelessWidget {
  const _PlanDayTile({
    required this.day,
    required this.onTap,
    required this.isCurrent,
  });

  final PlanDay day;
  final VoidCallback onTap;
  final bool isCurrent;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: isCurrent ? AppColors.surfaceMuted : AppColors.surfaceSoft,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isCurrent ? AppColors.borderStrong : AppColors.border,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        onTap: onTap,
        title: Text(
          'Day ${day.dayNumber}',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Text(day.title),
        ),
        trailing: isCurrent
            ? const Icon(Icons.play_circle_outline_rounded)
            : const Icon(Icons.arrow_forward_rounded),
      ),
    );
  }
}

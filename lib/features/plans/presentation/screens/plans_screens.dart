import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radii.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/app_screen_scaffold.dart';
import '../../data/public/supabase_plans_repository.dart';
import '../../domain/models/reading_plan.dart';
import '../../domain/repositories/plans_repository.dart';
import '../widgets/plan_day_focus_card.dart';
import '../widgets/plan_info_card.dart';
import '../widgets/plan_list_card.dart';

class PlansListScreen extends StatelessWidget {
  const PlansListScreen({super.key});

  static final PlansRepository _repository = SupabasePlansRepository();

  Future<_PlansListScreenData> _loadScreenData() async {
    final List<ReadingPlan> plans = await _repository.getPlans();
    final ReadingPlan? continuePlan = await _repository.getContinuePlan();
    return _PlansListScreenData(
      plans: plans,
      continuePlan: continuePlan,
      currentDay: continuePlan?.resolvedCurrentDay,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: _repository.revisionListenable,
      builder: (BuildContext context, int _, Widget? child) {
        return FutureBuilder<_PlansListScreenData>(
          future: _loadScreenData(),
          builder: (BuildContext context, AsyncSnapshot<_PlansListScreenData> snapshot) {
            return TabScreenScaffold(
              title: 'Plans',
              subtitle: 'Simple, supportive reading plans',
              body: _buildBody(context, snapshot),
            );
          },
        );
      },
    );
  }

  Widget _buildBody(
    BuildContext context,
    AsyncSnapshot<_PlansListScreenData> snapshot,
  ) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: CircularProgressIndicator());
    }

    if (snapshot.hasError) {
      return const _PlansMessageBody(
        title: 'Plans are not ready yet',
        message:
            'The plans catalog could not be loaded from Supabase for this session. Apply the plans migration and seed content, then try again.',
      );
    }

    final _PlansListScreenData data =
        snapshot.data ?? const _PlansListScreenData.empty();
    if (data.plans.isEmpty) {
      return const _PlansMessageBody(
        title: 'No plans available yet',
        message:
            'The V1 plans catalog is empty right now. Once the seeded plans are available in Supabase, they will appear here automatically.',
      );
    }

    final ReadingPlan continuePlan = data.continuePlan ?? data.plans.first;
    final PlanDay continueDay = data.currentDay ?? continuePlan.resolvedCurrentDay;

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
      children: <Widget>[
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Continue your plan',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                continuePlan.title,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 30),
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
                continueDay.focusLine,
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
                        dayNumber: continuePlan.currentDayNumber,
                      ),
                    );
                  },
                  child: Text(continuePlan.isStarted ? 'Continue today' : 'Start this plan'),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        PlanInfoCard(
          title: 'How plans are shaped',
          subtitle: 'Short, supportive reading rhythms that are easy to return to.',
          icon: Icons.event_note_outlined,
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _PlanBullet(
                text: 'Plans are designed to feel approachable and steady.',
              ),
              _PlanBullet(
                text:
                    'Each day focuses on one main thought, one reflection, and one prayer prompt.',
              ),
              _PlanBullet(
                text: 'Progress is meant to encourage consistency without pressure.',
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Text('Reading plans', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: AppSpacing.md),
        ...data.plans.map(
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
    );
  }
}

class PlanDetailScreen extends StatelessWidget {
  const PlanDetailScreen({super.key, this.planId});

  static final PlansRepository _repository = SupabasePlansRepository();

  final String? planId;

  Future<_PlanDetailScreenData> _loadScreenData() async {
    final ReadingPlan plan = await _repository.getPlanById(planId);
    return _PlanDetailScreenData(
      plan: plan,
      currentDay: plan.resolvedCurrentDay,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: _repository.revisionListenable,
      builder: (BuildContext context, int _, Widget? child) {
        return FutureBuilder<_PlanDetailScreenData>(
          future: _loadScreenData(),
          builder: (BuildContext context, AsyncSnapshot<_PlanDetailScreenData> snapshot) {
            return TabScreenScaffold(
              title: 'Plan detail',
              subtitle: 'Plans',
              showBackButton: true,
              body: _buildBody(context, snapshot),
            );
          },
        );
      },
    );
  }

  Widget _buildBody(
    BuildContext context,
    AsyncSnapshot<_PlanDetailScreenData> snapshot,
  ) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: CircularProgressIndicator());
    }

    if (snapshot.hasError) {
      return const _PlansMessageBody(
        title: 'Plan detail is unavailable',
        message:
            'This plan could not be loaded from Supabase right now. Try again after the plans content and progress tables are available.',
      );
    }

    final _PlanDetailScreenData? data = snapshot.data;
    if (data == null) {
      return const _PlansMessageBody(
        title: 'Plan detail is unavailable',
        message: 'The requested plan could not be found.',
      );
    }

    final ReadingPlan plan = data.plan;
    final PlanDay currentDay = data.currentDay;

    return ListView(
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
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 32),
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
                            dayNumber: plan.currentDayNumber,
                          ),
                        );
                      },
                      child: Text(plan.isStarted ? 'Open ${plan.progressLabel}' : 'Start plan'),
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
          subtitle: 'A short introduction to what this plan is meant to support.',
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
          subtitle: 'A quick look at where you are right now in the plan.',
          icon: Icons.play_circle_outline_rounded,
          child: PlanDayFocusCard(day: currentDay),
        ),
        const SizedBox(height: AppSpacing.lg),
        PlanInfoCard(
          title: 'Days in this plan',
          subtitle: 'Choose a day to continue or start from the beginning.',
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
                .toList(growable: false),
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
                  onPressed: () => context.push(AppRoutes.plansProgress),
                  child: const Text('View progress'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class PlanDayReadScreen extends StatelessWidget {
  const PlanDayReadScreen({super.key, this.planId, this.dayNumber});

  static final PlansRepository _repository = SupabasePlansRepository();

  final String? planId;
  final int? dayNumber;

  Future<PlanDayReadState> _loadScreenData() {
    return _repository.openPlanDay(planId: planId, dayNumber: dayNumber);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PlanDayReadState>(
      future: _loadScreenData(),
      builder: (BuildContext context, AsyncSnapshot<PlanDayReadState> snapshot) {
        return TabScreenScaffold(
          title: 'Day read',
          subtitle: 'Plans',
          showBackButton: true,
          body: _buildBody(context, snapshot),
        );
      },
    );
  }

  Widget _buildBody(
    BuildContext context,
    AsyncSnapshot<PlanDayReadState> snapshot,
  ) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: CircularProgressIndicator());
    }

    if (snapshot.hasError || !snapshot.hasData) {
      return const _PlansMessageBody(
        title: 'Day reading is unavailable',
        message:
            'This plan day could not be loaded from Supabase right now. Try again after the plans content tables are available.',
      );
    }

    final PlanDayReadState data = snapshot.data!;
    final ReadingPlan plan = data.plan;
    final PlanDay day = data.day;
    final PlanDay? previousDay = data.previousDay;
    final PlanDay? nextDay = data.nextDay;

    return ListView(
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
                  Chip(label: Text('${plan.durationDays} days')),
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
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 32),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(day.summary, style: Theme.of(context).textTheme.bodyLarge),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        PlanInfoCard(
          title: 'Today\'s focus',
          subtitle: 'One clear thought to carry through the reading.',
          icon: Icons.center_focus_strong_outlined,
          child: Text(
            day.focusLine,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        PlanInfoCard(
          title: 'Passage references',
          subtitle: 'A simple set of passages for today\'s reading.',
          icon: Icons.menu_book_outlined,
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: day.passageRefs
                .map((String ref) => Chip(label: Text(ref)))
                .toList(growable: false),
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
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontStyle: FontStyle.italic),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        PlanInfoCard(
          title: 'Keep going',
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
                      child: Text(nextDay == null && plan.isCompleted ? 'Completed' : 'Next'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class PlansProgressScreen extends StatelessWidget {
  const PlansProgressScreen({super.key});

  static final PlansRepository _repository = SupabasePlansRepository();

  Future<_PlansProgressScreenData> _loadScreenData() async {
    final List<ReadingPlan> plans = await _repository.getPlans();
    final List<ReadingPlan> startedPlans = plans
        .where((ReadingPlan plan) => plan.isStarted)
        .toList(growable: false);
    final int totalDays = startedPlans.fold<int>(
      0,
      (int sum, ReadingPlan plan) => sum + plan.durationDays,
    );
    final int completedDays = startedPlans.fold<int>(
      0,
      (int sum, ReadingPlan plan) => sum + plan.completedDayCount,
    );
    final double overallProgress = totalDays == 0
        ? 0
        : (completedDays / totalDays).clamp(0, 1).toDouble();

    return _PlansProgressScreenData(
      plans: plans,
      startedPlans: startedPlans.length,
      completedDays: completedDays,
      trackedDays: totalDays,
      overallProgress: overallProgress,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: _repository.revisionListenable,
      builder: (BuildContext context, int _, Widget? child) {
        return FutureBuilder<_PlansProgressScreenData>(
          future: _loadScreenData(),
          builder: (BuildContext context, AsyncSnapshot<_PlansProgressScreenData> snapshot) {
            return TabScreenScaffold(
              title: 'Progress',
              subtitle: 'Plans',
              showBackButton: true,
              body: _buildBody(context, snapshot),
            );
          },
        );
      },
    );
  }

  Widget _buildBody(
    BuildContext context,
    AsyncSnapshot<_PlansProgressScreenData> snapshot,
  ) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: CircularProgressIndicator());
    }

    if (snapshot.hasError) {
      return const _PlansMessageBody(
        title: 'Progress is unavailable',
        message:
            'Plan progress could not be loaded right now. Try again after the plans content and progress tables are available.',
      );
    }

    final _PlansProgressScreenData data =
        snapshot.data ?? const _PlansProgressScreenData.empty();

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
      children: <Widget>[
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Your reading progress',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'A simple view of where you are across your plans',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 30),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'Progress is here to encourage steady reading, not to create pressure.',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: AppSpacing.lg),
              ClipRRect(
                borderRadius: BorderRadius.circular(AppRadii.pill),
                child: LinearProgressIndicator(
                  value: data.overallProgress,
                  minHeight: 12,
                  backgroundColor: AppColors.surfaceMuted,
                  valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: <Widget>[
                  _ProgressPill(label: 'Started plans', value: '${data.startedPlans}'),
                  _ProgressPill(label: 'Completed days', value: '${data.completedDays}'),
                  _ProgressPill(label: 'Tracked days', value: '${data.trackedDays}'),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        PlanInfoCard(
          title: 'Plan snapshots',
          subtitle: 'A quick way to see where each plan currently stands.',
          icon: Icons.insights_outlined,
          child: data.plans.isEmpty
              ? const Text('No plans are available yet.')
              : Column(
                  children: data.plans
                      .map(
                        (ReadingPlan plan) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _PlanProgressTile(plan: plan),
                        ),
                      )
                      .toList(growable: false),
                ),
        ),
        const SizedBox(height: AppSpacing.lg),
        PlanInfoCard(
          title: 'Keep the rhythm gentle',
          subtitle: 'A little consistency matters more than trying to rush ahead.',
          icon: Icons.self_improvement_outlined,
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _PlanBullet(
                text: 'A missed day does not erase the value of returning.',
              ),
              _PlanBullet(
                text:
                    'Small, steady reading rhythms can carry more than a rushed catch-up.',
              ),
              _PlanBullet(
                text: 'Let progress support your reading, not take it over.',
              ),
            ],
          ),
        ),
      ],
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

class _ProgressPill extends StatelessWidget {
  const _ProgressPill({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surfaceMuted,
        borderRadius: BorderRadius.circular(AppRadii.xl),
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
            Text(label, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}

class _PlanProgressTile extends StatelessWidget {
  const _PlanProgressTile({required this.plan});

  final ReadingPlan plan;

  @override
  Widget build(BuildContext context) {
    final int percent = (plan.progressValue * 100).round();
    final String sublabel = plan.isCompleted
        ? 'Plan completed'
        : '${plan.completedDayCount} completed - $percent% through the plan';

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
            Text(plan.title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: AppSpacing.sm),
            Text(
              plan.progressLabel,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            Text(sublabel, style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: AppSpacing.md),
            ClipRRect(
              borderRadius: BorderRadius.circular(AppRadii.pill),
              child: LinearProgressIndicator(
                value: plan.progressValue,
                minHeight: 10,
                backgroundColor: AppColors.surfaceMuted,
                valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlansMessageBody extends StatelessWidget {
  const _PlansMessageBody({
    required this.title,
    required this.message,
  });

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
      children: <Widget>[
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(title, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: AppSpacing.md),
              Text(message, style: Theme.of(context).textTheme.bodyLarge),
            ],
          ),
        ),
      ],
    );
  }
}

class _PlansListScreenData {
  const _PlansListScreenData({
    required this.plans,
    required this.continuePlan,
    required this.currentDay,
  });

  const _PlansListScreenData.empty()
    : plans = const <ReadingPlan>[],
      continuePlan = null,
      currentDay = null;

  final List<ReadingPlan> plans;
  final ReadingPlan? continuePlan;
  final PlanDay? currentDay;
}

class _PlanDetailScreenData {
  const _PlanDetailScreenData({
    required this.plan,
    required this.currentDay,
  });

  final ReadingPlan plan;
  final PlanDay currentDay;
}

class _PlansProgressScreenData {
  const _PlansProgressScreenData({
    required this.plans,
    required this.startedPlans,
    required this.completedDays,
    required this.trackedDays,
    required this.overallProgress,
  });

  const _PlansProgressScreenData.empty()
    : plans = const <ReadingPlan>[],
      startedPlans = 0,
      completedDays = 0,
      trackedDays = 0,
      overallProgress = 0;

  final List<ReadingPlan> plans;
  final int startedPlans;
  final int completedDays;
  final int trackedDays;
  final double overallProgress;
}

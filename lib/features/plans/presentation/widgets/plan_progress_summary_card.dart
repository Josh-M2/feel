import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radii.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../domain/models/reading_plan.dart';

class PlanProgressSummaryCard extends StatelessWidget {
  const PlanProgressSummaryCard({
    super.key,
    required this.plan,
    required this.onOpenPlan,
    required this.onContinue,
  });

  final ReadingPlan plan;
  final VoidCallback onOpenPlan;
  final VoidCallback onContinue;

  double get _progressValue {
    if (plan.durationDays <= 0) return 0;
    return (plan.currentDayNumber / plan.durationDays).clamp(0, 1).toDouble();
  }

  int get _daysCompleted {
    final int value = plan.currentDayNumber - 1;
    return value < 0 ? 0 : value;
  }

  @override
  Widget build(BuildContext context) {
    final int percent = (_progressValue * 100).round();

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
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: <Widget>[
                _MiniBadge(label: plan.categoryLabel),
                _MiniBadge(label: '${plan.durationDays} days'),
                _MiniBadge(label: plan.progressLabel),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(plan.title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: AppSpacing.sm),
            Text(
              '$_daysCompleted completed • $percent% through the plan',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: AppSpacing.lg),
            ClipRRect(
              borderRadius: BorderRadius.circular(AppRadii.pill),
              child: LinearProgressIndicator(
                value: _progressValue,
                minHeight: 10,
                backgroundColor: AppColors.surfaceMuted,
                valueColor: const AlwaysStoppedAnimation<Color>(
                  AppColors.primary,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              plan.whyItHelps,
              style: Theme.of(context).textTheme.bodyLarge,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: AppSpacing.lg),
            Row(
              children: <Widget>[
                Expanded(
                  child: FilledButton(
                    onPressed: onContinue,
                    child: const Text('Continue'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: onOpenPlan,
                    child: const Text('View plan'),
                  ),
                ),
              ],
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
        color: AppColors.surfaceMuted,
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

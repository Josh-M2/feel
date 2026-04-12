import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../domain/models/today_verse.dart';
import 'today_badge.dart';

class TodayVerseHeroCard extends StatelessWidget {
  const TodayVerseHeroCard({
    super.key,
    required this.verse,
    this.compact = false,
    this.onTap,
  });

  final TodayVerse verse;
  final bool compact;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: <Widget>[
              TodayBadge(label: verse.dateLabel, icon: Icons.wb_sunny_outlined),
              TodayBadge(
                label: verse.category,
                icon: Icons.local_offer_outlined,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            verse.verseText,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontSize: compact ? 26 : 30,
              height: 1.25,
            ),
            maxLines: compact ? 5 : null,
            overflow: compact ? TextOverflow.ellipsis : null,
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            verse.reference,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            verse.translationLabel,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          if (onTap != null) ...<Widget>[
            const SizedBox(height: AppSpacing.lg),
            Row(
              children: <Widget>[
                Text(
                  'Open verse detail',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                const Spacer(),
                const Icon(
                  Icons.arrow_forward_rounded,
                  color: AppColors.textSecondary,
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

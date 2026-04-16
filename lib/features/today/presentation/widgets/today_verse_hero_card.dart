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
    final double verseFontSize = compact ? 22 : 28;
    final double metaGap = compact ? AppSpacing.sm : AppSpacing.md;
    final double referenceGap = compact ? AppSpacing.md : AppSpacing.lg;

    return AppCard(
      variant: AppCardVariant.primary,
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
          SizedBox(height: metaGap),
          Text(
            verse.verseText,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontSize: verseFontSize,
              height: compact ? 1.35 : 1.3,
              fontWeight: FontWeight.w600,
            ),
            softWrap: true,
          ),
          SizedBox(height: referenceGap),
          Text(
            verse.reference,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppColors.accentStrong,
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

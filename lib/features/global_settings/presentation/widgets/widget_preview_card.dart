import 'package:flutter/material.dart';

import '../../../../app/bootstrap/app_bootstrap_controller.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radii.dart';
import '../../../../app/theme/app_spacing.dart';

class WidgetPreviewSample {
  const WidgetPreviewSample({required this.verseText, required this.reference});

  final String verseText;
  final String reference;
}

WidgetPreviewSample buildWidgetPreviewSample(String categoryLabel) {
  switch (categoryLabel) {
    case 'Peace Over Anxiety':
      return const WidgetPreviewSample(
        verseText:
            'And the peace of God, which passeth all understanding, shall keep your hearts and minds through Christ Jesus.',
        reference: 'Philippians 4:7',
      );
    case 'Strength':
      return const WidgetPreviewSample(
        verseText:
            'But they that wait upon the Lord shall renew their strength...',
        reference: 'Isaiah 40:31',
      );
    case 'Hope':
      return const WidgetPreviewSample(
        verseText:
            'For I know the thoughts that I think toward you, saith the Lord...',
        reference: 'Jeremiah 29:11',
      );
    case 'Purpose and Calling':
      return const WidgetPreviewSample(
        verseText:
            'For we are his workmanship, created in Christ Jesus unto good works...',
        reference: 'Ephesians 2:10',
      );
    default:
      return const WidgetPreviewSample(
        verseText:
            'Trust in the Lord with all thine heart; and lean not unto thine own understanding.',
        reference: 'Proverbs 3:5',
      );
  }
}

class WidgetPreviewCard extends StatelessWidget {
  const WidgetPreviewCard({
    super.key,
    required this.sample,
    required this.categoryLabel,
    required this.updateTimeLabel,
    required this.style,
    required this.showReference,
    required this.showCategory,
    required this.showDate,
  });

  final WidgetPreviewSample sample;
  final String categoryLabel;
  final String updateTimeLabel;
  final WidgetPreviewStyle style;
  final bool showReference;
  final bool showCategory;
  final bool showDate;

  @override
  Widget build(BuildContext context) {
    final bool isCozy = style == WidgetPreviewStyle.cozy;

    final Color backgroundColor = isCozy
        ? AppColors.surfaceMuted
        : AppColors.surface;
    final Color innerBorderColor = isCozy
        ? AppColors.borderStrong
        : AppColors.border;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        DecoratedBox(
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(AppRadii.xl),
            border: Border.all(color: innerBorderColor),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(isCozy ? 18 : 16),
            child: ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 170),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  if (showDate || showCategory)
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: <Widget>[
                        if (showDate) const _WidgetMiniPill(label: 'TODAY'),
                        if (showCategory) _WidgetMiniPill(label: categoryLabel),
                      ],
                    ),
                  if (showDate || showCategory) const SizedBox(height: 14),
                  Text(
                    'Daily verse',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    sample.verseText,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      height: 1.28,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: isCozy ? 5 : 4,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  if (showReference)
                    Text(
                      sample.reference,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'Updates daily at $updateTimeLabel',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'Preview only for this UI-first phase. Real OS widget sync comes later.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}

class _WidgetMiniPill extends StatelessWidget {
  const _WidgetMiniPill({required this.label});

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
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

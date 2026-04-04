import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';
import 'app_card.dart';

class PlaceholderAction {
  const PlaceholderAction({required this.label, required this.route});

  final String label;
  final String route;
}

class PlaceholderContent extends StatelessWidget {
  const PlaceholderContent({
    super.key,
    required this.eyebrow,
    required this.title,
    required this.description,
    this.tags = const <String>[],
    this.actions = const <PlaceholderAction>[],
    this.extraSection,
    this.footerNote,
  });

  final String eyebrow;
  final String title;
  final String description;
  final List<String> tags;
  final List<PlaceholderAction> actions;
  final Widget? extraSection;
  final String? footerNote;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
      children: <Widget>[
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                eyebrow.toUpperCase(),
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.4,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                title,
                style: Theme.of(
                  context,
                ).textTheme.headlineMedium?.copyWith(fontSize: 28),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(description, style: Theme.of(context).textTheme.bodyLarge),
              if (tags.isNotEmpty) ...<Widget>[
                const SizedBox(height: AppSpacing.lg),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: tags
                      .map(
                        (String tag) => Chip(
                          label: Text(tag),
                          visualDensity: VisualDensity.compact,
                        ),
                      )
                      .toList(),
                ),
              ],
            ],
          ),
        ),
        if (actions.isNotEmpty) ...<Widget>[
          const SizedBox(height: AppSpacing.lg),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Quick routes',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: AppSpacing.md),
                ...actions.map(
                  (PlaceholderAction action) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () => context.push(action.route),
                        child: Text(action.label),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
        if (extraSection != null) ...<Widget>[
          const SizedBox(height: AppSpacing.lg),
          extraSection!,
        ],
        if (footerNote != null) ...<Widget>[
          const SizedBox(height: AppSpacing.lg),
          AppCard(
            child: Text(
              footerNote!,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ],
    );
  }
}

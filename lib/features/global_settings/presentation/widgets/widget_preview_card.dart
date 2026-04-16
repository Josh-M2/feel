import 'package:flutter/material.dart';

import '../../../../core/preferences/app_preference_snapshot.dart';
import '../../../../app/theme/app_radii.dart';
import '../../../../app/theme/app_spacing.dart';

class WidgetPreviewSample {
  const WidgetPreviewSample({
    required this.verseText,
    required this.reference,
    required this.translationLabel,
    required this.effectiveDateKey,
  });

  final String verseText;
  final String reference;
  final String translationLabel;
  final String effectiveDateKey;
}

class WidgetPreviewPalette {
  const WidgetPreviewPalette({
    required this.surface,
    required this.border,
    required this.badge,
    required this.primaryText,
    required this.secondaryText,
    required this.accent,
  });

  final Color surface;
  final Color border;
  final Color badge;
  final Color primaryText;
  final Color secondaryText;
  final Color accent;
}

WidgetPreviewSample buildWidgetPreviewSample(String categoryLabel) {
  switch (categoryLabel) {
    case 'Peace Over Anxiety':
      return const WidgetPreviewSample(
        verseText:
            'And the peace of God, which passeth all understanding, shall keep your hearts and minds through Christ Jesus.',
        reference: 'Philippians 4:7',
        translationLabel: 'KJV',
        effectiveDateKey: '2026-04-16',
      );
    case 'Strength':
      return const WidgetPreviewSample(
        verseText:
            'But they that wait upon the Lord shall renew their strength...',
        reference: 'Isaiah 40:31',
        translationLabel: 'KJV',
        effectiveDateKey: '2026-04-16',
      );
    case 'Hope':
      return const WidgetPreviewSample(
        verseText:
            'For I know the thoughts that I think toward you, saith the Lord...',
        reference: 'Jeremiah 29:11',
        translationLabel: 'KJV',
        effectiveDateKey: '2026-04-16',
      );
    case 'Purpose and Calling':
      return const WidgetPreviewSample(
        verseText:
            'For we are his workmanship, created in Christ Jesus unto good works...',
        reference: 'Ephesians 2:10',
        translationLabel: 'KJV',
        effectiveDateKey: '2026-04-16',
      );
    default:
      return const WidgetPreviewSample(
        verseText:
            'Trust in the Lord with all thine heart; and lean not unto thine own understanding.',
        reference: 'Proverbs 3:5',
        translationLabel: 'KJV',
        effectiveDateKey: '2026-04-16',
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
    required this.accentTone,
    required this.showReference,
    required this.showCategory,
    required this.showDate,
  });

  final WidgetPreviewSample sample;
  final String categoryLabel;
  final String updateTimeLabel;
  final WidgetPreviewStyle style;
  final WidgetAccentTone accentTone;
  final bool showReference;
  final bool showCategory;
  final bool showDate;

  @override
  Widget build(BuildContext context) {
    final WidgetPreviewPalette palette = widgetPreviewPalette(
      style: style,
      accentTone: accentTone,
    );
    final bool isClean = style == WidgetPreviewStyle.minimal;
    final bool isMist = style == WidgetPreviewStyle.softMist;
    final bool isTransparent = style == WidgetPreviewStyle.transparent;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        DecoratedBox(
          decoration: BoxDecoration(
            color: palette.surface,
            borderRadius: BorderRadius.circular(AppRadii.xl),
            border: Border.all(color: palette.border),
            gradient: isTransparent
                ? LinearGradient(
                    colors: <Color>[
                      Colors.white.withOpacity(0.16),
                      palette.accent.withOpacity(0.08),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : isMist
                ? LinearGradient(
                    colors: <Color>[
                      palette.surface.withOpacity(0.92),
                      Colors.white.withOpacity(0.74),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: palette.accent.withOpacity(
                  isTransparent
                      ? 0.06
                      : isMist
                      ? 0.16
                      : 0.08,
                ),
                blurRadius: isTransparent ? 14 : (isMist ? 24 : 18),
                offset: Offset(0, isTransparent ? 6 : 10),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(
              isTransparent
                  ? 14
                  : isClean
                  ? 16
                  : 18,
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: isTransparent ? 156 : 170),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  if (showCategory || sample.translationLabel.isNotEmpty)
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: <Widget>[
                        if (showCategory)
                          _WidgetMiniPill(
                            label: categoryLabel,
                            background: palette.badge,
                            foreground: palette.secondaryText,
                            border: palette.border,
                          ),
                        if (sample.translationLabel.isNotEmpty)
                          _WidgetMiniPill(
                            label: sample.translationLabel.toUpperCase(),
                            background: palette.badge,
                            foreground: palette.secondaryText,
                            border: palette.border,
                          ),
                      ],
                    ),
                  if (showCategory || sample.translationLabel.isNotEmpty)
                    SizedBox(height: isTransparent ? 10 : 14),
                  Text(
                    _styleHeadline(style),
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: palette.accent,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: isTransparent ? 8 : AppSpacing.md),
                  Text(
                    sample.verseText,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      height: isTransparent ? 1.2 : 1.28,
                      fontWeight: FontWeight.w600,
                      color: palette.primaryText,
                    ),
                    maxLines: isTransparent ? 4 : (isMist ? 5 : (isClean ? 4 : 5)),
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: isTransparent ? 12 : AppSpacing.md),
                  if (showReference)
                    Text(
                      sample.reference,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: palette.accent,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  if (showReference) SizedBox(height: isTransparent ? 8 : AppSpacing.sm),
                  Text(
                    _footerLabel(
                      effectiveDateKey: showDate ? sample.effectiveDateKey : '',
                      updateTimeLabel: updateTimeLabel,
                    ),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: palette.secondaryText,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          _captionForStyle(style),
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}

WidgetPreviewPalette widgetPreviewPalette({
  required WidgetPreviewStyle style,
  required WidgetAccentTone accentTone,
}) {
  final WidgetPreviewPalette base = switch (accentTone) {
    WidgetAccentTone.sky => const WidgetPreviewPalette(
      surface: Color(0xFFF4F9FF),
      border: Color(0xFFD1E6FA),
      badge: Color(0xFFE7F3FF),
      primaryText: Color(0xFF1B2B3A),
      secondaryText: Color(0xFF4F6578),
      accent: Color(0xFF2D73B9),
    ),
    WidgetAccentTone.sage => const WidgetPreviewPalette(
      surface: Color(0xFFF5FAF5),
      border: Color(0xFFD5E7D7),
      badge: Color(0xFFE8F4E8),
      primaryText: Color(0xFF223028),
      secondaryText: Color(0xFF5F7569),
      accent: Color(0xFF5A8B71),
    ),
    WidgetAccentTone.rose => const WidgetPreviewPalette(
      surface: Color(0xFFFFF7F8),
      border: Color(0xFFF0D7DF),
      badge: Color(0xFFFFECF1),
      primaryText: Color(0xFF36232C),
      secondaryText: Color(0xFF7D5B68),
      accent: Color(0xFFB56A86),
    ),
    WidgetAccentTone.sand => const WidgetPreviewPalette(
      surface: Color(0xFFFBF7F0),
      border: Color(0xFFE7D8C4),
      badge: Color(0xFFF6ECDE),
      primaryText: Color(0xFF2E261E),
      secondaryText: Color(0xFF736252),
      accent: Color(0xFFAA7A47),
    ),
    WidgetAccentTone.white => const WidgetPreviewPalette(
      surface: Color(0xFFFCFCFC),
      border: Color(0xFFE6E6E6),
      badge: Color(0xFFF5F5F5),
      primaryText: Color(0xFF171717),
      secondaryText: Color(0xFF6B6B6B),
      accent: Color(0xFF8A8A8A),
    ),
    WidgetAccentTone.black => const WidgetPreviewPalette(
      surface: Color(0xFF171717),
      border: Color(0xFF2F2F2F),
      badge: Color(0xFF232323),
      primaryText: Color(0xFFF6F6F6),
      secondaryText: Color(0xFFC6C6C6),
      accent: Color(0xFFEAEAEA),
    ),
  };

  if (style == WidgetPreviewStyle.minimal) {
    return WidgetPreviewPalette(
      surface: accentTone == WidgetAccentTone.black
          ? const Color(0xFF141414)
          : Colors.white,
      border: accentTone == WidgetAccentTone.black
          ? const Color(0xFF303030)
          : base.border,
      badge: accentTone == WidgetAccentTone.black
          ? const Color(0xFF212121)
          : const Color(0xFFF8FAFD),
      primaryText: base.primaryText,
      secondaryText: base.secondaryText,
      accent: base.accent,
    );
  }

  if (style == WidgetPreviewStyle.softMist) {
    return WidgetPreviewPalette(
      surface: base.surface.withOpacity(0.86),
      border: base.border.withOpacity(0.92),
      badge: Colors.white.withOpacity(0.64),
      primaryText: base.primaryText,
      secondaryText: base.secondaryText,
      accent: base.accent,
    );
  }

  if (style == WidgetPreviewStyle.transparent) {
    return WidgetPreviewPalette(
      surface: Colors.white.withOpacity(0.06),
      border: base.border.withOpacity(0.5),
      badge: Colors.white.withOpacity(0.12),
      primaryText: base.primaryText,
      secondaryText: base.secondaryText.withOpacity(0.96),
      accent: base.accent,
    );
  }

  return base;
}

String styleLabel(WidgetPreviewStyle style) {
  switch (style) {
    case WidgetPreviewStyle.cozy:
      return 'Warm';
    case WidgetPreviewStyle.minimal:
      return 'Clean';
    case WidgetPreviewStyle.softMist:
      return 'Soft mist';
    case WidgetPreviewStyle.transparent:
      return 'Transparent';
  }
}

String styleDescription(WidgetPreviewStyle style) {
  switch (style) {
    case WidgetPreviewStyle.cozy:
      return 'A warm card look with a little more softness and weight.';
    case WidgetPreviewStyle.minimal:
      return 'A lighter layout with cleaner edges and a simpler surface.';
    case WidgetPreviewStyle.softMist:
      return 'A frosted, soft-surface look inspired by glass without claiming full transparency.';
    case WidgetPreviewStyle.transparent:
      return 'The most compact option, with a near-clear surface that lets the homescreen breathe more.';
  }
}

String accentToneLabel(WidgetAccentTone tone) {
  switch (tone) {
    case WidgetAccentTone.sky:
      return 'Sky';
    case WidgetAccentTone.sage:
      return 'Sage';
    case WidgetAccentTone.rose:
      return 'Rose';
    case WidgetAccentTone.sand:
      return 'Sand';
    case WidgetAccentTone.white:
      return 'White';
    case WidgetAccentTone.black:
      return 'Black';
  }
}

String accentToneDescription(WidgetAccentTone tone) {
  switch (tone) {
    case WidgetAccentTone.sky:
      return 'Feels calm on blue, silver, and cloudy wallpapers.';
    case WidgetAccentTone.sage:
      return 'Works beautifully with green, beige, and nature backgrounds.';
    case WidgetAccentTone.rose:
      return 'Best for warm pink, sunset, and soft-photo wallpapers.';
    case WidgetAccentTone.sand:
      return 'A cozy fit for cream, brown, and warm neutral homescreens.';
    case WidgetAccentTone.white:
      return 'Perfect when your wallpaper is busy, colorful, or already dark.';
    case WidgetAccentTone.black:
      return 'Perfect for light wallpapers, bright gradients, and minimal layouts.';
  }
}

String _styleHeadline(WidgetPreviewStyle style) {
  switch (style) {
    case WidgetPreviewStyle.cozy:
      return 'Daily verse';
    case WidgetPreviewStyle.minimal:
      return 'Today in scripture';
    case WidgetPreviewStyle.softMist:
      return 'Gentle focus';
    case WidgetPreviewStyle.transparent:
      return 'Quiet glance';
  }
}

String _captionForStyle(WidgetPreviewStyle style) {
  switch (style) {
    case WidgetPreviewStyle.cozy:
      return 'A warmer card-style sample for the daily verse widget.';
    case WidgetPreviewStyle.minimal:
      return 'A cleaner, lighter sample for the daily verse widget.';
    case WidgetPreviewStyle.softMist:
      return 'A softly frosted sample that stays honest about native widget limits.';
    case WidgetPreviewStyle.transparent:
      return 'A tighter, almost-clear sample for a more compact homescreen feel.';
  }
}

String _footerLabel({
  required String effectiveDateKey,
  required String updateTimeLabel,
}) {
  final List<String> parts = <String>[
    if (effectiveDateKey.trim().isNotEmpty) effectiveDateKey.trim(),
    if (updateTimeLabel.trim().isNotEmpty) updateTimeLabel.trim(),
  ];

  if (parts.isEmpty) {
    return '';
  }

  return parts.join(' | ');
}

class _WidgetMiniPill extends StatelessWidget {
  const _WidgetMiniPill({
    required this.label,
    required this.background,
    required this.foreground,
    required this.border,
  });

  final String label;
  final Color background;
  final Color foreground;
  final Color border;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(AppRadii.pill),
        border: Border.all(color: border),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: foreground,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

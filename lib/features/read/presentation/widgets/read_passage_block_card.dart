import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radii.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../domain/models/read_book.dart';

class ReadPassageBlockCard extends StatelessWidget {
  const ReadPassageBlockCard({
    super.key,
    required this.block,
    required this.translationCode,
  });

  final ReadPassageBlock block;
  final String translationCode;

  @override
  Widget build(BuildContext context) {
    final List<int> omittedVerses = _knownWebOmittedVerses(
      rangeLabel: block.rangeLabel,
      verseNumbers: block.verses.map((ReadVerseLine verse) => verse.number),
      translationCode: translationCode,
    );
    final bool showRangeLabel = _shouldShowRangeLabel(
      heading: block.heading,
      rangeLabel: block.rangeLabel,
    );

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
            Text(block.heading, style: Theme.of(context).textTheme.titleMedium),
            if (showRangeLabel) ...<Widget>[
              const SizedBox(height: AppSpacing.xs),
              Text(
                block.rangeLabel,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
            if (omittedVerses.isNotEmpty) ...<Widget>[
              const SizedBox(height: AppSpacing.sm),
              ...omittedVerses.map(
                (int verseNumber) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(AppRadii.lg),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const Padding(
                            padding: EdgeInsets.only(top: 2),
                            child: Icon(
                              Icons.info_outline_rounded,
                              size: 16,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Verse $verseNumber is not present in the WEB main text.',
                              style: Theme.of(
                                context,
                              ).textTheme.bodySmall?.copyWith(
                                color: AppColors.textSecondary,
                                height: 1.35,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
            const SizedBox(height: AppSpacing.lg),
            ...block.verses.map(
              (ReadVerseLine verse) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      width: 28,
                      child: Text(
                        '${verse.number}',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        verse.text,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

List<int> _knownWebOmittedVerses({
  required String rangeLabel,
  required Iterable<int> verseNumbers,
  required String translationCode,
}) {
  if (translationCode.toLowerCase() != 'web') {
    return const <int>[];
  }

  final _ParsedRangeLabel? parsedRange = _parseRangeLabel(rangeLabel);
  if (parsedRange == null) {
    return const <int>[];
  }

  final Set<int> presentVerseNumbers = verseNumbers.toSet();
  return _knownWebOmissions
      .where(
        (_KnownWebOmission omission) =>
            omission.bookName == parsedRange.bookName &&
            omission.chapterNumber == parsedRange.chapterNumber &&
            omission.verseNumber >= parsedRange.verseStart &&
            omission.verseNumber <= parsedRange.verseEnd &&
            !presentVerseNumbers.contains(omission.verseNumber),
      )
      .map((_KnownWebOmission omission) => omission.verseNumber)
      .toList(growable: false);
}

_ParsedRangeLabel? _parseRangeLabel(String value) {
  final String normalized = value
      .trim()
      .replaceAll('\u2013', '-')
      .replaceAll('\u2014', '-');
  final RegExp sameChapterExp = RegExp(
    r'^(.+?)\s+(\d+):(\d+)(?:-(\d+))?$',
  );
  final Match? sameChapterMatch = sameChapterExp.firstMatch(normalized);
  if (sameChapterMatch == null) {
    return null;
  }

  final String bookName = sameChapterMatch.group(1)!.trim().toLowerCase();
  final int chapterNumber = int.parse(sameChapterMatch.group(2)!);
  final int verseStart = int.parse(sameChapterMatch.group(3)!);
  final int verseEnd =
      int.tryParse(sameChapterMatch.group(4) ?? '') ?? verseStart;

  return _ParsedRangeLabel(
    bookName: bookName,
    chapterNumber: chapterNumber,
    verseStart: verseStart,
    verseEnd: verseEnd,
  );
}

const List<_KnownWebOmission> _knownWebOmissions = <_KnownWebOmission>[
  _KnownWebOmission(bookName: 'acts', chapterNumber: 8, verseNumber: 37),
  _KnownWebOmission(bookName: 'acts', chapterNumber: 15, verseNumber: 34),
  _KnownWebOmission(bookName: 'acts', chapterNumber: 24, verseNumber: 7),
  _KnownWebOmission(bookName: 'luke', chapterNumber: 17, verseNumber: 36),
];

class _KnownWebOmission {
  const _KnownWebOmission({
    required this.bookName,
    required this.chapterNumber,
    required this.verseNumber,
  });

  final String bookName;
  final int chapterNumber;
  final int verseNumber;
}

class _ParsedRangeLabel {
  const _ParsedRangeLabel({
    required this.bookName,
    required this.chapterNumber,
    required this.verseStart,
    required this.verseEnd,
  });

  final String bookName;
  final int chapterNumber;
  final int verseStart;
  final int verseEnd;
}

bool _shouldShowRangeLabel({
  required String heading,
  required String rangeLabel,
}) {
  final String normalizedHeading = _normalizeLabelForComparison(heading);
  final String normalizedRangeLabel = _normalizeLabelForComparison(rangeLabel);

  if (normalizedRangeLabel.isEmpty) {
    return false;
  }

  return normalizedHeading != normalizedRangeLabel;
}

String _normalizeLabelForComparison(String value) {
  return value
      .trim()
      .toLowerCase()
      .replaceAll('\u2013', '-')
      .replaceAll('\u2014', '-')
      .replaceAll(RegExp(r'\s+'), ' ');
}

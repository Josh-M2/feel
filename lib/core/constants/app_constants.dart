// D:\Github\feel\lib\core\constants\app_constants.dart
class BibleTranslationOption {
  const BibleTranslationOption({
    required this.code,
    required this.label,
    required this.description,
    required this.isPreferredForToday,
  });

  final String code;
  final String label;
  final String description;
  final bool isPreferredForToday;
}

class AppConstants {
  AppConstants._();

  static const String appName = 'Feel';

  static const List<String> v1Categories = <String>[
    'Guidance',
    'Hope',
    'Strength',
    'Peace Over Anxiety',
    'Comfort and Healing',
    'Faith in Doubt',
    'Obedience',
    'Forgiveness',
    'Purpose and Calling',
    'Love and Relationships',
    'Gratitude and Joy',
  ];

  static const List<BibleTranslationOption>
  supportedTranslations = <BibleTranslationOption>[
    BibleTranslationOption(
      code: 'kjv',
      label: 'KJV',
      description: 'King James Version fallback and seeded reading scaffold.',
      isPreferredForToday: true,
    ),
    BibleTranslationOption(
      code: 'web',
      label: 'WEB',
      description:
          'World English Bible for a lighter modern public-domain reading style.',
      isPreferredForToday: true,
    ),
  ];

  static const String defaultTranslationCode = 'kjv';

  static String sanitizeTranslationCode(String? raw) {
    final String normalized = (raw ?? '').trim().toLowerCase();
    for (final BibleTranslationOption option in supportedTranslations) {
      if (option.code == normalized) {
        return option.code;
      }
    }
    return defaultTranslationCode;
  }

  static BibleTranslationOption translationOptionFor(String? raw) {
    final String code = sanitizeTranslationCode(raw);
    return supportedTranslations.firstWhere(
      (BibleTranslationOption option) => option.code == code,
      orElse: () => supportedTranslations.first,
    );
  }
}

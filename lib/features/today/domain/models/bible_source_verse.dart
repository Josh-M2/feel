class BibleSourceVerse {
  const BibleSourceVerse({
    required this.reference,
    required this.text,
    required this.translationCode,
    required this.translationLabel,
  });

  final String reference;
  final String text;
  final String translationCode;
  final String translationLabel;
}

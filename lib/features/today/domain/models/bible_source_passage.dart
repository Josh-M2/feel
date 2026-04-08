class BibleSourcePassageVerse {
  const BibleSourcePassageVerse({
    required this.number,
    required this.text,
  });

  final int number;
  final String text;
}

class BibleSourcePassage {
  const BibleSourcePassage({
    required this.reference,
    required this.translationCode,
    required this.translationLabel,
    required this.verses,
  });

  final String reference;
  final String translationCode;
  final String translationLabel;
  final List<BibleSourcePassageVerse> verses;
}

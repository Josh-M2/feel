import '../models/bible_source_passage.dart';
import '../models/bible_source_verse.dart';

abstract class BibleSourceAdapter {
  Future<BibleSourceVerse?> fetchVerseByReference({
    required String reference,
    required String translationCode,
  });

  Future<BibleSourcePassage?> fetchPassageByReference({
    required String reference,
    required String translationCode,
  });
}

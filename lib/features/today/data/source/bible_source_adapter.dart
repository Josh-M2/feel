import '../../domain/models/bible_source_passage.dart';

abstract class BibleSourceAdapter {
  Future<BibleSourcePassage?> resolveReference({
    required String reference,
    String translationCode,
  });
}

import '../../domain/models/bible_source_passage.dart';
import '../../domain/models/bible_source_verse.dart';
import '../../domain/repositories/bible_source_adapter.dart';
import 'bible_api_com_source_adapter.dart';

class ConfigurableBibleSourceAdapter implements BibleSourceAdapter {
  ConfigurableBibleSourceAdapter()
      : _delegate = BibleApiComSourceAdapter(
          baseUrl: const String.fromEnvironment(
            'BIBLE_SOURCE_BASE_URL',
            defaultValue: 'https://bible-api.com',
          ),
        );

  final BibleSourceAdapter _delegate;

  @override
  Future<BibleSourceVerse?> fetchVerseByReference({
    required String reference,
    required String translationCode,
  }) {
    return _delegate.fetchVerseByReference(
      reference: reference,
      translationCode: translationCode,
    );
  }

  @override
  Future<BibleSourcePassage?> fetchPassageByReference({
    required String reference,
    required String translationCode,
  }) {
    return _delegate.fetchPassageByReference(
      reference: reference,
      translationCode: translationCode,
    );
  }
}

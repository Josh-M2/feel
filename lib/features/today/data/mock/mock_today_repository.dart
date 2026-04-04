import '../../domain/models/today_verse.dart';

class MockTodayRepository {
  const MockTodayRepository();

  TodayVerse getTodayVerse() {
    return const TodayVerse(
      dateLabel: 'Assigned for today',
      category: 'Peace Over Anxiety',
      reference: 'Philippians 4:6–7',
      translationLabel: 'KJV mock preview',
      verseText:
          'Be careful for nothing; but in every thing by prayer and supplication '
          'with thanksgiving let your requests be made known unto God. '
          'And the peace of God, which passeth all understanding, '
          'shall keep your hearts and minds through Christ Jesus.',
      reflectionPrompt:
          'What burden feels loud today, and what would it look like to bring it honestly before God instead of carrying it alone?',
      encouragementLine:
          'This verse speaks to anxious inner noise with prayer, thanksgiving, and the promise of guarded peace.',
      contextSummary:
          'Paul is writing from hardship, yet he points believers toward a steady posture: rejoice, pray honestly, stay thankful, and let God guard the inner life.',
      contextSections: <VerseContextSection>[
        VerseContextSection(
          title: 'What is happening around this verse',
          body:
              'Philippians 4 moves through practical Christian living: stand firm, live in unity, rejoice, pray, think on what is good, and keep practicing what is true.',
        ),
        VerseContextSection(
          title: 'Why the wording matters',
          body:
              'The verse does not deny that trouble exists. It redirects the response. Instead of panic leading the heart, prayer and thanksgiving lead the response to God.',
        ),
        VerseContextSection(
          title: 'What “keep your hearts and minds” suggests',
          body:
              'The picture is protective. God’s peace is described almost like a guard over the inner life, not because life becomes easy, but because His presence becomes steady.',
        ),
      ],
      relatedPassages: <RelatedPassagePreview>[
        RelatedPassagePreview(
          reference: 'Matthew 6:31–34',
          note:
              'Jesus teaches against anxious striving and turns attention toward trust in the Father.',
        ),
        RelatedPassagePreview(
          reference: '1 Peter 5:7',
          note:
              'A simple companion verse about casting cares on God because He cares for you.',
        ),
        RelatedPassagePreview(
          reference: 'Isaiah 26:3',
          note: 'A strong cross-reference on peace and a mind stayed on God.',
        ),
      ],
      keyInsights: <String>[
        'Prayer is the first movement, not the last resort.',
        'Thanksgiving changes the emotional posture of the moment.',
        'Peace is not framed as self-control alone, but as God’s guarding presence.',
      ],
      prayer:
          'Lord, I bring You what has been heavy in my mind. Teach me to pray instead of spiral, to thank You even while I wait, and to rest in the peace only You can give.',
    );
  }
}

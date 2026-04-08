import '../../domain/models/daily_reference_candidate.dart';
import '../../domain/models/today_verse.dart';

class CuratedTodayReferencePool {
  const CuratedTodayReferencePool();

  List<DailyReferenceCandidate> forCategories(List<String> categories) {
    final List<String> effective = categories.isEmpty ? _fallbackOrder : categories;
    final List<DailyReferenceCandidate> results = <DailyReferenceCandidate>[];
    for (final String category in effective) {
      final List<DailyReferenceCandidate> matches = _all
          .where((DailyReferenceCandidate item) => item.category == category)
          .toList(growable: false);
      if (matches.isNotEmpty) {
        results.addAll(matches);
      }
    }
    return results.isEmpty ? List<DailyReferenceCandidate>.from(_all) : results;
  }

  static const List<String> _fallbackOrder = <String>[
    'Guidance',
    'Hope',
    'Strength',
    'Peace Over Anxiety',
    'Comfort and Healing',
    'Faith in Doubt',
    'Forgiveness',
    'Purpose and Calling',
    'Love and Relationships',
    'Gratitude and Joy',
  ];

  static const List<DailyReferenceCandidate> _all = <DailyReferenceCandidate>[
    DailyReferenceCandidate(
      category: 'Guidance',
      reference: 'Proverbs 3:5-6',
      translationCode: 'kjv',
      translationLabel: 'KJV fallback',
      fallbackVerseText:
          'Trust in the Lord with all thine heart; and lean not unto thine own understanding. In all thy ways acknowledge him, and he shall direct thy paths.',
      reflectionPrompt:
          'Where are you leaning on your own understanding today instead of trusting God to direct your path?',
      encouragementLine:
          'Guidance often starts with trust before clarity fully arrives.',
      contextSummary:
          'Proverbs keeps pulling wisdom back to the fear of the Lord, humble trust, and practical dependence on God rather than self-confidence alone.',
      contextSections: <VerseContextSection>[
        VerseContextSection(
          title: 'Why this fits guidance',
          body:
              'The verse is less about instant answers and more about a posture of trust that keeps your direction anchored in God.',
        ),
      ],
      relatedPassages: <RelatedPassagePreview>[
        RelatedPassagePreview(
          reference: 'Psalm 32:8',
          note: 'God promises instruction and wise direction.',
        ),
      ],
      keyInsights: <String>[
        'Guidance begins with trust.',
        'Godly direction is not built on self-reliance alone.',
      ],
      prayer:
          'Lord, direct my steps and quiet the urge to depend only on my own understanding.',
    ),
    DailyReferenceCandidate(
      category: 'Hope',
      reference: 'Romans 15:13',
      translationCode: 'kjv',
      translationLabel: 'KJV fallback',
      fallbackVerseText:
          'Now the God of hope fill you with all joy and peace in believing, that ye may abound in hope, through the power of the Holy Ghost.',
      reflectionPrompt:
          'What would it look like to receive hope from God instead of trying to manufacture it alone?',
      encouragementLine:
          'Biblical hope is not thin optimism; it is sustained by God Himself.',
      contextSummary:
          'Paul closes a section on unity and encouragement by pointing believers toward the God of hope as the true source of inner steadiness.',
      contextSections: <VerseContextSection>[
        VerseContextSection(
          title: 'Hope has a source',
          body:
              'Hope is not framed as self-generated mood, but as something God fills into the believer.',
        ),
      ],
      relatedPassages: <RelatedPassagePreview>[
        RelatedPassagePreview(
          reference: 'Lamentations 3:22-23',
          note: 'Hope is often renewed in the middle of difficulty.',
        ),
      ],
      keyInsights: <String>[
        'Hope is rooted in God’s character.',
        'Believing and peace are tied to abounding hope.',
      ],
      prayer:
          'God of hope, fill me with joy and peace in believing today.',
    ),
    DailyReferenceCandidate(
      category: 'Strength',
      reference: 'Isaiah 40:31',
      translationCode: 'kjv',
      translationLabel: 'KJV fallback',
      fallbackVerseText:
          'But they that wait upon the Lord shall renew their strength; they shall mount up with wings as eagles; they shall run, and not be weary; and they shall walk, and not faint.',
      reflectionPrompt:
          'Where do you most need renewed strength instead of pressured self-performance?',
      encouragementLine:
          'God often renews strength in the waiting, not only after the waiting ends.',
      contextSummary:
          'Isaiah contrasts human weakness with the enduring strength of God, calling weary people to wait on Him instead of collapsing inwardly.',
      contextSections: <VerseContextSection>[
        VerseContextSection(
          title: 'Waiting and strength',
          body:
              'The verse joins patient dependence with renewed strength, not frantic striving.',
        ),
      ],
      relatedPassages: <RelatedPassagePreview>[
        RelatedPassagePreview(
          reference: '2 Corinthians 12:9',
          note: 'God’s strength is often most visible in human weakness.',
        ),
      ],
      keyInsights: <String>[
        'Strength can be renewed.',
        'Waiting on God is active dependence, not emptiness.',
      ],
      prayer:
          'Lord, renew my strength for what is in front of me today.',
    ),
    DailyReferenceCandidate(
      category: 'Peace Over Anxiety',
      reference: 'Philippians 4:6-7',
      translationCode: 'kjv',
      translationLabel: 'KJV fallback',
      fallbackVerseText:
          'Be careful for nothing; but in every thing by prayer and supplication with thanksgiving let your requests be made known unto God. And the peace of God, which passeth all understanding, shall keep your hearts and minds through Christ Jesus.',
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
              'The verse does not deny trouble. It redirects the response toward prayer and thanksgiving before God.',
        ),
      ],
      relatedPassages: <RelatedPassagePreview>[
        RelatedPassagePreview(
          reference: '1 Peter 5:7',
          note: 'A companion verse about casting cares on God.',
        ),
      ],
      keyInsights: <String>[
        'Prayer is the first movement, not the last resort.',
        'Thanksgiving changes the posture of the moment.',
      ],
      prayer:
          'Lord, teach me to pray instead of spiral, and guard my heart with Your peace.',
    ),
    DailyReferenceCandidate(
      category: 'Comfort and Healing',
      reference: 'Psalm 147:3',
      translationCode: 'kjv',
      translationLabel: 'KJV fallback',
      fallbackVerseText:
          'He healeth the broken in heart, and bindeth up their wounds.',
      reflectionPrompt:
          'What wounded place in your heart most needs to be brought before God with honesty today?',
      encouragementLine:
          'God’s comfort is tender enough for what still feels broken.',
      contextSummary:
          'The psalm praises God as both majestic and near, strong enough to rule creation and tender enough to bind human wounds.',
      contextSections: <VerseContextSection>[
        VerseContextSection(
          title: 'Healing is personal',
          body:
              'The verse describes God as attentive to broken hearts, not distant from them.',
        ),
      ],
      relatedPassages: <RelatedPassagePreview>[
        RelatedPassagePreview(
          reference: 'Matthew 11:28',
          note: 'Jesus invites the weary to come to Him for rest.',
        ),
      ],
      keyInsights: <String>[
        'God sees brokenness clearly.',
        'Comfort is not detached from God’s care.',
      ],
      prayer:
          'Lord, meet me gently in the places that still feel wounded.',
    ),
    DailyReferenceCandidate(
      category: 'Faith in Doubt',
      reference: 'Mark 9:24',
      translationCode: 'kjv',
      translationLabel: 'KJV fallback',
      fallbackVerseText:
          'And straightway the father of the child cried out, and said with tears, Lord, I believe; help thou mine unbelief.',
      reflectionPrompt:
          'Where do belief and doubt feel mixed together in you right now?',
      encouragementLine:
          'The verse makes room for honest faith that still needs help.',
      contextSummary:
          'A desperate father comes to Jesus with real need, and his cry reveals that faith can be sincere even when it is trembling.',
      contextSections: <VerseContextSection>[
        VerseContextSection(
          title: 'Doubt is spoken honestly',
          body:
              'The man does not hide his struggle. He speaks it directly to Jesus.',
        ),
      ],
      relatedPassages: <RelatedPassagePreview>[
        RelatedPassagePreview(
          reference: 'John 20:27-29',
          note: 'Jesus meets Thomas in his need for assurance.',
        ),
      ],
      keyInsights: <String>[
        'Faith can be honest about weakness.',
        'Jesus welcomes the cry for help.',
      ],
      prayer:
          'Lord, help my unbelief and hold me steady where my faith feels thin.',
    ),
    DailyReferenceCandidate(
      category: 'Forgiveness',
      reference: '1 John 1:9',
      translationCode: 'kjv',
      translationLabel: 'KJV fallback',
      fallbackVerseText:
          'If we confess our sins, he is faithful and just to forgive us our sins, and to cleanse us from all unrighteousness.',
      reflectionPrompt:
          'What would honest confession look like before God today?',
      encouragementLine:
          'Forgiveness rests on God’s faithfulness, not on perfect self-repair.',
      contextSummary:
          'John keeps the believer near the light by joining honesty about sin with confidence in God’s faithful cleansing.',
      contextSections: <VerseContextSection>[
        VerseContextSection(
          title: 'Confession and cleansing',
          body:
              'The verse links confession to God’s faithful forgiveness and cleansing, not to shame remaining in control.',
        ),
      ],
      relatedPassages: <RelatedPassagePreview>[
        RelatedPassagePreview(
          reference: 'Psalm 32:5',
          note: 'Confession is tied to the relief of forgiven sin.',
        ),
      ],
      keyInsights: <String>[
        'God is faithful in forgiveness.',
        'Confession opens the heart to cleansing grace.',
      ],
      prayer:
          'Lord, bring me into honest confession and let Your forgiveness restore me.',
    ),
    DailyReferenceCandidate(
      category: 'Purpose and Calling',
      reference: 'Ephesians 2:10',
      translationCode: 'kjv',
      translationLabel: 'KJV fallback',
      fallbackVerseText:
          'For we are his workmanship, created in Christ Jesus unto good works, which God hath before ordained that we should walk in them.',
      reflectionPrompt:
          'Where might God be inviting you to walk faithfully in the good works He has prepared?',
      encouragementLine:
          'Purpose is received first as identity before it becomes activity.',
      contextSummary:
          'Paul roots calling in grace and new creation, showing that a believer’s purpose grows out of what God has already done in Christ.',
      contextSections: <VerseContextSection>[
        VerseContextSection(
          title: 'Workmanship before achievement',
          body:
              'The verse starts with what God has made the believer to be before focusing on what the believer does.',
        ),
      ],
      relatedPassages: <RelatedPassagePreview>[
        RelatedPassagePreview(
          reference: 'Colossians 3:23',
          note: 'Daily work can be lived before God with purpose.',
        ),
      ],
      keyInsights: <String>[
        'Purpose grows out of identity in Christ.',
        'God prepares faithful work ahead of us.',
      ],
      prayer:
          'Lord, help me walk faithfully in the work You have prepared for me.',
    ),
    DailyReferenceCandidate(
      category: 'Love and Relationships',
      reference: '1 Corinthians 13:4-5',
      translationCode: 'kjv',
      translationLabel: 'KJV fallback',
      fallbackVerseText:
          'Charity suffereth long, and is kind; charity envieth not; charity vaunteth not itself, is not puffed up, Doth not behave itself unseemly, seeketh not her own, is not easily provoked, thinketh no evil.',
      reflectionPrompt:
          'Which expression of love feels most needed in your relationships today?',
      encouragementLine:
          'Biblical love is patient and others-facing, not self-centered.',
      contextSummary:
          'Paul describes love as the more excellent way, shaping how believers treat one another even when gifts and knowledge are present.',
      contextSections: <VerseContextSection>[
        VerseContextSection(
          title: 'Love is relational practice',
          body:
              'The verse makes love visible in patient, humble, and kind behavior.',
        ),
      ],
      relatedPassages: <RelatedPassagePreview>[
        RelatedPassagePreview(
          reference: 'Ephesians 4:2',
          note: 'Humility and patience strengthen relationships.',
        ),
      ],
      keyInsights: <String>[
        'Love is patient and kind.',
        'Love resists pride and self-seeking.',
      ],
      prayer:
          'Lord, teach me to love with patience, humility, and kindness today.',
    ),
    DailyReferenceCandidate(
      category: 'Gratitude and Joy',
      reference: 'Psalm 118:24',
      translationCode: 'kjv',
      translationLabel: 'KJV fallback',
      fallbackVerseText:
          'This is the day which the Lord hath made; we will rejoice and be glad in it.',
      reflectionPrompt:
          'What small sign of God’s goodness can you notice and thank Him for today?',
      encouragementLine:
          'Joy can begin with receiving the day as God’s gift.',
      contextSummary:
          'The psalm celebrates God’s enduring mercy and invites rejoicing rooted in His saving faithfulness.',
      contextSections: <VerseContextSection>[
        VerseContextSection(
          title: 'Joy receives the day',
          body:
              'The verse calls for rejoicing as an act of faith in the God who made the day.',
        ),
      ],
      relatedPassages: <RelatedPassagePreview>[
        RelatedPassagePreview(
          reference: '1 Thessalonians 5:18',
          note: 'Gratitude remains part of faithful living in every season.',
        ),
      ],
      keyInsights: <String>[
        'Joy can begin with gratitude.',
        'The day itself can be received as God’s gift.',
      ],
      prayer:
          'Lord, teach my heart to rejoice in the day You have made.',
    ),
  ];
}

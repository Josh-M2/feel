import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/constants/app_constants.dart';
import '../../domain/models/daily_verse_pool_entry.dart';
import '../../domain/models/today_verse.dart';
import '../../domain/repositories/today_repository.dart';
import '../local/shared_prefs_today_assignment_local_store.dart';
import '../local/today_assignment_local_snapshot.dart';
import '../local/today_assignment_local_store.dart';

class SupabaseTodayRepository implements TodayRepository {
  SupabaseTodayRepository({
    SupabaseClient? client,
    TodayAssignmentLocalStore? localStore,
  }) : _client = _resolveClient(client),
       _localStore = localStore ?? SharedPrefsTodayAssignmentLocalStore();

  final SupabaseClient? _client;
  final TodayAssignmentLocalStore _localStore;

  static const List<DailyVersePoolEntry> _fallbackPool = <DailyVersePoolEntry>[
    DailyVersePoolEntry(
      id: 'guidance-proverbs-3-5-6',
      category: 'Guidance',
      reference: 'Proverbs 3:5-6',
      translationCode: 'kjv',
      verseTextFallback:
          'Trust in the Lord with all thine heart; and lean not unto thine own understanding. In all thy ways acknowledge him, and he shall direct thy paths.',
      reflectionPrompt:
          'Where are you most tempted to rely only on your own understanding today?',
      encouragementLine:
          'Guidance starts with trust before clarity. This verse invites surrender before direction.',
      contextSummary:
          'Proverbs frames wisdom as more than intelligence. It is a posture of reverence, trust, and daily surrender before God.',
      contextSections: <VerseContextSection>[
        VerseContextSection(
          title: 'Wisdom begins with trust',
          body:
              'This passage does not glorify self-sufficiency. It teaches a heart posture that starts with trusting God deeply.',
        ),
        VerseContextSection(
          title: 'Acknowledging God in all ways',
          body:
              'The promise of direction is tied to bringing everyday choices under God’s leadership.',
        ),
      ],
      relatedPassages: <RelatedPassagePreview>[
        RelatedPassagePreview(
          reference: 'Psalm 32:8',
          note: 'A companion promise about God instructing and guiding.',
        ),
      ],
      keyInsights: <String>[
        'Trust is the doorway to wisdom.',
        'Guidance grows where surrender grows.',
      ],
      prayer:
          'Lord, teach me to trust You more than my own instincts and to bring every decision under Your care.',
      sortOrder: 10,
    ),
    DailyVersePoolEntry(
      id: 'hope-jeremiah-29-11',
      category: 'Hope',
      reference: 'Jeremiah 29:11',
      translationCode: 'kjv',
      verseTextFallback:
          'For I know the thoughts that I think toward you, saith the Lord, thoughts of peace, and not of evil, to give you an expected end.',
      reflectionPrompt:
          'What part of your future feels uncertain enough that you need to hand it back to God?',
      encouragementLine:
          'Hope in scripture is not vague optimism. It is confidence that God has not forgotten His people.',
      contextSummary:
          'Jeremiah speaks to people in exile. God’s promise of future hope meets people living inside delay and uncertainty.',
      contextSections: <VerseContextSection>[
        VerseContextSection(
          title: 'Hope inside exile',
          body:
              'This promise was given while life still felt unsettled, reminding believers that waiting is not abandonment.',
        ),
      ],
      relatedPassages: <RelatedPassagePreview>[
        RelatedPassagePreview(
          reference: 'Romans 15:13',
          note: 'A New Testament prayer for hope through the Spirit.',
        ),
      ],
      keyInsights: <String>[
        'God’s hope can meet you before circumstances change.',
      ],
      prayer:
          'Lord, hold my future with more steadiness than my fears and teach me to hope in Your faithfulness.',
      sortOrder: 20,
    ),
    DailyVersePoolEntry(
      id: 'strength-isaiah-40-31',
      category: 'Strength',
      reference: 'Isaiah 40:31',
      translationCode: 'kjv',
      verseTextFallback:
          'But they that wait upon the Lord shall renew their strength; they shall mount up with wings as eagles; they shall run, and not be weary; and they shall walk, and not faint.',
      reflectionPrompt:
          'Where do you need renewed strength instead of forcing yourself through exhaustion?',
      encouragementLine:
          'This promise honors waiting on God as a place where strength is renewed, not wasted.',
      contextSummary:
          'Isaiah contrasts human frailty with God’s enduring power and invites weary people to hope in Him.',
      contextSections: <VerseContextSection>[
        VerseContextSection(
          title: 'Waiting is not passive defeat',
          body:
              'The passage frames waiting on the Lord as a posture of expectant trust that renews the inner life.',
        ),
      ],
      relatedPassages: <RelatedPassagePreview>[
        RelatedPassagePreview(
          reference: '2 Corinthians 12:9',
          note: 'God’s strength showing up in weakness.',
        ),
      ],
      keyInsights: <String>['God renews the weary, not just the strong.'],
      prayer:
          'Lord, renew what feels tired in me and teach me to wait for Your strength instead of pretending I have enough on my own.',
      sortOrder: 30,
    ),
    DailyVersePoolEntry(
      id: 'peace-philippians-4-6-7',
      category: 'Peace Over Anxiety',
      reference: 'Philippians 4:6-7',
      translationCode: 'kjv',
      verseTextFallback:
          'Be careful for nothing; but in every thing by prayer and supplication with thanksgiving let your requests be made known unto God. And the peace of God, which passeth all understanding, shall keep your hearts and minds through Christ Jesus.',
      reflectionPrompt:
          'What burden feels loud today, and what would it look like to bring it honestly before God instead of carrying it alone?',
      encouragementLine:
          'This verse speaks to anxious inner noise with prayer, thanksgiving, and the promise of guarded peace.',
      contextSummary:
          'Paul writes from hardship yet directs believers toward prayer, thanksgiving, and steady peace in Christ.',
      contextSections: <VerseContextSection>[
        VerseContextSection(
          title: 'Prayer over panic',
          body:
              'The verse does not deny trouble. It redirects the response from spiraling anxiety to honest prayer.',
        ),
      ],
      relatedPassages: <RelatedPassagePreview>[
        RelatedPassagePreview(
          reference: '1 Peter 5:7',
          note: 'Casting cares on God because He cares for you.',
        ),
      ],
      keyInsights: <String>[
        'Prayer is the first movement, not the last resort.',
        'Peace is pictured as God’s guarding presence.',
      ],
      prayer:
          'Lord, I bring You what has been heavy in my mind. Teach me to pray instead of spiral and rest in Your peace.',
      sortOrder: 40,
    ),
    DailyVersePoolEntry(
      id: 'comfort-psalm-34-18',
      category: 'Comfort and Healing',
      reference: 'Psalm 34:18',
      translationCode: 'kjv',
      verseTextFallback:
          'The Lord is nigh unto them that are of a broken heart; and saveth such as be of a contrite spirit.',
      reflectionPrompt:
          'Where do you most need God’s nearness in your pain right now?',
      encouragementLine:
          'God’s comfort is not distant. Scripture describes Him as near to the brokenhearted.',
      contextSummary:
          'Psalm 34 holds together distress, deliverance, and the nearness of God to those who are hurting.',
      contextSections: <VerseContextSection>[
        VerseContextSection(
          title: 'Nearness in brokenness',
          body:
              'The psalm does not minimize pain. It highlights God’s nearness inside it.',
        ),
      ],
      relatedPassages: <RelatedPassagePreview>[
        RelatedPassagePreview(
          reference: 'Matthew 11:28',
          note: 'Jesus inviting the weary to come to Him.',
        ),
      ],
      keyInsights: <String>['God’s nearness meets honest sorrow.'],
      prayer:
          'Lord, meet me in the places that feel tender and broken, and let Your nearness become more real than my fear.',
      sortOrder: 50,
    ),
    DailyVersePoolEntry(
      id: 'faith-mark-9-24',
      category: 'Faith in Doubt',
      reference: 'Mark 9:24',
      translationCode: 'kjv',
      verseTextFallback: 'Lord, I believe; help thou mine unbelief.',
      reflectionPrompt:
          'What doubt do you need to bring to Jesus honestly instead of hiding it?',
      encouragementLine:
          'This verse gives language for imperfect faith and honest dependence at the same time.',
      contextSummary:
          'A desperate father speaks with raw honesty, showing that faith and struggle can exist together before Jesus.',
      contextSections: <VerseContextSection>[
        VerseContextSection(
          title: 'Honest faith',
          body:
              'Scripture allows room for faith that asks for help in the middle of weakness.',
        ),
      ],
      relatedPassages: <RelatedPassagePreview>[
        RelatedPassagePreview(
          reference: 'Psalm 73:26',
          note: 'God as strength when the heart fails.',
        ),
      ],
      keyInsights: <String>['Doubt does not have to be hidden from God.'],
      prayer:
          'Lord, meet the places where my faith feels weak and teach me to bring my doubts to You honestly.',
      sortOrder: 60,
    ),

    DailyVersePoolEntry(
      id: 'obedience-james-1-22',
      category: 'Obedience',
      reference: 'James 1:22',
      translationCode: 'kjv',
      verseTextFallback:
          'But be ye doers of the word, and not hearers only, deceiving your own selves.',
      reflectionPrompt:
          'What truth from God do you need to practice today instead of only agreeing with in theory?',
      encouragementLine:
          'Obedience gives direction a real shape. Scripture invites response, not only reflection.',
      contextSummary:
          'James keeps bringing faith into everyday action. This verse warns against hearing truth without letting it change the way we live.',
      contextSections: <VerseContextSection>[
        VerseContextSection(
          title: 'Truth that moves into action',
          body:
              'The call is not toward performance for approval, but toward a faith that responds honestly to what God has said.',
        ),
      ],
      relatedPassages: <RelatedPassagePreview>[
        RelatedPassagePreview(
          reference: 'John 14:15',
          note: 'Jesus connecting love for Him with willing obedience.',
        ),
      ],
      keyInsights: <String>[
        'Obedience is lived trust, not just stated belief.',
      ],
      prayer:
          'Lord, help me respond to Your word with willing action and not settle for agreement without obedience.',
      sortOrder: 65,
    ),
    DailyVersePoolEntry(
      id: 'forgiveness-1-john-1-9',
      category: 'Forgiveness',
      reference: '1 John 1:9',
      translationCode: 'kjv',
      verseTextFallback:
          'If we confess our sins, he is faithful and just to forgive us our sins, and to cleanse us from all unrighteousness.',
      reflectionPrompt:
          'What would honest confession and fresh surrender look like today?',
      encouragementLine:
          'Forgiveness in Christ is grounded in God’s faithfulness, not our ability to clean ourselves up first.',
      contextSummary:
          'John calls believers to walk in the light honestly, trusting God’s faithfulness when sin is confessed.',
      contextSections: <VerseContextSection>[
        VerseContextSection(
          title: 'Confession and cleansing',
          body:
              'The verse joins honesty about sin with confidence in God’s forgiveness.',
        ),
      ],
      relatedPassages: <RelatedPassagePreview>[
        RelatedPassagePreview(
          reference: 'Psalm 103:12',
          note: 'A vivid picture of how far God removes transgressions.',
        ),
      ],
      keyInsights: <String>['Forgiveness rests on God’s faithfulness.'],
      prayer:
          'Lord, give me courage to confess honestly and rest in the cleansing You freely give.',
      sortOrder: 70,
    ),
    DailyVersePoolEntry(
      id: 'purpose-ephesians-2-10',
      category: 'Purpose and Calling',
      reference: 'Ephesians 2:10',
      translationCode: 'kjv',
      verseTextFallback:
          'For we are his workmanship, created in Christ Jesus unto good works, which God hath before ordained that we should walk in them.',
      reflectionPrompt:
          'Where might God be inviting you to walk faithfully in what He has prepared for you?',
      encouragementLine:
          'Purpose begins with belonging to God before it becomes activity for God.',
      contextSummary:
          'Ephesians roots calling in grace. Good works flow from identity formed in Christ, not self-made worth.',
      contextSections: <VerseContextSection>[
        VerseContextSection(
          title: 'Purpose after grace',
          body:
              'The verse places calling after salvation by grace, not before it.',
        ),
      ],
      relatedPassages: <RelatedPassagePreview>[
        RelatedPassagePreview(
          reference: 'Colossians 3:17',
          note: 'Living every action under the name of Jesus.',
        ),
      ],
      keyInsights: <String>['Calling grows from identity in Christ.'],
      prayer:
          'Lord, help me walk in the good works You have prepared and remember that my purpose starts with belonging to You.',
      sortOrder: 80,
    ),
    DailyVersePoolEntry(
      id: 'love-1-corinthians-13-4-7',
      category: 'Love and Relationships',
      reference: '1 Corinthians 13:4-7',
      translationCode: 'kjv',
      verseTextFallback:
          'Charity suffereth long, and is kind; charity envieth not; charity vaunteth not itself, is not puffed up... beareth all things, believeth all things, hopeth all things, endureth all things.',
      reflectionPrompt:
          'What part of love do you most need God to grow in you today?',
      encouragementLine:
          'Biblical love is patient, humble, and steady. It is formed by grace, not mere emotion.',
      contextSummary:
          'Paul describes love as the essential shape of mature Christian life and relationships.',
      contextSections: <VerseContextSection>[
        VerseContextSection(
          title: 'Love with substance',
          body:
              'The passage names real traits that love practices in ordinary relationships.',
        ),
      ],
      relatedPassages: <RelatedPassagePreview>[
        RelatedPassagePreview(
          reference: 'John 13:34-35',
          note: 'Jesus commanding His people to love one another.',
        ),
      ],
      keyInsights: <String>['Love is patient before it is impressive.'],
      prayer:
          'Lord, shape the way I love others so it reflects Your patience, humility, and steadfastness.',
      sortOrder: 90,
    ),
    DailyVersePoolEntry(
      id: 'joy-1-thessalonians-5-16-18',
      category: 'Gratitude and Joy',
      reference: '1 Thessalonians 5:16-18',
      translationCode: 'kjv',
      verseTextFallback:
          'Rejoice evermore. Pray without ceasing. In every thing give thanks: for this is the will of God in Christ Jesus concerning you.',
      reflectionPrompt:
          'What small act of gratitude can help reframe your day before God?',
      encouragementLine:
          'Joy and gratitude are practiced rhythms, not just reactions to easy circumstances.',
      contextSummary:
          'Paul’s brief commands encourage a steady posture of joy, prayer, and thanksgiving in everyday life.',
      contextSections: <VerseContextSection>[
        VerseContextSection(
          title: 'A daily posture',
          body:
              'These commands shape how believers carry ordinary days before God.',
        ),
      ],
      relatedPassages: <RelatedPassagePreview>[
        RelatedPassagePreview(
          reference: 'Psalm 118:24',
          note: 'Rejoicing in the day the Lord has made.',
        ),
      ],
      keyInsights: <String>[
        'Gratitude can steady the heart before the day changes.',
      ],
      prayer:
          'Lord, teach me to rejoice, pray, and give thanks with sincerity in the middle of ordinary life.',
      sortOrder: 100,
    ),
  ];

  static SupabaseClient? _resolveClient(SupabaseClient? client) {
    if (client != null) return client;
    try {
      return Supabase.instance.client;
    } catch (_) {
      return null;
    }
  }

  bool get _isConfigured => _client != null;
  String? get _authenticatedUserId => _client?.auth.currentUser?.id;

  @override
  Future<TodayVerse> getTodayVerse({
    required List<String> selectedCategories,
    required TimeOfDay dailyRefreshTime,
    required String preferredTranslationCode,
  }) async {
    final List<String> effectiveCategories = _sanitizeCategories(
      selectedCategories,
    );
    final String effectiveTranslationCode =
        AppConstants.sanitizeTranslationCode(preferredTranslationCode);
    final DateTime effectiveDate = _resolveEffectiveDate(dailyRefreshTime);
    final String dateKey = _toDateKey(effectiveDate);
    final TodayAssignmentLocalSnapshot localSnapshot = await _localStore.load();
    final String? userId = _authenticatedUserId;

    if (_isConfigured && userId != null) {
      final TodayAssignmentLocalRecord? remoteRecord =
          await _fetchRemoteAssignment(userId: userId, dateKey: dateKey);
      if (remoteRecord != null) {
        final TodayAssignmentLocalRecord translatedRemoteRecord =
            await _ensurePreferredTranslation(
              record: remoteRecord,
              preferredTranslationCode: effectiveTranslationCode,
            );
        await _localStore.save(localSnapshot.upsert(translatedRemoteRecord));
        if (_didRecordChange(remoteRecord, translatedRemoteRecord)) {
          await _persistRemoteAssignment(
            userId: userId,
            record: translatedRemoteRecord,
          );
        }
        return translatedRemoteRecord.toTodayVerse();
      }
    }

    final TodayAssignmentLocalRecord? cached = localSnapshot.findByDateKey(
      dateKey,
    );
    if (cached != null) {
      final TodayAssignmentLocalRecord translatedCachedRecord =
          await _ensurePreferredTranslation(
            record: cached,
            preferredTranslationCode: effectiveTranslationCode,
          );
      if (_didRecordChange(cached, translatedCachedRecord)) {
        await _localStore.save(localSnapshot.upsert(translatedCachedRecord));
      }
      if (_isConfigured && userId != null) {
        await _persistRemoteAssignment(
          userId: userId,
          record: translatedCachedRecord,
        );
      }
      return translatedCachedRecord.toTodayVerse();
    }

    final List<DailyVersePoolEntry> pool = await _loadPool();
    final List<String> recentReferences = await _loadRecentReferences(
      localSnapshot: localSnapshot,
      userId: userId,
    );
    final DailyVersePoolEntry entry = _choosePoolEntry(
      pool: pool,
      selectedCategories: effectiveCategories,
      dateKey: dateKey,
      recentReferences: recentReferences,
    );
    final _ResolvedVerseSnapshot? resolvedVerse =
        await _resolveScriptureFromSupabase(
          reference: entry.reference,
          preferredTranslationCode: effectiveTranslationCode,
        );

    final TodayAssignmentLocalRecord record = TodayAssignmentLocalRecord(
      dateKey: dateKey,
      category: entry.category,
      reference: resolvedVerse?.reference ?? entry.reference,
      translationCode: resolvedVerse?.translationCode ?? entry.translationCode,
      translationLabel:
          resolvedVerse?.translationLabel ??
          _fallbackTranslationLabel(
            requestedTranslationCode: effectiveTranslationCode,
            fallbackTranslationCode: entry.translationCode,
          ),
      verseText: resolvedVerse?.verseText ?? entry.verseTextFallback,
      reflectionPrompt: entry.reflectionPrompt,
      encouragementLine: entry.encouragementLine,
      contextSummary: entry.contextSummary,
      contextSections: entry.contextSections,
      relatedPassages: entry.relatedPassages,
      keyInsights: entry.keyInsights,
      prayer: entry.prayer,
      assignedAtIso: DateTime.now().toUtc().toIso8601String(),
    );

    await _localStore.save(localSnapshot.upsert(record));
    if (_isConfigured && userId != null) {
      await _persistRemoteAssignment(userId: userId, record: record);
    }
    return record.toTodayVerse();
  }

  @override
  Future<void> markTodayOpened({
    required List<String> selectedCategories,
    required TimeOfDay dailyRefreshTime,
    required String preferredTranslationCode,
  }) async {
    final TodayVerse _ = await getTodayVerse(
      selectedCategories: selectedCategories,
      dailyRefreshTime: dailyRefreshTime,
      preferredTranslationCode: preferredTranslationCode,
    );
    final String dateKey = _toDateKey(_resolveEffectiveDate(dailyRefreshTime));
    final TodayAssignmentLocalSnapshot snapshot = await _localStore.load();
    final TodayAssignmentLocalRecord? record = snapshot.findByDateKey(dateKey);
    if (record == null) return;

    final TodayAssignmentLocalRecord openedRecord = record.copyWith(
      openedAtIso: DateTime.now().toUtc().toIso8601String(),
    );
    await _localStore.save(snapshot.upsert(openedRecord));

    final String? userId = _authenticatedUserId;
    if (_isConfigured && userId != null) {
      await _persistRemoteAssignment(userId: userId, record: openedRecord);
    }
  }

  @override
  Future<void> syncTodayAssignment({
    required List<String> selectedCategories,
    required TimeOfDay dailyRefreshTime,
    required String preferredTranslationCode,
  }) async {
    await getTodayVerse(
      selectedCategories: selectedCategories,
      dailyRefreshTime: dailyRefreshTime,
      preferredTranslationCode: preferredTranslationCode,
    );

    final String? userId = _authenticatedUserId;
    if (!_isConfigured || userId == null) {
      return;
    }

    final String dateKey = _toDateKey(_resolveEffectiveDate(dailyRefreshTime));
    final TodayAssignmentLocalSnapshot snapshot = await _localStore.load();
    final TodayAssignmentLocalRecord? localRecord = snapshot.findByDateKey(
      dateKey,
    );
    if (localRecord != null) {
      await _persistRemoteAssignment(userId: userId, record: localRecord);
      return;
    }

    final TodayAssignmentLocalRecord? remoteRecord =
        await _fetchRemoteAssignment(userId: userId, dateKey: dateKey);
    if (remoteRecord != null) {
      await _localStore.save(snapshot.upsert(remoteRecord));
    }
  }

  Future<TodayAssignmentLocalRecord> _ensurePreferredTranslation({
    required TodayAssignmentLocalRecord record,
    required String preferredTranslationCode,
  }) async {
    final _ResolvedVerseSnapshot? resolvedVerse =
        await _resolveScriptureFromSupabase(
          reference: record.reference,
          preferredTranslationCode: preferredTranslationCode,
        );
    if (resolvedVerse == null) {
      return record;
    }

    return TodayAssignmentLocalRecord(
      dateKey: record.dateKey,
      category: record.category,
      reference: resolvedVerse.reference,
      translationCode: resolvedVerse.translationCode,
      translationLabel: resolvedVerse.translationLabel,
      verseText: resolvedVerse.verseText,
      reflectionPrompt: record.reflectionPrompt,
      encouragementLine: record.encouragementLine,
      contextSummary: record.contextSummary,
      contextSections: record.contextSections,
      relatedPassages: record.relatedPassages,
      keyInsights: record.keyInsights,
      prayer: record.prayer,
      assignedAtIso: record.assignedAtIso,
      openedAtIso: record.openedAtIso,
    );
  }

  String _fallbackTranslationLabel({
    required String requestedTranslationCode,
    required String fallbackTranslationCode,
  }) {
    if (requestedTranslationCode == fallbackTranslationCode) {
      return '${fallbackTranslationCode.toUpperCase()} fallback snapshot';
    }

    return '${requestedTranslationCode.toUpperCase()} requested - ${fallbackTranslationCode.toUpperCase()} fallback snapshot';
  }

  Future<_ResolvedVerseSnapshot?> _resolveScriptureFromSupabase({
    required String reference,
    required String preferredTranslationCode,
  }) async {
    if (!_isConfigured) {
      return null;
    }

    final _ReferenceParts? referenceParts = _parseReference(reference);
    if (referenceParts == null) {
      return null;
    }

    final String? bookId = await _resolveBookId(referenceParts.bookLabel);
    if (bookId == null) {
      return null;
    }

    final String requestedTranslationCode =
        AppConstants.sanitizeTranslationCode(preferredTranslationCode);
    List<Map<String, dynamic>> verseRows = await _loadPassageVerseRows(
      bookId: bookId,
      chapterNumber: referenceParts.chapterNumber,
      versionCode: requestedTranslationCode,
      verseStart: referenceParts.verseStart,
      verseEnd: referenceParts.verseEnd,
    );

    String appliedTranslationCode = requestedTranslationCode;
    if (verseRows.isEmpty && requestedTranslationCode != 'kjv') {
      verseRows = await _loadPassageVerseRows(
        bookId: bookId,
        chapterNumber: referenceParts.chapterNumber,
        versionCode: 'kjv',
        verseStart: referenceParts.verseStart,
        verseEnd: referenceParts.verseEnd,
      );
      appliedTranslationCode = 'kjv';
    }

    if (verseRows.isEmpty) {
      return null;
    }

    final String translationLabel =
        appliedTranslationCode == requestedTranslationCode
        ? AppConstants.translationOptionFor(appliedTranslationCode).label
        : '${AppConstants.translationOptionFor(requestedTranslationCode).label} requested - KJV fallback';

    return _ResolvedVerseSnapshot(
      reference: reference,
      translationCode: appliedTranslationCode,
      translationLabel: translationLabel,
      verseText: verseRows
          .map(
            (Map<String, dynamic> row) => row['verse_text']?.toString() ?? '',
          )
          .where((String text) => text.trim().isNotEmpty)
          .join(' '),
    );
  }

  _ReferenceParts? _parseReference(String reference) {
    final RegExp matchExp = RegExp(r'^(.+?)\s+(\d+):(\d+)(?:-(\d+))?$');
    final RegExpMatch? match = matchExp.firstMatch(reference.trim());
    if (match == null) {
      return null;
    }

    final int? chapterNumber = int.tryParse(match.group(2)!);
    final int? verseStart = int.tryParse(match.group(3)!);
    final int? verseEnd = int.tryParse(match.group(4) ?? match.group(3)!);
    if (chapterNumber == null || verseStart == null || verseEnd == null) {
      return null;
    }

    return _ReferenceParts(
      bookLabel: match.group(1)!.trim(),
      chapterNumber: chapterNumber,
      verseStart: verseStart,
      verseEnd: verseEnd,
    );
  }

  Future<String?> _resolveBookId(String bookLabel) async {
    final String normalizedLabel = _normalizeBookLabel(bookLabel);
    if (normalizedLabel.isEmpty) {
      return null;
    }

    try {
      final List<dynamic> bookRows = await _client!
          .from('content_bible_books')
          .select('id, name, short_name')
          .eq('is_active', true)
          .order('sort_order', ascending: true);
      final List<dynamic> aliasRows = await _client!
          .from('content_book_aliases')
          .select('book_id, alias');

      final Map<String, Set<String>> candidatesByBookId =
          <String, Set<String>>{};

      for (final dynamic item in bookRows) {
        final Map<String, dynamic> row = Map<String, dynamic>.from(item as Map);
        final String id = row['id']?.toString() ?? '';
        if (id.isEmpty) continue;
        candidatesByBookId[id] = <String>{
          _normalizeBookLabel(id),
          _normalizeBookLabel(row['name']?.toString() ?? ''),
          _normalizeBookLabel(row['short_name']?.toString() ?? ''),
        }..removeWhere((String value) => value.isEmpty);
      }

      for (final dynamic item in aliasRows) {
        final Map<String, dynamic> row = Map<String, dynamic>.from(item as Map);
        final String id = row['book_id']?.toString() ?? '';
        final String alias = _normalizeBookLabel(
          row['alias']?.toString() ?? '',
        );
        if (id.isEmpty || alias.isEmpty) continue;
        candidatesByBookId.putIfAbsent(id, () => <String>{}).add(alias);
      }

      for (final MapEntry<String, Set<String>> entry
          in candidatesByBookId.entries) {
        if (entry.value.contains(normalizedLabel)) {
          return entry.key;
        }
      }
    } catch (_) {
      return null;
    }

    return null;
  }

  Future<List<Map<String, dynamic>>> _loadPassageVerseRows({
    required String bookId,
    required int chapterNumber,
    required String versionCode,
    required int verseStart,
    required int verseEnd,
  }) async {
    try {
      final List<dynamic> rows = await _client!
          .from('content_bible_verses')
          .select('verse_number, verse_text')
          .eq('book_id', bookId)
          .eq('chapter_number', chapterNumber)
          .eq('version_id', versionCode)
          .gte('verse_number', verseStart)
          .lte('verse_number', verseEnd)
          .order('verse_number', ascending: true);
      return rows
          .map((dynamic item) => Map<String, dynamic>.from(item as Map))
          .toList(growable: false);
    } catch (_) {
      return const <Map<String, dynamic>>[];
    }
  }

  String _normalizeBookLabel(String value) {
    return value.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '');
  }

  bool _didRecordChange(
    TodayAssignmentLocalRecord original,
    TodayAssignmentLocalRecord next,
  ) {
    return original.reference != next.reference ||
        original.translationCode != next.translationCode ||
        original.translationLabel != next.translationLabel ||
        original.verseText != next.verseText;
  }

  Future<TodayAssignmentLocalRecord?> _fetchRemoteAssignment({
    required String userId,
    required String dateKey,
  }) async {
    try {
      final List<dynamic> rows = await _client!
          .from('user_daily_assignments')
          .select(
            'local_date, category_label, reference_label, translation_code, translation_label, verse_text_snapshot, reflection_prompt, encouragement_line, context_summary, prayer, details_json, assigned_at, opened_at',
          )
          .eq('user_id', userId)
          .eq('local_date', dateKey)
          .order('assigned_at', ascending: false)
          .limit(1);
      if (rows.isEmpty) return null;
      return _recordFromRemoteRow(Map<String, dynamic>.from(rows.first as Map));
    } catch (_) {
      return null;
    }
  }

  Future<void> _persistRemoteAssignment({
    required String userId,
    required TodayAssignmentLocalRecord record,
  }) async {
    if (!_isConfigured) return;
    try {
      await _client!.from('user_daily_assignments').upsert(<String, dynamic>{
        'user_id': userId,
        'local_date': record.dateKey,
        'timezone_name': DateTime.now().timeZoneName,
        'category_label': record.category,
        'reference_label': record.reference,
        'translation_code': record.translationCode,
        'translation_label': record.translationLabel,
        'verse_text_snapshot': record.verseText,
        'reflection_prompt': record.reflectionPrompt,
        'encouragement_line': record.encouragementLine,
        'context_summary': record.contextSummary,
        'prayer': record.prayer,
        'details_json': <String, dynamic>{
          'context_sections': record.contextSections
              .map((VerseContextSection item) => item.toJson())
              .toList(growable: false),
          'related_passages': record.relatedPassages
              .map((RelatedPassagePreview item) => item.toJson())
              .toList(growable: false),
          'key_insights': record.keyInsights,
        },
        'assigned_at': record.assignedAtIso,
        'opened_at': record.openedAtIso,
      }, onConflict: 'user_id,local_date');
    } catch (_) {}
  }

  Future<List<DailyVersePoolEntry>> _loadPool() async {
    if (!_isConfigured) return _fallbackPool;
    try {
      final List<dynamic> rows = await _client!
          .from('content_daily_verse_pool')
          .select(
            'id, category_label, reference_label, translation_code, verse_text_fallback, reflection_prompt, encouragement_line, context_summary, context_sections, related_passages, key_insights, prayer, sort_order',
          )
          .eq('is_active', true)
          .order('sort_order', ascending: true);
      if (rows.isEmpty) return _fallbackPool;
      return rows
          .map(
            (dynamic item) => DailyVersePoolEntry.fromSupabaseRow(
              Map<String, dynamic>.from(item as Map),
            ),
          )
          .toList(growable: false);
    } catch (_) {
      return _fallbackPool;
    }
  }

  Future<List<String>> _loadRecentReferences({
    required TodayAssignmentLocalSnapshot localSnapshot,
    required String? userId,
  }) async {
    final Set<String> references = localSnapshot
        .recentReferences(limit: 7)
        .toSet();
    if (!_isConfigured || userId == null) {
      return references.toList(growable: false);
    }

    try {
      final DateTime start = DateTime.now().subtract(const Duration(days: 14));
      final List<dynamic> rows = await _client!
          .from('user_daily_assignments')
          .select('reference_label')
          .eq('user_id', userId)
          .gte('local_date', _toDateKey(start))
          .order('local_date', ascending: false)
          .limit(7);
      for (final dynamic item in rows) {
        final String reference = item['reference_label']?.toString() ?? '';
        if (reference.isNotEmpty) {
          references.add(reference);
        }
      }
    } catch (_) {}

    return references.toList(growable: false);
  }

  DailyVersePoolEntry _choosePoolEntry({
    required List<DailyVersePoolEntry> pool,
    required List<String> selectedCategories,
    required String dateKey,
    required List<String> recentReferences,
  }) {
    final List<DailyVersePoolEntry> activePool = pool.isEmpty
        ? _fallbackPool
        : pool;
    final List<DailyVersePoolEntry> categoryMatches = activePool
        .where(
          (DailyVersePoolEntry item) =>
              selectedCategories.contains(item.category),
        )
        .toList(growable: false);
    final List<DailyVersePoolEntry> scopedPool = categoryMatches.isEmpty
        ? activePool
        : categoryMatches;

    final int categoryIndex = _stableHash(dateKey) % selectedCategories.length;
    final String preferredCategory = selectedCategories[categoryIndex];

    List<DailyVersePoolEntry> ranked = scopedPool
        .where((DailyVersePoolEntry item) => item.category == preferredCategory)
        .toList(growable: false);
    ranked = _withoutRecentReferences(ranked, recentReferences);
    if (ranked.isNotEmpty) {
      return ranked[_stableHash('$dateKey-$preferredCategory') % ranked.length];
    }

    ranked = _withoutRecentReferences(scopedPool, recentReferences);
    if (ranked.isNotEmpty) {
      return ranked[_stableHash(dateKey) % ranked.length];
    }

    final List<DailyVersePoolEntry> fallbackCategory = scopedPool
        .where((DailyVersePoolEntry item) => item.category == preferredCategory)
        .toList(growable: false);
    if (fallbackCategory.isNotEmpty) {
      return fallbackCategory[_stableHash(dateKey) % fallbackCategory.length];
    }

    return scopedPool[_stableHash(dateKey) % scopedPool.length];
  }

  List<DailyVersePoolEntry> _withoutRecentReferences(
    List<DailyVersePoolEntry> pool,
    List<String> recentReferences,
  ) {
    final Set<String> recent = recentReferences.toSet();
    final List<DailyVersePoolEntry> filtered = pool
        .where((DailyVersePoolEntry item) => !recent.contains(item.reference))
        .toList(growable: false);
    return filtered.isEmpty ? pool : filtered;
  }

  TodayAssignmentLocalRecord _recordFromRemoteRow(Map<String, dynamic> row) {
    final Map<String, dynamic> details = Map<String, dynamic>.from(
      row['details_json'] as Map? ?? const <String, dynamic>{},
    );

    return TodayAssignmentLocalRecord(
      dateKey: row['local_date']?.toString() ?? '',
      category: row['category_label']?.toString() ?? 'Guidance',
      reference: row['reference_label']?.toString() ?? '',
      translationCode: row['translation_code']?.toString() ?? 'kjv',
      translationLabel: row['translation_label']?.toString() ?? 'KJV',
      verseText: row['verse_text_snapshot']?.toString() ?? '',
      reflectionPrompt: row['reflection_prompt']?.toString() ?? '',
      encouragementLine: row['encouragement_line']?.toString() ?? '',
      contextSummary: row['context_summary']?.toString() ?? '',
      contextSections:
          (details['context_sections'] as List<dynamic>? ?? const <dynamic>[])
              .map(
                (dynamic item) => VerseContextSection.fromJson(
                  Map<String, dynamic>.from(item as Map),
                ),
              )
              .toList(growable: false),
      relatedPassages:
          (details['related_passages'] as List<dynamic>? ?? const <dynamic>[])
              .map(
                (dynamic item) => RelatedPassagePreview.fromJson(
                  Map<String, dynamic>.from(item as Map),
                ),
              )
              .toList(growable: false),
      keyInsights:
          (details['key_insights'] as List<dynamic>? ?? const <dynamic>[])
              .map((dynamic item) => item.toString())
              .toList(growable: false),
      prayer: row['prayer']?.toString() ?? '',
      assignedAtIso: row['assigned_at']?.toString() ?? '',
      openedAtIso: row['opened_at']?.toString(),
    );
  }

  List<String> _sanitizeCategories(List<String> raw) {
    final List<String> selected = raw
        .where((String item) => item.trim().isNotEmpty)
        .toList(growable: false);
    if (selected.isEmpty) {
      return const <String>['Guidance', 'Hope', 'Strength'];
    }
    return selected;
  }

  DateTime _resolveEffectiveDate(TimeOfDay dailyRefreshTime) {
    final DateTime now = DateTime.now();
    final DateTime refreshMoment = DateTime(
      now.year,
      now.month,
      now.day,
      dailyRefreshTime.hour,
      dailyRefreshTime.minute,
    );
    final DateTime effective = now.isBefore(refreshMoment)
        ? now.subtract(const Duration(days: 1))
        : now;
    return DateTime(effective.year, effective.month, effective.day);
  }

  String _toDateKey(DateTime value) {
    final String month = value.month.toString().padLeft(2, '0');
    final String day = value.day.toString().padLeft(2, '0');
    return '${value.year}-$month-$day';
  }

  int _stableHash(String value) {
    int hash = 0;
    for (int i = 0; i < value.length; i++) {
      hash = (hash * 31 + value.codeUnitAt(i)) & 0x7fffffff;
    }
    return hash;
  }
}

class _ReferenceParts {
  const _ReferenceParts({
    required this.bookLabel,
    required this.chapterNumber,
    required this.verseStart,
    required this.verseEnd,
  });

  final String bookLabel;
  final int chapterNumber;
  final int verseStart;
  final int verseEnd;
}

class _ResolvedVerseSnapshot {
  const _ResolvedVerseSnapshot({
    required this.reference,
    required this.translationCode,
    required this.translationLabel,
    required this.verseText,
  });

  final String reference;
  final String translationCode;
  final String translationLabel;
  final String verseText;
}

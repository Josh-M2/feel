import '../../domain/models/saved_item.dart';

class MockSavedRepository {
  const MockSavedRepository();

  List<SavedBookmark> getBookmarks() {
    return const <SavedBookmark>[
      SavedBookmark(
        id: 'bm_1',
        reference: 'Philippians 4:6–7',
        verseText:
            'Be careful for nothing; but in every thing by prayer and supplication with thanksgiving let your requests be made known unto God...',
        categoryLabel: 'Peace Over Anxiety',
        savedAtLabel: 'Saved today',
        translationLabel: 'KJV mock preview',
        hasReflection: true,
        highlightCount: 2,
        reflectionPreview:
            'I keep returning to this when my mind feels noisy. It reminds me to pray before spiraling.',
      ),
      SavedBookmark(
        id: 'bm_2',
        reference: 'Psalm 23:1',
        verseText: 'The Lord is my shepherd; I shall not want.',
        categoryLabel: 'Comfort and Healing',
        savedAtLabel: 'Saved yesterday',
        translationLabel: 'KJV mock preview',
        hasReflection: false,
        highlightCount: 1,
        reflectionPreview: null,
      ),
      SavedBookmark(
        id: 'bm_3',
        reference: 'Isaiah 26:3',
        verseText:
            'Thou wilt keep him in perfect peace, whose mind is stayed on thee: because he trusteth in thee.',
        categoryLabel: 'Peace Over Anxiety',
        savedAtLabel: 'Saved 3 days ago',
        translationLabel: 'KJV mock preview',
        hasReflection: true,
        highlightCount: 1,
        reflectionPreview:
            'This feels like a verse about attention. Peace seems connected to where the mind keeps returning.',
      ),
      SavedBookmark(
        id: 'bm_4',
        reference: 'John 15:5',
        verseText: '...for without me ye can do nothing.',
        categoryLabel: 'Purpose and Calling',
        savedAtLabel: 'Saved 1 week ago',
        translationLabel: 'KJV mock preview',
        hasReflection: true,
        highlightCount: 0,
        reflectionPreview:
            'I need this when I start thinking purpose depends only on my own effort.',
      ),
    ];
  }

  List<SavedHighlight> getHighlights() {
    return const <SavedHighlight>[
      SavedHighlight(
        id: 'hl_1',
        reference: 'Philippians 4:7',
        verseText:
            'And the peace of God, which passeth all understanding, shall keep your hearts and minds through Christ Jesus.',
        highlightedText: 'shall keep your hearts and minds',
        colorLabel: 'Warm amber',
        savedAtLabel: 'Highlighted today',
        notePreview:
            'The word “keep” feels protective, like peace is guarding the inner life.',
      ),
      SavedHighlight(
        id: 'hl_2',
        reference: 'Psalm 121:2',
        verseText: 'My help cometh from the Lord, which made heaven and earth.',
        highlightedText: 'My help cometh from the Lord',
        colorLabel: 'Soft olive',
        savedAtLabel: 'Highlighted yesterday',
        notePreview: null,
      ),
      SavedHighlight(
        id: 'hl_3',
        reference: 'Matthew 11:28',
        verseText:
            'Come unto me, all ye that labour and are heavy laden, and I will give you rest.',
        highlightedText: 'I will give you rest',
        colorLabel: 'Dusty rose',
        savedAtLabel: 'Highlighted 4 days ago',
        notePreview:
            'This feels like an invitation to come tired, not polished.',
      ),
      SavedHighlight(
        id: 'hl_4',
        reference: 'Proverbs 3:5',
        verseText:
            'Trust in the Lord with all thine heart; and lean not unto thine own understanding.',
        highlightedText: 'lean not unto thine own understanding',
        colorLabel: 'Warm amber',
        savedAtLabel: 'Highlighted 1 week ago',
        notePreview: null,
      ),
    ];
  }

  List<SavedNote> getNotes() {
    return const <SavedNote>[
      SavedNote(
        id: 'note_1',
        reference: 'Philippians 4:6–7',
        verseText:
            'Be careful for nothing... and the peace of God... shall keep your hearts and minds through Christ Jesus.',
        title: 'Prayer before panic',
        body:
            'I think this verse is teaching me that prayer is meant to be the first movement, not the backup plan after my thoughts are already running wild. I want to learn to pause earlier.',
        lastEditedLabel: 'Edited today',
        isPinned: true,
      ),
      SavedNote(
        id: 'note_2',
        reference: 'Isaiah 26:3',
        verseText:
            'Thou wilt keep him in perfect peace, whose mind is stayed on thee...',
        title: 'Attention shapes peace',
        body:
            'This verse makes me think peace is connected to what the mind keeps returning to. I want to be more deliberate about where my thoughts settle.',
        lastEditedLabel: 'Edited yesterday',
        isPinned: true,
      ),
      SavedNote(
        id: 'note_3',
        reference: 'John 15:5',
        verseText: '...for without me ye can do nothing.',
        title: 'Calling without self-pressure',
        body:
            'This keeps correcting me when I start turning purpose into pressure. Fruitfulness seems to come from abiding, not from forcing identity through achievement.',
        lastEditedLabel: 'Edited 3 days ago',
        isPinned: false,
      ),
      SavedNote(
        id: 'note_4',
        reference: 'Psalm 23:4',
        verseText:
            'Yea, though I walk through the valley of the shadow of death, I will fear no evil: for thou art with me...',
        title: 'Presence in the valley',
        body:
            'I notice the comfort of the psalm is not that valleys disappear, but that God remains present inside them.',
        lastEditedLabel: 'Edited 1 week ago',
        isPinned: false,
      ),
    ];
  }

  List<SavedHistoryEntry> getHistory() {
    return const <SavedHistoryEntry>[
      SavedHistoryEntry(
        id: 'hist_1',
        title: 'Opened today’s verse',
        reference: 'Philippians 4:6–7',
        detail:
            'You revisited the daily verse and opened its context after reading the encouragement summary.',
        occurredAtLabel: 'Today • 7:03 AM',
        sourceLabel: 'Today tab',
        kind: SavedHistoryKind.viewedVerse,
      ),
      SavedHistoryEntry(
        id: 'hist_2',
        title: 'Read a chapter',
        reference: 'John 3',
        detail:
            'You continued reading in John and opened the chapter on new birth and God’s love.',
        occurredAtLabel: 'Today • 6:41 AM',
        sourceLabel: 'Read tab',
        kind: SavedHistoryKind.readChapter,
      ),
      SavedHistoryEntry(
        id: 'hist_3',
        title: 'Opened a plan day',
        reference: 'Peace When Anxiety Feels Loud • Day 3',
        detail:
            'You resumed the current plan and revisited the focus on a mind stayed on God.',
        occurredAtLabel: 'Yesterday • 8:15 PM',
        sourceLabel: 'Plans tab',
        kind: SavedHistoryKind.openedPlanDay,
      ),
      SavedHistoryEntry(
        id: 'hist_4',
        title: 'Saved a verse',
        reference: 'Isaiah 26:3',
        detail:
            'You bookmarked this verse after reading it as part of your peace-related content flow.',
        occurredAtLabel: 'Yesterday • 7:48 PM',
        sourceLabel: 'Saved tab',
        kind: SavedHistoryKind.savedVerse,
      ),
      SavedHistoryEntry(
        id: 'hist_5',
        title: 'Wrote a private note',
        reference: 'John 15:5',
        detail:
            'You updated a reflection about purpose, pressure, and abiding in Christ.',
        occurredAtLabel: '3 days ago',
        sourceLabel: 'Saved tab',
        kind: SavedHistoryKind.wroteNote,
      ),
      SavedHistoryEntry(
        id: 'hist_6',
        title: 'Read a psalm',
        reference: 'Psalm 23',
        detail:
            'You opened Psalm 23 and spent time in the section about God’s presence in the valley.',
        occurredAtLabel: '1 week ago',
        sourceLabel: 'Read tab',
        kind: SavedHistoryKind.readChapter,
      ),
    ];
  }

  SavedLibrarySummary getSummary() {
    return SavedLibrarySummary(
      bookmarkCount: getBookmarks().length,
      highlightCount: getHighlights().length,
      noteCount: getNotes().length,
    );
  }

  List<SavedNote> getPinnedNotes() {
    return getNotes().where((SavedNote note) => note.isPinned).toList();
  }
}

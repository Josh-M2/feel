import '../../domain/models/read_book.dart';

class MockReadRepository {
  const MockReadRepository();

  List<ReadBook> getBooks() {
    return const <ReadBook>[
      ReadBook(
        id: 'john',
        name: 'John',
        testament: 'New Testament',
        chapterCount: 21,
        shortDescription:
            'A warm, personal gospel centered on Jesus, belief, and eternal life.',
        overview:
            'John highlights who Jesus is through signs, conversations, and direct teaching. The tone is personal and reflective, making it especially approachable for steady daily reading.',
        whyRead:
            'John is strong for both new and returning readers because it keeps pointing back to the identity of Jesus and the invitation to believe and remain in Him.',
        keyThemes: <String>['Belief', 'Life in Christ', 'Love', 'Abiding'],
        continueChapterNumber: 2,
        chapters: <ReadChapter>[
          ReadChapter(
            number: 1,
            title: 'The Word made flesh',
            introduction:
                'John opens high and deep. He does not begin with a stable scene first, but with the eternal Word, then moves toward the Word becoming flesh and dwelling among us.',
            focusLine:
                'This chapter frames Jesus not merely as teacher, but as the eternal Word entering human history.',
            blocks: <ReadPassageBlock>[
              ReadPassageBlock(
                heading: 'The eternal Word',
                rangeLabel: 'John 1:1–5',
                verses: <ReadVerseLine>[
                  ReadVerseLine(
                    number: 1,
                    text:
                        'In the beginning was the Word, and the Word was with God, and the Word was God.',
                  ),
                  ReadVerseLine(
                    number: 2,
                    text: 'The same was in the beginning with God.',
                  ),
                  ReadVerseLine(
                    number: 3,
                    text:
                        'All things were made by him; and without him was not any thing made that was made.',
                  ),
                  ReadVerseLine(
                    number: 4,
                    text: 'In him was life; and the life was the light of men.',
                  ),
                  ReadVerseLine(
                    number: 5,
                    text:
                        'And the light shineth in darkness; and the darkness comprehended it not.',
                  ),
                ],
              ),
              ReadPassageBlock(
                heading: 'The Word became flesh',
                rangeLabel: 'John 1:14',
                verses: <ReadVerseLine>[
                  ReadVerseLine(
                    number: 14,
                    text:
                        'And the Word was made flesh, and dwelt among us, and we beheld his glory...',
                  ),
                ],
              ),
            ],
          ),
          ReadChapter(
            number: 2,
            title: 'The wedding at Cana',
            introduction:
                'John’s second chapter shows Jesus turning water into wine and then cleansing the temple. It reveals both grace and authority.',
            focusLine:
                'Jesus is not distant from ordinary life, yet He is never reduced to ordinary expectations.',
            blocks: <ReadPassageBlock>[
              ReadPassageBlock(
                heading: 'The first sign',
                rangeLabel: 'John 2:1–11',
                verses: <ReadVerseLine>[
                  ReadVerseLine(
                    number: 7,
                    text:
                        'Jesus saith unto them, Fill the waterpots with water. And they filled them up to the brim.',
                  ),
                  ReadVerseLine(
                    number: 8,
                    text:
                        'And he saith unto them, Draw out now, and bear unto the governor of the feast. And they bare it.',
                  ),
                  ReadVerseLine(
                    number: 11,
                    text:
                        'This beginning of miracles did Jesus in Cana of Galilee, and manifested forth his glory; and his disciples believed on him.',
                  ),
                ],
              ),
              ReadPassageBlock(
                heading: 'Zeal for the Father’s house',
                rangeLabel: 'John 2:13–17',
                verses: <ReadVerseLine>[
                  ReadVerseLine(
                    number: 16,
                    text:
                        'Take these things hence; make not my Father’s house an house of merchandise.',
                  ),
                  ReadVerseLine(
                    number: 17,
                    text:
                        'And his disciples remembered that it was written, The zeal of thine house hath eaten me up.',
                  ),
                ],
              ),
            ],
          ),
          ReadChapter(
            number: 3,
            title: 'You must be born again',
            introduction:
                'Jesus speaks with Nicodemus and explains the need for spiritual rebirth, then the chapter moves into one of the clearest gospel invitations in scripture.',
            focusLine:
                'This chapter moves from confusion to invitation, from human limitation to God’s saving love.',
            blocks: <ReadPassageBlock>[
              ReadPassageBlock(
                heading: 'A new birth',
                rangeLabel: 'John 3:3–8',
                verses: <ReadVerseLine>[
                  ReadVerseLine(
                    number: 3,
                    text:
                        'Except a man be born again, he cannot see the kingdom of God.',
                  ),
                  ReadVerseLine(
                    number: 5,
                    text:
                        'Except a man be born of water and of the Spirit, he cannot enter into the kingdom of God.',
                  ),
                ],
              ),
              ReadPassageBlock(
                heading: 'God’s love and rescue',
                rangeLabel: 'John 3:16–17',
                verses: <ReadVerseLine>[
                  ReadVerseLine(
                    number: 16,
                    text:
                        'For God so loved the world, that he gave his only begotten Son...',
                  ),
                  ReadVerseLine(
                    number: 17,
                    text:
                        'For God sent not his Son into the world to condemn the world; but that the world through him might be saved.',
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      ReadBook(
        id: 'psalms',
        name: 'Psalms',
        testament: 'Old Testament',
        chapterCount: 150,
        shortDescription:
            'Songs, prayers, cries, and praise for the full range of the inner life.',
        overview:
            'Psalms gives language for worship, grief, trust, repentance, longing, and joy. It is one of the most emotionally honest books in scripture.',
        whyRead:
            'Psalms is especially good when the user wants to pray with scripture, process emotions before God, or find words for difficult seasons.',
        keyThemes: <String>['Prayer', 'Worship', 'Trust', 'God’s nearness'],
        continueChapterNumber: 23,
        chapters: <ReadChapter>[
          ReadChapter(
            number: 23,
            title: 'The Lord my shepherd',
            introduction:
                'Psalm 23 is one of the clearest pictures of God’s care, guidance, and steady presence through both rest and danger.',
            focusLine:
                'The peace of the psalm comes from the Shepherd’s presence, not from the absence of valleys.',
            blocks: <ReadPassageBlock>[
              ReadPassageBlock(
                heading: 'Provision and rest',
                rangeLabel: 'Psalm 23:1–3',
                verses: <ReadVerseLine>[
                  ReadVerseLine(
                    number: 1,
                    text: 'The Lord is my shepherd; I shall not want.',
                  ),
                  ReadVerseLine(
                    number: 2,
                    text:
                        'He maketh me to lie down in green pastures: he leadeth me beside the still waters.',
                  ),
                  ReadVerseLine(
                    number: 3,
                    text:
                        'He restoreth my soul: he leadeth me in the paths of righteousness for his name’s sake.',
                  ),
                ],
              ),
              ReadPassageBlock(
                heading: 'Presence in the valley',
                rangeLabel: 'Psalm 23:4–6',
                verses: <ReadVerseLine>[
                  ReadVerseLine(
                    number: 4,
                    text:
                        'Yea, though I walk through the valley of the shadow of death, I will fear no evil: for thou art with me...',
                  ),
                  ReadVerseLine(
                    number: 6,
                    text:
                        'Surely goodness and mercy shall follow me all the days of my life...',
                  ),
                ],
              ),
            ],
          ),
          ReadChapter(
            number: 27,
            title: 'Whom shall I fear?',
            introduction:
                'Psalm 27 holds courage and longing together. David speaks boldly of confidence in God while still voicing his need and desire.',
            focusLine:
                'Faith here is not pretending there is no threat. It is choosing where fear will not rule.',
            blocks: <ReadPassageBlock>[
              ReadPassageBlock(
                heading: 'Confidence in the Lord',
                rangeLabel: 'Psalm 27:1–3',
                verses: <ReadVerseLine>[
                  ReadVerseLine(
                    number: 1,
                    text:
                        'The Lord is my light and my salvation; whom shall I fear?',
                  ),
                  ReadVerseLine(
                    number: 3,
                    text:
                        'Though an host should encamp against me, my heart shall not fear...',
                  ),
                ],
              ),
              ReadPassageBlock(
                heading: 'One thing desired',
                rangeLabel: 'Psalm 27:4',
                verses: <ReadVerseLine>[
                  ReadVerseLine(
                    number: 4,
                    text:
                        'One thing have I desired of the Lord, that will I seek after...',
                  ),
                ],
              ),
            ],
          ),
          ReadChapter(
            number: 121,
            title: 'My help comes from the Lord',
            introduction:
                'Psalm 121 is a pilgrimage song that keeps repeating one main assurance: the Lord is a keeper who does not sleep.',
            focusLine:
                'This chapter builds confidence not by praising human strength, but by fixing attention on the keeping God.',
            blocks: <ReadPassageBlock>[
              ReadPassageBlock(
                heading: 'Help from the Maker',
                rangeLabel: 'Psalm 121:1–2',
                verses: <ReadVerseLine>[
                  ReadVerseLine(
                    number: 1,
                    text:
                        'I will lift up mine eyes unto the hills, from whence cometh my help.',
                  ),
                  ReadVerseLine(
                    number: 2,
                    text:
                        'My help cometh from the Lord, which made heaven and earth.',
                  ),
                ],
              ),
              ReadPassageBlock(
                heading: 'The Lord keeps you',
                rangeLabel: 'Psalm 121:3–8',
                verses: <ReadVerseLine>[
                  ReadVerseLine(
                    number: 4,
                    text:
                        'Behold, he that keepeth Israel shall neither slumber nor sleep.',
                  ),
                  ReadVerseLine(
                    number: 8,
                    text:
                        'The Lord shall preserve thy going out and thy coming in from this time forth, and even for evermore.',
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      ReadBook(
        id: 'philippians',
        name: 'Philippians',
        testament: 'New Testament',
        chapterCount: 4,
        shortDescription:
            'A short letter full of joy, steadiness, humility, and Christ-centered focus.',
        overview:
            'Philippians combines affection, endurance, joy, humility, and practical encouragement. It is compact, readable, and deeply comforting.',
        whyRead:
            'Philippians works well for users who want encouragement, peace in difficulty, and a strong reminder to center life on Christ.',
        keyThemes: <String>['Joy', 'Peace', 'Humility', 'Steadfastness'],
        continueChapterNumber: 4,
        chapters: <ReadChapter>[
          ReadChapter(
            number: 1,
            title: 'Confidence in God’s work',
            introduction:
                'Paul writes with affection and confidence that God will continue the work He has begun in believers.',
            focusLine:
                'This chapter keeps the reader grounded in God’s faithfulness rather than personal perfection.',
            blocks: <ReadPassageBlock>[
              ReadPassageBlock(
                heading: 'A good work begun',
                rangeLabel: 'Philippians 1:3–6',
                verses: <ReadVerseLine>[
                  ReadVerseLine(
                    number: 3,
                    text: 'I thank my God upon every remembrance of you...',
                  ),
                  ReadVerseLine(
                    number: 6,
                    text:
                        'He which hath begun a good work in you will perform it until the day of Jesus Christ.',
                  ),
                ],
              ),
              ReadPassageBlock(
                heading: 'Christ magnified',
                rangeLabel: 'Philippians 1:20–21',
                verses: <ReadVerseLine>[
                  ReadVerseLine(
                    number: 21,
                    text: 'For to me to live is Christ, and to die is gain.',
                  ),
                ],
              ),
            ],
          ),
          ReadChapter(
            number: 4,
            title: 'Prayer and peace',
            introduction:
                'Philippians 4 moves through rejoicing, gentleness, prayer, thought life, and contentment in Christ.',
            focusLine:
                'The chapter teaches peace as a Christ-centered posture shaped by prayer and trust.',
            blocks: <ReadPassageBlock>[
              ReadPassageBlock(
                heading: 'Pray instead of carrying everything alone',
                rangeLabel: 'Philippians 4:4–7',
                verses: <ReadVerseLine>[
                  ReadVerseLine(
                    number: 4,
                    text:
                        'Rejoice in the Lord alway: and again I say, Rejoice.',
                  ),
                  ReadVerseLine(
                    number: 6,
                    text:
                        'Be careful for nothing; but in every thing by prayer and supplication with thanksgiving let your requests be made known unto God.',
                  ),
                  ReadVerseLine(
                    number: 7,
                    text:
                        'And the peace of God, which passeth all understanding, shall keep your hearts and minds through Christ Jesus.',
                  ),
                ],
              ),
              ReadPassageBlock(
                heading: 'Contentment in Christ',
                rangeLabel: 'Philippians 4:11–13',
                verses: <ReadVerseLine>[
                  ReadVerseLine(
                    number: 11,
                    text:
                        '...for I have learned, in whatsoever state I am, therewith to be content.',
                  ),
                  ReadVerseLine(
                    number: 13,
                    text:
                        'I can do all things through Christ which strengtheneth me.',
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ];
  }

  ReadBook getDefaultBook() {
    return getBooks().first;
  }

  ReadBook getBookById(String? bookId) {
    return getBooks().firstWhere(
      (ReadBook book) => book.id == bookId,
      orElse: getDefaultBook,
    );
  }

  ReadBook getContinueReadingBook() {
    return getBookById('john');
  }

  ReadChapter getChapter({String? bookId, int? chapterNumber}) {
    final ReadBook book = getBookById(bookId);
    return book.chapters.firstWhere(
      (ReadChapter chapter) => chapter.number == chapterNumber,
      orElse: () => book.chapters.first,
    );
  }

  ReadChapter? getNextMockChapter({
    required String bookId,
    required int chapterNumber,
  }) {
    final ReadBook book = getBookById(bookId);
    final int currentIndex = book.chapters.indexWhere(
      (ReadChapter chapter) => chapter.number == chapterNumber,
    );

    if (currentIndex == -1) return null;
    if (currentIndex + 1 >= book.chapters.length) return null;
    return book.chapters[currentIndex + 1];
  }

  ReadChapter? getPreviousMockChapter({
    required String bookId,
    required int chapterNumber,
  }) {
    final ReadBook book = getBookById(bookId);
    final int currentIndex = book.chapters.indexWhere(
      (ReadChapter chapter) => chapter.number == chapterNumber,
    );

    if (currentIndex <= 0) return null;
    return book.chapters[currentIndex - 1];
  }
}

class ReadBook {
  const ReadBook({
    required this.id,
    required this.name,
    required this.testament,
    required this.chapterCount,
    required this.shortDescription,
    required this.overview,
    required this.whyRead,
    required this.keyThemes,
    required this.continueChapterNumber,
    required this.mockChapters,
  });

  final String id;
  final String name;
  final String testament;
  final int chapterCount;
  final String shortDescription;
  final String overview;
  final String whyRead;
  final List<String> keyThemes;
  final int continueChapterNumber;
  final List<ReadChapter> mockChapters;
}

class ReadChapter {
  const ReadChapter({
    required this.number,
    required this.title,
    required this.introduction,
    required this.focusLine,
    required this.blocks,
  });

  final int number;
  final String title;
  final String introduction;
  final String focusLine;
  final List<ReadPassageBlock> blocks;
}

class ReadPassageBlock {
  const ReadPassageBlock({
    required this.heading,
    required this.rangeLabel,
    required this.verses,
  });

  final String heading;
  final String rangeLabel;
  final List<ReadVerseLine> verses;
}

class ReadVerseLine {
  const ReadVerseLine({required this.number, required this.text});

  final int number;
  final String text;
}

class ReadBookRouteArgs {
  const ReadBookRouteArgs({required this.bookId});

  final String bookId;
}

class ChapterReadRouteArgs {
  const ChapterReadRouteArgs({
    required this.bookId,
    required this.chapterNumber,
  });

  final String bookId;
  final int chapterNumber;
}

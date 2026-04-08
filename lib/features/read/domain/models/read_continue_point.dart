class ReadContinuePoint {
  const ReadContinuePoint({
    required this.bookId,
    required this.bookName,
    required this.chapterNumber,
    required this.chapterTitle,
    required this.label,
    required this.focusLine,
    this.versionCode = 'kjv',
    this.versionLabel = 'KJV',
  });

  final String bookId;
  final String bookName;
  final int chapterNumber;
  final String chapterTitle;
  final String label;
  final String focusLine;
  final String versionCode;
  final String versionLabel;
}

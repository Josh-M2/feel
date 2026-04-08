class ReadReferenceSearchResult {
  const ReadReferenceSearchResult({
    required this.bookId,
    required this.bookName,
    required this.chapterNumber,
    required this.chapterTitle,
    required this.subtitle,
  });

  final String bookId;
  final String bookName;
  final int chapterNumber;
  final String chapterTitle;
  final String subtitle;
}

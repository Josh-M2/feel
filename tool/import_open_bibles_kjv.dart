import 'dart:io';

bool _skippingUnsupportedBook = false;

class CanonicalBook {
  const CanonicalBook({
    required this.osisCode,
    required this.id,
    required this.name,
    required this.shortName,
    required this.testament,
    required this.sortOrder,
    required this.chapterCount,
  });

  final String osisCode;
  final String id;
  final String name;
  final String shortName;
  final String testament;
  final int sortOrder;
  final int chapterCount;
}

class ParsedVerse {
  const ParsedVerse({
    required this.book,
    required this.chapterNumber,
    required this.verseNumber,
    required this.text,
  });

  final CanonicalBook book;
  final int chapterNumber;
  final int verseNumber;
  final String text;
}

class ChapterRow {
  const ChapterRow({
    required this.book,
    required this.chapterNumber,
    required this.title,
  });

  final CanonicalBook book;
  final int chapterNumber;
  final String title;
}

class ImportDocument {
  const ImportDocument({
    required this.books,
    required this.chapters,
    required this.verses,
  });

  final List<CanonicalBook> books;
  final List<ChapterRow> chapters;
  final List<ParsedVerse> verses;
}

class ImportOptions {
  const ImportOptions({required this.sourcePath, required this.outputPath});

  final String sourcePath;
  final String outputPath;
}

const List<CanonicalBook> canonicalBooks = <CanonicalBook>[
  CanonicalBook(
    osisCode: 'Gen',
    id: 'genesis',
    name: 'Genesis',
    shortName: 'Gen',
    testament: 'Old Testament',
    sortOrder: 1,
    chapterCount: 50,
  ),
  CanonicalBook(
    osisCode: 'Exod',
    id: 'exodus',
    name: 'Exodus',
    shortName: 'Exod',
    testament: 'Old Testament',
    sortOrder: 2,
    chapterCount: 40,
  ),
  CanonicalBook(
    osisCode: 'Lev',
    id: 'leviticus',
    name: 'Leviticus',
    shortName: 'Lev',
    testament: 'Old Testament',
    sortOrder: 3,
    chapterCount: 27,
  ),
  CanonicalBook(
    osisCode: 'Num',
    id: 'numbers',
    name: 'Numbers',
    shortName: 'Num',
    testament: 'Old Testament',
    sortOrder: 4,
    chapterCount: 36,
  ),
  CanonicalBook(
    osisCode: 'Deut',
    id: 'deuteronomy',
    name: 'Deuteronomy',
    shortName: 'Deut',
    testament: 'Old Testament',
    sortOrder: 5,
    chapterCount: 34,
  ),
  CanonicalBook(
    osisCode: 'Josh',
    id: 'joshua',
    name: 'Joshua',
    shortName: 'Josh',
    testament: 'Old Testament',
    sortOrder: 6,
    chapterCount: 24,
  ),
  CanonicalBook(
    osisCode: 'Judg',
    id: 'judges',
    name: 'Judges',
    shortName: 'Judg',
    testament: 'Old Testament',
    sortOrder: 7,
    chapterCount: 21,
  ),
  CanonicalBook(
    osisCode: 'Ruth',
    id: 'ruth',
    name: 'Ruth',
    shortName: 'Ruth',
    testament: 'Old Testament',
    sortOrder: 8,
    chapterCount: 4,
  ),
  CanonicalBook(
    osisCode: '1Sam',
    id: '1-samuel',
    name: '1 Samuel',
    shortName: '1 Sam',
    testament: 'Old Testament',
    sortOrder: 9,
    chapterCount: 31,
  ),
  CanonicalBook(
    osisCode: '2Sam',
    id: '2-samuel',
    name: '2 Samuel',
    shortName: '2 Sam',
    testament: 'Old Testament',
    sortOrder: 10,
    chapterCount: 24,
  ),
  CanonicalBook(
    osisCode: '1Kgs',
    id: '1-kings',
    name: '1 Kings',
    shortName: '1 Kgs',
    testament: 'Old Testament',
    sortOrder: 11,
    chapterCount: 22,
  ),
  CanonicalBook(
    osisCode: '2Kgs',
    id: '2-kings',
    name: '2 Kings',
    shortName: '2 Kgs',
    testament: 'Old Testament',
    sortOrder: 12,
    chapterCount: 25,
  ),
  CanonicalBook(
    osisCode: '1Chr',
    id: '1-chronicles',
    name: '1 Chronicles',
    shortName: '1 Chr',
    testament: 'Old Testament',
    sortOrder: 13,
    chapterCount: 29,
  ),
  CanonicalBook(
    osisCode: '2Chr',
    id: '2-chronicles',
    name: '2 Chronicles',
    shortName: '2 Chr',
    testament: 'Old Testament',
    sortOrder: 14,
    chapterCount: 36,
  ),
  CanonicalBook(
    osisCode: 'Ezra',
    id: 'ezra',
    name: 'Ezra',
    shortName: 'Ezra',
    testament: 'Old Testament',
    sortOrder: 15,
    chapterCount: 10,
  ),
  CanonicalBook(
    osisCode: 'Neh',
    id: 'nehemiah',
    name: 'Nehemiah',
    shortName: 'Neh',
    testament: 'Old Testament',
    sortOrder: 16,
    chapterCount: 13,
  ),
  CanonicalBook(
    osisCode: 'Esth',
    id: 'esther',
    name: 'Esther',
    shortName: 'Esth',
    testament: 'Old Testament',
    sortOrder: 17,
    chapterCount: 10,
  ),
  CanonicalBook(
    osisCode: 'Job',
    id: 'job',
    name: 'Job',
    shortName: 'Job',
    testament: 'Old Testament',
    sortOrder: 18,
    chapterCount: 42,
  ),
  CanonicalBook(
    osisCode: 'Ps',
    id: 'psalms',
    name: 'Psalms',
    shortName: 'Ps',
    testament: 'Old Testament',
    sortOrder: 19,
    chapterCount: 150,
  ),
  CanonicalBook(
    osisCode: 'Prov',
    id: 'proverbs',
    name: 'Proverbs',
    shortName: 'Prov',
    testament: 'Old Testament',
    sortOrder: 20,
    chapterCount: 31,
  ),
  CanonicalBook(
    osisCode: 'Eccl',
    id: 'ecclesiastes',
    name: 'Ecclesiastes',
    shortName: 'Eccl',
    testament: 'Old Testament',
    sortOrder: 21,
    chapterCount: 12,
  ),
  CanonicalBook(
    osisCode: 'Song',
    id: 'song-of-solomon',
    name: 'Song of Solomon',
    shortName: 'Song',
    testament: 'Old Testament',
    sortOrder: 22,
    chapterCount: 8,
  ),
  CanonicalBook(
    osisCode: 'Isa',
    id: 'isaiah',
    name: 'Isaiah',
    shortName: 'Isa',
    testament: 'Old Testament',
    sortOrder: 23,
    chapterCount: 66,
  ),
  CanonicalBook(
    osisCode: 'Jer',
    id: 'jeremiah',
    name: 'Jeremiah',
    shortName: 'Jer',
    testament: 'Old Testament',
    sortOrder: 24,
    chapterCount: 52,
  ),
  CanonicalBook(
    osisCode: 'Lam',
    id: 'lamentations',
    name: 'Lamentations',
    shortName: 'Lam',
    testament: 'Old Testament',
    sortOrder: 25,
    chapterCount: 5,
  ),
  CanonicalBook(
    osisCode: 'Ezek',
    id: 'ezekiel',
    name: 'Ezekiel',
    shortName: 'Ezek',
    testament: 'Old Testament',
    sortOrder: 26,
    chapterCount: 48,
  ),
  CanonicalBook(
    osisCode: 'Dan',
    id: 'daniel',
    name: 'Daniel',
    shortName: 'Dan',
    testament: 'Old Testament',
    sortOrder: 27,
    chapterCount: 12,
  ),
  CanonicalBook(
    osisCode: 'Hos',
    id: 'hosea',
    name: 'Hosea',
    shortName: 'Hos',
    testament: 'Old Testament',
    sortOrder: 28,
    chapterCount: 14,
  ),
  CanonicalBook(
    osisCode: 'Joel',
    id: 'joel',
    name: 'Joel',
    shortName: 'Joel',
    testament: 'Old Testament',
    sortOrder: 29,
    chapterCount: 3,
  ),
  CanonicalBook(
    osisCode: 'Amos',
    id: 'amos',
    name: 'Amos',
    shortName: 'Amos',
    testament: 'Old Testament',
    sortOrder: 30,
    chapterCount: 9,
  ),
  CanonicalBook(
    osisCode: 'Obad',
    id: 'obadiah',
    name: 'Obadiah',
    shortName: 'Obad',
    testament: 'Old Testament',
    sortOrder: 31,
    chapterCount: 1,
  ),
  CanonicalBook(
    osisCode: 'Jonah',
    id: 'jonah',
    name: 'Jonah',
    shortName: 'Jonah',
    testament: 'Old Testament',
    sortOrder: 32,
    chapterCount: 4,
  ),
  CanonicalBook(
    osisCode: 'Mic',
    id: 'micah',
    name: 'Micah',
    shortName: 'Mic',
    testament: 'Old Testament',
    sortOrder: 33,
    chapterCount: 7,
  ),
  CanonicalBook(
    osisCode: 'Nah',
    id: 'nahum',
    name: 'Nahum',
    shortName: 'Nah',
    testament: 'Old Testament',
    sortOrder: 34,
    chapterCount: 3,
  ),
  CanonicalBook(
    osisCode: 'Hab',
    id: 'habakkuk',
    name: 'Habakkuk',
    shortName: 'Hab',
    testament: 'Old Testament',
    sortOrder: 35,
    chapterCount: 3,
  ),
  CanonicalBook(
    osisCode: 'Zeph',
    id: 'zephaniah',
    name: 'Zephaniah',
    shortName: 'Zeph',
    testament: 'Old Testament',
    sortOrder: 36,
    chapterCount: 3,
  ),
  CanonicalBook(
    osisCode: 'Hag',
    id: 'haggai',
    name: 'Haggai',
    shortName: 'Hag',
    testament: 'Old Testament',
    sortOrder: 37,
    chapterCount: 2,
  ),
  CanonicalBook(
    osisCode: 'Zech',
    id: 'zechariah',
    name: 'Zechariah',
    shortName: 'Zech',
    testament: 'Old Testament',
    sortOrder: 38,
    chapterCount: 14,
  ),
  CanonicalBook(
    osisCode: 'Mal',
    id: 'malachi',
    name: 'Malachi',
    shortName: 'Mal',
    testament: 'Old Testament',
    sortOrder: 39,
    chapterCount: 4,
  ),
  CanonicalBook(
    osisCode: 'Matt',
    id: 'matthew',
    name: 'Matthew',
    shortName: 'Matt',
    testament: 'New Testament',
    sortOrder: 40,
    chapterCount: 28,
  ),
  CanonicalBook(
    osisCode: 'Mark',
    id: 'mark',
    name: 'Mark',
    shortName: 'Mark',
    testament: 'New Testament',
    sortOrder: 41,
    chapterCount: 16,
  ),
  CanonicalBook(
    osisCode: 'Luke',
    id: 'luke',
    name: 'Luke',
    shortName: 'Luke',
    testament: 'New Testament',
    sortOrder: 42,
    chapterCount: 24,
  ),
  CanonicalBook(
    osisCode: 'John',
    id: 'john',
    name: 'John',
    shortName: 'John',
    testament: 'New Testament',
    sortOrder: 43,
    chapterCount: 21,
  ),
  CanonicalBook(
    osisCode: 'Acts',
    id: 'acts',
    name: 'Acts',
    shortName: 'Acts',
    testament: 'New Testament',
    sortOrder: 44,
    chapterCount: 28,
  ),
  CanonicalBook(
    osisCode: 'Rom',
    id: 'romans',
    name: 'Romans',
    shortName: 'Rom',
    testament: 'New Testament',
    sortOrder: 45,
    chapterCount: 16,
  ),
  CanonicalBook(
    osisCode: '1Cor',
    id: '1-corinthians',
    name: '1 Corinthians',
    shortName: '1 Cor',
    testament: 'New Testament',
    sortOrder: 46,
    chapterCount: 16,
  ),
  CanonicalBook(
    osisCode: '2Cor',
    id: '2-corinthians',
    name: '2 Corinthians',
    shortName: '2 Cor',
    testament: 'New Testament',
    sortOrder: 47,
    chapterCount: 13,
  ),
  CanonicalBook(
    osisCode: 'Gal',
    id: 'galatians',
    name: 'Galatians',
    shortName: 'Gal',
    testament: 'New Testament',
    sortOrder: 48,
    chapterCount: 6,
  ),
  CanonicalBook(
    osisCode: 'Eph',
    id: 'ephesians',
    name: 'Ephesians',
    shortName: 'Eph',
    testament: 'New Testament',
    sortOrder: 49,
    chapterCount: 6,
  ),
  CanonicalBook(
    osisCode: 'Phil',
    id: 'philippians',
    name: 'Philippians',
    shortName: 'Phil',
    testament: 'New Testament',
    sortOrder: 50,
    chapterCount: 4,
  ),
  CanonicalBook(
    osisCode: 'Col',
    id: 'colossians',
    name: 'Colossians',
    shortName: 'Col',
    testament: 'New Testament',
    sortOrder: 51,
    chapterCount: 4,
  ),
  CanonicalBook(
    osisCode: '1Thess',
    id: '1-thessalonians',
    name: '1 Thessalonians',
    shortName: '1 Thess',
    testament: 'New Testament',
    sortOrder: 52,
    chapterCount: 5,
  ),
  CanonicalBook(
    osisCode: '2Thess',
    id: '2-thessalonians',
    name: '2 Thessalonians',
    shortName: '2 Thess',
    testament: 'New Testament',
    sortOrder: 53,
    chapterCount: 3,
  ),
  CanonicalBook(
    osisCode: '1Tim',
    id: '1-timothy',
    name: '1 Timothy',
    shortName: '1 Tim',
    testament: 'New Testament',
    sortOrder: 54,
    chapterCount: 6,
  ),
  CanonicalBook(
    osisCode: '2Tim',
    id: '2-timothy',
    name: '2 Timothy',
    shortName: '2 Tim',
    testament: 'New Testament',
    sortOrder: 55,
    chapterCount: 4,
  ),
  CanonicalBook(
    osisCode: 'Titus',
    id: 'titus',
    name: 'Titus',
    shortName: 'Titus',
    testament: 'New Testament',
    sortOrder: 56,
    chapterCount: 3,
  ),
  CanonicalBook(
    osisCode: 'Phlm',
    id: 'philemon',
    name: 'Philemon',
    shortName: 'Phlm',
    testament: 'New Testament',
    sortOrder: 57,
    chapterCount: 1,
  ),
  CanonicalBook(
    osisCode: 'Heb',
    id: 'hebrews',
    name: 'Hebrews',
    shortName: 'Heb',
    testament: 'New Testament',
    sortOrder: 58,
    chapterCount: 13,
  ),
  CanonicalBook(
    osisCode: 'Jas',
    id: 'james',
    name: 'James',
    shortName: 'Jas',
    testament: 'New Testament',
    sortOrder: 59,
    chapterCount: 5,
  ),
  CanonicalBook(
    osisCode: '1Pet',
    id: '1-peter',
    name: '1 Peter',
    shortName: '1 Pet',
    testament: 'New Testament',
    sortOrder: 60,
    chapterCount: 5,
  ),
  CanonicalBook(
    osisCode: '2Pet',
    id: '2-peter',
    name: '2 Peter',
    shortName: '2 Pet',
    testament: 'New Testament',
    sortOrder: 61,
    chapterCount: 3,
  ),
  CanonicalBook(
    osisCode: '1John',
    id: '1-john',
    name: '1 John',
    shortName: '1 John',
    testament: 'New Testament',
    sortOrder: 62,
    chapterCount: 5,
  ),
  CanonicalBook(
    osisCode: '2John',
    id: '2-john',
    name: '2 John',
    shortName: '2 John',
    testament: 'New Testament',
    sortOrder: 63,
    chapterCount: 1,
  ),
  CanonicalBook(
    osisCode: '3John',
    id: '3-john',
    name: '3 John',
    shortName: '3 John',
    testament: 'New Testament',
    sortOrder: 64,
    chapterCount: 1,
  ),
  CanonicalBook(
    osisCode: 'Jude',
    id: 'jude',
    name: 'Jude',
    shortName: 'Jude',
    testament: 'New Testament',
    sortOrder: 65,
    chapterCount: 1,
  ),
  CanonicalBook(
    osisCode: 'Rev',
    id: 'revelation',
    name: 'Revelation',
    shortName: 'Rev',
    testament: 'New Testament',
    sortOrder: 66,
    chapterCount: 22,
  ),
];

final Map<String, CanonicalBook> canonicalBookByOsis = <String, CanonicalBook>{
  for (final CanonicalBook book in canonicalBooks) book.osisCode: book,
};

const Set<String> _ignoredElements = <String>{
  'note',
  'title',
  'header',
  'speaker',
  'reference',
};

const Set<String> _breakElements = <String>{'lb', 'l', 'br', 'p'};

Future<void> main(List<String> arguments) async {
  final ImportOptions options = parseArguments(
    arguments,
    usageLine:
        'Usage: dart run tool/import_open_bibles_kjv.dart --source <eng-kjv.osis.xml> --out <output.sql>',
  );
  final File sourceFile = File(options.sourcePath);
  if (!sourceFile.existsSync()) {
    stderr.writeln('Source file not found: ${options.sourcePath}');
    exitCode = 2;
    return;
  }

  final String xml = await sourceFile.readAsString();
  final ImportDocument document = parseOpenBiblesKjvOsis(xml);
  final String sql = buildImportSql(document);

  final File outputFile = File(options.outputPath);
  outputFile.parent.createSync(recursive: true);
  await outputFile.writeAsString(sql);

  stdout.writeln(
    'Generated ${document.verses.length} verses across '
    '${document.chapters.length} chapters into ${outputFile.path}',
  );
}

ImportOptions parseArguments(
  List<String> arguments, {
  String usageLine =
      'Usage: dart run tool/import_open_bibles_kjv.dart --source <eng-kjv.osis.xml> --out <output.sql>',
}) {
  String? sourcePath;
  String? outputPath;

  for (int index = 0; index < arguments.length; index++) {
    final String argument = arguments[index];
    switch (argument) {
      case '--source':
        sourcePath = _nextArgument(arguments, ++index, '--source');
        break;
      case '--out':
        outputPath = _nextArgument(arguments, ++index, '--out');
        break;
      case '--help':
      case '-h':
        _printUsage(usageLine);
        exit(0);
      default:
        throw FormatException('Unknown argument: $argument');
    }
  }

  if (sourcePath == null || outputPath == null) {
    _printUsage(usageLine);
    throw const FormatException('Both --source and --out are required.');
  }

  return ImportOptions(sourcePath: sourcePath, outputPath: outputPath);
}

String _nextArgument(List<String> arguments, int index, String flag) {
  if (index >= arguments.length) {
    throw FormatException('Missing value for $flag.');
  }
  return arguments[index];
}

void _printUsage(String usageLine) {
  stdout.writeln(usageLine);
}

ImportDocument parseOpenBiblesKjvOsis(
  String xml, {
  bool requireCompleteCanon = true,
}) {
  final _OsisParser parser = _OsisParser(xml);
  return buildCanonicalImportDocument(
    parser.parse(),
    requireCompleteCanon: requireCompleteCanon,
  );
}

ImportDocument buildCanonicalImportDocument(
  List<ParsedVerse> verses, {
  bool requireCompleteCanon = true,
}) {
  final Map<String, ChapterRow> chaptersByKey = <String, ChapterRow>{};

  for (final ParsedVerse verse in verses) {
    final String key = '${verse.book.id}:${verse.chapterNumber}';
    chaptersByKey.putIfAbsent(
      key,
      () => ChapterRow(
        book: verse.book,
        chapterNumber: verse.chapterNumber,
        title: '${verse.book.name} ${verse.chapterNumber}',
      ),
    );
  }

  final List<ChapterRow> chapters = chaptersByKey.values.toList(growable: false)
    ..sort((ChapterRow a, ChapterRow b) {
      final int bookCompare = a.book.sortOrder.compareTo(b.book.sortOrder);
      if (bookCompare != 0) return bookCompare;
      return a.chapterNumber.compareTo(b.chapterNumber);
    });

  validateCanonicalImportDocument(
    verses,
    chapters,
    requireCompleteCanon: requireCompleteCanon,
  );

  return ImportDocument(
    books: canonicalBooks,
    chapters: chapters,
    verses: verses,
  );
}

void validateCanonicalImportDocument(
  List<ParsedVerse> verses,
  List<ChapterRow> chapters, {
  required bool requireCompleteCanon,
}) {
  final Set<String> seenVerseKeys = <String>{};
  for (final ParsedVerse verse in verses) {
    final String verseKey =
        '${verse.book.id}:${verse.chapterNumber}:${verse.verseNumber}';
    if (!seenVerseKeys.add(verseKey)) {
      throw StateError('Duplicate verse detected: $verseKey');
    }
    if (verse.text.trim().isEmpty) {
      throw StateError('Blank verse text detected: $verseKey');
    }
  }

  final Map<String, int> chapterCounts = <String, int>{};
  for (final ChapterRow chapter in chapters) {
    chapterCounts.update(
      chapter.book.id,
      (int value) => value + 1,
      ifAbsent: () => 1,
    );
  }

  if (requireCompleteCanon) {
    for (final CanonicalBook book in canonicalBooks) {
      final int actual = chapterCounts[book.id] ?? 0;
      if (actual != book.chapterCount) {
        throw StateError(
          'Chapter count mismatch for ${book.name}: expected ${book.chapterCount}, got $actual',
        );
      }
    }
  }
}

String buildImportSql(ImportDocument document) {
  return buildImportSqlForVersion(
    document,
    versionId: 'kjv',
    versionName: 'King James Version',
    sourceDescription: 'Open Bibles KJV OSIS XML',
    generatorLabel: 'tool/import_open_bibles_kjv.dart',
    validationFunctionName: 'validate_kjv_scripture_import',
  );
}

String buildImportSqlForVersion(
  ImportDocument document, {
  required String versionId,
  required String versionName,
  required String sourceDescription,
  required String generatorLabel,
  required String validationFunctionName,
  bool includeCanonicalMetadata = true,
}) {
  final StringBuffer buffer = StringBuffer()
    ..writeln('-- Generated by $generatorLabel')
    ..writeln('-- Source: $sourceDescription')
    ..writeln('begin;')
    ..writeln()
    ..writeln();

  _writeVersionUpsert(
    buffer,
    versionId: versionId,
    versionName: versionName,
    isDefault: versionId == 'kjv',
  );
  if (includeCanonicalMetadata) {
    _writeBookUpserts(buffer, document.books);
    _writeAliasInserts(buffer, document.books);
    _writeChapterUpserts(buffer, document.chapters);
  }
  _writeVerseImport(buffer, document.verses, versionId: versionId);

  buffer
    ..writeln()
    ..writeln('commit;')
    ..writeln()
    ..writeln('-- Run after import:')
    ..writeln('-- select * from public.$validationFunctionName();');

  return buffer.toString();
}

void _writeVersionUpsert(
  StringBuffer buffer, {
  required String versionId,
  required String versionName,
  required bool isDefault,
}) {
  buffer
    ..writeln(
      'insert into public.content_bible_versions (id, name, language_code, is_default, is_public_domain, is_active)',
    )
    ..writeln(
      "values (${_sql(versionId)}, ${_sql(versionName)}, 'en', ${isDefault ? 'true' : 'false'}, true, true)",
    )
    ..writeln('on conflict (id) do update')
    ..writeln('set')
    ..writeln('  name = excluded.name,')
    ..writeln('  language_code = excluded.language_code,')
    ..writeln('  is_default = excluded.is_default,')
    ..writeln('  is_public_domain = excluded.is_public_domain,')
    ..writeln('  is_active = excluded.is_active;')
    ..writeln();
}

void _writeBookUpserts(StringBuffer buffer, List<CanonicalBook> books) {
  buffer.writeln('insert into public.content_bible_books (');
  buffer.writeln('  id,');
  buffer.writeln('  name,');
  buffer.writeln('  short_name,');
  buffer.writeln('  testament,');
  buffer.writeln('  sort_order,');
  buffer.writeln('  chapter_count,');
  buffer.writeln('  osis_code,');
  buffer.writeln('  book_number,');
  buffer.writeln('  is_active');
  buffer.writeln(')');
  buffer.writeln('values');

  for (int index = 0; index < books.length; index++) {
    final CanonicalBook book = books[index];
    final String suffix = index == books.length - 1 ? '' : ',';
    buffer.writeln(
      "  (${_sql(book.id)}, ${_sql(book.name)}, ${_sql(book.shortName)}, "
      "${_sql(book.testament)}, ${book.sortOrder}, ${book.chapterCount}, "
      "${_sql(book.osisCode)}, ${book.sortOrder}, true)$suffix",
    );
  }

  buffer.writeln('on conflict (id) do update');
  buffer.writeln('set');
  buffer.writeln('  name = excluded.name,');
  buffer.writeln('  short_name = excluded.short_name,');
  buffer.writeln('  testament = excluded.testament,');
  buffer.writeln('  sort_order = excluded.sort_order,');
  buffer.writeln('  chapter_count = excluded.chapter_count,');
  buffer.writeln('  osis_code = excluded.osis_code,');
  buffer.writeln('  book_number = excluded.book_number,');
  buffer.writeln('  is_active = excluded.is_active,');
  buffer.writeln("  updated_at = timezone('utc', now());");
  buffer.writeln();
}

void _writeAliasInserts(StringBuffer buffer, List<CanonicalBook> books) {
  buffer.writeln('delete from public.content_book_aliases');
  buffer.writeln('where book_id in (');
  for (int index = 0; index < books.length; index++) {
    final String suffix = index == books.length - 1 ? '' : ',';
    buffer.writeln('  ${_sql(books[index].id)}$suffix');
  }
  buffer.writeln(');');
  buffer.writeln();
  buffer.writeln('insert into public.content_book_aliases (book_id, alias)');
  buffer.writeln('values');

  final List<String> rows = <String>[];
  for (final CanonicalBook book in books) {
    for (final String alias in _aliasesFor(book)) {
      rows.add('  (${_sql(book.id)}, ${_sql(alias)})');
    }
  }

  for (int index = 0; index < rows.length; index++) {
    final String suffix = index == rows.length - 1 ? '' : ',';
    buffer.writeln('${rows[index]}$suffix');
  }
  buffer.writeln('on conflict (book_id, alias) do nothing;');
  buffer.writeln();
}

void _writeChapterUpserts(StringBuffer buffer, List<ChapterRow> chapters) {
  const int batchSize = 250;
  for (int start = 0; start < chapters.length; start += batchSize) {
    final List<ChapterRow> batch = chapters
        .skip(start)
        .take(batchSize)
        .toList(growable: false);
    buffer.writeln('insert into public.content_bible_chapters (');
    buffer.writeln('  book_id,');
    buffer.writeln('  chapter_number,');
    buffer.writeln('  title');
    buffer.writeln(')');
    buffer.writeln('values');

    for (int index = 0; index < batch.length; index++) {
      final ChapterRow chapter = batch[index];
      final String suffix = index == batch.length - 1 ? '' : ',';
      buffer.writeln(
        "  (${_sql(chapter.book.id)}, ${chapter.chapterNumber}, ${_sql(chapter.title)})$suffix",
      );
    }

    buffer.writeln('on conflict (book_id, chapter_number) do update');
    buffer.writeln('set');
    buffer.writeln(
      "  title = case when btrim(public.content_bible_chapters.title) = '' or public.content_bible_chapters.title = ('Chapter ' || excluded.chapter_number::text)"
      " then excluded.title else public.content_bible_chapters.title end,",
    );
    buffer.writeln("  updated_at = timezone('utc', now());");
    buffer.writeln();
  }
}

void _writeVerseImport(
  StringBuffer buffer,
  List<ParsedVerse> verses, {
  required String versionId,
}) {
  buffer.writeln(
    "delete from public.content_bible_verses where version_id = ${_sql(versionId)};",
  );
  buffer.writeln();

  const int batchSize = 500;
  for (int start = 0; start < verses.length; start += batchSize) {
    final List<ParsedVerse> batch = verses
        .skip(start)
        .take(batchSize)
        .toList(growable: false);
    buffer.writeln('insert into public.content_bible_verses (');
    buffer.writeln('  version_id,');
    buffer.writeln('  book_id,');
    buffer.writeln('  chapter_number,');
    buffer.writeln('  verse_number,');
    buffer.writeln('  verse_text');
    buffer.writeln(')');
    buffer.writeln('values');

    for (int index = 0; index < batch.length; index++) {
      final ParsedVerse verse = batch[index];
      final String suffix = index == batch.length - 1 ? '' : ',';
      buffer.writeln(
        "  (${_sql(versionId)}, ${_sql(verse.book.id)}, ${verse.chapterNumber}, ${verse.verseNumber}, ${_sql(verse.text)})$suffix",
      );
    }
    buffer.writeln(';');
    buffer.writeln();
  }
}

Set<String> _aliasesFor(CanonicalBook book) {
  final Set<String> aliases = <String>{
    book.name.toLowerCase(),
    book.shortName.toLowerCase(),
    book.osisCode.toLowerCase(),
  };

  final String normalizedName = book.name.toLowerCase().replaceAll(
    RegExp(r'[^a-z0-9]+'),
    '',
  );
  final String normalizedShort = book.shortName.toLowerCase().replaceAll(
    RegExp(r'[^a-z0-9]+'),
    '',
  );
  aliases
    ..add(normalizedName)
    ..add(normalizedShort);

  if (book.name.contains(' ')) {
    aliases.add(book.name.toLowerCase().replaceAll(' ', ''));
  }

  return aliases.where((String alias) => alias.trim().isNotEmpty).toSet();
}

String _sql(String value) {
  return "'${value.replaceAll("'", "''")}'";
}

class _OsisParser {
  _OsisParser(this.xml);

  final String xml;
  final List<ParsedVerse> verses = <ParsedVerse>[];
  final RegExp _tagPattern = RegExp(r'<[^>]+>', multiLine: true, dotAll: true);

  CanonicalBook? _currentBook;
  int? _currentChapterNumber;
  int? _currentVerseNumber;
  final StringBuffer _currentVerseText = StringBuffer();
  int _ignoredDepth = 0;

  List<ParsedVerse> parse() {
    int index = 0;

    for (final RegExpMatch match in _tagPattern.allMatches(xml)) {
      final String textSegment = xml.substring(index, match.start);
      _appendText(textSegment);
      _handleTag(match.group(0)!);
      index = match.end;
    }

    if (index < xml.length) {
      _appendText(xml.substring(index));
    }

    _flushVerse();

    return verses.toList(growable: false);
  }

  void _handleTag(String tag) {
    final String trimmed = tag.trim();
    if (trimmed.startsWith('<?') || trimmed.startsWith('<!')) {
      return;
    }

    final bool isClosing = trimmed.startsWith('</');
    final bool isSelfClosing = trimmed.endsWith('/>');
    final String name = _tagName(trimmed);
    final Map<String, String> attributes = isClosing
        ? const <String, String>{}
        : _attributes(trimmed);

    if (isClosing) {
      if (_ignoredDepth > 0 && _ignoredElements.contains(name)) {
        _ignoredDepth--;
        return;
      }

      if (name == 'verse') {
        _flushVerse();
        return;
      }

      if (name == 'div') {
        _skippingUnsupportedBook = false;
        _currentBook = null;
        _currentChapterNumber = null;
        _currentVerseNumber = null;
        _currentVerseText.clear();
        return;
      }

      return;
    }

    if (_ignoredDepth > 0) {
      if (_ignoredElements.contains(name) && !isSelfClosing) {
        _ignoredDepth++;
      }
      return;
    }

    if (_ignoredElements.contains(name)) {
      if (!isSelfClosing) {
        _ignoredDepth++;
      }
      return;
    }

    if (_breakElements.contains(name)) {
      _appendBreak();
      return;
    }

    switch (name) {
      case 'div':
        if (attributes['type'] == 'book') {
          _flushVerse();
          final String osisCode = attributes['osisID'] ?? '';
          _currentBook = canonicalBookByOsis[osisCode];
          _currentChapterNumber = null;
          _currentVerseNumber = null;
          _currentVerseText.clear();
          _skippingUnsupportedBook = _currentBook == null;
        }
        break;

      case 'chapter':
        if (_skippingUnsupportedBook) return;
        final String? milestone = attributes['sID'] ?? attributes['osisID'];
        if (attributes.containsKey('eID') && !attributes.containsKey('sID')) {
          return;
        }
        if (milestone == null) return;
        final _VerseRef ref = _VerseRef.chapterOnly(milestone);
        _flushVerse();
        _currentBook = ref.book;
        _currentChapterNumber = ref.chapterNumber;
        break;

      case 'verse':
        if (_skippingUnsupportedBook) return;
        if (attributes.containsKey('eID') && !attributes.containsKey('sID')) {
          _flushVerse();
          return;
        }

        final String? milestone = attributes['sID'] ?? attributes['osisID'];
        if (milestone == null) return;
        final _VerseRef ref = _VerseRef.verse(milestone);
        _startVerse(ref);
        break;

      default:
        break;
    }
  }

  void _startVerse(_VerseRef ref) {
    _flushVerse();
    _currentBook = ref.book;
    _currentChapterNumber = ref.chapterNumber;
    _currentVerseNumber = ref.verseNumber;
  }

  void _appendText(String rawText) {
    if (_ignoredDepth > 0 ||
        _currentBook == null ||
        _currentChapterNumber == null ||
        _currentVerseNumber == null) {
      return;
    }

    final String decoded = _decodeXml(rawText);
    if (decoded.trim().isEmpty) {
      if (decoded.contains('\n') ||
          decoded.contains('\r') ||
          decoded.contains('\t')) {
        _appendBreak();
      }
      return;
    }

    final String normalized = decoded.replaceAll(RegExp(r'\s+'), ' ').trim();
    if (normalized.isEmpty) return;

    if (_currentVerseText.isNotEmpty) {
      final String existing = _currentVerseText.toString();
      if (!_endsWithJoiner(existing) && !_startsWithPunctuation(normalized)) {
        _currentVerseText.write(' ');
      }
    }
    _currentVerseText.write(normalized);
  }

  void _appendBreak() {
    if (_currentVerseText.isEmpty) return;
    if (!_currentVerseText.toString().endsWith(' ')) {
      _currentVerseText.write(' ');
    }
  }

  void _flushVerse() {
    if (_currentBook == null ||
        _currentChapterNumber == null ||
        _currentVerseNumber == null) {
      _currentVerseText.clear();
      _currentVerseNumber = null;
      return;
    }

    final String text = _currentVerseText
        .toString()
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
    if (text.isNotEmpty) {
      verses.add(
        ParsedVerse(
          book: _currentBook!,
          chapterNumber: _currentChapterNumber!,
          verseNumber: _currentVerseNumber!,
          text: text,
        ),
      );
    }

    _currentVerseText.clear();
    _currentVerseNumber = null;
  }

  String _tagName(String tag) {
    final int start = tag.startsWith('</') ? 2 : 1;
    final int end = tag.indexOf(RegExp(r'[\s>/]'), start);
    return (end == -1
            ? tag.substring(start, tag.length - 1)
            : tag.substring(start, end))
        .trim();
  }

  Map<String, String> _attributes(String tag) {
    final Map<String, String> attributes = <String, String>{};
    final RegExp exp = RegExp(
      r"""([A-Za-z_:][-A-Za-z0-9_:.]*)\s*=\s*("([^"]*)"|'([^']*)')""",
    );
    for (final RegExpMatch match in exp.allMatches(tag)) {
      final String key = match.group(1)!;
      final String value = match.group(3) ?? match.group(4) ?? '';
      attributes[key] = value;
    }
    return attributes;
  }

  String _decodeXml(String input) {
    String value = input
        .replaceAll('&amp;', '&')
        .replaceAll('&quot;', '"')
        .replaceAll('&apos;', "'")
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>');

    value = value.replaceAllMapped(RegExp(r'&#([0-9]+);'), (Match match) {
      final int? codePoint = int.tryParse(match.group(1)!);
      return codePoint == null
          ? match.group(0)!
          : String.fromCharCode(codePoint);
    });

    value = value.replaceAllMapped(RegExp(r'&#x([0-9A-Fa-f]+);'), (
      Match match,
    ) {
      final int? codePoint = int.tryParse(match.group(1)!, radix: 16);
      return codePoint == null
          ? match.group(0)!
          : String.fromCharCode(codePoint);
    });

    return value;
  }

  bool _startsWithPunctuation(String value) {
    return RegExp(r'^[,.;:!?)]').hasMatch(value);
  }

  bool _endsWithJoiner(String value) {
    return RegExp(r"[\s('\u2018\u201c-]$").hasMatch(value);
  }
}

class _VerseRef {
  const _VerseRef({
    required this.book,
    required this.chapterNumber,
    this.verseNumber,
  });

  final CanonicalBook book;
  final int chapterNumber;
  final int? verseNumber;

  factory _VerseRef.chapterOnly(String raw) {
    final List<String> parts = raw
        .split('.')
        .where((String value) => value.isNotEmpty)
        .toList(growable: false);
    if (parts.length < 2) {
      throw FormatException('Invalid chapter osisID: $raw');
    }
    final CanonicalBook? book = canonicalBookByOsis[parts.first];
    if (book == null) {
      throw StateError('Unknown OSIS book code: ${parts.first}');
    }
    final int? chapterNumber = int.tryParse(parts[1]);
    if (chapterNumber == null) {
      throw FormatException('Invalid chapter number in osisID: $raw');
    }
    return _VerseRef(book: book, chapterNumber: chapterNumber);
  }

  factory _VerseRef.verse(String raw) {
    final List<String> parts = raw
        .split('.')
        .where((String value) => value.isNotEmpty)
        .toList(growable: false);
    if (parts.length < 3) {
      throw FormatException('Invalid verse osisID: $raw');
    }
    final CanonicalBook? book = canonicalBookByOsis[parts.first];
    if (book == null) {
      throw StateError('Unknown OSIS book code: ${parts.first}');
    }
    final int? chapterNumber = int.tryParse(parts[1]);
    final int? verseNumber = int.tryParse(parts[2].split('-').first);
    if (chapterNumber == null || verseNumber == null) {
      throw FormatException('Invalid verse number in osisID: $raw');
    }
    return _VerseRef(
      book: book,
      chapterNumber: chapterNumber,
      verseNumber: verseNumber,
    );
  }
}

import 'dart:io';

import 'import_open_bibles_kjv.dart' as kjv;

const Map<String, String> _canonicalUsfxToOsis = <String, String>{
  'GEN': 'Gen',
  'EXO': 'Exod',
  'LEV': 'Lev',
  'NUM': 'Num',
  'DEU': 'Deut',
  'JOS': 'Josh',
  'JDG': 'Judg',
  'RUT': 'Ruth',
  '1SA': '1Sam',
  '2SA': '2Sam',
  '1KI': '1Kgs',
  '2KI': '2Kgs',
  '1CH': '1Chr',
  '2CH': '2Chr',
  'EZR': 'Ezra',
  'NEH': 'Neh',
  'EST': 'Esth',
  'JOB': 'Job',
  'PSA': 'Ps',
  'PRO': 'Prov',
  'ECC': 'Eccl',
  'SNG': 'Song',
  'ISA': 'Isa',
  'JER': 'Jer',
  'LAM': 'Lam',
  'EZK': 'Ezek',
  'DAN': 'Dan',
  'HOS': 'Hos',
  'JOL': 'Joel',
  'AMO': 'Amos',
  'OBA': 'Obad',
  'JON': 'Jonah',
  'MIC': 'Mic',
  'NAM': 'Nah',
  'HAB': 'Hab',
  'ZEP': 'Zeph',
  'HAG': 'Hag',
  'ZEC': 'Zech',
  'MAL': 'Mal',
  'MAT': 'Matt',
  'MRK': 'Mark',
  'LUK': 'Luke',
  'JHN': 'John',
  'ACT': 'Acts',
  'ROM': 'Rom',
  '1CO': '1Cor',
  '2CO': '2Cor',
  'GAL': 'Gal',
  'EPH': 'Eph',
  'PHP': 'Phil',
  'COL': 'Col',
  '1TH': '1Thess',
  '2TH': '2Thess',
  '1TI': '1Tim',
  '2TI': '2Tim',
  'TIT': 'Titus',
  'PHM': 'Phlm',
  'HEB': 'Heb',
  'JAS': 'Jas',
  '1PE': '1Pet',
  '2PE': '2Pet',
  '1JN': '1John',
  '2JN': '2John',
  '3JN': '3John',
  'JUD': 'Jude',
  'REV': 'Rev',
};

final Map<String, kjv.CanonicalBook> _canonicalBookByUsfxId =
    <String, kjv.CanonicalBook>{
      for (final MapEntry<String, String> entry in _canonicalUsfxToOsis.entries)
        entry.key: kjv.canonicalBookByOsis[entry.value]!,
    };

const Set<String> _ignoredElements = <String>{
  'f',
  'fe',
  'fm',
  'fk',
  'fq',
  'fqa',
  'fl',
  'fw',
  'x',
  'xt',
  'xo',
  'xk',
  'fig',
};

const Set<String> _breakElements = <String>{
  'p',
  'q',
  'q1',
  'q2',
  'q3',
  'q4',
  'm',
  'mi',
  'nb',
  'b',
  'li',
  'li1',
  'li2',
  'li3',
  'li4',
  'pi',
  'pi1',
  'pi2',
  'pi3',
  'pc',
};

Future<void> main(List<String> arguments) async {
  final kjv.ImportOptions options = kjv.parseArguments(
    arguments,
    usageLine:
        'Usage: dart run tool/import_web_usfx.dart --source <eng-web.usfx.xml> --out <output.sql>',
  );
  final File sourceFile = File(options.sourcePath);
  if (!sourceFile.existsSync()) {
    stderr.writeln('Source file not found: ${options.sourcePath}');
    exitCode = 2;
    return;
  }

  final String xml = await sourceFile.readAsString();
  final kjv.ImportDocument document = parseWorldEnglishBibleUsfx(xml);
  final String sql = kjv.buildImportSqlForVersion(
    document,
    versionId: 'web',
    versionName: 'World English Bible',
    sourceDescription: 'World English Bible USFX XML',
    generatorLabel: 'tool/import_web_usfx.dart',
    validationFunctionName: 'validate_web_scripture_import',
    includeCanonicalMetadata: false,
  );

  final File outputFile = File(options.outputPath);
  outputFile.parent.createSync(recursive: true);
  await outputFile.writeAsString(sql);

  stdout.writeln(
    'Generated ${document.verses.length} WEB verses across '
    '${document.chapters.length} chapters into ${outputFile.path}',
  );
}

kjv.ImportDocument parseWorldEnglishBibleUsfx(
  String xml, {
  bool requireCompleteCanon = true,
}) {
  final _UsfxParser parser = _UsfxParser(xml);
  return kjv.buildCanonicalImportDocument(
    parser.parse(),
    requireCompleteCanon: requireCompleteCanon,
  );
}

class _UsfxParser {
  _UsfxParser(this.xml);

  final String xml;
  final List<kjv.ParsedVerse> verses = <kjv.ParsedVerse>[];
  final RegExp _tagPattern = RegExp(r'<[^>]+>', multiLine: true, dotAll: true);

  kjv.CanonicalBook? _currentBook;
  int? _currentChapterNumber;
  int? _currentVerseNumber;
  final StringBuffer _currentVerseText = StringBuffer();
  int _ignoredDepth = 0;
  bool _skippingUnsupportedBook = false;

  List<kjv.ParsedVerse> parse() {
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

      if (name == 'book') {
        _flushVerse();
        _currentBook = null;
        _currentChapterNumber = null;
        _currentVerseNumber = null;
        _currentVerseText.clear();
        _skippingUnsupportedBook = false;
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
      case 'book':
        _flushVerse();
        final String usfxId = attributes['id'] ?? '';
        _currentBook = _canonicalBookByUsfxId[usfxId];
        _currentChapterNumber = null;
        _currentVerseNumber = null;
        _currentVerseText.clear();
        _skippingUnsupportedBook = _currentBook == null;
        break;

      case 'c':
        if (_skippingUnsupportedBook) return;
        final int? chapterNumber = int.tryParse(attributes['id'] ?? '');
        if (chapterNumber == null) {
          throw FormatException('Invalid chapter id: ${attributes['id']}');
        }
        _flushVerse();
        _currentChapterNumber = chapterNumber;
        break;

      case 'v':
        if (_skippingUnsupportedBook) return;
        if (_currentBook == null || _currentChapterNumber == null) {
          throw StateError(
            'Encountered verse before canonical book/chapter context.',
          );
        }
        final int? verseNumber = int.tryParse(attributes['id'] ?? '');
        if (verseNumber == null) {
          throw FormatException('Invalid verse id: ${attributes['id']}');
        }
        _startVerse(verseNumber);
        break;

      case 've':
        if (_skippingUnsupportedBook) return;
        _flushVerse();
        break;

      default:
        break;
    }
  }

  void _startVerse(int verseNumber) {
    _flushVerse();
    _currentVerseNumber = verseNumber;
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
        kjv.ParsedVerse(
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

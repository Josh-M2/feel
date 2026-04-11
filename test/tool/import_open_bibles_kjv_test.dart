import 'package:flutter_test/flutter_test.dart';

import '../../tool/import_open_bibles_kjv.dart';

void main() {
  group('parseOpenBiblesKjvOsis', () {
    test('parses milestone verses, strips notes, and normalizes inline text', () {
      const String xml = '''
<osis>
  <osisText>
    <div type="book" osisID="Gen">
      <chapter osisID="Gen.1" sID="Gen.1"/>
      <verse osisID="Gen.1.1" sID="Gen.1.1"/>In the beginning <note>ignore me</note>God created the heaven and the earth.<verse eID="Gen.1.1"/>
      <verse osisID="Gen.1.2" sID="Gen.1.2"/>And the earth was <q>without form</q>, and void;<lb/>and darkness was upon the face of the deep.<verse eID="Gen.1.2"/>
      <chapter eID="Gen.1"/>
    </div>
  </osisText>
</osis>
''';

      final ImportDocument document = parseOpenBiblesKjvOsis(
        xml,
        requireCompleteCanon: false,
      );

      expect(document.books.length, canonicalBooks.length);
      expect(document.chapters, hasLength(1));
      expect(document.verses, hasLength(2));
      expect(document.verses.first.book.id, 'genesis');
      expect(document.verses.first.chapterNumber, 1);
      expect(document.verses.first.verseNumber, 1);
      expect(
        document.verses.first.text,
        'In the beginning God created the heaven and the earth.',
      );
      expect(
        document.verses[1].text,
        'And the earth was without form, and void; and darkness was upon the face of the deep.',
      );
    });

    test('supports container-style verse tags and xml entities', () {
      const String xml = '''
<osis>
  <osisText>
    <div type="book" osisID="John">
      <chapter osisID="John.1" sID="John.1"/>
      <verse osisID="John.1.1">In the beginning was the Word, and the Word was with God, and the Word was God.</verse>
      <verse osisID="John.1.2">The same was in the beginning with God &amp; with men&#39;s witness.</verse>
    </div>
  </osisText>
</osis>
''';

      final ImportDocument document = parseOpenBiblesKjvOsis(
        xml,
        requireCompleteCanon: false,
      );

      expect(document.chapters.single.book.id, 'john');
      expect(document.verses, hasLength(2));
      expect(
        document.verses[1].text,
        "The same was in the beginning with God & with men's witness.",
      );
    });
  });

  group('buildImportSql', () {
    test('emits idempotent sql for books, aliases, chapters, and verses', () {
      final ImportDocument document = ImportDocument(
        books: canonicalBooks.take(2).toList(growable: false),
        chapters: <ChapterRow>[
          ChapterRow(
            book: canonicalBooks.first,
            chapterNumber: 1,
            title: 'Genesis 1',
          ),
        ],
        verses: <ParsedVerse>[
          ParsedVerse(
            book: canonicalBooks.first,
            chapterNumber: 1,
            verseNumber: 1,
            text: "In the beginning God's word.",
          ),
        ],
      );

      final String sql = buildImportSql(document);

      expect(sql, contains('insert into public.content_bible_versions'));
      expect(
        sql,
        contains("delete from public.content_bible_verses where version_id = 'kjv';"),
      );
      expect(
        sql,
        contains("('kjv', 'genesis', 1, 1, 'In the beginning God''s word.')"),
      );
      expect(sql, contains('on conflict (book_id, alias) do nothing;'));
      expect(sql, contains('select * from public.validate_kjv_scripture_import();'));
    });
  });
}

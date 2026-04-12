-- Phase 10: post-import validation for the World English Bible USFX pipeline.
-- The current schema stores main verse text only in content_bible_verses.
-- WEB footnote-only omitted verses are therefore intentionally absent as
-- normal verse rows and must be validated explicitly.

create or replace function public.validate_web_scripture_import()
returns table (
  check_name text,
  passed boolean,
  details text
)
language sql
stable
as $$
  with
    web_version as (
      select count(*)::integer as count_value
      from public.content_bible_versions
      where id = 'web'
        and is_active = true
    ),
    canonical_books as (
      select count(*)::integer as count_value
      from public.content_bible_books
      where is_active = true
        and osis_code is not null
        and book_number is not null
    ),
    web_empty_chapters as (
      select count(*)::integer as count_value
      from (
        select 1
        from public.content_bible_chapters chapters
        join public.content_bible_books books
          on books.id = chapters.book_id
        left join public.content_bible_verses verses
          on verses.book_id = chapters.book_id
         and verses.chapter_number = chapters.chapter_number
         and verses.version_id = 'web'
        where books.is_active = true
          and books.osis_code is not null
          and books.book_number is not null
        group by chapters.book_id, chapters.chapter_number
        having count(verses.verse_number) = 0
      ) empty_rows
    ),
    web_verses as (
      select count(*)::integer as count_value
      from public.content_bible_verses
      where version_id = 'web'
    ),
    blank_web_verses as (
      select count(*)::integer as count_value
      from public.content_bible_verses
      where version_id = 'web'
        and btrim(verse_text) = ''
    ),
    expected_missing_web_verses as (
      select 'acts'::text as book_id, 8::integer as chapter_number, 37::integer as verse_number
      union all
      select 'acts', 15, 34
      union all
      select 'acts', 24, 7
      union all
      select 'luke', 17, 36
    ),
    expected_missing_web_verse_presence as (
      select
        expected.book_id,
        expected.chapter_number,
        expected.verse_number,
        exists (
          select 1
          from public.content_bible_verses verses
          where verses.version_id = 'web'
            and verses.book_id = expected.book_id
            and verses.chapter_number = expected.chapter_number
            and verses.verse_number = expected.verse_number
        ) as verse_exists
      from expected_missing_web_verses expected
    ),
    expected_missing_web_verses_present as (
      select count(*)::integer as count_value
      from expected_missing_web_verse_presence
      where verse_exists = true
    )
  select
    'web_version_present'::text,
    (select count_value = 1 from web_version),
    'Expected one active WEB row in public.content_bible_versions.'::text
  union all
  select
    'canonical_book_count',
    (select count_value = 66 from canonical_books),
    'Expected 66 active canonical books with osis_code and book_number.'::text
  union all
  select
    'chapters_have_web_verses',
    (select count_value = 0 from web_empty_chapters),
    'Every canonical chapter should have at least one WEB verse row.'::text
  union all
  select
    'web_verse_count',
    (select count_value = 31098 from web_verses),
    'Expected 31,098 WEB main-text verse rows under the current schema semantics.'::text
  union all
  select
    'web_verses_not_blank',
    (select count_value = 0 from blank_web_verses),
    'Imported WEB verse_text values should never be blank.'::text
  union all
  select
    'web_expected_footnote_only_verses_absent',
    (select count_value = 0 from expected_missing_web_verses_present),
    'acts 8:37, acts 15:34, acts 24:7, and luke 17:36 should be absent as WEB main-text verse rows under the current schema semantics.'::text;
$$;

# Supabase Scripture Import Workflow

This repo now supports a repeatable Open Bibles KJV import pipeline without changing the runtime Flutter feature code in `lib/`.

## What This Phase Adds

- `supabase/migrations/202604088_open_bibles_kjv_import_validation.sql`
  - finalizes schema for canonical KJV import
  - adds `osis_code`, `book_number`, and `short_name` support on `content_bible_books`
  - adds the missing `content_daily_verse_pool` and `user_daily_assignments` tables required by the checked-in app code
  - adds `public.validate_kjv_scripture_import()` for post-import validation
- `tool/import_open_bibles_kjv.dart`
  - parses an Open Bibles KJV OSIS XML source file
  - generates idempotent SQL to upsert books, aliases, chapters, and KJV verses
- `test/tool/import_open_bibles_kjv_test.dart`
  - covers parser behavior and SQL generation

## Source Input

Use the Open Bibles KJV OSIS XML source file, such as the `eng-kjv.osis.xml` export from the Open Bibles dataset.

This workflow expects an OSIS XML file with canonical Protestant book/chapter/verse structure.

## Run Order

1. Apply migrations so the finalized scripture schema exists.
2. Generate the KJV import SQL from the Open Bibles source file.
3. Apply the generated SQL to Supabase.
4. Run the validation query and confirm every check passes.

## Commands

From the repo root:

```powershell
flutter test test/tool/import_open_bibles_kjv_test.dart
```

```powershell
dart run tool/import_open_bibles_kjv.dart --source <path-to-eng-kjv.osis.xml> --out supabase/generated/open_bibles_kjv_import.sql
```

Then apply the generated SQL after your normal migration flow. Example options:

- Supabase SQL editor
- `supabase db push` for migrations, then paste/run the generated SQL
- `psql` against the target Postgres database

## Validation Query

Run this after the generated import SQL succeeds:

```sql
select * from public.validate_kjv_scripture_import();
```

Expected outcomes:

- `kjv_version_present` = `true`
- `canonical_book_count` = `true`
- `chapter_counts_match_books` = `true`
- `chapters_have_kjv_verses` = `true`
- `kjv_verse_count` = `true`
- `kjv_verses_not_blank` = `true`
- `today_pool_table_present` = `true`
- `today_assignments_table_present` = `true`

## Repeatable Import Notes

- The importer always generates KJV-only verse import SQL.
- Book metadata is upserted, so reruns do not require manual cleanup.
- Book aliases are rebuilt from the canonical importer mapping on each run.
- KJV verse rows are deleted and fully reinserted on each run so the import stays deterministic.
- Existing curated `content_chapter_sections` are intentionally left untouched in this phase.
- Existing richer chapter metadata can remain in place; the importer only guarantees a structural chapter row for every chapter.

## Operational Edge Cases

- If the OSIS file is missing canonical books or chapters, the importer throws before generating SQL.
- If duplicate verses are present, the importer throws before generating SQL.
- If blank verse text is parsed, the importer throws before generating SQL.
- If Supabase validation fails after import, treat the generated SQL as incomplete or the source file as malformed and rerun with a known-good Open Bibles file.

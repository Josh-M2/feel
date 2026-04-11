-- Phase 8: finalize scripture import schema for Open Bibles KJV
-- Adds canonical book metadata, closes the Today schema gap, and exposes
-- a validation function that can be run after each KJV import.

alter table public.content_bible_books
  add column if not exists short_name text not null default '',
  add column if not exists osis_code text,
  add column if not exists book_number integer;

alter table public.content_bible_books
  drop constraint if exists content_bible_books_book_number_check;

alter table public.content_bible_books
  add constraint content_bible_books_book_number_check
  check (book_number is null or (book_number >= 1 and book_number <= 66));

create unique index if not exists content_bible_books_osis_code_uidx
  on public.content_bible_books(osis_code)
  where osis_code is not null;

create unique index if not exists content_bible_books_book_number_uidx
  on public.content_bible_books(book_number)
  where book_number is not null;

create table if not exists public.content_daily_verse_pool (
  id text primary key,
  category_label text not null,
  reference_label text not null,
  translation_code text not null references public.content_bible_versions(id) on delete restrict,
  verse_text_fallback text not null,
  reflection_prompt text not null default '',
  encouragement_line text not null default '',
  context_summary text not null default '',
  context_sections jsonb not null default '[]'::jsonb,
  related_passages jsonb not null default '[]'::jsonb,
  key_insights jsonb not null default '[]'::jsonb,
  prayer text not null default '',
  sort_order integer not null default 0,
  is_active boolean not null default true,
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now()),
  constraint content_daily_verse_pool_context_sections_array_check
    check (jsonb_typeof(context_sections) = 'array'),
  constraint content_daily_verse_pool_related_passages_array_check
    check (jsonb_typeof(related_passages) = 'array'),
  constraint content_daily_verse_pool_key_insights_array_check
    check (jsonb_typeof(key_insights) = 'array')
);

create index if not exists content_daily_verse_pool_active_sort_idx
  on public.content_daily_verse_pool(is_active, sort_order, category_label);

create index if not exists content_daily_verse_pool_reference_idx
  on public.content_daily_verse_pool(reference_label);

alter table public.content_daily_verse_pool enable row level security;

drop policy if exists "public read daily verse pool" on public.content_daily_verse_pool;
create policy "public read daily verse pool"
  on public.content_daily_verse_pool
  for select
  to anon, authenticated
  using (is_active = true);

create table if not exists public.user_daily_assignments (
  user_id uuid not null references auth.users(id) on delete cascade,
  local_date date not null,
  timezone_name text not null default 'UTC',
  category_label text not null,
  reference_label text not null,
  translation_code text not null references public.content_bible_versions(id) on delete restrict,
  translation_label text not null default '',
  verse_text_snapshot text not null,
  reflection_prompt text not null default '',
  encouragement_line text not null default '',
  context_summary text not null default '',
  prayer text not null default '',
  details_json jsonb not null default '{}'::jsonb,
  assigned_at timestamptz not null default timezone('utc', now()),
  opened_at timestamptz,
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now()),
  primary key (user_id, local_date),
  constraint user_daily_assignments_details_object_check
    check (jsonb_typeof(details_json) = 'object')
);

create index if not exists user_daily_assignments_user_assigned_idx
  on public.user_daily_assignments(user_id, assigned_at desc);

create index if not exists user_daily_assignments_reference_idx
  on public.user_daily_assignments(reference_label);

alter table public.user_daily_assignments enable row level security;

drop policy if exists "users read own daily assignments" on public.user_daily_assignments;
create policy "users read own daily assignments"
  on public.user_daily_assignments
  for select
  to authenticated
  using (auth.uid() is not null and auth.uid() = user_id);

drop policy if exists "users insert own daily assignments" on public.user_daily_assignments;
create policy "users insert own daily assignments"
  on public.user_daily_assignments
  for insert
  to authenticated
  with check (auth.uid() is not null and auth.uid() = user_id);

drop policy if exists "users update own daily assignments" on public.user_daily_assignments;
create policy "users update own daily assignments"
  on public.user_daily_assignments
  for update
  to authenticated
  using (auth.uid() is not null and auth.uid() = user_id)
  with check (auth.uid() is not null and auth.uid() = user_id);

drop policy if exists "users delete own daily assignments" on public.user_daily_assignments;
create policy "users delete own daily assignments"
  on public.user_daily_assignments
  for delete
  to authenticated
  using (auth.uid() is not null and auth.uid() = user_id);

create or replace function public.set_content_daily_verse_pool_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = timezone('utc', now());
  return new;
end;
$$;

drop trigger if exists trg_content_daily_verse_pool_updated_at on public.content_daily_verse_pool;
create trigger trg_content_daily_verse_pool_updated_at
before update on public.content_daily_verse_pool
for each row
execute function public.set_content_daily_verse_pool_updated_at();

create or replace function public.set_user_daily_assignments_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = timezone('utc', now());
  return new;
end;
$$;

drop trigger if exists trg_user_daily_assignments_updated_at on public.user_daily_assignments;
create trigger trg_user_daily_assignments_updated_at
before update on public.user_daily_assignments
for each row
execute function public.set_user_daily_assignments_updated_at();

create or replace function public.validate_kjv_scripture_import()
returns table (
  check_name text,
  passed boolean,
  details text
)
language sql
stable
as $$
  with
    kjv_version as (
      select count(*)::integer as count_value
      from public.content_bible_versions
      where id = 'kjv'
        and is_active = true
    ),
    kjv_books as (
      select count(*)::integer as count_value
      from public.content_bible_books
      where is_active = true
        and osis_code is not null
        and book_number is not null
    ),
    chapter_mismatches as (
      select count(*)::integer as count_value
      from (
        select
          books.id,
          books.chapter_count,
          count(chapters.chapter_number)::integer as actual_chapters
        from public.content_bible_books books
        left join public.content_bible_chapters chapters
          on chapters.book_id = books.id
        where books.is_active = true
          and books.osis_code is not null
          and books.book_number is not null
        group by books.id, books.chapter_count
        having count(chapters.chapter_number)::integer <> books.chapter_count
      ) mismatches
    ),
    empty_chapters as (
      select count(*)::integer as count_value
      from (
        select 1
        from public.content_bible_chapters chapters
        left join public.content_bible_verses verses
          on verses.book_id = chapters.book_id
         and verses.chapter_number = chapters.chapter_number
         and verses.version_id = 'kjv'
        group by chapters.book_id, chapters.chapter_number
        having count(verses.verse_number) = 0
      ) empty_rows
    ),
    kjv_verses as (
      select count(*)::integer as count_value
      from public.content_bible_verses
      where version_id = 'kjv'
    ),
    blank_verses as (
      select count(*)::integer as count_value
      from public.content_bible_verses
      where version_id = 'kjv'
        and btrim(verse_text) = ''
    ),
    today_pool_table as (
      select count(*)::integer as count_value
      from information_schema.tables
      where table_schema = 'public'
        and table_name = 'content_daily_verse_pool'
    ),
    today_assignments_table as (
      select count(*)::integer as count_value
      from information_schema.tables
      where table_schema = 'public'
        and table_name = 'user_daily_assignments'
    )
  select
    'kjv_version_present'::text,
    (select count_value = 1 from kjv_version),
    'Expected one active KJV row in public.content_bible_versions.'::text
  union all
  select
    'canonical_book_count',
    (select count_value = 66 from kjv_books),
    'Expected 66 active canonical books with osis_code and book_number.'::text
  union all
  select
    'chapter_counts_match_books',
    (select count_value = 0 from chapter_mismatches),
    'Each active canonical book should have exactly chapter_count rows in public.content_bible_chapters.'::text
  union all
  select
    'chapters_have_kjv_verses',
    (select count_value = 0 from empty_chapters),
    'Every imported chapter should have at least one KJV verse row.'::text
  union all
  select
    'kjv_verse_count',
    (select count_value = 31102 from kjv_verses),
    'Expected 31,102 KJV verse rows from the Open Bibles import.'::text
  union all
  select
    'kjv_verses_not_blank',
    (select count_value = 0 from blank_verses),
    'Imported verse_text values should never be blank.'::text
  union all
  select
    'today_pool_table_present',
    (select count_value = 1 from today_pool_table),
    'The checked-in app expects public.content_daily_verse_pool to exist.'::text
  union all
  select
    'today_assignments_table_present',
    (select count_value = 1 from today_assignments_table),
    'The checked-in app expects public.user_daily_assignments to exist.'::text;
$$;

-- Phase 2: public scripture content foundation for Read
-- Public-read tables only. User-specific continuity remains in later phases.

create extension if not exists pgcrypto;

create table if not exists public.content_categories (
  key text primary key,
  name text not null,
  description text not null default '',
  sort_order integer not null default 0,
  is_active boolean not null default true,
  created_at timestamptz not null default timezone('utc', now())
);

create table if not exists public.content_bible_versions (
  id text primary key,
  name text not null,
  language_code text not null default 'en',
  is_default boolean not null default false,
  is_public_domain boolean not null default true,
  is_active boolean not null default true,
  created_at timestamptz not null default timezone('utc', now())
);

create table if not exists public.content_bible_books (
  id text primary key,
  name text not null,
  testament text not null check (testament in ('Old Testament', 'New Testament')),
  sort_order integer not null,
  chapter_count integer not null check (chapter_count > 0),
  short_description text not null default '',
  overview text not null default '',
  why_read text not null default '',
  key_themes text[] not null default '{}',
  preferred_continue_chapter integer not null default 1,
  is_featured_default boolean not null default false,
  is_active boolean not null default true,
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now()),
  constraint content_bible_books_preferred_continue_valid
    check (preferred_continue_chapter >= 1 and preferred_continue_chapter <= chapter_count)
);

create table if not exists public.content_book_aliases (
  book_id text not null references public.content_bible_books(id) on delete cascade,
  alias text not null,
  created_at timestamptz not null default timezone('utc', now()),
  primary key (book_id, alias)
);

create table if not exists public.content_bible_chapters (
  book_id text not null references public.content_bible_books(id) on delete cascade,
  chapter_number integer not null check (chapter_number > 0),
  title text not null,
  introduction text not null default '',
  focus_line text not null default '',
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now()),
  primary key (book_id, chapter_number)
);

create table if not exists public.content_chapter_sections (
  id uuid primary key default gen_random_uuid(),
  book_id text not null,
  chapter_number integer not null,
  sort_order integer not null default 0,
  heading text not null,
  verse_start integer not null check (verse_start > 0),
  verse_end integer not null check (verse_end >= verse_start),
  created_at timestamptz not null default timezone('utc', now()),
  constraint content_chapter_sections_chapter_fk
    foreign key (book_id, chapter_number)
    references public.content_bible_chapters(book_id, chapter_number)
    on delete cascade
);

create table if not exists public.content_bible_verses (
  version_id text not null references public.content_bible_versions(id) on delete cascade,
  book_id text not null references public.content_bible_books(id) on delete cascade,
  chapter_number integer not null check (chapter_number > 0),
  verse_number integer not null check (verse_number > 0),
  verse_text text not null,
  search_document tsvector generated always as (to_tsvector('simple', coalesce(verse_text, ''))) stored,
  created_at timestamptz not null default timezone('utc', now()),
  primary key (version_id, book_id, chapter_number, verse_number),
  constraint content_bible_verses_chapter_fk
    foreign key (book_id, chapter_number)
    references public.content_bible_chapters(book_id, chapter_number)
    on delete cascade
);

create index if not exists content_bible_books_sort_order_idx
  on public.content_bible_books(sort_order);
create index if not exists content_book_aliases_alias_idx
  on public.content_book_aliases(lower(alias));
create index if not exists content_bible_chapters_book_chapter_idx
  on public.content_bible_chapters(book_id, chapter_number);
create index if not exists content_chapter_sections_book_chapter_sort_idx
  on public.content_chapter_sections(book_id, chapter_number, sort_order);
create index if not exists content_bible_verses_book_chapter_verse_idx
  on public.content_bible_verses(book_id, chapter_number, verse_number);
create index if not exists content_bible_verses_search_document_idx
  on public.content_bible_verses using gin(search_document);

alter table public.content_categories enable row level security;
alter table public.content_bible_versions enable row level security;
alter table public.content_bible_books enable row level security;
alter table public.content_book_aliases enable row level security;
alter table public.content_bible_chapters enable row level security;
alter table public.content_chapter_sections enable row level security;
alter table public.content_bible_verses enable row level security;

drop policy if exists "public read categories" on public.content_categories;
create policy "public read categories"
  on public.content_categories
  for select
  to anon, authenticated
  using (is_active = true);

drop policy if exists "public read bible versions" on public.content_bible_versions;
create policy "public read bible versions"
  on public.content_bible_versions
  for select
  to anon, authenticated
  using (is_active = true);

drop policy if exists "public read bible books" on public.content_bible_books;
create policy "public read bible books"
  on public.content_bible_books
  for select
  to anon, authenticated
  using (is_active = true);

drop policy if exists "public read book aliases" on public.content_book_aliases;
create policy "public read book aliases"
  on public.content_book_aliases
  for select
  to anon, authenticated
  using (
    exists (
      select 1
      from public.content_bible_books books
      where books.id = content_book_aliases.book_id
        and books.is_active = true
    )
  );

drop policy if exists "public read bible chapters" on public.content_bible_chapters;
create policy "public read bible chapters"
  on public.content_bible_chapters
  for select
  to anon, authenticated
  using (
    exists (
      select 1
      from public.content_bible_books books
      where books.id = content_bible_chapters.book_id
        and books.is_active = true
    )
  );

drop policy if exists "public read chapter sections" on public.content_chapter_sections;
create policy "public read chapter sections"
  on public.content_chapter_sections
  for select
  to anon, authenticated
  using (
    exists (
      select 1
      from public.content_bible_books books
      where books.id = content_chapter_sections.book_id
        and books.is_active = true
    )
  );

drop policy if exists "public read bible verses" on public.content_bible_verses;
create policy "public read bible verses"
  on public.content_bible_verses
  for select
  to anon, authenticated
  using (
    exists (
      select 1
      from public.content_bible_books books
      join public.content_bible_versions versions
        on versions.id = content_bible_verses.version_id
      where books.id = content_bible_verses.book_id
        and books.is_active = true
        and versions.is_active = true
    )
  );

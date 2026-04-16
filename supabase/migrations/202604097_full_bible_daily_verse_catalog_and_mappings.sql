-- Phase 12: full-Bible daily verse selection foundation.
-- Separates full scripture eligibility from app-owned category mappings so
-- Today can draw from the whole Bible while category curation grows over time.

create table if not exists public.content_daily_verse_catalog (
  translation_code text not null references public.content_bible_versions(id) on delete cascade,
  book_id text not null references public.content_bible_books(id) on delete cascade,
  chapter_number integer not null check (chapter_number > 0),
  verse_number integer not null check (verse_number > 0),
  reference_label text not null,
  is_active boolean not null default true,
  created_at timestamptz not null default timezone('utc', now()),
  primary key (translation_code, book_id, chapter_number, verse_number)
);

create index if not exists content_daily_verse_catalog_translation_idx
  on public.content_daily_verse_catalog(translation_code, book_id, chapter_number, verse_number);

alter table public.content_daily_verse_catalog enable row level security;

drop policy if exists "public read daily verse catalog" on public.content_daily_verse_catalog;
create policy "public read daily verse catalog"
  on public.content_daily_verse_catalog
  for select
  to anon, authenticated
  using (is_active = true);

create table if not exists public.content_verse_category_mappings (
  category_key text not null references public.content_categories(key) on delete cascade,
  translation_code text not null references public.content_bible_versions(id) on delete cascade,
  book_id text not null references public.content_bible_books(id) on delete cascade,
  chapter_number integer not null check (chapter_number > 0),
  verse_start integer not null check (verse_start > 0),
  verse_end integer not null check (verse_end >= verse_start),
  reference_label text not null,
  weight integer not null default 1 check (weight > 0),
  is_active boolean not null default true,
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now()),
  primary key (
    category_key,
    translation_code,
    book_id,
    chapter_number,
    verse_start,
    verse_end
  )
);

create index if not exists content_verse_category_mappings_lookup_idx
  on public.content_verse_category_mappings(category_key, translation_code, is_active, book_id, chapter_number, verse_start, verse_end);

alter table public.content_verse_category_mappings enable row level security;

drop policy if exists "public read verse category mappings" on public.content_verse_category_mappings;
create policy "public read verse category mappings"
  on public.content_verse_category_mappings
  for select
  to anon, authenticated
  using (is_active = true);

create or replace function public.set_content_verse_category_mappings_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = timezone('utc', now());
  return new;
end;
$$;

drop trigger if exists trg_content_verse_category_mappings_updated_at on public.content_verse_category_mappings;
create trigger trg_content_verse_category_mappings_updated_at
before update on public.content_verse_category_mappings
for each row
execute function public.set_content_verse_category_mappings_updated_at();

insert into public.content_daily_verse_catalog (
  translation_code,
  book_id,
  chapter_number,
  verse_number,
  reference_label,
  is_active
)
select
  verses.version_id,
  verses.book_id,
  verses.chapter_number,
  verses.verse_number,
  books.name || ' ' || verses.chapter_number::text || ':' || verses.verse_number::text,
  true
from public.content_bible_verses verses
join public.content_bible_books books
  on books.id = verses.book_id
where verses.version_id in ('kjv', 'web')
  and books.is_active = true
on conflict (translation_code, book_id, chapter_number, verse_number) do update
set
  reference_label = excluded.reference_label,
  is_active = true;

insert into public.content_verse_category_mappings (
  category_key,
  translation_code,
  book_id,
  chapter_number,
  verse_start,
  verse_end,
  reference_label,
  weight,
  is_active
)
select
  case lower(pool.category_label)
    when 'guidance' then 'guidance'
    when 'hope' then 'hope'
    when 'strength' then 'strength'
    when 'peace over anxiety' then 'peace_over_anxiety'
    when 'comfort and healing' then 'comfort_and_healing'
    when 'faith in doubt' then 'faith_in_doubt'
    when 'obedience' then 'obedience'
    when 'forgiveness' then 'forgiveness'
    when 'purpose and calling' then 'purpose_and_calling'
    when 'love and relationships' then 'love_and_relationships'
    when 'gratitude and joy' then 'gratitude_and_joy'
    else null
  end as category_key,
  pool.translation_code,
  pool.book_id,
  pool.chapter_number,
  pool.verse_start,
  pool.verse_end,
  pool.reference_label,
  5,
  pool.is_active
from public.content_daily_verse_pool pool
where pool.book_id is not null
  and pool.chapter_number is not null
  and pool.verse_start is not null
  and pool.verse_end is not null
  and pool.translation_code in ('kjv', 'web')
  and case lower(pool.category_label)
    when 'guidance' then 'guidance'
    when 'hope' then 'hope'
    when 'strength' then 'strength'
    when 'peace over anxiety' then 'peace_over_anxiety'
    when 'comfort and healing' then 'comfort_and_healing'
    when 'faith in doubt' then 'faith_in_doubt'
    when 'obedience' then 'obedience'
    when 'forgiveness' then 'forgiveness'
    when 'purpose and calling' then 'purpose_and_calling'
    when 'love and relationships' then 'love_and_relationships'
    when 'gratitude and joy' then 'gratitude_and_joy'
    else null
  end is not null
on conflict (
  category_key,
  translation_code,
  book_id,
  chapter_number,
  verse_start,
  verse_end
) do update
set
  reference_label = excluded.reference_label,
  weight = excluded.weight,
  is_active = excluded.is_active;

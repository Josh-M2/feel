-- Phase 13: rename the old curated pool into an editorial override table.
-- Keeps a compatibility view at the old name so existing app/query paths do
-- not break immediately while the codebase converges on the new terminology.

do $$
begin
  if exists (
    select 1
    from information_schema.tables
    where table_schema = 'public'
      and table_name = 'content_daily_verse_pool'
  ) and not exists (
    select 1
    from information_schema.tables
    where table_schema = 'public'
      and table_name = 'content_daily_verse_editorial_overrides'
  ) then
    alter table public.content_daily_verse_pool
      rename to content_daily_verse_editorial_overrides;
  end if;
end
$$;

alter index if exists public.content_daily_verse_pool_active_sort_idx
  rename to content_daily_verse_editorial_overrides_active_sort_idx;

alter index if exists public.content_daily_verse_pool_reference_idx
  rename to content_daily_verse_editorial_overrides_reference_idx;

alter index if exists public.content_daily_verse_pool_book_reference_idx
  rename to content_daily_verse_editorial_overrides_book_reference_idx;

alter index if exists public.content_daily_verse_pool_category_reference_uidx
  rename to content_daily_verse_editorial_overrides_category_reference_uidx;

do $$
begin
  if exists (
    select 1
    from information_schema.table_constraints
    where table_schema = 'public'
      and table_name = 'content_daily_verse_editorial_overrides'
      and constraint_name = 'content_daily_verse_pool_book_fk'
  ) then
    alter table public.content_daily_verse_editorial_overrides
      rename constraint content_daily_verse_pool_book_fk
      to content_daily_verse_editorial_overrides_book_fk;
  end if;

  if exists (
    select 1
    from information_schema.table_constraints
    where table_schema = 'public'
      and table_name = 'content_daily_verse_editorial_overrides'
      and constraint_name = 'content_daily_verse_pool_normalized_reference_check'
  ) then
    alter table public.content_daily_verse_editorial_overrides
      rename constraint content_daily_verse_pool_normalized_reference_check
      to content_daily_verse_editorial_overrides_normalized_reference_check;
  end if;
end
$$;

create or replace function public.set_content_daily_verse_editorial_overrides_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = timezone('utc', now());
  return new;
end;
$$;

drop trigger if exists trg_content_daily_verse_pool_updated_at on public.content_daily_verse_editorial_overrides;
drop trigger if exists trg_content_daily_verse_editorial_overrides_updated_at on public.content_daily_verse_editorial_overrides;

create trigger trg_content_daily_verse_editorial_overrides_updated_at
before update on public.content_daily_verse_editorial_overrides
for each row
execute function public.set_content_daily_verse_editorial_overrides_updated_at();

drop view if exists public.content_daily_verse_pool;

create view public.content_daily_verse_pool as
select *
from public.content_daily_verse_editorial_overrides;

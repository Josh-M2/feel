-- Phase 7: multi-translation Read foundation + Today remote sync cleanup metadata.

insert into public.content_bible_versions (
  id,
  name,
  language_code,
  is_default,
  is_public_domain,
  is_active
)
values ('web', 'World English Bible', 'en', false, true, true)
on conflict (id) do update
set
  name = excluded.name,
  language_code = excluded.language_code,
  is_default = excluded.is_default,
  is_public_domain = excluded.is_public_domain,
  is_active = excluded.is_active;

alter table public.user_read_progress
  add column if not exists version_code text not null default 'kjv',
  add column if not exists version_label text not null default 'KJV';

alter table public.user_read_progress
  drop constraint if exists user_read_progress_version_code_check;

alter table public.user_read_progress
  add constraint user_read_progress_version_code_check
  check (version_code in ('kjv', 'web'));

update public.user_read_progress
set
  version_code = case
    when lower(coalesce(version_code, 'kjv')) in ('kjv', 'web') then lower(version_code)
    else 'kjv'
  end,
  version_label = case
    when lower(coalesce(version_code, 'kjv')) = 'web' then 'WEB'
    else 'KJV'
  end;

create index if not exists user_read_progress_user_version_last_opened_idx
  on public.user_read_progress(user_id, version_code, last_opened_at desc);

alter table public.user_daily_assignments
  add column if not exists updated_at timestamptz not null default timezone('utc', now());

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

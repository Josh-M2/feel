-- Phase 14: normalize active user preference, assignment, read progress,
-- and reading plan domains while preserving compatibility during rollout.

create table if not exists public.user_content_preferences (
  user_id uuid primary key references auth.users(id) on delete cascade,
  onboarding_completed boolean not null default false,
  preferred_translation_code text not null default 'kjv'
    references public.content_bible_versions(id) on delete restrict,
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now())
);

create table if not exists public.user_notification_preferences (
  user_id uuid primary key references auth.users(id) on delete cascade,
  notifications_enabled boolean not null default false,
  notification_time_local time not null default '07:00:00',
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now())
);

create table if not exists public.user_widget_preferences (
  user_id uuid primary key references auth.users(id) on delete cascade,
  widget_preview_style text not null default 'cozy'
    check (widget_preview_style in ('cozy', 'minimal')),
  widget_show_reference boolean not null default true,
  widget_show_category boolean not null default true,
  widget_show_date boolean not null default true,
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now())
);

alter table public.user_content_preferences enable row level security;
alter table public.user_notification_preferences enable row level security;
alter table public.user_widget_preferences enable row level security;

drop policy if exists "user_content_preferences_select_own" on public.user_content_preferences;
create policy "user_content_preferences_select_own"
on public.user_content_preferences
for select
to authenticated
using (auth.uid() is not null and auth.uid() = user_id);

drop policy if exists "user_content_preferences_insert_own" on public.user_content_preferences;
create policy "user_content_preferences_insert_own"
on public.user_content_preferences
for insert
to authenticated
with check (auth.uid() is not null and auth.uid() = user_id);

drop policy if exists "user_content_preferences_update_own" on public.user_content_preferences;
create policy "user_content_preferences_update_own"
on public.user_content_preferences
for update
to authenticated
using (auth.uid() is not null and auth.uid() = user_id)
with check (auth.uid() is not null and auth.uid() = user_id);

drop policy if exists "user_notification_preferences_select_own" on public.user_notification_preferences;
create policy "user_notification_preferences_select_own"
on public.user_notification_preferences
for select
to authenticated
using (auth.uid() is not null and auth.uid() = user_id);

drop policy if exists "user_notification_preferences_insert_own" on public.user_notification_preferences;
create policy "user_notification_preferences_insert_own"
on public.user_notification_preferences
for insert
to authenticated
with check (auth.uid() is not null and auth.uid() = user_id);

drop policy if exists "user_notification_preferences_update_own" on public.user_notification_preferences;
create policy "user_notification_preferences_update_own"
on public.user_notification_preferences
for update
to authenticated
using (auth.uid() is not null and auth.uid() = user_id)
with check (auth.uid() is not null and auth.uid() = user_id);

drop policy if exists "user_widget_preferences_select_own" on public.user_widget_preferences;
create policy "user_widget_preferences_select_own"
on public.user_widget_preferences
for select
to authenticated
using (auth.uid() is not null and auth.uid() = user_id);

drop policy if exists "user_widget_preferences_insert_own" on public.user_widget_preferences;
create policy "user_widget_preferences_insert_own"
on public.user_widget_preferences
for insert
to authenticated
with check (auth.uid() is not null and auth.uid() = user_id);

drop policy if exists "user_widget_preferences_update_own" on public.user_widget_preferences;
create policy "user_widget_preferences_update_own"
on public.user_widget_preferences
for update
to authenticated
using (auth.uid() is not null and auth.uid() = user_id)
with check (auth.uid() is not null and auth.uid() = user_id);

drop trigger if exists trg_user_content_preferences_updated_at on public.user_content_preferences;
create trigger trg_user_content_preferences_updated_at
before update on public.user_content_preferences
for each row execute procedure public.set_updated_at();

drop trigger if exists trg_user_notification_preferences_updated_at on public.user_notification_preferences;
create trigger trg_user_notification_preferences_updated_at
before update on public.user_notification_preferences
for each row execute procedure public.set_updated_at();

drop trigger if exists trg_user_widget_preferences_updated_at on public.user_widget_preferences;
create trigger trg_user_widget_preferences_updated_at
before update on public.user_widget_preferences
for each row execute procedure public.set_updated_at();

insert into public.user_content_preferences (
  user_id,
  onboarding_completed,
  preferred_translation_code
)
select
  user_id,
  onboarding_completed,
  coalesce(preferred_translation_code, 'kjv')
from public.user_preferences
on conflict (user_id) do update
set
  onboarding_completed = excluded.onboarding_completed,
  preferred_translation_code = excluded.preferred_translation_code;

insert into public.user_notification_preferences (
  user_id,
  notifications_enabled,
  notification_time_local
)
select
  user_id,
  notifications_enabled,
  notification_time_local
from public.user_preferences
on conflict (user_id) do update
set
  notifications_enabled = excluded.notifications_enabled,
  notification_time_local = excluded.notification_time_local;

insert into public.user_widget_preferences (
  user_id,
  widget_preview_style,
  widget_show_reference,
  widget_show_category,
  widget_show_date
)
select
  user_id,
  widget_preview_style,
  widget_show_reference,
  widget_show_category,
  widget_show_date
from public.user_preferences
on conflict (user_id) do update
set
  widget_preview_style = excluded.widget_preview_style,
  widget_show_reference = excluded.widget_show_reference,
  widget_show_category = excluded.widget_show_category,
  widget_show_date = excluded.widget_show_date;

alter table public.user_read_progress
  add column if not exists snapshot_json jsonb not null default '{}'::jsonb;

alter table public.user_read_progress
  drop constraint if exists user_read_progress_snapshot_json_object_check;

alter table public.user_read_progress
  add constraint user_read_progress_snapshot_json_object_check
  check (jsonb_typeof(snapshot_json) = 'object');

-- The snapshot_json column will be used to store a JSON representation of the user's read progress for the current day, allowing for more flexible querying and future extensibility without needing to alter the table schema for additional fields.

alter table public.user_daily_assignments
  add column if not exists category_key text references public.content_categories(key) on delete restrict,
  add column if not exists book_id text references public.content_bible_books(id) on delete restrict,
  add column if not exists chapter_number integer,
  add column if not exists verse_start integer,
  add column if not exists verse_end integer;

create index if not exists user_daily_assignments_book_reference_idx
  on public.user_daily_assignments(book_id, chapter_number, verse_start, verse_end);

update public.user_daily_assignments assignments
set
  category_key = case lower(assignments.category_label)
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
    else assignments.category_key
  end
where assignments.category_key is null;

update public.user_daily_assignments assignments
set
  book_id = overrides.book_id,
  chapter_number = overrides.chapter_number,
  verse_start = overrides.verse_start,
  verse_end = overrides.verse_end
from public.content_daily_verse_editorial_overrides overrides
where assignments.book_id is null
  and overrides.translation_code = assignments.translation_code
  and overrides.reference_label = assignments.reference_label;

alter table public.content_reading_plans
  add column if not exists category_key text references public.content_categories(key) on delete restrict;

update public.content_reading_plans plans
set category_key = case lower(plans.category_label)
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
  else plans.category_key
end
where plans.category_key is null;

create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  insert into public.user_profiles (
    user_id,
    display_name,
    primary_timezone
  )
  values (
    new.id,
    nullif(trim(new.raw_user_meta_data ->> 'display_name'), ''),
    coalesce(nullif(new.raw_user_meta_data ->> 'primary_timezone', ''), 'Asia/Manila')
  )
  on conflict (user_id) do nothing;

  insert into public.user_preferences (user_id)
  values (new.id)
  on conflict (user_id) do nothing;

  insert into public.user_content_preferences (user_id)
  values (new.id)
  on conflict (user_id) do nothing;

  insert into public.user_notification_preferences (user_id)
  values (new.id)
  on conflict (user_id) do nothing;

  insert into public.user_widget_preferences (user_id)
  values (new.id)
  on conflict (user_id) do nothing;

  return new;
end;
$$;

create extension if not exists pgcrypto;

create table if not exists public.user_profiles (
  user_id uuid primary key references auth.users (id) on delete cascade,
  display_name text,
  primary_timezone text not null default 'Asia/Manila',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.user_preferences (
  user_id uuid primary key references auth.users (id) on delete cascade,
  onboarding_completed boolean not null default false,
  notifications_enabled boolean not null default false,
  notification_time_local time not null default '07:00:00',
  widget_preview_style text not null default 'cozy'
    check (widget_preview_style in ('cozy', 'minimal')),
  widget_show_reference boolean not null default true,
  widget_show_category boolean not null default true,
  widget_show_date boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.user_category_preferences (
  user_id uuid not null references auth.users (id) on delete cascade,
  category_key text not null,
  position integer not null default 0,
  created_at timestamptz not null default now(),
  primary key (user_id, category_key)
);

create index if not exists idx_user_category_preferences_user_position
  on public.user_category_preferences (user_id, position);

alter table public.user_profiles enable row level security;
alter table public.user_preferences enable row level security;
alter table public.user_category_preferences enable row level security;

create or replace function public.set_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

drop trigger if exists trg_user_profiles_updated_at on public.user_profiles;
create trigger trg_user_profiles_updated_at
before update on public.user_profiles
for each row execute procedure public.set_updated_at();

drop trigger if exists trg_user_preferences_updated_at on public.user_preferences;
create trigger trg_user_preferences_updated_at
before update on public.user_preferences
for each row execute procedure public.set_updated_at();

drop policy if exists "user_profiles_select_own" on public.user_profiles;
create policy "user_profiles_select_own"
on public.user_profiles
for select
to authenticated
using (auth.uid() is not null and auth.uid() = user_id);

drop policy if exists "user_profiles_insert_own" on public.user_profiles;
create policy "user_profiles_insert_own"
on public.user_profiles
for insert
to authenticated
with check (auth.uid() is not null and auth.uid() = user_id);

drop policy if exists "user_profiles_update_own" on public.user_profiles;
create policy "user_profiles_update_own"
on public.user_profiles
for update
to authenticated
using (auth.uid() is not null and auth.uid() = user_id)
with check (auth.uid() is not null and auth.uid() = user_id);

drop policy if exists "user_preferences_select_own" on public.user_preferences;
create policy "user_preferences_select_own"
on public.user_preferences
for select
to authenticated
using (auth.uid() is not null and auth.uid() = user_id);

drop policy if exists "user_preferences_insert_own" on public.user_preferences;
create policy "user_preferences_insert_own"
on public.user_preferences
for insert
to authenticated
with check (auth.uid() is not null and auth.uid() = user_id);

drop policy if exists "user_preferences_update_own" on public.user_preferences;
create policy "user_preferences_update_own"
on public.user_preferences
for update
to authenticated
using (auth.uid() is not null and auth.uid() = user_id)
with check (auth.uid() is not null and auth.uid() = user_id);

drop policy if exists "user_category_preferences_select_own" on public.user_category_preferences;
create policy "user_category_preferences_select_own"
on public.user_category_preferences
for select
to authenticated
using (auth.uid() is not null and auth.uid() = user_id);

drop policy if exists "user_category_preferences_insert_own" on public.user_category_preferences;
create policy "user_category_preferences_insert_own"
on public.user_category_preferences
for insert
to authenticated
with check (auth.uid() is not null and auth.uid() = user_id);

drop policy if exists "user_category_preferences_update_own" on public.user_category_preferences;
create policy "user_category_preferences_update_own"
on public.user_category_preferences
for update
to authenticated
using (auth.uid() is not null and auth.uid() = user_id)
with check (auth.uid() is not null and auth.uid() = user_id);

drop policy if exists "user_category_preferences_delete_own" on public.user_category_preferences;
create policy "user_category_preferences_delete_own"
on public.user_category_preferences
for delete
to authenticated
using (auth.uid() is not null and auth.uid() = user_id);

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

  insert into public.user_preferences (
    user_id
  )
  values (
    new.id
  )
  on conflict (user_id) do nothing;

  return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
after insert on auth.users
for each row execute procedure public.handle_new_user();

-- Phase 4: user read continuity foundation
-- Adds authenticated read progress persistence for continue-reading.

create table if not exists public.user_read_progress (
  user_id uuid not null references auth.users(id) on delete cascade,
  book_id text not null references public.content_bible_books(id) on delete cascade,
  chapter_number integer not null check (chapter_number > 0),
  book_name text not null default '',
  chapter_title text not null default '',
  focus_line text not null default '',
  last_opened_at timestamptz not null default timezone('utc', now()),
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now()),
  primary key (user_id, book_id, chapter_number)
);

create index if not exists user_read_progress_user_last_opened_idx
  on public.user_read_progress(user_id, last_opened_at desc);

alter table public.user_read_progress enable row level security;

drop policy if exists "users read own progress" on public.user_read_progress;
create policy "users read own progress"
  on public.user_read_progress
  for select
  to authenticated
  using (auth.uid() is not null and auth.uid() = user_id);

drop policy if exists "users insert own progress" on public.user_read_progress;
create policy "users insert own progress"
  on public.user_read_progress
  for insert
  to authenticated
  with check (auth.uid() is not null and auth.uid() = user_id);

drop policy if exists "users update own progress" on public.user_read_progress;
create policy "users update own progress"
  on public.user_read_progress
  for update
  to authenticated
  using (auth.uid() is not null and auth.uid() = user_id)
  with check (auth.uid() is not null and auth.uid() = user_id);

drop policy if exists "users delete own progress" on public.user_read_progress;
create policy "users delete own progress"
  on public.user_read_progress
  for delete
  to authenticated
  using (auth.uid() is not null and auth.uid() = user_id);

create or replace function public.set_user_read_progress_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = timezone('utc', now());
  return new;
end;
$$;

drop trigger if exists trg_user_read_progress_updated_at on public.user_read_progress;
create trigger trg_user_read_progress_updated_at
before update on public.user_read_progress
for each row
execute function public.set_user_read_progress_updated_at();

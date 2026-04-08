alter table public.user_preferences
  add column if not exists preferred_translation_code text not null default 'kjv';

alter table public.user_preferences
  drop constraint if exists user_preferences_preferred_translation_code_check;

alter table public.user_preferences
  add constraint user_preferences_preferred_translation_code_check
  check (preferred_translation_code in ('kjv', 'web'));

-- Phase 11: plans backend foundation for V1
-- Replaces mock-driven plans runtime flow with Supabase-backed catalog content
-- and authenticated progress persistence, while preserving guest-local progress.

create extension if not exists pgcrypto;

create table if not exists public.content_reading_plans (
  id text primary key,
  title text not null,
  subtitle text not null default '',
  category_label text not null default '',
  duration_days integer not null check (duration_days > 0),
  description text not null default '',
  why_it_helps text not null default '',
  sort_order integer not null default 0,
  is_active boolean not null default true,
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now())
);

create table if not exists public.content_reading_plan_days (
  plan_id text not null references public.content_reading_plans(id) on delete cascade,
  day_number integer not null check (day_number > 0),
  title text not null,
  focus_line text not null default '',
  summary text not null default '',
  reflection_prompt text not null default '',
  prayer_prompt text not null default '',
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now()),
  primary key (plan_id, day_number)
);

create table if not exists public.content_reading_plan_day_passages (
  id uuid primary key default gen_random_uuid(),
  plan_id text not null,
  day_number integer not null,
  sort_order integer not null default 0,
  reference_label text not null,
  book_id text not null references public.content_bible_books(id) on delete cascade,
  chapter_start integer not null check (chapter_start > 0),
  verse_start integer not null check (verse_start > 0),
  chapter_end integer not null check (chapter_end >= chapter_start),
  verse_end integer not null check (verse_end > 0),
  created_at timestamptz not null default timezone('utc', now()),
  constraint content_reading_plan_day_passages_day_fk
    foreign key (plan_id, day_number)
    references public.content_reading_plan_days(plan_id, day_number)
    on delete cascade
);

create table if not exists public.user_reading_plan_progress (
  user_id uuid not null references auth.users(id) on delete cascade,
  plan_id text not null references public.content_reading_plans(id) on delete cascade,
  current_day_number integer not null check (current_day_number > 0),
  completed_day_count integer not null default 0 check (completed_day_count >= 0),
  started_at timestamptz not null default timezone('utc', now()),
  last_opened_at timestamptz not null default timezone('utc', now()),
  completed_at timestamptz,
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now()),
  primary key (user_id, plan_id)
);

create index if not exists content_reading_plans_sort_order_idx
  on public.content_reading_plans(sort_order);

create index if not exists content_reading_plan_days_plan_day_idx
  on public.content_reading_plan_days(plan_id, day_number);

create index if not exists content_reading_plan_day_passages_plan_day_sort_idx
  on public.content_reading_plan_day_passages(plan_id, day_number, sort_order);

create index if not exists user_reading_plan_progress_user_last_opened_idx
  on public.user_reading_plan_progress(user_id, last_opened_at desc);

alter table public.content_reading_plans enable row level security;
alter table public.content_reading_plan_days enable row level security;
alter table public.content_reading_plan_day_passages enable row level security;
alter table public.user_reading_plan_progress enable row level security;

drop policy if exists "public read reading plans" on public.content_reading_plans;
create policy "public read reading plans"
  on public.content_reading_plans
  for select
  to anon, authenticated
  using (is_active = true);

drop policy if exists "public read reading plan days" on public.content_reading_plan_days;
create policy "public read reading plan days"
  on public.content_reading_plan_days
  for select
  to anon, authenticated
  using (
    exists (
      select 1
      from public.content_reading_plans plans
      where plans.id = content_reading_plan_days.plan_id
        and plans.is_active = true
    )
  );

drop policy if exists "public read reading plan day passages" on public.content_reading_plan_day_passages;
create policy "public read reading plan day passages"
  on public.content_reading_plan_day_passages
  for select
  to anon, authenticated
  using (
    exists (
      select 1
      from public.content_reading_plans plans
      where plans.id = content_reading_plan_day_passages.plan_id
        and plans.is_active = true
    )
  );

drop policy if exists "users read own reading plan progress" on public.user_reading_plan_progress;
create policy "users read own reading plan progress"
  on public.user_reading_plan_progress
  for select
  to authenticated
  using (auth.uid() is not null and auth.uid() = user_id);

drop policy if exists "users insert own reading plan progress" on public.user_reading_plan_progress;
create policy "users insert own reading plan progress"
  on public.user_reading_plan_progress
  for insert
  to authenticated
  with check (auth.uid() is not null and auth.uid() = user_id);

drop policy if exists "users update own reading plan progress" on public.user_reading_plan_progress;
create policy "users update own reading plan progress"
  on public.user_reading_plan_progress
  for update
  to authenticated
  using (auth.uid() is not null and auth.uid() = user_id)
  with check (auth.uid() is not null and auth.uid() = user_id);

drop policy if exists "users delete own reading plan progress" on public.user_reading_plan_progress;
create policy "users delete own reading plan progress"
  on public.user_reading_plan_progress
  for delete
  to authenticated
  using (auth.uid() is not null and auth.uid() = user_id);

create or replace function public.set_content_reading_plans_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = timezone('utc', now());
  return new;
end;
$$;

create or replace function public.set_content_reading_plan_days_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = timezone('utc', now());
  return new;
end;
$$;

create or replace function public.set_user_reading_plan_progress_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = timezone('utc', now());
  return new;
end;
$$;

drop trigger if exists trg_content_reading_plans_updated_at on public.content_reading_plans;
create trigger trg_content_reading_plans_updated_at
before update on public.content_reading_plans
for each row
execute function public.set_content_reading_plans_updated_at();

drop trigger if exists trg_content_reading_plan_days_updated_at on public.content_reading_plan_days;
create trigger trg_content_reading_plan_days_updated_at
before update on public.content_reading_plan_days
for each row
execute function public.set_content_reading_plan_days_updated_at();

drop trigger if exists trg_user_reading_plan_progress_updated_at on public.user_reading_plan_progress;
create trigger trg_user_reading_plan_progress_updated_at
before update on public.user_reading_plan_progress
for each row
execute function public.set_user_reading_plan_progress_updated_at();

insert into public.content_reading_plans (
  id,
  title,
  subtitle,
  category_label,
  duration_days,
  description,
  why_it_helps,
  sort_order,
  is_active
)
values
  (
    'peace_when_anxious',
    'Peace When Anxiety Feels Loud',
    'A gentle 7-day reading rhythm for prayer, trust, and steadiness.',
    'Peace Over Anxiety',
    7,
    'This plan is built for days when the mind feels crowded, restless, or heavy. Each day keeps the reading simple and prayerful instead of overwhelming.',
    'It gives the user a calm structure: a short passage focus, one main encouragement, and a reflection prompt that stays spiritually grounded rather than productivity-heavy.',
    1,
    true
  ),
  (
    'finding_strength_in_weariness',
    'Strength for Tired Days',
    'A 5-day plan for weakness, endurance, and dependence on God.',
    'Strength',
    5,
    'This plan is for people who feel emotionally or spiritually drained. It keeps the pace simple and lets scripture speak to fatigue with hope.',
    'Instead of asking the user to perform harder, it points them toward the sustaining strength of God in weakness.',
    2,
    true
  ),
  (
    'purpose_and_calling',
    'Purpose in Ordinary Days',
    'A 6-day plan for calling, faithfulness, and walking with God in real life.',
    'Purpose and Calling',
    6,
    'This plan helps the reader think about calling in a grounded way. It is less about grand status and more about faithful daily walking with God.',
    'It helps prevent calling from becoming anxious pressure. The tone stays practical, calm, and spiritually centered.',
    3,
    true
  )
on conflict (id) do update
set
  title = excluded.title,
  subtitle = excluded.subtitle,
  category_label = excluded.category_label,
  duration_days = excluded.duration_days,
  description = excluded.description,
  why_it_helps = excluded.why_it_helps,
  sort_order = excluded.sort_order,
  is_active = excluded.is_active,
  updated_at = timezone('utc', now());

delete from public.content_reading_plan_day_passages
where plan_id in (
  'peace_when_anxious',
  'finding_strength_in_weariness',
  'purpose_and_calling'
);

delete from public.content_reading_plan_days
where plan_id in (
  'peace_when_anxious',
  'finding_strength_in_weariness',
  'purpose_and_calling'
);

insert into public.content_reading_plan_days (
  plan_id,
  day_number,
  title,
  focus_line,
  summary,
  reflection_prompt,
  prayer_prompt
)
values
  (
    'peace_when_anxious',
    1,
    'Bring the weight honestly',
    'God invites honest prayer before He gives peace beyond understanding.',
    'The opening day sets the tone: do not hide the anxious burden. Bring it into prayer with thanksgiving and let God hold what feels too heavy.',
    'What burden have you been carrying internally instead of placing before God in prayer?',
    'Lord, I bring You the pressure I have been holding. Teach me to pray instead of spiraling.'
  ),
  (
    'peace_when_anxious',
    2,
    'Remember the Father''s care',
    'Jesus speaks directly to anxious striving and redirects the heart to the Father.',
    'This day centers on the care of God, reminding the reader that worry does not secure life the way trust in the Father does.',
    'Where have you been measuring safety by control instead of God''s care?',
    'Father, help me trust Your care where I usually try to create certainty for myself.'
  ),
  (
    'peace_when_anxious',
    3,
    'Let your mind stay on Him',
    'Peace grows where the mind is trained toward God rather than consumed by fear.',
    'This day is about attention. Fear tries to dominate thought, but scripture keeps calling the mind back toward God''s truth and steadiness.',
    'What thought pattern has been feeding unrest, and what truth from God do you need to sit with instead?',
    'Lord, steady my thoughts and teach my mind to return to what is true and life-giving.'
  ),
  (
    'peace_when_anxious',
    4,
    'Rest in God''s nearness',
    'Peace is not only about solutions. It is also about the nearness of God.',
    'This day reminds the reader that God''s closeness matters in the middle of unresolved situations.',
    'How would your day feel different if you truly believed God was near in this moment?',
    'God, remind me that Your presence is not far from my weakness or fear.'
  ),
  (
    'peace_when_anxious',
    5,
    'Wait without panic',
    'Biblical waiting is not passive despair. It is patient trust under God.',
    'This day helps the user stay grounded when answers are delayed and fear wants to take over.',
    'Where are you being asked to wait, and what does faithful waiting look like there?',
    'Lord, keep me from panic while I wait. Teach me to remain steady in You.'
  ),
  (
    'peace_when_anxious',
    6,
    'Practice gratitude in the middle',
    'Thanksgiving changes the posture of the heart even before circumstances change.',
    'Gratitude does not deny pain. It keeps the heart open to God''s faithfulness in the middle of it.',
    'What evidence of God''s care can you thank Him for even in an unfinished season?',
    'God, keep my heart from shrinking into fear alone. Help me stay thankful for Your faithfulness.'
  ),
  (
    'peace_when_anxious',
    7,
    'Carry peace forward',
    'Peace is not a one-time feeling. It becomes a daily returning to God.',
    'The final day helps the reader move from a short plan into an ongoing prayerful rhythm with God.',
    'What small daily habit could help you keep returning to God''s peace after this plan ends?',
    'Lord, let Your peace rule in me beyond this week. Keep drawing me back to You day by day.'
  ),
  (
    'finding_strength_in_weariness',
    1,
    'Come weary, not polished',
    'Jesus calls the weary to come, not to fix themselves first.',
    'The first day opens with invitation: bring tiredness honestly before Christ.',
    'What part of your life feels tired enough that you need Christ''s rest today?',
    'Jesus, I come tired. Meet me in my weakness and let me rest in You.'
  ),
  (
    'finding_strength_in_weariness',
    2,
    'Strength renewed',
    'God''s strength meets those who wait on Him, not those who pretend they never grow faint.',
    'This day helps the reader see waiting on God as renewal, not useless delay.',
    'Where do you need God''s renewal more than your own effort?',
    'Lord, renew me where I feel depleted and unable to keep carrying things alone.'
  ),
  (
    'finding_strength_in_weariness',
    3,
    'Grace in weakness',
    'God does not only work after weakness passes. He works inside it.',
    'This day turns the reader toward grace that meets weakness rather than shame that hides it.',
    'How might God be inviting you to depend on grace instead of image or self-sufficiency?',
    'God, let Your strength be clearer to me than my limitation.'
  ),
  (
    'finding_strength_in_weariness',
    4,
    'Do not grow weary',
    'Faithfulness often looks quiet and repeated long before it feels rewarding.',
    'The fourth day encourages steadiness when doing good feels slow and costly.',
    'What good work are you tempted to stop because you feel tired or unseen?',
    'Lord, give me steady endurance where I feel like giving up.'
  ),
  (
    'finding_strength_in_weariness',
    5,
    'Stand with hope',
    'Strength is not only surviving pressure. It is learning to stand in hope with God.',
    'The plan closes by anchoring the reader in hope and courage from God''s presence.',
    'What would courageous hope look like in your next step?',
    'God, strengthen my heart and help me move forward with hope.'
  ),
  (
    'purpose_and_calling',
    1,
    'Begin with God, not image',
    'Purpose starts with belonging to God before accomplishing things for God.',
    'The first day resets the idea of calling so it begins with relationship and trust.',
    'Have you been treating purpose more like pressure to prove yourself than a life with God?',
    'Lord, root my purpose in You before anything I produce or achieve.'
  ),
  (
    'purpose_and_calling',
    2,
    'Be faithful where you are',
    'God often forms calling through ordinary obedience before visible outcomes.',
    'This day focuses on faithfulness in present responsibilities instead of obsession with future recognition.',
    'What ordinary responsibility might God be asking you to treat with deeper faithfulness today?',
    'God, help me honor You in the small and ordinary things in front of me.'
  ),
  (
    'purpose_and_calling',
    3,
    'Walk humbly',
    'Purpose is not self-exaltation. It is a life shaped by justice, mercy, and humble walking with God.',
    'This day guards against inflated calling language by rooting life in faithful character.',
    'Where do you need humility to reshape how you think about your future?',
    'Lord, keep my heart humble and my steps aligned with what pleases You.'
  ),
  (
    'purpose_and_calling',
    4,
    'Do good without noise',
    'Purpose often shows up as quiet obedience long before it looks impressive.',
    'This day emphasizes consistency and goodness without needing applause.',
    'What good can you keep doing even if it feels small or unnoticed?',
    'God, make me faithful in good works whether or not they are seen.'
  ),
  (
    'purpose_and_calling',
    5,
    'Trust His leading',
    'Calling becomes clearer when the heart learns to trust God''s direction day by day.',
    'This day helps the reader hold future uncertainty with trust instead of restless control.',
    'Where are you craving certainty more than daily trust in God''s leading?',
    'Lord, direct my path and help me trust You more than my own understanding.'
  ),
  (
    'purpose_and_calling',
    6,
    'Offer your life to God',
    'Purpose matures as the whole life is placed before God in willing surrender.',
    'The final day closes with surrendered worship as the shape of faithful calling.',
    'What part of your life still feels withheld from God''s shaping?',
    'God, I offer my life to You. Shape my purpose in a way that honors You.'
  );

insert into public.content_reading_plan_day_passages (
  plan_id,
  day_number,
  sort_order,
  reference_label,
  book_id,
  chapter_start,
  verse_start,
  chapter_end,
  verse_end
)
values
  ('peace_when_anxious', 1, 1, 'Philippians 4:6-7', 'philippians', 4, 6, 4, 7),
  ('peace_when_anxious', 1, 2, '1 Peter 5:7', '1-peter', 5, 7, 5, 7),
  ('peace_when_anxious', 2, 1, 'Matthew 6:25-34', 'matthew', 6, 25, 6, 34),
  ('peace_when_anxious', 2, 2, 'Psalm 121', 'psalms', 121, 1, 121, 8),
  ('peace_when_anxious', 3, 1, 'Isaiah 26:3', 'isaiah', 26, 3, 26, 3),
  ('peace_when_anxious', 3, 2, 'Philippians 4:8', 'philippians', 4, 8, 4, 8),
  ('peace_when_anxious', 4, 1, 'Psalm 34:17-18', 'psalms', 34, 17, 34, 18),
  ('peace_when_anxious', 4, 2, 'John 14:27', 'john', 14, 27, 14, 27),
  ('peace_when_anxious', 5, 1, 'Psalm 27:13-14', 'psalms', 27, 13, 27, 14),
  ('peace_when_anxious', 5, 2, 'Lamentations 3:25-26', 'lamentations', 3, 25, 3, 26),
  ('peace_when_anxious', 6, 1, '1 Thessalonians 5:16-18', '1-thessalonians', 5, 16, 5, 18),
  ('peace_when_anxious', 6, 2, 'Psalm 103:1-5', 'psalms', 103, 1, 103, 5),
  ('peace_when_anxious', 7, 1, 'Colossians 3:15', 'colossians', 3, 15, 3, 15),
  ('peace_when_anxious', 7, 2, 'Psalm 23', 'psalms', 23, 1, 23, 6),
  ('finding_strength_in_weariness', 1, 1, 'Matthew 11:28-30', 'matthew', 11, 28, 11, 30),
  ('finding_strength_in_weariness', 2, 1, 'Isaiah 40:28-31', 'isaiah', 40, 28, 40, 31),
  ('finding_strength_in_weariness', 3, 1, '2 Corinthians 12:9-10', '2-corinthians', 12, 9, 12, 10),
  ('finding_strength_in_weariness', 4, 1, 'Galatians 6:9', 'galatians', 6, 9, 6, 9),
  ('finding_strength_in_weariness', 4, 2, 'Hebrews 12:1-3', 'hebrews', 12, 1, 12, 3),
  ('finding_strength_in_weariness', 5, 1, 'Psalm 27:13-14', 'psalms', 27, 13, 27, 14),
  ('finding_strength_in_weariness', 5, 2, 'Joshua 1:9', 'joshua', 1, 9, 1, 9),
  ('purpose_and_calling', 1, 1, 'John 15:4-5', 'john', 15, 4, 15, 5),
  ('purpose_and_calling', 1, 2, 'Ephesians 2:10', 'ephesians', 2, 10, 2, 10),
  ('purpose_and_calling', 2, 1, 'Colossians 3:23-24', 'colossians', 3, 23, 3, 24),
  ('purpose_and_calling', 2, 2, 'Luke 16:10', 'luke', 16, 10, 16, 10),
  ('purpose_and_calling', 3, 1, 'Micah 6:8', 'micah', 6, 8, 6, 8),
  ('purpose_and_calling', 4, 1, 'Galatians 6:9-10', 'galatians', 6, 9, 6, 10),
  ('purpose_and_calling', 4, 2, 'Matthew 5:14-16', 'matthew', 5, 14, 5, 16),
  ('purpose_and_calling', 5, 1, 'Proverbs 3:5-6', 'proverbs', 3, 5, 3, 6),
  ('purpose_and_calling', 5, 2, 'Psalm 32:8', 'psalms', 32, 8, 32, 8),
  ('purpose_and_calling', 6, 1, 'Romans 12:1-2', 'romans', 12, 1, 12, 2);

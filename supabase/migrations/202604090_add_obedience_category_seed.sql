-- D:\Github\feel\supabase\migrations\202604090_add_obedience_category_seed.sql
-- Phase 10: add Obedience to the app-owned category taxonomy.
-- Keeps existing categories, preserves ordering, and seeds Obedience support
-- for the curated daily verse pool used by Today.

with source_categories (key, name, description, sort_order) as (
  values
    ('guidance', 'Guidance', 'Verses for direction, wisdom, and next-step clarity.', 10),
    ('hope', 'Hope', 'Verses for waiting, confidence, and future-facing trust in God.', 20),
    ('strength', 'Strength', 'Verses for endurance, courage, and renewed inner strength.', 30),
    ('peace_over_anxiety', 'Peace Over Anxiety', 'Verses for anxious thoughts, prayer, and guarded peace.', 40),
    ('comfort_and_healing', 'Comfort and Healing', 'Verses for pain, grief, recovery, and God''s nearness.', 50),
    ('faith_in_doubt', 'Faith in Doubt', 'Verses for honest struggle, weak faith, and steady dependence on God.', 60),
    ('obedience', 'Obedience', 'Verses for willing response, faithful action, and walking in what God has said.', 70),
    ('forgiveness', 'Forgiveness', 'Verses for confession, mercy, cleansing, and restored relationship with God.', 80),
    ('purpose_and_calling', 'Purpose and Calling', 'Verses for vocation, identity, and faithful daily purpose.', 90),
    ('love_and_relationships', 'Love and Relationships', 'Verses for patience, humility, reconciliation, and Christ-shaped love.', 100),
    ('gratitude_and_joy', 'Gratitude and Joy', 'Verses for thanksgiving, rejoicing, and steady delight in God.', 110)
)
insert into public.content_categories (
  key,
  name,
  description,
  sort_order,
  is_active
)
select
  key,
  name,
  description,
  sort_order,
  true
from source_categories
on conflict (key) do update
set
  name = excluded.name,
  description = excluded.description,
  sort_order = excluded.sort_order,
  is_active = true;

insert into public.content_daily_verse_pool (
  id,
  category_label,
  reference_label,
  translation_code,
  verse_text_fallback,
  reflection_prompt,
  encouragement_line,
  context_summary,
  context_sections,
  related_passages,
  key_insights,
  prayer,
  sort_order,
  is_active
)
values
  (
    'obedience-james-1-22',
    'Obedience',
    'James 1:22',
    'kjv',
    'But be ye doers of the word, and not hearers only, deceiving your own selves.',
    'What truth from God do you need to practice today instead of only agreeing with in theory?',
    'Obedience gives direction a real shape. Scripture invites response, not only reflection.',
    'James keeps bringing faith into everyday action. This verse warns against hearing truth without letting it change the way we live.',
    jsonb_build_array(
      jsonb_build_object(
        'title', 'Truth that moves into action',
        'body', 'The call is not toward performance for approval, but toward a faith that responds honestly to what God has said.'
      )
    ),
    jsonb_build_array(
      jsonb_build_object(
        'reference', 'John 14:15',
        'note', 'Jesus connecting love for Him with willing obedience.'
      )
    ),
    jsonb_build_array('Obedience is lived trust, not just stated belief.'),
    'Lord, help me respond to Your word with willing action and not settle for agreement without obedience.',
    65,
    true
  ),
  (
    'obedience-deuteronomy-5-33',
    'Obedience',
    'Deuteronomy 5:33',
    'kjv',
    'Ye shall walk in all the ways which the Lord your God hath commanded you, that ye may live, and that it may be well with you, and that ye may prolong your days in the land which ye shall possess.',
    'Where is God inviting you into a steady next step of obedience rather than a dramatic moment?',
    'Obedience is often a path walked consistently, not a single emotional decision.',
    'Moses urges God''s people to walk in the ways they have been given. The emphasis is on faithful direction, daily life, and the goodness of staying near God''s commands.',
    jsonb_build_array(
      jsonb_build_object(
        'title', 'A walk, not just a moment',
        'body', 'The verse pictures obedience as a path shaped by repeated trust and faithful steps over time.'
      )
    ),
    jsonb_build_array(
      jsonb_build_object(
        'reference', 'Psalm 119:105',
        'note', 'God''s word guiding the next step on the path.'
      )
    ),
    jsonb_build_array('Faithful obedience is often quiet, steady, and deeply fruitful.'),
    'Lord, steady my steps in the ways You have shown me and make obedience feel more precious than convenience.',
    66,
    true
  )
on conflict (id) do nothing;

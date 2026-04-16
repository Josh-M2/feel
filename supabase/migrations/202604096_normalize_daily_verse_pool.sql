-- Phase 11: normalize Today's curated verse pool against the scripture tables.
-- Keeps the pool app-owned by category and metadata, but anchors each entry
-- to canonical version/book/chapter/verse coordinates instead of loose text.

alter table public.content_daily_verse_pool
  add column if not exists book_id text,
  add column if not exists chapter_number integer,
  add column if not exists verse_start integer,
  add column if not exists verse_end integer;

alter table public.content_daily_verse_pool
  drop constraint if exists content_daily_verse_pool_book_fk;

alter table public.content_daily_verse_pool
  add constraint content_daily_verse_pool_book_fk
  foreign key (book_id)
  references public.content_bible_books(id)
  on delete restrict;

alter table public.content_daily_verse_pool
  drop constraint if exists content_daily_verse_pool_normalized_reference_check;

alter table public.content_daily_verse_pool
  add constraint content_daily_verse_pool_normalized_reference_check
  check (
    (
      book_id is null and
      chapter_number is null and
      verse_start is null and
      verse_end is null
    ) or (
      book_id is not null and
      chapter_number is not null and chapter_number > 0 and
      verse_start is not null and verse_start > 0 and
      verse_end is not null and verse_end >= verse_start
    )
  );

create index if not exists content_daily_verse_pool_book_reference_idx
  on public.content_daily_verse_pool(book_id, chapter_number, verse_start, verse_end);

create unique index if not exists content_daily_verse_pool_category_reference_uidx
  on public.content_daily_verse_pool(
    category_label,
    translation_code,
    book_id,
    chapter_number,
    verse_start,
    verse_end
  )
  where book_id is not null
    and chapter_number is not null
    and verse_start is not null
    and verse_end is not null;

with curated_entries (
  category_label,
  reference_label,
  book_id,
  chapter_number,
  verse_start,
  verse_end,
  reflection_prompt,
  encouragement_line,
  context_summary,
  context_sections,
  related_passages,
  key_insights,
  prayer,
  sort_order
) as (
  values
    (
      'Guidance',
      'Proverbs 3:5-6',
      'proverbs',
      3,
      5,
      6,
      'Where are you most tempted to rely only on your own understanding today?',
      'Guidance starts with trust before clarity. This verse invites surrender before direction.',
      'Proverbs frames wisdom as more than intelligence. It is a posture of reverence, trust, and daily surrender before God.',
      jsonb_build_array(
        jsonb_build_object(
          'title', 'Wisdom begins with trust',
          'body', 'This passage does not glorify self-sufficiency. It teaches a heart posture that starts with trusting God deeply.'
        ),
        jsonb_build_object(
          'title', 'Acknowledging God in all ways',
          'body', 'The promise of direction is tied to bringing everyday choices under God''s leadership.'
        )
      ),
      jsonb_build_array(
        jsonb_build_object(
          'reference', 'Psalm 32:8',
          'note', 'A companion promise about God instructing and guiding.'
        )
      ),
      jsonb_build_array(
        'Trust is the doorway to wisdom.',
        'Guidance grows where surrender grows.'
      ),
      'Lord, teach me to trust You more than my own instincts and to bring every decision under Your care.',
      10
    ),
    (
      'Hope',
      'Jeremiah 29:11',
      'jeremiah',
      29,
      11,
      11,
      'What part of your future feels uncertain enough that you need to hand it back to God?',
      'Hope in scripture is not vague optimism. It is confidence that God has not forgotten His people.',
      'Jeremiah speaks to people in exile. God''s promise of future hope meets people living inside delay and uncertainty.',
      jsonb_build_array(
        jsonb_build_object(
          'title', 'Hope inside exile',
          'body', 'This promise was given while life still felt unsettled, reminding believers that waiting is not abandonment.'
        )
      ),
      jsonb_build_array(
        jsonb_build_object(
          'reference', 'Romans 15:13',
          'note', 'A New Testament prayer for hope through the Spirit.'
        )
      ),
      jsonb_build_array('God''s hope can meet you before circumstances change.'),
      'Lord, hold my future with more steadiness than my fears and teach me to hope in Your faithfulness.',
      20
    ),
    (
      'Strength',
      'Isaiah 40:31',
      'isaiah',
      40,
      31,
      31,
      'Where do you need renewed strength instead of forcing yourself through exhaustion?',
      'This promise honors waiting on God as a place where strength is renewed, not wasted.',
      'Isaiah contrasts human frailty with God''s enduring power and invites weary people to hope in Him.',
      jsonb_build_array(
        jsonb_build_object(
          'title', 'Waiting is not passive defeat',
          'body', 'The passage frames waiting on the Lord as a posture of expectant trust that renews the inner life.'
        )
      ),
      jsonb_build_array(
        jsonb_build_object(
          'reference', '2 Corinthians 12:9',
          'note', 'God''s strength showing up in weakness.'
        )
      ),
      jsonb_build_array('God renews the weary, not just the strong.'),
      'Lord, renew what feels tired in me and teach me to wait for Your strength instead of pretending I have enough on my own.',
      30
    ),
    (
      'Peace Over Anxiety',
      'Philippians 4:6-7',
      'philippians',
      4,
      6,
      7,
      'What burden feels loud today, and what would it look like to bring it honestly before God instead of carrying it alone?',
      'This verse speaks to anxious inner noise with prayer, thanksgiving, and the promise of guarded peace.',
      'Paul writes from hardship yet directs believers toward prayer, thanksgiving, and steady peace in Christ.',
      jsonb_build_array(
        jsonb_build_object(
          'title', 'Prayer over panic',
          'body', 'The verse does not deny trouble. It redirects the response from spiraling anxiety to honest prayer.'
        )
      ),
      jsonb_build_array(
        jsonb_build_object(
          'reference', '1 Peter 5:7',
          'note', 'Casting cares on God because He cares for you.'
        )
      ),
      jsonb_build_array(
        'Prayer is the first movement, not the last resort.',
        'Peace is pictured as God''s guarding presence.'
      ),
      'Lord, I bring You what has been heavy in my mind. Teach me to pray instead of spiral and rest in Your peace.',
      40
    ),
    (
      'Comfort and Healing',
      'Psalm 34:18',
      'psalms',
      34,
      18,
      18,
      'Where do you most need God''s nearness in your pain right now?',
      'God''s comfort is not distant. Scripture describes Him as near to the brokenhearted.',
      'Psalm 34 holds together distress, deliverance, and the nearness of God to those who are hurting.',
      jsonb_build_array(
        jsonb_build_object(
          'title', 'Nearness in brokenness',
          'body', 'The psalm does not minimize pain. It highlights God''s nearness inside it.'
        )
      ),
      jsonb_build_array(
        jsonb_build_object(
          'reference', 'Matthew 11:28',
          'note', 'Jesus inviting the weary to come to Him.'
        )
      ),
      jsonb_build_array('God''s nearness meets honest sorrow.'),
      'Lord, meet me in the places that feel tender and broken, and let Your nearness become more real than my fear.',
      50
    ),
    (
      'Faith in Doubt',
      'Mark 9:24',
      'mark',
      9,
      24,
      24,
      'What doubt do you need to bring to Jesus honestly instead of hiding it?',
      'This verse gives language for imperfect faith and honest dependence at the same time.',
      'A desperate father speaks with raw honesty, showing that faith and struggle can exist together before Jesus.',
      jsonb_build_array(
        jsonb_build_object(
          'title', 'Honest faith',
          'body', 'Scripture allows room for faith that asks for help in the middle of weakness.'
        )
      ),
      jsonb_build_array(
        jsonb_build_object(
          'reference', 'Psalm 73:26',
          'note', 'God as strength when the heart fails.'
        )
      ),
      jsonb_build_array('Doubt does not have to be hidden from God.'),
      'Lord, meet the places where my faith feels weak and teach me to bring my doubts to You honestly.',
      60
    ),
    (
      'Obedience',
      'James 1:22',
      'james',
      1,
      22,
      22,
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
      70
    ),
    (
      'Forgiveness',
      '1 John 1:9',
      '1-john',
      1,
      9,
      9,
      'What would honest confession and fresh surrender look like today?',
      'Forgiveness in Christ is grounded in God''s faithfulness, not our ability to clean ourselves up first.',
      'John calls believers to walk in the light honestly, trusting God''s faithfulness when sin is confessed.',
      jsonb_build_array(
        jsonb_build_object(
          'title', 'Confession and cleansing',
          'body', 'The verse joins honesty about sin with confidence in God''s forgiveness.'
        )
      ),
      jsonb_build_array(
        jsonb_build_object(
          'reference', 'Psalm 103:12',
          'note', 'A vivid picture of how far God removes transgressions.'
        )
      ),
      jsonb_build_array('Forgiveness rests on God''s faithfulness.'),
      'Lord, give me courage to confess honestly and rest in the cleansing You freely give.',
      80
    ),
    (
      'Purpose and Calling',
      'Ephesians 2:10',
      'ephesians',
      2,
      10,
      10,
      'Where might God be inviting you to walk faithfully in what He has prepared for you?',
      'Purpose begins with belonging to God before it becomes activity for God.',
      'Ephesians roots calling in grace. Good works flow from identity formed in Christ, not self-made worth.',
      jsonb_build_array(
        jsonb_build_object(
          'title', 'Purpose after grace',
          'body', 'The verse places calling after salvation by grace, not before it.'
        )
      ),
      jsonb_build_array(
        jsonb_build_object(
          'reference', 'Colossians 3:17',
          'note', 'Living every action under the name of Jesus.'
        )
      ),
      jsonb_build_array('Calling grows from identity in Christ.'),
      'Lord, help me walk in the good works You have prepared and remember that my purpose starts with belonging to You.',
      90
    ),
    (
      'Love and Relationships',
      '1 Corinthians 13:4-7',
      '1-corinthians',
      13,
      4,
      7,
      'What part of love do you most need God to grow in you today?',
      'Biblical love is patient, humble, and steady. It is formed by grace, not mere emotion.',
      'Paul describes love as the essential shape of mature Christian life and relationships.',
      jsonb_build_array(
        jsonb_build_object(
          'title', 'Love with substance',
          'body', 'The passage names real traits that love practices in ordinary relationships.'
        )
      ),
      jsonb_build_array(
        jsonb_build_object(
          'reference', 'John 13:34-35',
          'note', 'Jesus commanding His people to love one another.'
        )
      ),
      jsonb_build_array('Love is patient before it is impressive.'),
      'Lord, shape the way I love others so it reflects Your patience, humility, and steadfastness.',
      100
    ),
    (
      'Gratitude and Joy',
      '1 Thessalonians 5:16-18',
      '1-thessalonians',
      5,
      16,
      18,
      'What small act of gratitude can help reframe your day before God?',
      'Joy and gratitude are practiced rhythms, not just reactions to easy circumstances.',
      'Paul''s brief commands encourage a steady posture of joy, prayer, and thanksgiving in everyday life.',
      jsonb_build_array(
        jsonb_build_object(
          'title', 'A daily posture',
          'body', 'These commands shape how believers carry ordinary days before God.'
        )
      ),
      jsonb_build_array(
        jsonb_build_object(
          'reference', 'Psalm 118:24',
          'note', 'Rejoicing in the day the Lord has made.'
        )
      ),
      jsonb_build_array('Gratitude can steady the heart before the day changes.'),
      'Lord, teach me to rejoice, pray, and give thanks with sincerity in the middle of ordinary life.',
      110
    )
),
target_versions as (
  select id
  from public.content_bible_versions
  where id in ('kjv', 'web')
    and is_active = true
),
resolved_passages as (
  select
    versions.id as translation_code,
    curated.category_label,
    curated.reference_label,
    curated.book_id,
    curated.chapter_number,
    curated.verse_start,
    curated.verse_end,
    curated.reflection_prompt,
    curated.encouragement_line,
    curated.context_summary,
    curated.context_sections,
    curated.related_passages,
    curated.key_insights,
    curated.prayer,
    curated.sort_order,
    string_agg(verses.verse_text, ' ' order by verses.verse_number) as verse_text_fallback
  from curated_entries curated
  join target_versions versions
    on true
  join public.content_bible_books books
    on books.id = curated.book_id
   and books.is_active = true
  join public.content_bible_verses verses
    on verses.version_id = versions.id
   and verses.book_id = curated.book_id
   and verses.chapter_number = curated.chapter_number
   and verses.verse_number between curated.verse_start and curated.verse_end
  group by
    versions.id,
    curated.category_label,
    curated.reference_label,
    curated.book_id,
    curated.chapter_number,
    curated.verse_start,
    curated.verse_end,
    curated.reflection_prompt,
    curated.encouragement_line,
    curated.context_summary,
    curated.context_sections,
    curated.related_passages,
    curated.key_insights,
    curated.prayer,
    curated.sort_order
  having count(*) = curated.verse_end - curated.verse_start + 1
)
insert into public.content_daily_verse_pool (
  id,
  category_label,
  reference_label,
  translation_code,
  book_id,
  chapter_number,
  verse_start,
  verse_end,
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
select
  lower(replace(category_label, ' ', '-')) ||
    '-' ||
    book_id ||
    '-' ||
    chapter_number::text ||
    '-' ||
    verse_start::text ||
    case
      when verse_end = verse_start then ''
      else '-' || verse_end::text
    end ||
    '-' ||
    translation_code as id,
  category_label,
  reference_label,
  translation_code,
  book_id,
  chapter_number,
  verse_start,
  verse_end,
  verse_text_fallback,
  reflection_prompt,
  encouragement_line,
  context_summary,
  context_sections,
  related_passages,
  key_insights,
  prayer,
  sort_order,
  true
from resolved_passages
on conflict (id) do update
set
  category_label = excluded.category_label,
  reference_label = excluded.reference_label,
  translation_code = excluded.translation_code,
  book_id = excluded.book_id,
  chapter_number = excluded.chapter_number,
  verse_start = excluded.verse_start,
  verse_end = excluded.verse_end,
  verse_text_fallback = excluded.verse_text_fallback,
  reflection_prompt = excluded.reflection_prompt,
  encouragement_line = excluded.encouragement_line,
  context_summary = excluded.context_summary,
  context_sections = excluded.context_sections,
  related_passages = excluded.related_passages,
  key_insights = excluded.key_insights,
  prayer = excluded.prayer,
  sort_order = excluded.sort_order,
  is_active = true;

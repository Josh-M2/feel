-- Phase 3: seed public scripture content used by the current Read UI.
-- Idempotent seed for the mock-backed V1 reading surface.

insert into public.content_bible_versions (
  id,
  name,
  language_code,
  is_default,
  is_public_domain,
  is_active
)
values ('kjv', 'King James Version', 'en', true, true, true)
on conflict (id) do update
set
  name = excluded.name,
  language_code = excluded.language_code,
  is_default = excluded.is_default,
  is_public_domain = excluded.is_public_domain,
  is_active = excluded.is_active;

insert into public.content_bible_books (
  id,
  name,
  testament,
  sort_order,
  chapter_count,
  short_description,
  overview,
  why_read,
  key_themes,
  preferred_continue_chapter,
  is_featured_default,
  is_active
)
values
  (
    'john',
    'John',
    'New Testament',
    43,
    21,
    'A warm, personal gospel centered on Jesus, belief, and eternal life.',
    'John highlights who Jesus is through signs, conversations, and direct teaching. The tone is personal and reflective, making it especially approachable for steady daily reading.',
    'John is strong for both new and returning readers because it keeps pointing back to the identity of Jesus and the invitation to believe and remain in Him.',
    array['Belief', 'Life in Christ', 'Love', 'Abiding'],
    2,
    true,
    true
  ),
  (
    'psalms',
    'Psalms',
    'Old Testament',
    19,
    150,
    'Songs, prayers, cries, and praise for the full range of the inner life.',
    'Psalms gives language for worship, grief, trust, repentance, longing, and joy. It is one of the most emotionally honest books in scripture.',
    'Psalms is especially good when the user wants to pray with scripture, process emotions before God, or find words for difficult seasons.',
    array['Prayer', 'Worship', 'Trust', 'God''s nearness'],
    23,
    false,
    true
  ),
  (
    'philippians',
    'Philippians',
    'New Testament',
    50,
    4,
    'A short letter full of joy, steadiness, humility, and Christ-centered focus.',
    'Philippians combines affection, endurance, joy, humility, and practical encouragement. It is compact, readable, and deeply comforting.',
    'Philippians works well for users who want encouragement, peace in difficulty, and a strong reminder to center life on Christ.',
    array['Joy', 'Peace', 'Humility', 'Steadfastness'],
    4,
    false,
    true
  )
on conflict (id) do update
set
  name = excluded.name,
  testament = excluded.testament,
  sort_order = excluded.sort_order,
  chapter_count = excluded.chapter_count,
  short_description = excluded.short_description,
  overview = excluded.overview,
  why_read = excluded.why_read,
  key_themes = excluded.key_themes,
  preferred_continue_chapter = excluded.preferred_continue_chapter,
  is_featured_default = excluded.is_featured_default,
  is_active = excluded.is_active,
  updated_at = timezone('utc', now());

insert into public.content_book_aliases (book_id, alias)
values
  ('john', 'john'),
  ('john', 'jn'),
  ('psalms', 'psalm'),
  ('psalms', 'psalms'),
  ('psalms', 'ps'),
  ('philippians', 'philippians'),
  ('philippians', 'phil'),
  ('philippians', 'php')
on conflict (book_id, alias) do nothing;

insert into public.content_bible_chapters (
  book_id,
  chapter_number,
  title,
  introduction,
  focus_line
)
values
  (
    'john',
    1,
    'The Word made flesh',
    'John opens high and deep. He does not begin with a stable scene first, but with the eternal Word, then moves toward the Word becoming flesh and dwelling among us.',
    'This chapter frames Jesus not merely as teacher, but as the eternal Word entering human history.'
  ),
  (
    'john',
    2,
    'The wedding at Cana',
    'John’s second chapter shows Jesus turning water into wine and then cleansing the temple. It reveals both grace and authority.',
    'Jesus is not distant from ordinary life, yet He is never reduced to ordinary expectations.'
  ),
  (
    'john',
    3,
    'You must be born again',
    'Jesus speaks with Nicodemus and explains the need for spiritual rebirth, then the chapter moves into one of the clearest gospel invitations in scripture.',
    'This chapter moves from confusion to invitation, from human limitation to God’s saving love.'
  ),
  (
    'psalms',
    23,
    'The Lord my shepherd',
    'Psalm 23 is one of the clearest pictures of God’s care, guidance, and steady presence through both rest and danger.',
    'The peace of the psalm comes from the Shepherd’s presence, not from the absence of valleys.'
  ),
  (
    'psalms',
    27,
    'Whom shall I fear?',
    'Psalm 27 holds courage and longing together. David speaks boldly of confidence in God while still voicing his need and desire.',
    'Faith here is not pretending there is no threat. It is choosing where fear will not rule.'
  ),
  (
    'philippians',
    1,
    'Confidence in God’s work',
    'Paul writes with affection and confidence that God will continue the work He has begun in believers.',
    'This chapter keeps the reader grounded in God’s faithfulness rather than personal perfection.'
  ),
  (
    'philippians',
    4,
    'Prayer and peace',
    'Philippians 4 moves through rejoicing, gentleness, prayer, thought life, and contentment in Christ.',
    'The chapter teaches peace as a Christ-centered posture shaped by prayer and trust.'
  )
on conflict (book_id, chapter_number) do update
set
  title = excluded.title,
  introduction = excluded.introduction,
  focus_line = excluded.focus_line,
  updated_at = timezone('utc', now());

with source_sections (book_id, chapter_number, sort_order, heading, verse_start, verse_end) as (
  values
    ('john', 1, 1, 'The eternal Word', 1, 5),
    ('john', 1, 2, 'The Word became flesh', 14, 14),
    ('john', 2, 1, 'The first sign', 7, 11),
    ('john', 2, 2, 'Zeal for the Father’s house', 16, 17),
    ('john', 3, 1, 'A new birth', 3, 8),
    ('john', 3, 2, 'God’s love and rescue', 16, 17),
    ('psalms', 23, 1, 'Provision and rest', 1, 3),
    ('psalms', 23, 2, 'Presence in the valley', 4, 6),
    ('psalms', 27, 1, 'Confidence in the Lord', 1, 3),
    ('psalms', 27, 2, 'One thing desired', 4, 4),
    ('philippians', 1, 1, 'A good work begun', 3, 6),
    ('philippians', 1, 2, 'Christ magnified', 20, 21),
    ('philippians', 4, 1, 'Pray instead of carrying everything alone', 4, 7),
    ('philippians', 4, 2, 'Contentment in Christ', 11, 13)
)
insert into public.content_chapter_sections (
  book_id,
  chapter_number,
  sort_order,
  heading,
  verse_start,
  verse_end
)
select
  book_id,
  chapter_number,
  sort_order,
  heading,
  verse_start,
  verse_end
from source_sections src
where not exists (
  select 1
  from public.content_chapter_sections existing
  where existing.book_id = src.book_id
    and existing.chapter_number = src.chapter_number
    and existing.sort_order = src.sort_order
);

with source_verses (version_id, book_id, chapter_number, verse_number, verse_text) as (
  values
    ('kjv', 'john', 1, 1, 'In the beginning was the Word, and the Word was with God, and the Word was God.'),
    ('kjv', 'john', 1, 2, 'The same was in the beginning with God.'),
    ('kjv', 'john', 1, 3, 'All things were made by him; and without him was not any thing made that was made.'),
    ('kjv', 'john', 1, 4, 'In him was life; and the life was the light of men.'),
    ('kjv', 'john', 1, 5, 'And the light shineth in darkness; and the darkness comprehended it not.'),
    ('kjv', 'john', 1, 14, 'And the Word was made flesh, and dwelt among us, and we beheld his glory...'),
    ('kjv', 'john', 2, 7, 'Jesus saith unto them, Fill the waterpots with water. And they filled them up to the brim.'),
    ('kjv', 'john', 2, 8, 'And he saith unto them, Draw out now, and bear unto the governor of the feast. And they bare it.'),
    ('kjv', 'john', 2, 11, 'This beginning of miracles did Jesus in Cana of Galilee, and manifested forth his glory; and his disciples believed on him.'),
    ('kjv', 'john', 2, 16, 'Take these things hence; make not my Father’s house an house of merchandise.'),
    ('kjv', 'john', 2, 17, 'And his disciples remembered that it was written, The zeal of thine house hath eaten me up.'),
    ('kjv', 'john', 3, 3, 'Except a man be born again, he cannot see the kingdom of God.'),
    ('kjv', 'john', 3, 5, 'Except a man be born of water and of the Spirit, he cannot enter into the kingdom of God.'),
    ('kjv', 'john', 3, 16, 'For God so loved the world, that he gave his only begotten Son...'),
    ('kjv', 'john', 3, 17, 'For God sent not his Son into the world to condemn the world; but that the world through him might be saved.'),
    ('kjv', 'psalms', 23, 1, 'The Lord is my shepherd; I shall not want.'),
    ('kjv', 'psalms', 23, 2, 'He maketh me to lie down in green pastures: he leadeth me beside the still waters.'),
    ('kjv', 'psalms', 23, 3, 'He restoreth my soul: he leadeth me in the paths of righteousness for his name’s sake.'),
    ('kjv', 'psalms', 23, 4, 'Yea, though I walk through the valley of the shadow of death, I will fear no evil: for thou art with me...'),
    ('kjv', 'psalms', 23, 6, 'Surely goodness and mercy shall follow me all the days of my life...'),
    ('kjv', 'psalms', 27, 1, 'The Lord is my light and my salvation; whom shall I fear?'),
    ('kjv', 'psalms', 27, 3, 'Though an host should encamp against me, my heart shall not fear...'),
    ('kjv', 'psalms', 27, 4, 'One thing have I desired of the Lord, that will I seek after...'),
    ('kjv', 'philippians', 1, 3, 'I thank my God upon every remembrance of you...'),
    ('kjv', 'philippians', 1, 6, 'He which hath begun a good work in you will perform it until the day of Jesus Christ.'),
    ('kjv', 'philippians', 1, 21, 'For to me to live is Christ, and to die is gain.'),
    ('kjv', 'philippians', 4, 4, 'Rejoice in the Lord alway: and again I say, Rejoice.'),
    ('kjv', 'philippians', 4, 6, 'Be careful for nothing; but in every thing by prayer and supplication with thanksgiving let your requests be made known unto God.'),
    ('kjv', 'philippians', 4, 7, 'And the peace of God, which passeth all understanding, shall keep your hearts and minds through Christ Jesus.'),
    ('kjv', 'philippians', 4, 11, '...for I have learned, in whatsoever state I am, therewith to be content.'),
    ('kjv', 'philippians', 4, 13, 'I can do all things through Christ which strengtheneth me.')
)
insert into public.content_bible_verses (
  version_id,
  book_id,
  chapter_number,
  verse_number,
  verse_text
)
select
  version_id,
  book_id,
  chapter_number,
  verse_number,
  verse_text
from source_verses
on conflict (version_id, book_id, chapter_number, verse_number) do update
set verse_text = excluded.verse_text;

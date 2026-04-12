-- Phase 11 follow-up: expand the V1 plans catalog with six additional
-- pastoral reading plans while preserving the Phase 11 schema and progress
-- model introduced in 202604093_plans_backend.sql.

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
    'hope_when_discouraged',
    'Hope When You Feel Discouraged',
    'A 6-day plan for steady hope when the heart feels worn down.',
    'Hope',
    6,
    'This plan is for seasons when discouragement lingers and hope feels harder to hold. Each day keeps the reading grounded in God''s faithfulness rather than quick emotional lift.',
    'It gives the reader a gentle path back toward hope through scripture, honest reflection, and patient prayer instead of pressure to feel better immediately.',
    4,
    true
  ),
  (
    'faith_when_doubt_wont_quiet_down',
    'Faith When Doubt Won''t Quiet Down',
    'A 6-day plan for bringing questions honestly before God.',
    'Faith in Doubt',
    6,
    'This plan is for readers who are carrying uncertainty, questions, or spiritual fatigue. It keeps the tone honest and reverent, making room for faith that seeks God without pretending doubt is absent.',
    'It helps the user bring doubt into the light of scripture, where faith can become more honest, more dependent, and more rooted in God''s character.',
    5,
    true
  ),
  (
    'forgiveness_when_letting_go_feels_hard',
    'Forgiveness When Letting Go Feels Hard',
    'A 6-day plan for mercy, healing, and releasing what keeps hurting.',
    'Forgiveness',
    6,
    'This plan is for moments when forgiveness feels costly, complicated, or deeply personal. It keeps the pace calm and scripture-centered while making room for the real struggle of letting go.',
    'It helps the reader move toward forgiveness without minimizing pain, grounding the process in God''s mercy, truth, and healing rather than denial.',
    6,
    true
  ),
  (
    'gratitude_in_heavy_seasons',
    'Gratitude in Heavy Seasons',
    'A 6-day plan for thankfulness that remains honest in hard times.',
    'Gratitude and Joy',
    6,
    'This plan is for heavy seasons when gratitude does not come easily. It keeps the reader from reducing thankfulness to denial and instead frames it as a faithful response to God in the middle of unfinished circumstances.',
    'It gives the reader a calm, realistic rhythm for noticing God''s faithfulness even when life still feels weighty.',
    7,
    true
  ),
  (
    'walking_in_obedience',
    'Walking in Obedience',
    'A 6-day plan for faithful steps, surrender, and trust in God''s way.',
    'Obedience',
    6,
    'This plan is for readers who want obedience to feel less like pressure and more like loving trust. Each day keeps the focus practical and scripture-centered, helping the heart respond to God with steadiness.',
    'It frames obedience as daily faithfulness shaped by trust, humility, and love instead of fear-driven performance.',
    8,
    true
  ),
  (
    'love_with_wisdom_and_patience',
    'Love with Wisdom and Patience',
    'A 6-day plan for relationships shaped by truth, gentleness, and steady love.',
    'Love and Relationships',
    6,
    'This plan is for readers who want their relationships to be formed by God''s wisdom rather than reaction, hurry, or frustration. It keeps the tone pastoral and practical for real-life love.',
    'It helps the reader see love as patient, discerning, and rooted in Christ rather than emotion alone.',
    9,
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
  'hope_when_discouraged',
  'faith_when_doubt_wont_quiet_down',
  'forgiveness_when_letting_go_feels_hard',
  'gratitude_in_heavy_seasons',
  'walking_in_obedience',
  'love_with_wisdom_and_patience'
);

delete from public.content_reading_plan_days
where plan_id in (
  'hope_when_discouraged',
  'faith_when_doubt_wont_quiet_down',
  'forgiveness_when_letting_go_feels_hard',
  'gratitude_in_heavy_seasons',
  'walking_in_obedience',
  'love_with_wisdom_and_patience'
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
    'hope_when_discouraged',
    1,
    'Bring your discouragement into the light',
    'Biblical hope begins by bringing weary hearts honestly before God.',
    'The first day opens with honesty. Discouragement grows heavier when it stays hidden, but scripture keeps inviting the reader to pour out the heart before God.',
    'What discouragement have you been carrying quietly that needs to be brought honestly before God today?',
    'Lord, I bring You the discouragement I have been holding. Meet me with Your mercy and steadiness.'
  ),
  (
    'hope_when_discouraged',
    2,
    'Remember what God has done',
    'Hope is strengthened when the heart remembers the faithfulness of God.',
    'This day helps the reader look backward in faith so present discouragement does not become the only story being told.',
    'Where have you forgotten God''s past faithfulness because today feels heavy?',
    'God, help me remember Your faithfulness when discouragement narrows my vision.'
  ),
  (
    'hope_when_discouraged',
    3,
    'Wait with expectation',
    'Waiting on God is not empty resignation. It is hopeful dependence.',
    'This day reframes waiting as a place where hope can deepen instead of collapse.',
    'Where are you being asked to wait, and how can waiting become trust instead of despair?',
    'Lord, keep me from giving up while I wait. Teach me hopeful dependence on You.'
  ),
  (
    'hope_when_discouraged',
    4,
    'Let truth steady your heart',
    'Hope grows when the soul is anchored in what is true about God.',
    'This day helps the reader move from mood-led discouragement toward truth-shaped steadiness.',
    'What truth about God do you need to speak back to your discouragement today?',
    'God, steady my heart in what is true when my emotions feel unreliable.'
  ),
  (
    'hope_when_discouraged',
    5,
    'Take the next faithful step',
    'Hope often returns through small acts of steady faithfulness.',
    'This day reminds the reader that hope does not always arrive dramatically. Sometimes it grows through the next faithful step under God.',
    'What is one faithful next step you can take without waiting to feel fully strong first?',
    'Lord, help me keep walking with You one faithful step at a time.'
  ),
  (
    'hope_when_discouraged',
    6,
    'Hold onto God''s future',
    'Christian hope rests in God''s promises, not only present circumstances.',
    'The final day helps the reader lift the eyes beyond the present moment and rest in the future God is holding.',
    'How does God''s promised future change the way you look at your present discouragement?',
    'Father, hold my heart in hope and keep me anchored in Your promises.'
  ),

  (
    'faith_when_doubt_wont_quiet_down',
    1,
    'Bring your questions honestly',
    'God is not threatened by honest questions brought in faith.',
    'The first day makes room for the reader to stop hiding doubt and bring it honestly before God.',
    'What question or uncertainty have you been carrying but hesitating to bring before God?',
    'Lord, I bring You my questions. Teach me to seek You honestly rather than pretend certainty.'
  ),
  (
    'faith_when_doubt_wont_quiet_down',
    2,
    'Remember who Jesus is',
    'Faith is steadied when attention returns to the person and character of Christ.',
    'This day redirects the reader from spiraling inner uncertainty toward the trustworthy person of Jesus.',
    'How might looking more carefully at Jesus reshape the way you carry your doubt?',
    'Jesus, help me see You clearly and let my faith rest in who You are.'
  ),
  (
    'faith_when_doubt_wont_quiet_down',
    3,
    'Ask for help believing',
    'Weak faith still belongs before God when it asks for mercy and help.',
    'This day keeps the reader from confusing honest weakness with spiritual failure.',
    'Where do you need to pray, "I believe; help my unbelief" with greater honesty?',
    'God, meet my weak faith with mercy and strengthen what feels unsteady.'
  ),
  (
    'faith_when_doubt_wont_quiet_down',
    4,
    'Stay rooted in what is written',
    'Scripture keeps faith grounded when emotions and questions keep shifting.',
    'This day encourages the reader to return to God''s word as a stable place for trust.',
    'What part of your faith needs to be re-anchored in scripture instead of passing emotion?',
    'Lord, root my faith in Your word when I feel unsettled and uncertain.'
  ),
  (
    'faith_when_doubt_wont_quiet_down',
    5,
    'Keep near to God',
    'Faith is not only certainty of thought. It is continued nearness to God.',
    'This day reminds the reader that drawing near to God still matters even when not every question is resolved.',
    'How can you remain near to God even while some questions are still unanswered?',
    'Father, keep me near You even when my mind is still working through doubt.'
  ),
  (
    'faith_when_doubt_wont_quiet_down',
    6,
    'Trust Him with what remains unresolved',
    'Faith matures when unanswered things are still entrusted to God.',
    'The final day helps the reader hand unresolved questions to God without walking away from Him.',
    'What unresolved part of your faith journey do you need to place into God''s hands today?',
    'God, I entrust to You what I do not yet understand. Keep my faith faithful and near.'
  ),

  (
    'forgiveness_when_letting_go_feels_hard',
    1,
    'Acknowledge the wound truthfully',
    'Forgiveness does not begin by pretending the pain was small.',
    'The first day invites honest naming of what was painful so forgiveness is not built on denial.',
    'What hurt do you need to acknowledge truthfully before God instead of minimizing it?',
    'Lord, help me face this wound honestly in Your presence.'
  ),
  (
    'forgiveness_when_letting_go_feels_hard',
    2,
    'Remember the mercy you have received',
    'God''s mercy softens the heart without excusing what was wrong.',
    'This day helps the reader remember that forgiveness flows from God''s mercy received, not from pretending justice does not matter.',
    'How does remembering God''s mercy toward you affect the way you view forgiveness?',
    'God, remind me of the mercy You have shown me and let it shape my heart.'
  ),
  (
    'forgiveness_when_letting_go_feels_hard',
    3,
    'Release revenge to God',
    'Forgiveness lets go of personal vengeance and entrusts justice to God.',
    'This day helps the reader distinguish forgiveness from retaliation, bitterness, and self-appointed justice.',
    'Where are you still holding onto the desire to settle the wound in your own way?',
    'Lord, help me release revenge and entrust justice to You.'
  ),
  (
    'forgiveness_when_letting_go_feels_hard',
    4,
    'Pray through resistance',
    'Resistance in forgiveness is real, and God invites it into prayer.',
    'This day gives the reader permission to bring resistance to forgiveness into God''s presence rather than hide it.',
    'What part of forgiveness still feels impossible or deeply resisted in you?',
    'God, meet me where forgiveness still feels hard and reshape my heart with grace.'
  ),
  (
    'forgiveness_when_letting_go_feels_hard',
    5,
    'Choose peace without pretending',
    'Forgiveness seeks peace while still honoring truth and wisdom.',
    'This day helps the reader pursue peace without collapsing healthy boundaries or honesty.',
    'How can you move toward peace without denying what is true or wise?',
    'Father, teach me how to walk in peace with both truth and wisdom.'
  ),
  (
    'forgiveness_when_letting_go_feels_hard',
    6,
    'Keep your heart free',
    'Forgiveness is part of guarding the heart from bitterness over time.',
    'The final day focuses on the long-term freedom God desires for the heart that keeps returning to mercy.',
    'What would it look like to guard your heart from bitterness after this point?',
    'Lord, keep my heart free from bitterness and rooted in Your healing mercy.'
  ),

  (
    'gratitude_in_heavy_seasons',
    1,
    'Tell the truth about the heaviness',
    'Gratitude grows best where sorrow is not denied.',
    'The first day reminds the reader that thanksgiving is not built by pretending the season is light when it is not.',
    'Where do you need to be more honest with God about the heaviness you are carrying?',
    'God, help me tell the truth about my season without losing sight of You.'
  ),
  (
    'gratitude_in_heavy_seasons',
    2,
    'Notice daily mercies',
    'God''s mercies still meet the heart even in hard seasons.',
    'This day helps the reader look for evidence of God''s care without demanding that life be easy first.',
    'What small mercy from God have you overlooked because your season feels heavy?',
    'Lord, open my eyes to Your mercies that are present even here.'
  ),
  (
    'gratitude_in_heavy_seasons',
    3,
    'Give thanks with sincerity',
    'Thanksgiving is strongest when it is sincere, not forced.',
    'This day encourages gratitude that is simple, honest, and rooted in God''s worthiness.',
    'What sincere thanks can you offer God today without pretending everything is fine?',
    'God, receive my honest thanks and keep my heart open before You.'
  ),
  (
    'gratitude_in_heavy_seasons',
    4,
    'Let gratitude soften the heart',
    'Thankfulness can gently loosen the grip of fear, resentment, and despair.',
    'This day focuses on the way gratitude reshapes the inner posture of the heart toward God.',
    'What hardness in your heart might gratitude begin to soften?',
    'Father, let gratitude soften what has grown tense, guarded, or weary in me.'
  ),
  (
    'gratitude_in_heavy_seasons',
    5,
    'Remember joy is still possible',
    'Joy in God is not erased simply because the season is hard.',
    'This day helps the reader remember that joy can remain rooted in God even when circumstances still feel unfinished.',
    'How might joy in God still be possible in your life right now?',
    'Lord, restore a quiet joy in You even while this season remains heavy.'
  ),
  (
    'gratitude_in_heavy_seasons',
    6,
    'Carry thanksgiving forward',
    'Gratitude becomes a steady rhythm when it keeps returning to God.',
    'The final day helps the reader continue gratitude as a faithful habit rather than a temporary mood.',
    'What practice could help you keep returning to gratitude after this plan ends?',
    'God, shape in me a grateful heart that keeps returning to You.'
  ),

  (
    'walking_in_obedience',
    1,
    'Start with surrender',
    'Obedience begins with a yielded heart before it becomes a visible action.',
    'The first day grounds obedience in surrender to God rather than external performance alone.',
    'What area of your life still resists being fully yielded to God?',
    'Lord, I offer You my heart again. Teach me willing surrender.'
  ),
  (
    'walking_in_obedience',
    2,
    'Trust God''s way',
    'Obedience grows where the heart trusts that God''s way is good.',
    'This day reminds the reader that obedience is tied to trust in God''s character, not only rule-keeping.',
    'Where is obedience difficult because you are struggling to trust God''s way?',
    'God, deepen my trust where obedience feels costly or unclear.'
  ),
  (
    'walking_in_obedience',
    3,
    'Walk in what you already know',
    'Faithfulness often begins with obeying the light God has already given.',
    'This day keeps the reader from waiting for perfect clarity before taking faithful action.',
    'What is one area where God has already made the next step clear to you?',
    'Lord, help me obey what I already know instead of delaying in hesitation.'
  ),
  (
    'walking_in_obedience',
    4,
    'Choose obedience over convenience',
    'Godly obedience often asks for faithfulness beyond what feels easiest.',
    'This day helps the reader notice where convenience, comfort, or self-protection are competing with obedience.',
    'Where are you tempted to choose convenience instead of what honors God?',
    'Father, give me courage to choose obedience over comfort.'
  ),
  (
    'walking_in_obedience',
    5,
    'Stay humble and teachable',
    'Obedience remains healthy when the heart stays humble before God.',
    'This day focuses on teachability so obedience does not become self-righteousness or stubborn striving.',
    'What would a more teachable posture before God look like for you right now?',
    'God, keep my heart humble, soft, and ready to follow You.'
  ),
  (
    'walking_in_obedience',
    6,
    'Keep walking faithfully',
    'Obedience is often a steady rhythm, not one dramatic moment.',
    'The final day encourages the reader to see obedience as daily faithfulness shaped by love for God.',
    'What steady pattern of obedience is God inviting you to continue after this plan?',
    'Lord, keep me faithful in the quiet daily steps of obedience.'
  ),

  (
    'love_with_wisdom_and_patience',
    1,
    'Begin with the love of Christ',
    'Healthy love grows best when it is first shaped by Christ.',
    'The first day reminds the reader that love in relationships begins by being rooted in the love received from God.',
    'How does Christ''s love need to reshape the way you relate to others right now?',
    'Jesus, root the way I love others in the love You have shown me.'
  ),
  (
    'love_with_wisdom_and_patience',
    2,
    'Practice patience in pressure',
    'Patient love is often formed in ordinary moments of tension and delay.',
    'This day helps the reader see patience not as passivity but as faithful restraint under God.',
    'Where is impatience most likely to show up in your relationships right now?',
    'Lord, teach me patient love when I feel hurried, irritated, or reactive.'
  ),
  (
    'love_with_wisdom_and_patience',
    3,
    'Speak with gentleness and truth',
    'Love is kind, but it is also honest and wise.',
    'This day helps the reader hold together grace and truth instead of sacrificing one for the other.',
    'What conversation in your life needs both greater gentleness and greater honesty?',
    'God, help my words be truthful, gentle, and fitting for the moment.'
  ),
  (
    'love_with_wisdom_and_patience',
    4,
    'Bear with one another wisely',
    'Love makes room for weakness without abandoning wisdom or boundaries.',
    'This day reminds the reader that relational patience does not mean ignoring what is unhealthy or untrue.',
    'Where do you need wisdom to love someone well without losing discernment?',
    'Father, teach me how to love with both patience and wisdom.'
  ),
  (
    'love_with_wisdom_and_patience',
    5,
    'Pursue peace where possible',
    'Godly love seeks peace without forcing control over every outcome.',
    'This day helps the reader move toward peace while remaining humble about what cannot be controlled.',
    'What peaceful step can you take in a relationship without trying to control everything?',
    'Lord, help me pursue peace with humility, courage, and grace.'
  ),
  (
    'love_with_wisdom_and_patience',
    6,
    'Let love remain steady',
    'Love matures through steady faithfulness over time.',
    'The final day encourages the reader to keep practicing patient, wise love as a long-term rhythm shaped by Christ.',
    'What steady practice could help your love remain more patient and grounded after this plan ends?',
    'God, keep my love steady, wise, and shaped by Your presence.'
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
  ('hope_when_discouraged', 1, 1, 'Psalm 42:5', 'psalms', 42, 5, 42, 5),
  ('hope_when_discouraged', 1, 2, 'Psalm 62:8', 'psalms', 62, 8, 62, 8),
  ('hope_when_discouraged', 2, 1, 'Lamentations 3:21-23', 'lamentations', 3, 21, 3, 23),
  ('hope_when_discouraged', 2, 2, 'Psalm 77:11-14', 'psalms', 77, 11, 77, 14),
  ('hope_when_discouraged', 3, 1, 'Isaiah 40:31', 'isaiah', 40, 31, 40, 31),
  ('hope_when_discouraged', 3, 2, 'Psalm 130:5', 'psalms', 130, 5, 130, 5),
  ('hope_when_discouraged', 4, 1, 'Romans 15:13', 'romans', 15, 13, 15, 13),
  ('hope_when_discouraged', 4, 2, 'Hebrews 10:23', 'hebrews', 10, 23, 10, 23),
  ('hope_when_discouraged', 5, 1, 'Galatians 6:9', 'galatians', 6, 9, 6, 9),
  ('hope_when_discouraged', 5, 2, 'Psalm 27:13-14', 'psalms', 27, 13, 27, 14),
  ('hope_when_discouraged', 6, 1, 'Romans 8:24-25', 'romans', 8, 24, 8, 25),
  ('hope_when_discouraged', 6, 2, 'Revelation 21:4-5', 'revelation', 21, 4, 21, 5),

  ('faith_when_doubt_wont_quiet_down', 1, 1, 'Psalm 73:21-26', 'psalms', 73, 21, 73, 26),
  ('faith_when_doubt_wont_quiet_down', 1, 2, 'Mark 9:24', 'mark', 9, 24, 9, 24),
  ('faith_when_doubt_wont_quiet_down', 2, 1, 'John 6:68-69', 'john', 6, 68, 6, 69),
  ('faith_when_doubt_wont_quiet_down', 2, 2, 'Hebrews 1:1-3', 'hebrews', 1, 1, 1, 3),
  ('faith_when_doubt_wont_quiet_down', 3, 1, 'Mark 9:14-29', 'mark', 9, 14, 9, 29),
  ('faith_when_doubt_wont_quiet_down', 3, 2, 'Jude 22', 'jude', 1, 22, 1, 22),
  ('faith_when_doubt_wont_quiet_down', 4, 1, 'Romans 10:17', 'romans', 10, 17, 10, 17),
  ('faith_when_doubt_wont_quiet_down', 4, 2, 'Psalm 119:105', 'psalms', 119, 105, 119, 105),
  ('faith_when_doubt_wont_quiet_down', 5, 1, 'James 4:8', 'james', 4, 8, 4, 8),
  ('faith_when_doubt_wont_quiet_down', 5, 2, 'Psalm 34:18', 'psalms', 34, 18, 34, 18),
  ('faith_when_doubt_wont_quiet_down', 6, 1, 'Proverbs 3:5-6', 'proverbs', 3, 5, 3, 6),
  ('faith_when_doubt_wont_quiet_down', 6, 2, 'Deuteronomy 29:29', 'deuteronomy', 29, 29, 29, 29),

  ('forgiveness_when_letting_go_feels_hard', 1, 1, 'Psalm 55:22', 'psalms', 55, 22, 55, 22),
  ('forgiveness_when_letting_go_feels_hard', 1, 2, 'Psalm 62:8', 'psalms', 62, 8, 62, 8),
  ('forgiveness_when_letting_go_feels_hard', 2, 1, 'Ephesians 4:31-32', 'ephesians', 4, 31, 4, 32),
  ('forgiveness_when_letting_go_feels_hard', 2, 2, 'Colossians 3:12-13', 'colossians', 3, 12, 3, 13),
  ('forgiveness_when_letting_go_feels_hard', 3, 1, 'Romans 12:17-19', 'romans', 12, 17, 12, 19),
  ('forgiveness_when_letting_go_feels_hard', 3, 2, 'Deuteronomy 32:35', 'deuteronomy', 32, 35, 32, 35),
  ('forgiveness_when_letting_go_feels_hard', 4, 1, 'Psalm 139:23-24', 'psalms', 139, 23, 139, 24),
  ('forgiveness_when_letting_go_feels_hard', 4, 2, 'Matthew 26:41', 'matthew', 26, 41, 26, 41),
  ('forgiveness_when_letting_go_feels_hard', 5, 1, 'Romans 12:18', 'romans', 12, 18, 12, 18),
  ('forgiveness_when_letting_go_feels_hard', 5, 2, 'James 3:17-18', 'james', 3, 17, 3, 18),
  ('forgiveness_when_letting_go_feels_hard', 6, 1, 'Hebrews 12:14-15', 'hebrews', 12, 14, 12, 15),
  ('forgiveness_when_letting_go_feels_hard', 6, 2, 'Proverbs 4:23', 'proverbs', 4, 23, 4, 23),

  ('gratitude_in_heavy_seasons', 1, 1, 'Psalm 13:1-6', 'psalms', 13, 1, 13, 6),
  ('gratitude_in_heavy_seasons', 1, 2, '2 Corinthians 1:3-4', '2-corinthians', 1, 3, 1, 4),
  ('gratitude_in_heavy_seasons', 2, 1, 'Lamentations 3:22-23', 'lamentations', 3, 22, 3, 23),
  ('gratitude_in_heavy_seasons', 2, 2, 'Psalm 103:1-5', 'psalms', 103, 1, 103, 5),
  ('gratitude_in_heavy_seasons', 3, 1, '1 Thessalonians 5:16-18', '1-thessalonians', 5, 16, 5, 18),
  ('gratitude_in_heavy_seasons', 3, 2, 'Colossians 3:15-17', 'colossians', 3, 15, 3, 17),
  ('gratitude_in_heavy_seasons', 4, 1, 'Psalm 95:1-3', 'psalms', 95, 1, 95, 3),
  ('gratitude_in_heavy_seasons', 4, 2, 'Philippians 4:6-7', 'philippians', 4, 6, 4, 7),
  ('gratitude_in_heavy_seasons', 5, 1, 'Habakkuk 3:17-19', 'habakkuk', 3, 17, 3, 19),
  ('gratitude_in_heavy_seasons', 5, 2, 'Romans 15:13', 'romans', 15, 13, 15, 13),
  ('gratitude_in_heavy_seasons', 6, 1, 'Psalm 92:1-2', 'psalms', 92, 1, 92, 2),
  ('gratitude_in_heavy_seasons', 6, 2, 'James 1:17', 'james', 1, 17, 1, 17),

  ('walking_in_obedience', 1, 1, 'Romans 12:1-2', 'romans', 12, 1, 12, 2),
  ('walking_in_obedience', 1, 2, 'Psalm 143:10', 'psalms', 143, 10, 143, 10),
  ('walking_in_obedience', 2, 1, 'John 14:15', 'john', 14, 15, 14, 15),
  ('walking_in_obedience', 2, 2, 'Psalm 119:33-35', 'psalms', 119, 33, 119, 35),
  ('walking_in_obedience', 3, 1, 'James 1:22-25', 'james', 1, 22, 1, 25),
  ('walking_in_obedience', 3, 2, 'Luke 11:28', 'luke', 11, 28, 11, 28),
  ('walking_in_obedience', 4, 1, 'Deuteronomy 10:12-13', 'deuteronomy', 10, 12, 10, 13),
  ('walking_in_obedience', 4, 2, 'Matthew 7:24-25', 'matthew', 7, 24, 7, 25),
  ('walking_in_obedience', 5, 1, 'Micah 6:8', 'micah', 6, 8, 6, 8),
  ('walking_in_obedience', 5, 2, 'Philippians 2:12-13', 'philippians', 2, 12, 2, 13),
  ('walking_in_obedience', 6, 1, 'Colossians 1:9-10', 'colossians', 1, 9, 1, 10),
  ('walking_in_obedience', 6, 2, 'Hebrews 12:1-2', 'hebrews', 12, 1, 12, 2),

  ('love_with_wisdom_and_patience', 1, 1, '1 John 4:10-11', '1-john', 4, 10, 4, 11),
  ('love_with_wisdom_and_patience', 1, 2, 'John 13:34-35', 'john', 13, 34, 13, 35),
  ('love_with_wisdom_and_patience', 2, 1, '1 Corinthians 13:4-5', '1-corinthians', 13, 4, 13, 5),
  ('love_with_wisdom_and_patience', 2, 2, 'James 1:19', 'james', 1, 19, 1, 19),
  ('love_with_wisdom_and_patience', 3, 1, 'Ephesians 4:15', 'ephesians', 4, 15, 4, 15),
  ('love_with_wisdom_and_patience', 3, 2, 'Proverbs 15:1', 'proverbs', 15, 1, 15, 1),
  ('love_with_wisdom_and_patience', 4, 1, 'Colossians 3:12-14', 'colossians', 3, 12, 3, 14),
  ('love_with_wisdom_and_patience', 4, 2, 'Philippians 1:9-10', 'philippians', 1, 9, 1, 10),
  ('love_with_wisdom_and_patience', 5, 1, 'Romans 12:18', 'romans', 12, 18, 12, 18),
  ('love_with_wisdom_and_patience', 5, 2, 'Matthew 5:9', 'matthew', 5, 9, 5, 9),
  ('love_with_wisdom_and_patience', 6, 1, '1 Corinthians 16:14', '1-corinthians', 16, 14, 16, 14),
  ('love_with_wisdom_and_patience', 6, 2, 'Colossians 3:15', 'colossians', 3, 15, 3, 15);

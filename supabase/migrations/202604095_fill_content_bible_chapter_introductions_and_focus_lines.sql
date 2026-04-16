-- Phase 13: complete missing chapter-level introduction and focus line content for V1.
-- Conservative by design: only blank introduction/focus_line fields are filled.

create or replace function public.phase13_chapter_introduction(
  chapter_book_id text,
  chapter_number integer
)
returns text
language sql
immutable
as $$
  select case chapter_book_id
    when 'genesis' then case
      when chapter_number between 1 and 2 then 'Genesis opens with God creating, ordering, and blessing the world. These chapters ground the story of scripture in His power, goodness, and purpose.'
      when chapter_number = 3 then 'The human story turns here as trust gives way to rebellion. Genesis 3 explains both the wound of sin and the first hint that God will not leave creation without hope.'
      when chapter_number between 4 and 5 then 'These chapters trace the spread of sin and the quiet persistence of God''s preserving grace. The line of the promise continues even in a fractured world.'
      when chapter_number between 6 and 9 then 'The flood account shows both the seriousness of human evil and the mercy of God in preserving life. Judgment and covenant stand side by side in these chapters.'
      when chapter_number between 10 and 11 then 'Genesis widens its view to nations, languages, and human pride. The scattering of Babel sets the stage for God''s covenant work through one family.'
      when chapter_number between 12 and 17 then 'God calls Abram and begins to shape a covenant people through promise, faith, and waiting. These chapters introduce the long arc of blessing that will reach far beyond one household.'
      when chapter_number between 18 and 19 then 'These chapters hold mercy, intercession, and judgment together. God is attentive to both the cries of the vulnerable and the weight of human wickedness.'
      when chapter_number between 20 and 22 then 'The promise line is tested, protected, and deepened here. Genesis keeps showing that God remains faithful even when fear, delay, or costly obedience press hard.'
      when chapter_number between 23 and 25 then 'Loss, transition, and God''s ongoing promise shape this part of Genesis. The story moves from Abraham''s later years toward the next generation with steady covenant focus.'
      when chapter_number between 26 and 28 then 'These chapters follow Isaac and Jacob through conflict, blessing, and turning points. God''s promise continues through imperfect people and surprising moments of encounter.'
      when chapter_number between 29 and 31 then 'Jacob''s household grows through strain, labor, and complicated relationships. Even in tangled family history, God keeps building what He has promised.'
      when chapter_number between 32 and 36 then 'Return, reconciliation, grief, and family lines shape these chapters. Genesis slows down long enough to show that God forms His people through both struggle and mercy.'
      when chapter_number between 37 and 41 then 'Joseph''s story begins in betrayal and moves through suffering toward providential elevation. God''s hidden guidance becomes clearer with each chapter.'
      when chapter_number between 42 and 45 then 'The famine brings Joseph''s brothers back into the story and exposes old wounds. These chapters are rich with testing, repentance, and unexpected mercy.'
      when chapter_number between 46 and 50 then 'Genesis closes by settling Jacob''s family in Egypt and looking ahead with faith. Death, blessing, and promise all point forward to what God will do next.'
      else ''
    end
    when 'exodus' then case
      when chapter_number between 1 and 4 then 'Exodus begins in oppression, rescue, and calling. God sees His people, remembers His covenant, and prepares to act through Moses.'
      when chapter_number between 5 and 11 then 'Resistance hardens and the contest between Pharaoh and the Lord intensifies. These chapters reveal God''s authority over false power and His resolve to deliver.'
      when chapter_number between 12 and 15 then 'Passover, departure, and deliverance at the sea stand at the heart of Exodus. God saves His people in a way they will be called to remember for generations.'
      when chapter_number between 16 and 18 then 'In the wilderness, need becomes a classroom for trust. God provides daily bread, guidance, and help for a newly freed people.'
      when chapter_number between 19 and 24 then 'Israel comes to Sinai and learns that deliverance leads into covenant life. God draws near, speaks clearly, and calls His people into holy belonging.'
      when chapter_number between 25 and 31 then 'These chapters turn toward worship and the tabernacle. God is not only rescuing a people from slavery but shaping a people who will live near His presence.'
      when chapter_number between 32 and 34 then 'Sin at the golden calf threatens the covenant, yet mercy is not withdrawn. Exodus shows both the seriousness of idolatry and the wonder of God''s restoring grace.'
      when chapter_number between 35 and 40 then 'Exodus closes with willing obedience, skilled work, and the tabernacle completed. The final note is not human achievement but the glory of God dwelling among His people.'
      else ''
    end
    when 'leviticus' then case
      when chapter_number between 1 and 7 then 'Leviticus opens by teaching sacrifice, worship, and atonement. These chapters show that drawing near to a holy God is possible only through the way He provides.'
      when chapter_number between 8 and 10 then 'Priestly consecration and warning come into sharp focus here. God''s holiness is not distant or abstract; it shapes the way His people approach Him.'
      when chapter_number between 11 and 15 then 'These chapters address purity, uncleanness, and the realities of embodied life. Leviticus teaches that holiness touches ordinary living, not only formal worship.'
      when chapter_number = 16 then 'The Day of Atonement stands at the center of Leviticus. This chapter gathers together cleansing, substitution, and the mercy of God for a sinful people.'
      when chapter_number between 17 and 22 then 'Holiness now moves outward into worship, ethics, relationships, and leadership. God''s people are called to reflect His character in the shape of daily life.'
      when chapter_number between 23 and 25 then 'Sacred times, worship rhythms, and covenant mercy fill these chapters. Leviticus teaches Israel to remember that time, land, and rest all belong to God.'
      when chapter_number between 26 and 27 then 'The book closes with covenant blessing, warning, and vows. Leviticus ends by pressing the heart toward reverence, obedience, and wholehearted devotion.'
      else ''
    end
    when 'numbers' then case
      when chapter_number between 1 and 4 then 'Numbers begins with ordering the camp for a journey under God''s care. Even these early chapters show that God leads His people with purpose and presence.'
      when chapter_number between 5 and 10 then 'Holiness, worship, and readiness shape this section before the journey advances. Israel is being formed to move with God in ordered trust.'
      when chapter_number between 11 and 14 then 'Complaint, fear, and unbelief rise sharply in these chapters. Numbers shows how quickly a people can forget grace when hardship becomes their main focus.'
      when chapter_number between 15 and 19 then 'After failure, God still gives instruction, warning, and means of cleansing. Mercy continues to run alongside discipline in the wilderness story.'
      when chapter_number between 20 and 25 then 'Leadership strain, conflict, and surprising moments of blessing shape these chapters. God remains faithful even when His people falter again and again.'
      when chapter_number between 26 and 30 then 'A new generation comes into view as Numbers turns toward inheritance and covenant order. The story begins to look ahead instead of only back.'
      when chapter_number between 31 and 36 then 'Numbers closes with preparation for entering the land. Justice, boundaries, and inheritance all underline that God is still bringing His promise to fulfillment.'
      else ''
    end
    when 'deuteronomy' then case
      when chapter_number between 1 and 4 then 'Deuteronomy opens with remembered history and renewed perspective. Moses calls the people to learn from the past as they prepare to step into the promise.'
      when chapter_number between 5 and 11 then 'These chapters gather the covenant call around love, memory, and wholehearted obedience. Deuteronomy keeps pressing truth from the level of law down into the level of the heart.'
      when chapter_number between 12 and 18 then 'Worship, leadership, and daily covenant life take concrete shape here. God''s people are being taught how to live differently in the land they are about to receive.'
      when chapter_number between 19 and 26 then 'Justice, mercy, worship, and communal responsibility fill this part of the book. Deuteronomy shows that covenant life is both spiritual and deeply practical.'
      when chapter_number between 27 and 30 then 'Blessing and warning are set plainly before the people. Moses speaks with urgency because covenant choices shape the future of the whole community.'
      when chapter_number between 31 and 34 then 'Deuteronomy closes with transition, song, blessing, and the death of Moses. The ending is tender and weighty, but it still points forward to God''s ongoing faithfulness.'
      else ''
    end
    when 'joshua' then case
      when chapter_number between 1 and 5 then 'Joshua begins with transition, courage, and crossing into the promised land. God''s presence is the steady ground beneath the people''s next step.'
      when chapter_number between 6 and 12 then 'Victory and conflict fill these chapters as Israel takes possession of the land. Joshua keeps showing that success depends on trusting and obeying the Lord.'
      when chapter_number between 13 and 22 then 'The long work of inheritance and settlement takes center stage here. These chapters may feel quieter, but they underline that God truly gives what He promised.'
      when chapter_number between 23 and 24 then 'Joshua ends with remembrance and covenant renewal. The final call is simple and searching: remain faithful to the Lord who has brought you this far.'
      else ''
    end
    when 'judges' then case
      when chapter_number between 1 and 3 then 'Judges opens by showing incomplete obedience and the beginning of Israel''s downward cycle. The book quickly makes clear that compromise never stays small.'
      when chapter_number between 4 and 5 then 'Deborah''s leadership and the song of victory bring a bright moment in a dark period. God still raises deliverance in surprising and powerful ways.'
      when chapter_number between 6 and 8 then 'Gideon''s story mixes fear, grace, weakness, and victory. Judges reminds the reader that God can work through fragile faith without celebrating human pride.'
      when chapter_number between 9 and 10 then 'These chapters return to the instability of self-seeking leadership and recurring decline. The need for righteousness in Israel grows more obvious.'
      when chapter_number between 11 and 12 then 'Jephthah''s account is both tragic and sobering. Judges continues to show what happens when spiritual confusion shapes leadership.'
      when chapter_number between 13 and 16 then 'Samson''s story is full of strength, compromise, and missed calling. The book exposes how giftedness without faithfulness can still end in ruin.'
      when chapter_number between 17 and 21 then 'Judges closes with disorder that is painful to read and impossible to dismiss. The final chapters leave the reader longing for faithful leadership and covenant renewal.'
      else ''
    end
    when 'ruth' then case
      when chapter_number = 1 then 'Ruth begins in grief, loss, and a costly decision to stay close in love and faith. The chapter turns hardship into the opening for quiet redemption.'
      when chapter_number = 2 then 'Kindness meets need in the fields of Bethlehem. God''s care begins to appear through ordinary generosity and faithful provision.'
      when chapter_number = 3 then 'Ruth 3 moves carefully through risk, humility, and hope. The chapter holds tenderness and trust together as redemption comes nearer.'
      when chapter_number = 4 then 'Ruth closes with redemption completed and a future opened beyond immediate sorrow. What began in emptiness ends with belonging, joy, and covenant hope.'
      else ''
    end
    when '1-samuel' then case
      when chapter_number between 1 and 3 then '1 Samuel begins with prayer, birth, and the call of a prophet. God is already at work in hidden places before public leadership changes.'
      when chapter_number between 4 and 7 then 'These chapters expose the weakness of empty religion and the holiness of God. Israel must learn that God''s presence cannot be managed on human terms.'
      when chapter_number between 8 and 12 then 'Israel asks for a king, and the cost of that desire comes into view. Even here, God remains faithful while warning His people about misplaced trust.'
      when chapter_number between 13 and 15 then 'Saul''s reign begins to unravel through fear and disobedience. The book presses the question of what kind of heart can truly lead under God.'
      when chapter_number between 16 and 20 then 'David enters the story as the anointed yet not-yet-enthroned king. These chapters hold courage, friendship, tension, and waiting together.'
      when chapter_number between 21 and 26 then 'David lives in pressure, exile, and restraint. 1 Samuel shows that true leadership is tested by what a person does before power is finally theirs.'
      when chapter_number between 27 and 31 then 'The book closes with crisis, battle, and Saul''s tragic end. The transition is painful, but it clears the way for God''s larger purpose through David.'
      else ''
    end
    when '2-samuel' then case
      when chapter_number between 1 and 5 then '2 Samuel opens with grief, transition, and the rise of David''s kingdom. The story moves toward settled leadership while keeping covenant promise in view.'
      when chapter_number between 6 and 10 then 'Worship, covenant promise, and expanding strength shape this part of David''s reign. These chapters show both public blessing and deep spiritual significance.'
      when chapter_number between 11 and 12 then 'David''s sin and confrontation form one of scripture''s clearest pictures of moral collapse and honest repentance. Grace does not erase consequence, but neither does failure end God''s mercy.'
      when chapter_number between 13 and 20 then 'The sword within David''s house becomes painfully visible here. Family fracture, rebellion, and sorrow reveal how far-reaching sin can be.'
      when chapter_number between 21 and 24 then '2 Samuel closes with reflection, deliverance, praise, and a final act of costly worship. The ending gathers together justice, mercy, and the need for atonement.'
      else ''
    end
    when '1-kings' then case
      when chapter_number between 1 and 4 then '1 Kings opens with succession, stability, and the early promise of Solomon''s reign. Wisdom and kingdom order appear as gifts to be stewarded with reverence.'
      when chapter_number between 5 and 8 then 'The temple takes shape and the central place of worship comes into focus. These chapters highlight the beauty and seriousness of God dwelling among His people.'
      when chapter_number between 9 and 11 then 'Splendor begins to give way to spiritual drift. 1 Kings warns that success without wholehearted faithfulness is never secure.'
      when chapter_number between 12 and 16 then 'The kingdom divides, and the story turns toward instability in both Israel and Judah. False worship and compromised leadership deepen the fracture.'
      when chapter_number between 17 and 19 then 'Elijah steps forward in power, dependence, and honest weakness. God confronts idolatry while also meeting His servant with sustaining mercy.'
      when chapter_number between 20 and 22 then 'Conflict, warning, and prophetic truth fill the close of the book. 1 Kings ends by showing how rulers are still accountable to the word of the Lord.'
      else ''
    end
    when '2-kings' then case
      when chapter_number between 1 and 8 then '2 Kings begins with prophetic authority and the ministry of Elisha. In a season of instability, God keeps revealing His power, compassion, and truth.'
      when chapter_number between 9 and 17 then 'Political upheaval and spiritual decline push the northern kingdom toward collapse. These chapters are a sober witness to the long cost of covenant unfaithfulness.'
      when chapter_number between 18 and 20 then 'Hezekiah''s reign brings reform, crisis, and prayerful dependence. Judah briefly shows what trust in God can still look like under pressure.'
      when chapter_number between 21 and 23 then 'After deep corruption, Josiah''s reforms bring a last bright moment of renewal. Yet the book also shows how long patterns of rebellion carry lasting consequence.'
      when chapter_number between 24 and 25 then '2 Kings closes with Jerusalem''s fall and exile. The ending is heavy, but even here a small note of preservation keeps hope from being extinguished.'
      else ''
    end
    when '1-chronicles' then case
      when chapter_number between 1 and 9 then '1 Chronicles begins with genealogies that reconnect the people to covenant identity and sacred history. These chapters remind readers that belonging and memory matter.'
      when chapter_number between 10 and 16 then 'David''s rise and the return of the ark reshape Israel around worship and kingdom hope. The chronicler highlights what leads a people back toward faithful praise.'
      when chapter_number between 17 and 21 then 'God''s covenant with David stands at the center of this section. Promise, prayer, victory, and even failure are all viewed through a worship-shaped lens.'
      when chapter_number between 22 and 29 then 'The book closes with preparation for the temple and a generous vision of ordered worship. David''s later years point beyond himself to a future centered on God''s house.'
      else ''
    end
    when '2-chronicles' then case
      when chapter_number between 1 and 9 then '2 Chronicles opens with Solomon, wisdom, and the temple in full view. The emphasis is not only royal success but the worship life of the nation.'
      when chapter_number between 10 and 20 then 'The divided kingdom story is told with repeated attention to reform, prayer, and trust. These chapters show how turning toward God changes the path of a people.'
      when chapter_number between 21 and 28 then 'Judah''s decline comes into sharper focus through compromised rulers and spiritual drift. The chronicler keeps returning to the cost of forgetting God.'
      when chapter_number between 29 and 32 then 'Hezekiah''s reforms bring one of the book''s clearest portraits of renewal. Worship, repentance, and trust stand together as the path back to health.'
      when chapter_number between 33 and 36 then 'The final chapters gather repentance, final warnings, collapse, and the first light of restoration. Even at the edge of exile, God does not abandon His larger purpose.'
      else ''
    end
    when 'ezra' then case
      when chapter_number between 1 and 3 then 'Ezra begins with return, rebuilding, and the recovery of worship. The people are not starting from comfort but from remembered mercy.'
      when chapter_number between 4 and 6 then 'Opposition slows the work, yet God continues to move His people toward completion. Ezra encourages steady obedience when progress feels threatened.'
      when chapter_number between 7 and 10 then 'Ezra''s arrival turns the story toward scripture, reform, and repentance. Restoration is shown to require not only walls or structures but renewed covenant faithfulness.'
      else ''
    end
    when 'nehemiah' then case
      when chapter_number between 1 and 2 then 'Nehemiah opens with grief, prayer, and courageous initiative. The rebuilding of Jerusalem begins in the heart before it reaches the wall.'
      when chapter_number between 3 and 7 then 'The work advances in the face of opposition, pressure, and fatigue. Nehemiah highlights shared labor and steady leadership under God.'
      when chapter_number between 8 and 10 then 'Scripture, confession, and covenant renewal become central here. Rebuilding is shown to be incomplete until God''s word shapes the people again.'
      when chapter_number between 11 and 13 then 'Nehemiah closes with dedication, ordering, and ongoing reform. The book is honest that renewal must be guarded, not merely begun.'
      else ''
    end
    when 'esther' then case
      when chapter_number between 1 and 2 then 'Esther begins inside a court shaped by power, appearance, and hidden tension. God''s name is not spoken, yet His providence quietly starts moving the story.'
      when chapter_number between 3 and 5 then 'Threat, courage, and careful timing build through these chapters. Esther shows that faithful action often requires patience as well as bravery.'
      when chapter_number between 6 and 8 then 'The turning point arrives through reversal and providence. What seemed locked in place begins to shift with remarkable precision.'
      when chapter_number between 9 and 10 then 'Esther ends with deliverance remembered and the people preserved. The close invites gratitude for the quiet but decisive care of God.'
      else ''
    end
    when 'job' then case
      when chapter_number between 1 and 2 then 'Job opens with devastating loss and a mystery deeper than human sight. The book refuses shallow explanations and takes suffering seriously from the start.'
      when chapter_number between 3 and 14 then 'The first cycle of speeches gives voice to grief, confusion, and contested wisdom. Job insists that honest pain belongs in the presence of God.'
      when chapter_number between 15 and 21 then 'The debate deepens as friends defend a narrow view of suffering and justice. Job continues to wrestle for truth without pretending all is well.'
      when chapter_number between 22 and 31 then 'These chapters intensify Job''s protest, memory, and longing for vindication. The reader is invited to sit with unresolved questions rather than rush past them.'
      when chapter_number between 32 and 37 then 'Elihu speaks with urgency about God''s greatness and human limitation. The tone shifts toward humility before the Lord''s wisdom.'
      when chapter_number between 38 and 42 then 'God answers Job out of the whirlwind and restores perspective before restoration fully comes. The ending leads not to neat closure but to deeper reverence and trust.'
      else ''
    end
    when 'psalms' then case
      when chapter_number between 1 and 2 then 'The opening psalms set the tone for the whole book with a contrast between the righteous path and rebellious resistance. They invite the reader to begin with reverence, trust, and delight in God''s ways.'
      when chapter_number between 3 and 8 then 'These early psalms move through fear, prayer, protection, and wonder. The voice is personal, but the hope keeps returning to God''s faithful rule.'
      when chapter_number between 9 and 15 then 'Justice, refuge, worship, and the shape of a righteous life rise to the surface here. The psalms teach the heart to bring both trouble and trust before God.'
      when chapter_number between 16 and 24 then 'Confidence, worship, and God''s kingship hold these psalms together. The reader is drawn toward joy that rests in the Lord''s steady care and holy presence.'
      when chapter_number between 25 and 32 then 'These psalms give language for guidance, repentance, protection, and mercy. They are especially strong for readers who need honesty without losing hope.'
      when chapter_number between 33 and 41 then 'Praise, affliction, deliverance, and patient trust shape the close of Book One. The psalms keep returning to the faithfulness of God in changing circumstances.'
      when chapter_number between 42 and 49 then 'Book Two opens with longing, tears, remembrance, and renewed hope. These psalms stay close to the ache of the soul while still reaching toward God.'
      when chapter_number between 50 and 59 then 'Worship, justice, repentance, and rescue are woven tightly together here. The psalms refuse empty religion and keep calling the heart back to sincerity before God.'
      when chapter_number between 60 and 68 then 'National distress, divine help, and confident praise fill this stretch of psalms. The reader is reminded that God remains a refuge for both individuals and His people together.'
      when chapter_number between 69 and 72 then 'These psalms move through suffering, kingship, and closing blessing. The section ends with a wider hope that reaches beyond one moment of need.'
      when chapter_number between 73 and 78 then 'Book Three wrestles with envy, confusion, history, and sanctuary perspective. The psalms help the heart move from surface appearances back to God''s deeper truth.'
      when chapter_number between 79 and 89 then 'Lament over ruin and longing for covenant mercy define this part of Psalms. Even in grief, the singers keep turning toward the Lord rather than away from Him.'
      when chapter_number between 90 and 99 then 'Book Four opens with God''s everlasting reign over against human frailty. These psalms steady the reader with worship, humility, and confidence in God''s rule.'
      when chapter_number between 100 and 106 then 'Thanksgiving, remembrance, and covenant mercy fill the close of Book Four. The psalms teach praise that is rooted in who God has proven Himself to be.'
      when chapter_number between 107 and 118 then 'Book Five opens by tracing many kinds of need back to the same faithful God. Deliverance, gratitude, and steadfast love echo through these psalms.'
      when chapter_number between 119 and 119 then 'Psalm 119 is a sustained meditation on God''s word, shaping desire, obedience, and endurance. It is patient, personal, and deeply anchored in scripture.'
      when chapter_number between 120 and 134 then 'The Songs of Ascents gather pilgrimage, dependence, and worshipful perspective. These psalms feel like companions for the road toward God''s presence.'
      when chapter_number between 135 and 145 then 'Praise, memory, kingdom hope, and personal trust grow stronger through this section. The psalms keep lifting the eyes of the reader back to the Lord''s greatness and goodness.'
      when chapter_number between 146 and 150 then 'Psalms closes with pure praise. The final songs gather the whole book into a joyful call to bless the Lord with wholehearted worship.'
      else ''
    end
    when 'proverbs' then case
      when chapter_number between 1 and 9 then 'The opening chapters of Proverbs are fatherly appeals to choose wisdom over folly. They prepare the reader to see that daily choices are shaped by deeper loves and loyalties.'
      when chapter_number between 10 and 15 then 'These chapters turn into compact sayings about speech, work, relationships, and character. Wisdom becomes practical without losing its spiritual weight.'
      when chapter_number between 16 and 22 then 'Proverbs keeps pressing discernment into ordinary life, especially around motives, plans, influence, and self-control. The book teaches that godliness and wisdom belong together.'
      when chapter_number between 23 and 29 then 'Warnings, observations, and guidance for mature living fill this part of the book. These chapters sharpen discernment in a world where folly often looks attractive.'
      when chapter_number between 30 and 31 then 'Proverbs closes with humility, collected wisdom, and a portrait of faithful strength. The ending is both searching and hopeful, showing wisdom embodied in life.'
      else ''
    end
    when 'ecclesiastes' then case
      when chapter_number between 1 and 2 then 'Ecclesiastes begins with the ache of repetition and the limits of human striving. The book clears away illusions before it offers any lasting wisdom.'
      when chapter_number between 3 and 6 then 'Time, injustice, work, and desire are examined with unsparing honesty. Ecclesiastes teaches the reader to live soberly within creaturely limits.'
      when chapter_number between 7 and 10 then 'These chapters gather wisdom for navigating a complicated and often crooked world. The tone is mature, restrained, and deeply realistic.'
      when chapter_number between 11 and 12 then 'Ecclesiastes closes with urgency, joy, and remembrance of the Creator. The final call is not despair but reverent living in the face of mortality.'
      else ''
    end
    when 'song-of-solomon' then case
      when chapter_number between 1 and 2 then 'Song of Solomon opens with delight, longing, and mutual affection. The poetry honors love as something warm, embodied, and deeply personal.'
      when chapter_number between 3 and 5 then 'These chapters move through desire, celebration, nearness, and searching. Love is shown as both beautiful joy and costly vulnerability.'
      when chapter_number between 6 and 8 then 'The song closes by deepening the themes of delight, exclusivity, and enduring affection. The final note is one of cherished love that remains strong and precious.'
      else ''
    end
    when 'isaiah' then case
      when chapter_number between 1 and 12 then 'Isaiah opens with sharp warning, holy vision, and a widening promise of redemption. Judgment is real here, but so is the coming hope of God''s saving reign.'
      when chapter_number between 13 and 23 then 'These chapters speak to nations under the eye of God''s sovereignty. Isaiah reminds the reader that no earthly power stands outside the Lord''s rule.'
      when chapter_number between 24 and 27 then 'Cosmic judgment and future hope are held together in this section. The vision grows larger, more sobering, and more comforting at the same time.'
      when chapter_number between 28 and 35 then 'Isaiah confronts false trust while still pointing toward restoration. The message presses the heart away from self-made security and back toward God.'
      when chapter_number between 36 and 39 then 'Historical crisis comes into clear view through Hezekiah''s story. These chapters show what it looks like when fear, prayer, and God''s deliverance meet in real time.'
      when chapter_number between 40 and 48 then 'Comfort begins to rise with new strength as Isaiah speaks to exiles and the weary. God''s greatness is presented not to crush the heart but to steady it.'
      when chapter_number between 49 and 55 then 'The Servant songs and redemption promises form the center of hope here. Isaiah turns the reader toward restoration that is both tender and world-reaching.'
      when chapter_number between 56 and 66 then 'The final chapters gather worship, justice, warning, renewal, and future glory. Isaiah closes by keeping holiness and hope in strong, clear tension.'
      else ''
    end
    when 'jeremiah' then case
      when chapter_number between 1 and 10 then 'Jeremiah begins with calling, warning, and the ache of a stubborn people. The prophet speaks with urgency because covenant drift has already gone deep.'
      when chapter_number between 11 and 20 then 'Conflict intensifies as Jeremiah carries God''s message through resistance and personal sorrow. These chapters reveal both prophetic courage and human cost.'
      when chapter_number between 21 and 29 then 'Judgment against kings, leaders, and false confidence fills this part of the book. Jeremiah keeps exposing misplaced trust while calling for honest surrender to God.'
      when chapter_number between 30 and 33 then 'In the middle of darkness, the book opens a bright window of restoration and new covenant hope. These chapters are gentle and strong at the same time.'
      when chapter_number between 34 and 45 then 'Jeremiah returns to rebellion, collapse, and the prophet''s own suffering. The message remains tender toward God and unsparing toward sin.'
      when chapter_number between 46 and 52 then 'The closing chapters widen out to the nations and then back to Jerusalem''s fall. Jeremiah ends in ruins, but not without leaving hope alive.'
      else ''
    end
    when 'lamentations' then case
      when chapter_number between 1 and 2 then 'Lamentations opens with grief laid bare before God. The poems do not rush past loss, and that honesty is part of their faithfulness.'
      when chapter_number = 3 then 'At the center of the book, sorrow meets remembered mercy. This chapter is a turning point that keeps hope alive without denying pain.'
      when chapter_number between 4 and 5 then 'The final poems look steadily at the ruins and still lift a plea toward God. Lament remains open-eyed, but it is not finally hopeless.'
      else ''
    end
    when 'ezekiel' then case
      when chapter_number between 1 and 11 then 'Ezekiel begins with overwhelming visions, prophetic calling, and the seriousness of God''s holiness. The opening chapters are meant to awaken a numb and resistant people.'
      when chapter_number between 12 and 24 then 'Warnings, signs, and judgments continue with striking force. Ezekiel keeps exposing the depth of spiritual rebellion and the need for cleansing.'
      when chapter_number between 25 and 32 then 'The message turns toward the nations, showing that God''s justice is not limited to Judah alone. These chapters widen the horizon of accountability.'
      when chapter_number between 33 and 39 then 'After judgment, Ezekiel speaks more directly of restoration, shepherding, and renewed life. Hope begins to rise in a way that feels hard-won and deeply needed.'
      when chapter_number between 40 and 48 then 'The book closes with temple vision, order, inheritance, and the promise of God''s dwelling presence. Ezekiel ends by turning the imagination toward a restored future.'
      else ''
    end
    when 'daniel' then case
      when chapter_number between 1 and 6 then 'Daniel''s opening stories show faithfulness under pressure in exile. God is present in courts, fires, lions'' dens, and every place where loyalty is tested.'
      when chapter_number between 7 and 12 then 'The second half of Daniel turns toward visions, kingdoms, conflict, and lasting hope. The imagery is searching, but the deeper message is that God''s kingdom still stands.'
      else ''
    end
    when 'hosea' then case
      when chapter_number between 1 and 3 then 'Hosea begins with lived prophecy that dramatizes covenant unfaithfulness and pursuing mercy. The pain in these chapters is personal because the message is about love betrayed.'
      when chapter_number between 4 and 10 then 'The book confronts Israel''s idolatry, corruption, and spiritual emptiness with piercing honesty. Hosea exposes sin in order to call the heart back home.'
      when chapter_number between 11 and 14 then 'Judgment remains real, but God''s compassion becomes especially luminous here. Hosea closes with a tender invitation to return and be healed.'
      else ''
    end
    when 'joel' then case
      when chapter_number between 1 and 2 then 'Joel moves from devastation toward repentance and urgent prayer. The crisis becomes a summons to seek the Lord with sincerity.'
      when chapter_number = 3 then 'Joel closes with judgment on evil and hope for God''s people. The ending is strong with both justice and restoration.'
      else ''
    end
    when 'amos' then case
      when chapter_number between 1 and 6 then 'Amos opens with judgment, moral clarity, and a sharp challenge to complacency. The prophet refuses to separate worship from justice.'
      when chapter_number between 7 and 9 then 'Visions and final promises close the book with both severity and hope. Amos leaves the reader chastened, but not without a future.'
      else ''
    end
    when 'obadiah' then case
      when chapter_number = 1 then 'Obadiah is brief but weighty, confronting pride, betrayal, and false security. The chapter reminds the reader that God sees what nations and individuals try to excuse.'
      else ''
    end
    when 'jonah' then case
      when chapter_number = 1 then 'Jonah opens with refusal, storm, and God''s unrelenting pursuit. The chapter shows that running from God is never truly escape.'
      when chapter_number = 2 then 'From the depths, Jonah prays. The chapter slows the story long enough to show that mercy can meet us where resistance has taken us.'
      when chapter_number = 3 then 'Jonah is sent again, and Nineveh responds with repentance. God''s compassion reaches farther than Jonah expected or preferred.'
      when chapter_number = 4 then 'The book closes by exposing Jonah''s heart and widening the reader''s view of divine compassion. Mercy is not only the book''s gift but also its challenge.'
      else ''
    end
    when 'micah' then case
      when chapter_number between 1 and 3 then 'Micah opens with judgment against corruption, oppression, and false leadership. The prophet speaks plainly because injustice has become normal.'
      when chapter_number between 4 and 5 then 'Hope rises here with visions of peace, rule, and future restoration. Micah places coming redemption beside present trouble.'
      when chapter_number between 6 and 7 then 'The book closes with covenant accusation, humble obedience, and renewed mercy. Micah ends by lifting the heart toward the God who pardons.'
      else ''
    end
    when 'nahum' then case
      when chapter_number between 1 and 3 then 'Nahum announces judgment on Nineveh with fierce clarity. The book offers comfort to the oppressed by reminding them that cruelty does not go unanswered forever.'
      else ''
    end
    when 'habakkuk' then case
      when chapter_number between 1 and 2 then 'Habakkuk opens with hard questions and a dialogue shaped by waiting. The prophet does not hide his confusion, but he keeps bringing it before God.'
      when chapter_number = 3 then 'The book closes in prayerful awe and hard-won trust. Habakkuk leads the reader toward joy that can stand even when circumstances remain difficult.'
      else ''
    end
    when 'zephaniah' then case
      when chapter_number between 1 and 2 then 'Zephaniah warns of judgment with urgency and moral seriousness. The call is not despair, but repentance while there is still refuge to be found.'
      when chapter_number = 3 then 'The final chapter moves toward purification, singing, and restored joy. Zephaniah closes with one of the Bible''s tender pictures of God''s delight over His people.'
      else ''
    end
    when 'haggai' then case
      when chapter_number between 1 and 2 then 'Haggai is a short but direct call to reorder priorities and begin again. The prophet meets discouragement with God''s presence and promise.'
      else ''
    end
    when 'zechariah' then case
      when chapter_number between 1 and 8 then 'Zechariah opens with vivid visions meant to strengthen a rebuilding people. The imagery is rich, but the heart of the message is cleansing, return, and hope.'
      when chapter_number between 9 and 14 then 'The second half widens toward kingship, conflict, and future restoration. Zechariah teaches the reader to hope beyond what is immediately visible.'
      else ''
    end
    when 'malachi' then case
      when chapter_number between 1 and 4 then 'Malachi confronts spiritual weariness, compromised worship, and casual faithfulness. The book is a final loving summons to return to wholehearted covenant life.'
      else ''
    end
    when 'matthew' then case
      when chapter_number between 1 and 4 then 'Matthew opens by rooting Jesus in promise, identity, and kingdom arrival. The gospel begins with fulfillment and quickly moves toward public ministry.'
      when chapter_number between 5 and 7 then 'The Sermon on the Mount gathers the values and vision of Jesus'' kingdom. These chapters are searching because they reach the heart beneath visible behavior.'
      when chapter_number between 8 and 10 then 'Authority, healing, and mission define this section. Jesus'' works and words both call for trust and active discipleship.'
      when chapter_number between 11 and 13 then 'Matthew turns toward response, resistance, and parables of the kingdom. The reader is invited to see that nearness to Jesus does not guarantee understanding.'
      when chapter_number between 14 and 18 then 'Compassion, confession, glory, and instruction shape these middle chapters. Matthew keeps training the reader in what faithful following looks like.'
      when chapter_number between 19 and 23 then 'Jesus moves steadily toward Jerusalem while teaching on discipleship, humility, and hypocrisy. The pressure rises, but so does the clarity of His call.'
      when chapter_number between 24 and 28 then 'The gospel closes with watchfulness, suffering, resurrection, and commission. Matthew ends by joining kingdom hope to the risen authority of Christ.'
      else ''
    end
    when 'mark' then case
      when chapter_number between 1 and 4 then 'Mark begins quickly, showing Jesus in action with authority over sickness, demons, crowds, and hearts. The pace is fast, but the central question is clear: who is this?'
      when chapter_number between 5 and 8 then 'Power, compassion, misunderstanding, and confession continue to shape the story. Mark reveals both Jesus'' strength and the disciples'' need for deeper sight.'
      when chapter_number between 9 and 13 then 'Teaching on greatness, discipleship, suffering, and watchfulness becomes more focused here. The road with Jesus is shown to be glorious and costly.'
      when chapter_number between 14 and 16 then 'Mark closes with betrayal, crucifixion, and resurrection. The ending calls the reader to sober wonder and renewed faith.'
      else ''
    end
    when 'luke' then case
      when chapter_number between 1 and 4 then 'Luke opens with songs, birth narratives, and Spirit-shaped beginnings. The gospel starts with joy, humility, and God''s saving attention to the overlooked.'
      when chapter_number between 5 and 9 then 'Jesus gathers disciples, heals, teaches, and reveals His authority with warmth and compassion. Luke keeps showing the wideness of the good news.'
      when chapter_number between 10 and 19 then 'The long journey section turns the reader toward mercy, prayer, wealth, repentance, and faithful discipleship. Luke moves patiently and pastorally through the shape of life with Jesus.'
      when chapter_number between 20 and 24 then 'Conflict, sacrifice, resurrection, and witness close the gospel. Luke ends with worship, clarity, and hope rooted in the risen Christ.'
      else ''
    end
    when 'john' then case
      when chapter_number between 1 and 4 then 'John begins by revealing Jesus as the eternal Word who has come near. The early chapters move through witness, signs, and life-giving conversations that invite belief.'
      when chapter_number between 5 and 10 then 'Conflict and revelation deepen as Jesus speaks plainly about His identity and work. John keeps pressing the reader beyond curiosity toward trust.'
      when chapter_number between 11 and 12 then 'The raising of Lazarus and the approach to Jerusalem gather both glory and tension. These chapters stand close to the turning point of the gospel.'
      when chapter_number between 13 and 17 then 'John slows down in the upper room to dwell on love, abiding, sorrow, prayer, and hope. These chapters are intimate, steadying, and deeply pastoral.'
      when chapter_number between 18 and 21 then 'The gospel closes with arrest, crucifixion, resurrection, and restoration. John ends by showing that Jesus'' glory shines most clearly through sacrificial love and risen life.'
      else ''
    end
    when 'acts' then case
      when chapter_number between 1 and 7 then 'Acts begins with ascension, Pentecost, and the early witness of the church in Jerusalem. The Spirit''s power turns fear into public testimony.'
      when chapter_number between 8 and 12 then 'The gospel moves outward across boundaries of place, people, and expectation. Acts shows that the risen Jesus keeps directing His mission through surprising paths.'
      when chapter_number between 13 and 20 then 'Paul''s missionary journeys fill this central section with preaching, suffering, church planting, and discernment. The church grows through both opposition and grace.'
      when chapter_number between 21 and 28 then 'Acts closes with arrest, trials, storms, and witness that refuses to be silenced. The ending is open-ended in the best sense, because the gospel is still moving outward.'
      else ''
    end
    when 'romans' then case
      when chapter_number between 1 and 4 then 'Romans opens by laying bare humanity''s need and God''s righteousness in the gospel. Paul builds slowly and carefully toward grace that no one can claim to have earned.'
      when chapter_number between 5 and 8 then 'These chapters gather assurance, union with Christ, freedom from condemnation, and life in the Spirit. Romans reaches some of its strongest notes of comfort here.'
      when chapter_number between 9 and 11 then 'Paul turns toward Israel, mercy, and the mystery of God''s purposes. The tone is reverent, grief-aware, and full of wonder.'
      when chapter_number between 12 and 16 then 'Romans closes by pressing doctrine into worship, community, humility, and love. The gospel is shown to reshape ordinary relationships and daily life.'
      else ''
    end
    when '1-corinthians' then case
      when chapter_number between 1 and 4 then '1 Corinthians opens by confronting pride, factions, and misplaced wisdom. Paul calls the church back to the crucified Christ as its true center.'
      when chapter_number between 5 and 7 then 'Holiness, discipline, and embodied faithfulness take clear shape here. The gospel is applied to difficult and deeply personal areas of community life.'
      when chapter_number between 8 and 11 then 'These chapters address conscience, freedom, worship, and self-giving love. Paul keeps showing that maturity is measured by what builds others up.'
      when chapter_number between 12 and 14 then 'Spiritual gifts are set inside the larger call to love and ordered worship. The church is one body, and every part is meant to serve that unity.'
      when chapter_number between 15 and 16 then 'The letter closes with resurrection hope and practical steadfastness. Paul lifts the eyes of the church from present disorder to the lasting victory of Christ.'
      else ''
    end
    when '2-corinthians' then case
      when chapter_number between 1 and 7 then '2 Corinthians opens with comfort, weakness, integrity, and reconciliation. Paul ministers from honesty rather than image, and the letter carries that same tone.'
      when chapter_number between 8 and 9 then 'Generosity comes into focus here as an expression of grace rather than pressure. These chapters connect giving to joy, trust, and shared care.'
      when chapter_number between 10 and 13 then 'Paul closes with strong defense, searching appeal, and strength made perfect in weakness. The letter ends with both gravity and grace.'
      else ''
    end
    when 'galatians' then case
      when chapter_number between 1 and 2 then 'Galatians begins with urgency because the gospel itself is at stake. Paul defends grace with clarity, personal testimony, and apostolic conviction.'
      when chapter_number between 3 and 4 then 'These chapters unfold the shape of promise, sonship, and freedom in Christ. Paul argues that grace is not a side note but the heart of covenant life fulfilled.'
      when chapter_number between 5 and 6 then 'Galatians closes by pressing freedom into Spirit-led living, love, and perseverance. The gospel is shown to produce a new kind of life, not spiritual drift.'
      else ''
    end
    when 'ephesians' then case
      when chapter_number between 1 and 3 then 'Ephesians opens with praise, prayer, grace, and the mystery of God''s united people in Christ. The tone is spacious and worshipful from the start.'
      when chapter_number between 4 and 6 then 'The letter turns toward unity, holiness, love, relationships, and spiritual strength. Identity in Christ is meant to become visible in the life of the church.'
      else ''
    end
    when 'philippians' then case
      when chapter_number = 1 then 'Paul writes with affection, gratitude, and confidence in God''s ongoing work. Even in hardship, the chapter sounds a steady note of Christ-centered hope.'
      when chapter_number = 2 then 'Philippians 2 moves through humility, obedience, and the mind of Christ. The chapter calls believers to a lowly and radiant kind of faithfulness.'
      when chapter_number = 3 then 'Paul turns toward true righteousness, holy desire, and pressing on toward Christ. The tone is focused, personal, and forward-looking.'
      when chapter_number = 4 then 'The letter closes with joy, gentleness, prayer, contentment, and generous partnership. Peace here is rooted in Christ rather than circumstance.'
      else ''
    end
    when 'colossians' then case
      when chapter_number between 1 and 2 then 'Colossians opens by lifting the reader''s eyes to the fullness and supremacy of Christ. Paul writes to steady the church against competing voices by showing them who Jesus is.'
      when chapter_number between 3 and 4 then 'The letter turns toward new life, holy habits, relationships, prayer, and witness. Christ''s sufficiency is meant to reshape both the inner life and the ordinary day.'
      else ''
    end
    when '1-thessalonians' then case
      when chapter_number between 1 and 3 then '1 Thessalonians opens with gratitude, memory, and tender pastoral concern. Paul encourages a young church to remain steady under pressure.'
      when chapter_number between 4 and 5 then 'The letter closes with holiness, hope, and watchful readiness. Future hope is presented not to stir fear, but to strengthen faithful living now.'
      else ''
    end
    when '2-thessalonians' then case
      when chapter_number between 1 and 3 then '2 Thessalonians brings clarity, perseverance, and practical steadiness to a church facing confusion. Paul aims to quiet fear and strengthen disciplined hope.'
      else ''
    end
    when '1-timothy' then case
      when chapter_number between 1 and 3 then '1 Timothy opens with instruction about doctrine, prayer, and ordered church life. Paul writes so that the household of God will be marked by truth and godliness.'
      when chapter_number between 4 and 6 then 'The letter continues with counsel on leadership, example, money, and perseverance. Spiritual maturity is shown to be visible, steady, and practical.'
      else ''
    end
    when '2-timothy' then case
      when chapter_number between 1 and 2 then '2 Timothy begins with affection, courage, and a charge to endure. Paul writes from suffering, but his tone remains warm and resolute.'
      when chapter_number between 3 and 4 then 'The letter closes with warnings, scripture-grounded ministry, and the perspective of faithful finishing. Paul wants Timothy to keep going without compromise.'
      else ''
    end
    when 'titus' then case
      when chapter_number between 1 and 3 then 'Titus is a compact letter about healthy doctrine, ordered leadership, and grace-shaped living. Paul keeps joining truth to visible goodness in community life.'
      else ''
    end
    when 'philemon' then case
      when chapter_number = 1 then 'Philemon is a short, personal appeal shaped by dignity, love, and gospel reconciliation. The letter shows how grace can enter strained relationships without coercion.'
      else ''
    end
    when 'hebrews' then case
      when chapter_number between 1 and 4 then 'Hebrews opens by showing the greatness of the Son and warning against drift. The letter wants weary believers to see that Jesus is more than enough.'
      when chapter_number between 5 and 10 then 'Priesthood, sacrifice, covenant, and access to God are unfolded with depth and urgency here. Hebrews keeps pressing the reader toward confidence grounded in Christ''s finished work.'
      when chapter_number between 11 and 13 then 'The letter closes with faith-filled endurance, worship, discipline, and practical love. The final appeal is to keep running with eyes fixed on Jesus.'
      else ''
    end
    when 'james' then case
      when chapter_number between 1 and 2 then 'James opens with testing, wisdom, hearing, doing, and impartial love. Faith is treated as something living, visible, and steady under pressure.'
      when chapter_number between 3 and 5 then 'The letter continues with speech, desires, patience, prayer, and everyday obedience. James keeps bringing spiritual maturity down to earth.'
      else ''
    end
    when '1-peter' then case
      when chapter_number between 1 and 2 then '1 Peter opens with living hope, holiness, and identity for believers in pressure-filled settings. Suffering is not minimized, but it is reframed by resurrection hope.'
      when chapter_number between 3 and 5 then 'Peter continues with courage, humility, shepherding, and steadfast endurance. The letter encourages a calm and holy kind of resilience.'
      else ''
    end
    when '2-peter' then case
      when chapter_number between 1 and 3 then '2 Peter is a short, urgent call to growth, discernment, and confidence in God''s promises. The letter aims to steady believers against distortion and drift.'
      else ''
    end
    when '1-john' then case
      when chapter_number between 1 and 2 then '1 John opens with fellowship, light, advocacy, and assurance. The tone is warm, but it is also clear-eyed about sin and truth.'
      when chapter_number between 3 and 5 then 'The letter continues through love, testing, confidence, and eternal life. John writes so that assurance will rest in Christ rather than vague feeling.'
      else ''
    end
    when '2-john' then case
      when chapter_number = 1 then '2 John is brief and direct, calling believers to hold truth and love together. Faithfulness here means remaining gracious without welcoming deception.'
      else ''
    end
    when '3-john' then case
      when chapter_number = 1 then '3 John offers a small but vivid picture of hospitality, truth, and unhealthy leadership. The letter commends what is faithful and quietly exposes what is not.'
      else ''
    end
    when 'jude' then case
      when chapter_number = 1 then 'Jude is a short call to contend for the faith with vigilance and mercy. The warning is serious, but the letter still ends by pointing to God''s keeping power.'
      else ''
    end
    when 'revelation' then case
      when chapter_number between 1 and 3 then 'Revelation opens with the risen Christ among His churches, speaking words of correction, comfort, and promise. The book begins pastorally before it expands apocalyptically.'
      when chapter_number between 4 and 5 then 'The throne room vision reorients the reader around worship and the worthiness of the Lamb. Everything that follows must be read from this center.'
      when chapter_number between 6 and 11 then 'Judgment, witness, prayer, and perseverance unfold with increasing intensity. Revelation keeps pressing the church to endure with worshipful clarity.'
      when chapter_number between 12 and 14 then 'The conflict behind history comes into view through vivid symbolic vision. These chapters strengthen faith by showing that the struggle is real, but not ultimate.'
      when chapter_number between 15 and 18 then 'Judgment reaches a climactic form as evil systems are exposed and brought down. Revelation speaks here with sobering moral force.'
      when chapter_number between 19 and 22 then 'The book closes with victory, judgment, renewal, and the hope of God dwelling with His people. Revelation ends not in confusion but in worship and longing for Christ''s return.'
      else ''
    end
    else ''
  end;
$$;

create or replace function public.phase13_chapter_focus_line(
  chapter_book_id text,
  chapter_number integer
)
returns text
language sql
immutable
as $$
  select case chapter_book_id
    when 'genesis' then case
      when chapter_number between 1 and 11 then 'Genesis begins by showing both the goodness of God''s world and the depth of humanity''s need.'
      when chapter_number between 12 and 36 then 'Watch how God''s promise holds steady through calling, waiting, and imperfect lives.'
      when chapter_number between 37 and 50 then 'Joseph''s story teaches the reader to notice providence even when it is hidden.'
      else ''
    end
    when 'exodus' then case
      when chapter_number between 1 and 15 then 'God sees, remembers, and rescues His people with holy power.'
      when chapter_number between 16 and 24 then 'Deliverance leads into trust, covenant, and learning how to live near God.'
      when chapter_number between 25 and 40 then 'The heart of Exodus is God dwelling among a people shaped for worship.'
      else ''
    end
    when 'leviticus' then 'Holiness is not distance from God but life ordered by His mercy.'
    when 'numbers' then 'The wilderness becomes a place where unbelief is exposed and God''s faithfulness endures.'
    when 'deuteronomy' then 'Remembered grace is meant to lead to wholehearted love and obedience.'
    when 'joshua' then 'Courage grows where God''s presence is trusted more than the size of the challenge.'
    when 'judges' then 'Judges keeps warning that spiritual drift always asks for rescue from outside ourselves.'
    when 'ruth' then 'Quiet faithfulness becomes the setting where redemption gently appears.'
    when '1-samuel' then 'God looks deeper than appearances and forms leaders through surrender and obedience.'
    when '2-samuel' then 'Promise and failure meet here, but God''s mercy does not disappear.'
    when '1-kings' then 'Outward glory cannot replace a heart that remains faithful to the Lord.'
    when '2-kings' then 'These chapters teach how compromise hardens, but prayerful trust still matters.'
    when '1-chronicles' then 'The chronicler keeps turning history toward worship, identity, and covenant hope.'
    when '2-chronicles' then 'Renewal comes when God''s people humble themselves and return to Him.'
    when 'ezra' then 'True restoration reaches beyond rebuilding structures into renewed worship and obedience.'
    when 'nehemiah' then 'Prayerful leadership and steady obedience make room for lasting rebuilding.'
    when 'esther' then 'Providence often works quietly, but never passively.'
    when 'job' then 'Job invites honest suffering into the presence of the God whose wisdom is larger than ours.'
    when 'psalms' then case
      when chapter_number between 1 and 41 then 'These psalms teach the heart to pray honestly and trust God personally.'
      when chapter_number between 42 and 89 then 'Bring longing, confusion, and grief before God without letting go of Him.'
      when chapter_number between 90 and 106 then 'God''s reign steadies human frailty and reshapes worship.'
      when chapter_number between 107 and 150 then 'The psalter moves toward gratitude, pilgrimage, and wholehearted praise.'
      else ''
    end
    when 'proverbs' then 'Wisdom takes shape in ordinary words, habits, decisions, and desires.'
    when 'ecclesiastes' then 'Life''s limits are meant to turn the heart toward humble reverence, not despair.'
    when 'song-of-solomon' then 'Love is treated here as a gift to be cherished with delight and faithfulness.'
    when 'isaiah' then 'Isaiah keeps holding together God''s holiness, truthful judgment, and enduring hope.'
    when 'jeremiah' then 'Even through tears and warning, God keeps speaking toward repentance and future mercy.'
    when 'lamentations' then 'Faithful grief does not silence hope; it carries hope through sorrow.'
    when 'ezekiel' then 'God can awaken what has grown numb and restore what seems ruined.'
    when 'daniel' then 'Faithfulness under pressure makes sense because God''s kingdom outlasts every empire.'
    when 'hosea' then 'God''s steadfast love keeps pursuing hearts that have wandered.'
    when 'joel' then 'Crisis becomes a call to return to God with sincerity and hope.'
    when 'amos' then 'God refuses worship that leaves justice and righteousness behind.'
    when 'obadiah' then 'Pride is never secure before the justice of God.'
    when 'jonah' then 'The book asks whether we will receive mercy only for ourselves or rejoice when it reaches others too.'
    when 'micah' then 'Judgment is real, but God still calls His people into humble, hope-filled faithfulness.'
    when 'nahum' then 'Cruelty does not stand forever; God remembers the afflicted.'
    when 'habakkuk' then 'Waiting faith learns to trust God before circumstances improve.'
    when 'zephaniah' then 'Judgment clears the ground for refuge, cleansing, and restored joy.'
    when 'haggai' then 'God''s presence strengthens weary people to begin faithful work again.'
    when 'zechariah' then 'Hope grows when God''s people look beyond present weakness to His promised restoration.'
    when 'malachi' then 'God calls tired hearts back to sincere worship and covenant faithfulness.'
    when 'matthew' then 'Matthew keeps asking whether we will receive Jesus as King on His terms.'
    when 'mark' then 'The pace is quick, but the call is steady: follow Jesus with open-eyed trust.'
    when 'luke' then 'Luke shows the grace of Jesus reaching the overlooked and inviting wholehearted response.'
    when 'john' then 'John writes so the reader will see who Jesus is and trust Him more deeply.'
    when 'acts' then 'The risen Jesus still leads His mission by the power of the Spirit.'
    when 'romans' then 'Grace in Christ is strong enough to humble, assure, and transform.'
    when '1-corinthians' then 'The gospel speaks directly into messy community life with truth and love.'
    when '2-corinthians' then 'God''s strength often becomes clearest in weakness honestly offered to Him.'
    when 'galatians' then 'Freedom in Christ is meant to produce Spirit-shaped love, not self-made religion.'
    when 'ephesians' then 'Identity in Christ is meant to overflow into unity, holiness, and strength.'
    when 'philippians' then 'Joy here is not shallow cheerfulness but Christ-centered steadiness.'
    when 'colossians' then 'Keep lifting your eyes to the fullness of Christ and live from that center.'
    when '1-thessalonians' then 'Hope for Christ''s coming strengthens ordinary faithfulness today.'
    when '2-thessalonians' then 'Steadiness matters when fear, confusion, or pressure start to cloud hope.'
    when '1-timothy' then 'Healthy doctrine should become visible in ordered, godly, everyday life.'
    when '2-timothy' then 'Finish faithfully by holding fast to the gospel and the scriptures.'
    when 'titus' then 'Grace trains the church to live with visible integrity and fruitful service.'
    when 'philemon' then 'The gospel dignifies people and reshapes strained relationships with mercy.'
    when 'hebrews' then 'Do not drift; keep seeing Jesus as greater, final, and sufficient.'
    when 'james' then 'Mature faith becomes visible in speech, endurance, humility, and action.'
    when '1-peter' then 'Hope in Christ enables holy endurance when faithfulness is costly.'
    when '2-peter' then 'Keep growing in truth so you do not drift with every false voice.'
    when '1-john' then 'Assurance grows where truth, obedience, and love remain joined in Christ.'
    when '2-john' then 'Real love does not loosen its grip on truth.'
    when '3-john' then 'Faithful hospitality and truth-shaped leadership still matter deeply.'
    when 'jude' then 'Contend for the faith without forgetting mercy and God''s keeping grace.'
    when 'revelation' then 'Read every vision in the light of the Lamb who reigns and will make all things new.'
    else ''
  end;
$$;

with target_rows as (
  select
    chapters.book_id,
    chapters.chapter_number,
    public.phase13_chapter_introduction(chapters.book_id, chapters.chapter_number) as introduction,
    public.phase13_chapter_focus_line(chapters.book_id, chapters.chapter_number) as focus_line
  from public.content_bible_chapters chapters
  where btrim(chapters.introduction) = ''
     or btrim(chapters.focus_line) = ''
)
update public.content_bible_chapters as chapters
set
  introduction = case
    when btrim(chapters.introduction) = '' then target.introduction
    else chapters.introduction
  end,
  focus_line = case
    when btrim(chapters.focus_line) = '' then target.focus_line
    else chapters.focus_line
  end,
  updated_at = timezone('utc', now())
from target_rows as target
where chapters.book_id = target.book_id
  and chapters.chapter_number = target.chapter_number
  and (
    (btrim(chapters.introduction) = '' and target.introduction <> '')
    or (btrim(chapters.focus_line) = '' and target.focus_line <> '')
  );

drop function public.phase13_chapter_introduction(text, integer);
drop function public.phase13_chapter_focus_line(text, integer);

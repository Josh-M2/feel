import '../../domain/models/reading_plan.dart';

class MockPlansRepository {
  const MockPlansRepository();

  List<ReadingPlan> getPlans() {
    return const <ReadingPlan>[
      ReadingPlan(
        id: 'peace_when_anxious',
        title: 'Peace When Anxiety Feels Loud',
        subtitle:
            'A gentle 7-day reading rhythm for prayer, trust, and steadiness.',
        categoryLabel: 'Peace Over Anxiety',
        durationDays: 7,
        description:
            'This plan is built for days when the mind feels crowded, restless, or heavy. Each day keeps the reading simple and prayerful instead of overwhelming.',
        whyItHelps:
            'It gives the user a calm structure: a short passage focus, one main encouragement, and a reflection prompt that stays spiritually grounded rather than productivity-heavy.',
        progressLabel: 'Day 3 of 7',
        currentDayNumber: 3,
        days: <PlanDay>[
          PlanDay(
            dayNumber: 1,
            title: 'Bring the weight honestly',
            focusLine:
                'God invites honest prayer before He gives peace beyond understanding.',
            summary:
                'The opening day sets the tone: do not hide the anxious burden. Bring it into prayer with thanksgiving and let God hold what feels too heavy.',
            passageRefs: <String>['Philippians 4:6–7', '1 Peter 5:7'],
            reflectionPrompt:
                'What burden have you been carrying internally instead of placing before God in prayer?',
            prayerPrompt:
                'Lord, I bring You the pressure I have been holding. Teach me to pray instead of spiraling.',
          ),
          PlanDay(
            dayNumber: 2,
            title: 'Remember the Father’s care',
            focusLine:
                'Jesus speaks directly to anxious striving and redirects the heart to the Father.',
            summary:
                'This day centers on the care of God, reminding the reader that worry does not secure life the way trust in the Father does.',
            passageRefs: <String>['Matthew 6:25–34', 'Psalm 121'],
            reflectionPrompt:
                'Where have you been measuring safety by control instead of God’s care?',
            prayerPrompt:
                'Father, help me trust Your care where I usually try to create certainty for myself.',
          ),
          PlanDay(
            dayNumber: 3,
            title: 'Let your mind stay on Him',
            focusLine:
                'Peace grows where the mind is trained toward God rather than consumed by fear.',
            summary:
                'This day is about attention. Fear tries to dominate thought, but scripture keeps calling the mind back toward God’s truth and steadiness.',
            passageRefs: <String>['Isaiah 26:3', 'Philippians 4:8'],
            reflectionPrompt:
                'What thought pattern has been feeding unrest, and what truth from God do you need to sit with instead?',
            prayerPrompt:
                'Lord, steady my thoughts and teach my mind to return to what is true and life-giving.',
          ),
          PlanDay(
            dayNumber: 4,
            title: 'Rest in God’s nearness',
            focusLine:
                'Peace is not only about solutions. It is also about the nearness of God.',
            summary:
                'This day reminds the reader that God’s closeness matters in the middle of unresolved situations.',
            passageRefs: <String>['Psalm 34:17–18', 'John 14:27'],
            reflectionPrompt:
                'How would your day feel different if you truly believed God was near in this moment?',
            prayerPrompt:
                'God, remind me that Your presence is not far from my weakness or fear.',
          ),
          PlanDay(
            dayNumber: 5,
            title: 'Wait without panic',
            focusLine:
                'Biblical waiting is not passive despair. It is patient trust under God.',
            summary:
                'This day helps the user stay grounded when answers are delayed and fear wants to take over.',
            passageRefs: <String>['Psalm 27:13–14', 'Lamentations 3:25–26'],
            reflectionPrompt:
                'Where are you being asked to wait, and what does faithful waiting look like there?',
            prayerPrompt:
                'Lord, keep me from panic while I wait. Teach me to remain steady in You.',
          ),
          PlanDay(
            dayNumber: 6,
            title: 'Practice gratitude in the middle',
            focusLine:
                'Thanksgiving changes the posture of the heart even before circumstances change.',
            summary:
                'Gratitude does not deny pain. It keeps the heart open to God’s faithfulness in the middle of it.',
            passageRefs: <String>['1 Thessalonians 5:16–18', 'Psalm 103:1–5'],
            reflectionPrompt:
                'What evidence of God’s care can you thank Him for even in an unfinished season?',
            prayerPrompt:
                'God, keep my heart from shrinking into fear alone. Help me stay thankful for Your faithfulness.',
          ),
          PlanDay(
            dayNumber: 7,
            title: 'Carry peace forward',
            focusLine:
                'Peace is not a one-time feeling. It becomes a daily returning to God.',
            summary:
                'The final day helps the reader move from a short plan into an ongoing prayerful rhythm with God.',
            passageRefs: <String>['Colossians 3:15', 'Psalm 23'],
            reflectionPrompt:
                'What small daily habit could help you keep returning to God’s peace after this plan ends?',
            prayerPrompt:
                'Lord, let Your peace rule in me beyond this week. Keep drawing me back to You day by day.',
          ),
        ],
      ),
      ReadingPlan(
        id: 'finding_strength_in_weariness',
        title: 'Strength for Tired Days',
        subtitle:
            'A 5-day plan for weakness, endurance, and dependence on God.',
        categoryLabel: 'Strength',
        durationDays: 5,
        description:
            'This plan is for people who feel emotionally or spiritually drained. It keeps the pace simple and lets scripture speak to fatigue with hope.',
        whyItHelps:
            'Instead of asking the user to perform harder, it points them toward the sustaining strength of God in weakness.',
        progressLabel: 'Day 1 of 5',
        currentDayNumber: 1,
        days: <PlanDay>[
          PlanDay(
            dayNumber: 1,
            title: 'Come weary, not polished',
            focusLine:
                'Jesus calls the weary to come, not to fix themselves first.',
            summary:
                'The first day opens with invitation: bring tiredness honestly before Christ.',
            passageRefs: <String>['Matthew 11:28–30'],
            reflectionPrompt:
                'What part of your life feels tired enough that you need Christ’s rest today?',
            prayerPrompt:
                'Jesus, I come tired. Meet me in my weakness and let me rest in You.',
          ),
          PlanDay(
            dayNumber: 2,
            title: 'Strength renewed',
            focusLine:
                'God’s strength meets those who wait on Him, not those who pretend they never grow faint.',
            summary:
                'This day helps the reader see waiting on God as renewal, not useless delay.',
            passageRefs: <String>['Isaiah 40:28–31'],
            reflectionPrompt:
                'Where do you need God’s renewal more than your own effort?',
            prayerPrompt:
                'Lord, renew me where I feel depleted and unable to keep carrying things alone.',
          ),
          PlanDay(
            dayNumber: 3,
            title: 'Grace in weakness',
            focusLine:
                'God does not only work after weakness passes. He works inside it.',
            summary:
                'This day turns the reader toward grace that meets weakness rather than shame that hides it.',
            passageRefs: <String>['2 Corinthians 12:9–10'],
            reflectionPrompt:
                'How might God be inviting you to depend on grace instead of image or self-sufficiency?',
            prayerPrompt:
                'God, let Your strength be clearer to me than my limitation.',
          ),
          PlanDay(
            dayNumber: 4,
            title: 'Do not grow weary',
            focusLine:
                'Faithfulness often looks quiet and repeated long before it feels rewarding.',
            summary:
                'The fourth day encourages steadiness when doing good feels slow and costly.',
            passageRefs: <String>['Galatians 6:9', 'Hebrews 12:1–3'],
            reflectionPrompt:
                'What good work are you tempted to stop because you feel tired or unseen?',
            prayerPrompt:
                'Lord, give me steady endurance where I feel like giving up.',
          ),
          PlanDay(
            dayNumber: 5,
            title: 'Stand with hope',
            focusLine:
                'Strength is not only surviving pressure. It is learning to stand in hope with God.',
            summary:
                'The plan closes by anchoring the reader in hope and courage from God’s presence.',
            passageRefs: <String>['Psalm 27:13–14', 'Joshua 1:9'],
            reflectionPrompt:
                'What would courageous hope look like in your next step?',
            prayerPrompt:
                'God, strengthen my heart and help me move forward with hope.',
          ),
        ],
      ),
      ReadingPlan(
        id: 'purpose_and_calling',
        title: 'Purpose in Ordinary Days',
        subtitle:
            'A 6-day plan for calling, faithfulness, and walking with God in real life.',
        categoryLabel: 'Purpose and Calling',
        durationDays: 6,
        description:
            'This plan helps the reader think about calling in a grounded way. It is less about grand status and more about faithful daily walking with God.',
        whyItHelps:
            'It helps prevent calling from becoming anxious pressure. The tone stays practical, calm, and spiritually centered.',
        progressLabel: 'Day 2 of 6',
        currentDayNumber: 2,
        days: <PlanDay>[
          PlanDay(
            dayNumber: 1,
            title: 'Begin with God, not image',
            focusLine:
                'Purpose starts with belonging to God before accomplishing things for God.',
            summary:
                'The first day resets the idea of calling so it begins with relationship and trust.',
            passageRefs: <String>['John 15:4–5', 'Ephesians 2:10'],
            reflectionPrompt:
                'Have you been treating purpose more like pressure to prove yourself than a life with God?',
            prayerPrompt:
                'Lord, root my purpose in You before anything I produce or achieve.',
          ),
          PlanDay(
            dayNumber: 2,
            title: 'Be faithful where you are',
            focusLine:
                'God often forms calling through ordinary obedience before visible outcomes.',
            summary:
                'This day focuses on faithfulness in present responsibilities instead of obsession with future recognition.',
            passageRefs: <String>['Colossians 3:23–24', 'Luke 16:10'],
            reflectionPrompt:
                'What ordinary responsibility might God be asking you to treat with deeper faithfulness today?',
            prayerPrompt:
                'God, help me honor You in the small and ordinary things in front of me.',
          ),
          PlanDay(
            dayNumber: 3,
            title: 'Walk humbly',
            focusLine:
                'Purpose is not self-exaltation. It is a life shaped by justice, mercy, and humble walking with God.',
            summary:
                'This day guards against inflated calling language by rooting life in faithful character.',
            passageRefs: <String>['Micah 6:8'],
            reflectionPrompt:
                'Where do you need humility to reshape how you think about your future?',
            prayerPrompt:
                'Lord, keep my heart humble and my steps aligned with what pleases You.',
          ),
          PlanDay(
            dayNumber: 4,
            title: 'Do good without noise',
            focusLine:
                'Purpose often shows up as quiet obedience long before it looks impressive.',
            summary:
                'This day emphasizes consistency and goodness without needing applause.',
            passageRefs: <String>['Galatians 6:9–10', 'Matthew 5:14–16'],
            reflectionPrompt:
                'What good can you keep doing even if it feels small or unnoticed?',
            prayerPrompt:
                'God, make me faithful in good works whether or not they are seen.',
          ),
          PlanDay(
            dayNumber: 5,
            title: 'Trust His leading',
            focusLine:
                'Calling becomes clearer when the heart learns to trust God’s direction day by day.',
            summary:
                'This day helps the reader hold future uncertainty with trust instead of restless control.',
            passageRefs: <String>['Proverbs 3:5–6', 'Psalm 32:8'],
            reflectionPrompt:
                'Where are you craving certainty more than daily trust in God’s leading?',
            prayerPrompt:
                'Lord, direct my path and help me trust You more than my own understanding.',
          ),
          PlanDay(
            dayNumber: 6,
            title: 'Offer your life to God',
            focusLine:
                'Purpose matures as the whole life is placed before God in willing surrender.',
            summary:
                'The final day closes with surrendered worship as the shape of faithful calling.',
            passageRefs: <String>['Romans 12:1–2'],
            reflectionPrompt:
                'What part of your life still feels withheld from God’s shaping?',
            prayerPrompt:
                'God, I offer my life to You. Shape my purpose in a way that honors You.',
          ),
        ],
      ),
    ];
  }

  ReadingPlan getDefaultPlan() {
    return getPlans().first;
  }

  ReadingPlan getPlanById(String? planId) {
    return getPlans().firstWhere(
      (ReadingPlan plan) => plan.id == planId,
      orElse: getDefaultPlan,
    );
  }

  ReadingPlan getContinuePlan() {
    return getPlanById('peace_when_anxious');
  }

  PlanDay getPlanDay({String? planId, int? dayNumber}) {
    final ReadingPlan plan = getPlanById(planId);
    return plan.days.firstWhere(
      (PlanDay day) => day.dayNumber == dayNumber,
      orElse: () => plan.days.first,
    );
  }

  PlanDay? getNextDay({required String planId, required int dayNumber}) {
    final ReadingPlan plan = getPlanById(planId);
    final int currentIndex = plan.days.indexWhere(
      (PlanDay day) => day.dayNumber == dayNumber,
    );

    if (currentIndex == -1 || currentIndex + 1 >= plan.days.length) {
      return null;
    }

    return plan.days[currentIndex + 1];
  }

  PlanDay? getPreviousDay({required String planId, required int dayNumber}) {
    final ReadingPlan plan = getPlanById(planId);
    final int currentIndex = plan.days.indexWhere(
      (PlanDay day) => day.dayNumber == dayNumber,
    );

    if (currentIndex <= 0) {
      return null;
    }

    return plan.days[currentIndex - 1];
  }
}

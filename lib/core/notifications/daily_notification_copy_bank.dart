import '../constants/app_constants.dart';

class DailyNotificationCopy {
  const DailyNotificationCopy({
    required this.title,
    required this.body,
    required this.category,
  });

  final String title;
  final String body;
  final String category;
}

class DailyNotificationCopyBank {
  DailyNotificationCopyBank._();

  static const List<String> _titles = <String>[
    'Today\'s verse',
    'A gentle reminder',
    'Open today\'s reading',
  ];

  static const Map<String, List<String>> _bodyByCategory = <String, List<String>>{
    'Guidance': <String>[
      'Pause for today\'s verse and let God steady your next step.',
      'Open today\'s verse for quiet direction before the day rushes on.',
      'Your daily verse is ready when you need a little clarity.',
      'Take a breath and open today\'s verse for wisdom that stays grounded.',
      'Today\'s verse is here to gently guide what comes next.',
      'Return to scripture for a calm word of guidance today.',
      'Open today\'s verse and bring your decisions back into prayer.',
      'A steady word for today is waiting in your daily verse.',
      'Let today\'s verse meet the places where you need direction.',
      'Open your verse for a grounded reminder before moving ahead.',
      'Today\'s reading is ready to help settle your path.',
      'Step back into scripture and receive a little guidance for today.',
    ],
    'Hope': <String>[
      'Open today\'s verse for a hopeful word you can carry gently.',
      'Your daily verse is ready with a reminder that God has not forgotten you.',
      'Take a moment with today\'s verse and let hope breathe again.',
      'Today\'s reading is here with a quiet word of hope.',
      'Open your verse for a steadier view of what God is still doing.',
      'A hopeful scripture is waiting for you in today\'s verse.',
      'Return to today\'s verse and let hope speak softly again.',
      'Open today\'s reading for a calm reminder of God\'s faithfulness.',
      'Today\'s verse is ready when you need hope that feels grounded.',
      'Let scripture meet today with a little more hope.',
      'Open today\'s verse and receive a hopeful word for this moment.',
      'A gentle reminder of hope is ready in today\'s reading.',
    ],
    'Strength': <String>[
      'Open today\'s verse for strength that does not come from striving alone.',
      'Your daily verse is ready with a steadier kind of strength.',
      'Pause with today\'s verse and let God meet your weariness.',
      'Today\'s reading is here when you need renewed strength.',
      'Open your verse for strength that can hold the rest of this day.',
      'A stronger word for today is waiting in scripture.',
      'Return to today\'s verse and let God renew what feels tired.',
      'Open today\'s reading for strength that stays honest and calm.',
      'Today\'s verse is ready when you need help carrying the day.',
      'Let scripture steady you with a fresh word of strength today.',
      'Open today\'s verse and bring your fatigue back to God.',
      'A quiet reminder of strength is ready in today\'s reading.',
    ],
    'Peace Over Anxiety': <String>[
      'Open today\'s verse for peace that meets anxious thoughts with gentleness.',
      'Your daily verse is ready with a calmer word for your heart.',
      'Pause with today\'s verse and let prayer interrupt the spiral.',
      'Today\'s reading is here with a quieter way to carry the day.',
      'Open your verse for peace that can hold what feels unsettled.',
      'A calm word is waiting for you in today\'s verse.',
      'Return to today\'s verse and let scripture slow the inner noise.',
      'Open today\'s reading for a peaceful reminder you do not have to carry this alone.',
      'Today\'s verse is ready when you need a breath of peace.',
      'Let scripture meet your anxious places with a steadier word today.',
      'Open today\'s verse and bring the heavy thoughts into prayer.',
      'A gentle reminder of peace is ready in today\'s reading.',
    ],
    'Comfort and Healing': <String>[
      'Open today\'s verse for comfort that stays near to real pain.',
      'Your daily verse is ready with a gentle word for hurting places.',
      'Pause with today\'s verse and let God meet your tenderness.',
      'Today\'s reading is here with quiet comfort for this moment.',
      'Open your verse for a reminder that God stays near in sorrow.',
      'A comforting word is waiting in today\'s verse.',
      'Return to today\'s verse and receive a little steadiness for healing.',
      'Open today\'s reading for comfort that does not rush your heart.',
      'Today\'s verse is ready when you need nearness more than noise.',
      'Let scripture sit with you gently through today.',
      'Open today\'s verse and bring the ache back into God\'s care.',
      'A healing reminder is ready in today\'s reading.',
    ],
    'Faith in Doubt': <String>[
      'Open today\'s verse for faith that can stay honest in the middle of doubt.',
      'Your daily verse is ready with room for both trust and questions.',
      'Pause with today\'s verse and bring your doubts into the light.',
      'Today\'s reading is here with a steady word for uncertain places.',
      'Open your verse for faith that does not have to pretend.',
      'A grounded word is waiting in today\'s verse when belief feels thin.',
      'Return to today\'s verse and let scripture meet your honest questions.',
      'Open today\'s reading for a calm reminder that God is not afraid of doubt.',
      'Today\'s verse is ready when you need help believing again.',
      'Let scripture hold the places where your faith feels fragile today.',
      'Open today\'s verse and bring both trust and struggle with you.',
      'A gentle word for doubtful places is ready in today\'s reading.',
    ],
    'Forgiveness': <String>[
      'Open today\'s verse for grace that invites honest confession and fresh peace.',
      'Your daily verse is ready with a reminder of God\'s mercy.',
      'Pause with today\'s verse and come back to the freedom of forgiveness.',
      'Today\'s reading is here with a gentle word about grace.',
      'Open your verse for a reminder that mercy is still open to you.',
      'A gracious word is waiting in today\'s verse.',
      'Return to today\'s verse and let forgiveness quiet the shame.',
      'Open today\'s reading for a steadier picture of God\'s mercy.',
      'Today\'s verse is ready when you need grace more than self-repair.',
      'Let scripture lead you back to confession and peace today.',
      'Open today\'s verse and rest again in the mercy of God.',
      'A calm reminder of forgiveness is ready in today\'s reading.',
    ],
    'Purpose and Calling': <String>[
      'Open today\'s verse for a grounded reminder of the work God is shaping in you.',
      'Your daily verse is ready with a calm word about purpose.',
      'Pause with today\'s verse and remember that calling starts with belonging.',
      'Today\'s reading is here to steady your sense of purpose.',
      'Open your verse for a faithful next step instead of more pressure.',
      'A clarifying word is waiting in today\'s verse.',
      'Return to today\'s verse and let scripture re-center your calling.',
      'Open today\'s reading for purpose that feels rooted, not rushed.',
      'Today\'s verse is ready when you need to remember why you are walking this way.',
      'Let scripture guide your purpose with a gentler pace today.',
      'Open today\'s verse and bring your calling back into God\'s hands.',
      'A steady reminder of purpose is ready in today\'s reading.',
    ],
    'Love and Relationships': <String>[
      'Open today\'s verse for love that grows gentler, truer, and steadier.',
      'Your daily verse is ready with a word for the way you love others.',
      'Pause with today\'s verse and let scripture shape your relationships.',
      'Today\'s reading is here with a calmer picture of love.',
      'Open your verse for grace that can soften the way you respond today.',
      'A relational word is waiting in today\'s verse.',
      'Return to today\'s verse and let God form patience and kindness again.',
      'Open today\'s reading for love that feels rooted instead of reactive.',
      'Today\'s verse is ready when you want to love more faithfully.',
      'Let scripture bring tenderness into your relationships today.',
      'Open today\'s verse and invite God into the way you care for others.',
      'A gentle reminder about love is ready in today\'s reading.',
    ],
    'Gratitude and Joy': <String>[
      'Open today\'s verse for joy that can still breathe in ordinary moments.',
      'Your daily verse is ready with a small invitation into gratitude.',
      'Pause with today\'s verse and let joy return quietly.',
      'Today\'s reading is here with a lighter word for your day.',
      'Open your verse for gratitude that steadies the heart.',
      'A joyful word is waiting in today\'s verse.',
      'Return to today\'s verse and let scripture brighten the ordinary.',
      'Open today\'s reading for a gentle reminder to rejoice and give thanks.',
      'Today\'s verse is ready when you need joy that feels honest.',
      'Let scripture lead you back to gratitude today.',
      'Open today\'s verse and receive a calmer kind of joy.',
      'A grateful reminder is ready in today\'s reading.',
    ],
    'Obedience': <String>[
      'Open today\'s verse for a faithful reminder to live what God is saying.',
      'Your daily verse is ready with a steady word about obedience.',
      'Pause with today\'s verse and let truth move into action.',
      'Today\'s reading is here with a gentle call toward faithfulness.',
      'Open your verse for a next step that looks like lived trust.',
      'A clarifying word is waiting in today\'s verse.',
      'Return to today\'s verse and let scripture shape what you practice.',
      'Open today\'s reading for obedience that grows from love, not pressure.',
      'Today\'s verse is ready when you need courage to respond faithfully.',
      'Let scripture guide your response with simple obedience today.',
      'Open today\'s verse and bring your next step back before God.',
      'A gentle reminder to walk it out is ready in today\'s reading.',
    ],
  };

  static DailyNotificationCopy resolve({
    required List<String> selectedCategories,
    required DateTime date,
    String? lockedCategory,
  }) {
    final List<String> effectiveCategories = selectedCategories
        .where(AppConstants.v1Categories.contains)
        .toList(growable: false);
    final List<String> categories = effectiveCategories.isEmpty
        ? const <String>['Guidance', 'Hope', 'Strength']
        : effectiveCategories;
    final String dateKey = _dateKey(date);
    final String category = lockedCategory != null &&
            AppConstants.v1Categories.contains(lockedCategory)
        ? lockedCategory
        : categories[_stableHash(dateKey) % categories.length];
    final List<String> bodies =
        _bodyByCategory[category] ?? _bodyByCategory.values.first;
    final String body =
        bodies[_stableHash('$category|$dateKey') % bodies.length];
    final String title = _titles[_stableHash('title|$dateKey') % _titles.length];
    return DailyNotificationCopy(title: title, body: body, category: category);
  }

  static List<String> previewBodiesForCategory(String category) {
    final List<String>? values = _bodyByCategory[category];
    if (values != null) {
      return List<String>.unmodifiable(values);
    }
    return List<String>.unmodifiable(_bodyByCategory.values.first);
  }

  static bool isValid() {
    return _bodyByCategory.length == AppConstants.v1Categories.length &&
        AppConstants.v1Categories.every(
          (String category) => (_bodyByCategory[category]?.length ?? 0) == 12,
        );
  }

  static String _dateKey(DateTime value) {
    final String month = value.month.toString().padLeft(2, '0');
    final String day = value.day.toString().padLeft(2, '0');
    return '${value.year}-$month-$day';
  }

  static int _stableHash(String value) {
    int hash = 0;
    for (int index = 0; index < value.length; index++) {
      hash = (hash * 31 + value.codeUnitAt(index)) & 0x7fffffff;
    }
    return hash;
  }
}

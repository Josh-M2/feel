class ReadingPlan {
  const ReadingPlan({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.categoryLabel,
    required this.durationDays,
    required this.description,
    required this.whyItHelps,
    required this.progressLabel,
    required this.currentDayNumber,
    required this.days,
  });

  final String id;
  final String title;
  final String subtitle;
  final String categoryLabel;
  final int durationDays;
  final String description;
  final String whyItHelps;
  final String progressLabel;
  final int currentDayNumber;
  final List<PlanDay> days;
}

class PlanDay {
  const PlanDay({
    required this.dayNumber,
    required this.title,
    required this.focusLine,
    required this.summary,
    required this.passageRefs,
    required this.reflectionPrompt,
    required this.prayerPrompt,
  });

  final int dayNumber;
  final String title;
  final String focusLine;
  final String summary;
  final List<String> passageRefs;
  final String reflectionPrompt;
  final String prayerPrompt;
}

class PlanDetailRouteArgs {
  const PlanDetailRouteArgs({required this.planId});

  final String planId;
}

class PlanDayReadRouteArgs {
  const PlanDayReadRouteArgs({required this.planId, required this.dayNumber});

  final String planId;
  final int dayNumber;
}

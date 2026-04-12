class ReadingPlan {
  const ReadingPlan({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.categoryLabel,
    required this.durationDays,
    required this.description,
    required this.whyItHelps,
    required this.days,
    this.progress = const ReadingPlanProgress.unstarted(),
  });

  final String id;
  final String title;
  final String subtitle;
  final String categoryLabel;
  final int durationDays;
  final String description;
  final String whyItHelps;
  final List<PlanDay> days;
  final ReadingPlanProgress progress;

  int get safeDurationDays => durationDays <= 0 ? 1 : durationDays;

  int get currentDayNumber {
    final int candidate = progress.currentDayNumber;
    if (candidate < 1) {
      return 1;
    }
    if (candidate > safeDurationDays) {
      return safeDurationDays;
    }
    return candidate;
  }

  int get completedDayCount {
    if (progress.isCompleted) {
      return safeDurationDays;
    }
    final int candidate = progress.completedDayCount;
    if (candidate < 0) {
      return 0;
    }
    if (candidate > safeDurationDays) {
      return safeDurationDays;
    }
    return candidate;
  }

  bool get isStarted => progress.isStarted;

  bool get isCompleted => progress.isCompleted;

  double get progressValue {
    if (safeDurationDays <= 0) {
      return 0;
    }
    return (completedDayCount / safeDurationDays).clamp(0, 1).toDouble();
  }

  String get progressLabel {
    if (isCompleted) {
      return 'Completed';
    }
    return 'Day $currentDayNumber of $safeDurationDays';
  }

  PlanDay get resolvedCurrentDay {
    return days.firstWhere(
      (PlanDay day) => day.dayNumber == currentDayNumber,
      orElse: () => days.isEmpty ? const PlanDay.empty() : days.first,
    );
  }

  ReadingPlan copyWith({
    String? id,
    String? title,
    String? subtitle,
    String? categoryLabel,
    int? durationDays,
    String? description,
    String? whyItHelps,
    List<PlanDay>? days,
    ReadingPlanProgress? progress,
  }) {
    return ReadingPlan(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      categoryLabel: categoryLabel ?? this.categoryLabel,
      durationDays: durationDays ?? this.durationDays,
      description: description ?? this.description,
      whyItHelps: whyItHelps ?? this.whyItHelps,
      days: days ?? this.days,
      progress: progress ?? this.progress,
    );
  }
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

  const PlanDay.empty()
    : dayNumber = 1,
      title = '',
      focusLine = '',
      summary = '',
      passageRefs = const <String>[],
      reflectionPrompt = '',
      prayerPrompt = '';
}

class ReadingPlanProgress {
  const ReadingPlanProgress({
    required this.currentDayNumber,
    required this.completedDayCount,
    required this.isStarted,
    required this.isCompleted,
    this.startedAtIso,
    this.lastOpenedAtIso,
    this.completedAtIso,
    this.updatedAtIso,
  });

  const ReadingPlanProgress.unstarted()
    : currentDayNumber = 1,
      completedDayCount = 0,
      isStarted = false,
      isCompleted = false,
      startedAtIso = null,
      lastOpenedAtIso = null,
      completedAtIso = null,
      updatedAtIso = null;

  final int currentDayNumber;
  final int completedDayCount;
  final bool isStarted;
  final bool isCompleted;
  final String? startedAtIso;
  final String? lastOpenedAtIso;
  final String? completedAtIso;
  final String? updatedAtIso;

  ReadingPlanProgress copyWith({
    int? currentDayNumber,
    int? completedDayCount,
    bool? isStarted,
    bool? isCompleted,
    String? startedAtIso,
    String? lastOpenedAtIso,
    String? completedAtIso,
    String? updatedAtIso,
  }) {
    return ReadingPlanProgress(
      currentDayNumber: currentDayNumber ?? this.currentDayNumber,
      completedDayCount: completedDayCount ?? this.completedDayCount,
      isStarted: isStarted ?? this.isStarted,
      isCompleted: isCompleted ?? this.isCompleted,
      startedAtIso: startedAtIso ?? this.startedAtIso,
      lastOpenedAtIso: lastOpenedAtIso ?? this.lastOpenedAtIso,
      completedAtIso: completedAtIso ?? this.completedAtIso,
      updatedAtIso: updatedAtIso ?? this.updatedAtIso,
    );
  }
}

class PlanDayReadState {
  const PlanDayReadState({
    required this.plan,
    required this.day,
    required this.previousDay,
    required this.nextDay,
  });

  final ReadingPlan plan;
  final PlanDay day;
  final PlanDay? previousDay;
  final PlanDay? nextDay;
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

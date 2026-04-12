class PlanProgressLocalSnapshot {
  const PlanProgressLocalSnapshot({required this.entries});

  final List<PlanProgressLocalRecord> entries;

  factory PlanProgressLocalSnapshot.empty() {
    return const PlanProgressLocalSnapshot(entries: <PlanProgressLocalRecord>[]);
  }

  factory PlanProgressLocalSnapshot.fromJson(Map<String, dynamic> json) {
    final List<dynamic> rawEntries =
        json['entries'] as List<dynamic>? ?? const <dynamic>[];
    return PlanProgressLocalSnapshot(
      entries: rawEntries
          .whereType<Map<String, dynamic>>()
          .map(PlanProgressLocalRecord.fromJson)
          .toList(growable: false),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'entries': entries
          .map((PlanProgressLocalRecord item) => item.toJson())
          .toList(growable: false),
    };
  }

  PlanProgressLocalSnapshot copyWith({
    List<PlanProgressLocalRecord>? entries,
  }) {
    return PlanProgressLocalSnapshot(entries: entries ?? this.entries);
  }
}

class PlanProgressLocalRecord {
  const PlanProgressLocalRecord({
    required this.planId,
    required this.currentDayNumber,
    required this.completedDayCount,
    required this.isStarted,
    required this.isCompleted,
    this.startedAtIso,
    this.lastOpenedAtIso,
    this.completedAtIso,
    this.updatedAtIso,
  });

  final String planId;
  final int currentDayNumber;
  final int completedDayCount;
  final bool isStarted;
  final bool isCompleted;
  final String? startedAtIso;
  final String? lastOpenedAtIso;
  final String? completedAtIso;
  final String? updatedAtIso;

  factory PlanProgressLocalRecord.fromJson(Map<String, dynamic> json) {
    return PlanProgressLocalRecord(
      planId: json['planId']?.toString() ?? '',
      currentDayNumber: (json['currentDayNumber'] as num?)?.toInt() ?? 1,
      completedDayCount: (json['completedDayCount'] as num?)?.toInt() ?? 0,
      isStarted: json['isStarted'] == true,
      isCompleted: json['isCompleted'] == true,
      startedAtIso: json['startedAtIso']?.toString(),
      lastOpenedAtIso: json['lastOpenedAtIso']?.toString(),
      completedAtIso: json['completedAtIso']?.toString(),
      updatedAtIso: json['updatedAtIso']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'planId': planId,
      'currentDayNumber': currentDayNumber,
      'completedDayCount': completedDayCount,
      'isStarted': isStarted,
      'isCompleted': isCompleted,
      'startedAtIso': startedAtIso,
      'lastOpenedAtIso': lastOpenedAtIso,
      'completedAtIso': completedAtIso,
      'updatedAtIso': updatedAtIso,
    };
  }

  PlanProgressLocalRecord copyWith({
    String? planId,
    int? currentDayNumber,
    int? completedDayCount,
    bool? isStarted,
    bool? isCompleted,
    String? startedAtIso,
    String? lastOpenedAtIso,
    String? completedAtIso,
    String? updatedAtIso,
  }) {
    return PlanProgressLocalRecord(
      planId: planId ?? this.planId,
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

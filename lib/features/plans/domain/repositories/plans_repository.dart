import 'package:flutter/foundation.dart';

import '../models/reading_plan.dart';

abstract class PlansRepository {
  ValueListenable<int> get revisionListenable;

  Future<List<ReadingPlan>> getPlans();

  Future<ReadingPlan> getPlanById(String? planId);

  Future<ReadingPlan?> getContinuePlan();

  Future<PlanDayReadState> openPlanDay({
    required String? planId,
    int? dayNumber,
  });
}

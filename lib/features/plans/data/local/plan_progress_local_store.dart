import 'plan_progress_local_snapshot.dart';

abstract class PlanProgressLocalStore {
  Future<PlanProgressLocalSnapshot> load();

  Future<void> save(PlanProgressLocalSnapshot snapshot);

  Future<void> clear();
}

import 'today_assignment_local_snapshot.dart';

abstract class TodayAssignmentLocalStore {
  Future<TodayAssignmentLocalSnapshot> load();
  Future<void> save(TodayAssignmentLocalSnapshot snapshot);
  Future<void> clear();
}

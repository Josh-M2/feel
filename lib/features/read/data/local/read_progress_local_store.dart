import 'read_progress_local_snapshot.dart';

abstract class ReadProgressLocalStore {
  Future<ReadProgressLocalSnapshot> load();
  Future<void> save(ReadProgressLocalSnapshot snapshot);
  Future<void> clear();
}

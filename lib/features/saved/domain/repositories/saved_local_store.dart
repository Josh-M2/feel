import '../models/saved_library_local_snapshot.dart';

abstract class SavedLocalStore {
  Future<SavedLibraryLocalSnapshot> load();
  Future<void> save(SavedLibraryLocalSnapshot snapshot);
  Future<void> clear();
}

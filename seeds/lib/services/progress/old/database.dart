import '../../saved.dart';
import '../record.dart';

abstract class ProgressDatabase<D>
    extends SavedDatabase<D, String, ProgressRecord> {
  /// Saves the progress record to the database, using the ID as the key.
  Future<void> saveRecord(ProgressRecord record) => save(record.topic, record);

  /// Loads all records as an iterable.
  Future<Iterable<ProgressRecord>> loadAllRecords() async =>
      (await loadAll()).values;
}

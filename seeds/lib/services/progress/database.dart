import '../saved.dart';
import 'event.dart';

abstract class ProgressEventDatabase<D>
    extends SavedDatabase<D, DateTime, ProgressEvent> {
  /// Saves the progress record to the database, using the ID as the key.
  Future<void> saveEvent(ProgressEvent event) => save(event.dateTime, event);

  /// Loads all records as an iterable.
  Future<Iterable<ProgressEvent>> loadAllEvents() async =>
      (await loadAll()).values;
}

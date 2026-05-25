import '../saved.dart';
import 'entry.dart';

abstract class JournalDatabase<D extends Object>
    extends SavedDatabase<D, DateTime, JournalEntry> {
  /// Saves the journal entry to the database, using the name as the key.
  Future<void> saveEntry(JournalEntry entry) => save(entry.created, entry);

  /// Deletes the journal entry from the database based on the entry's date.
  Future<bool> removeEntry(JournalEntry entry) => remove(entry.created);

  /// Loads all journal entries as an iterable.
  Future<Iterable<JournalEntry>> loadAllEntries() async =>
      (await loadAll()).values;
}

import '../custom_database/database.dart';
import 'entry.dart';

abstract class JournalDatabase<D>
    extends CustomDatabase<D, String, JournalEntry> {
  /// Saves the journal entry to the database, using the name as the key.
  Future<void> saveEntry(JournalEntry entry) => save(entry.name, entry);

  /// Deletes the journal entry from the database based on the entry's name.
  Future<bool> deleteEntry(JournalEntry entry) => delete(entry.name);

  /// Loads all journal entries as an iterable.
  Future<Iterable<JournalEntry>> loadAllEntries() async =>
      (await loadAll()).values;
}

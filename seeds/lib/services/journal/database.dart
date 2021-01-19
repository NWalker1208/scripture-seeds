import '../database.dart';
import 'entry.dart';

abstract class JournalDatabase<D>
    extends CustomDatabase<D, String, JournalEntry> {
  /// Saves the journal entry to the database, using the name as the key.
  Future<void> saveEntry(JournalEntry entry) => save(entry.name, entry);

  /// Deletes the journal entry from the database based on the entry's name.
  Future<bool> deleteEntry(JournalEntry entry) => delete(entry.name);

  /// Loads all journal entries as an iterable.
  /// Automatically removes entries which loaded as null.
  Future<Iterable<JournalEntry>> loadAllEntries() async => [
        for (var entry in (await loadAll()).values)
          if (entry != null) entry,
      ];
}

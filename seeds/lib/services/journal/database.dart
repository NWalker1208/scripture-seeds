import '../saved.dart';
import 'entry.dart';

abstract class JournalDatabase<D>
    extends SavedDatabase<D, DateTime, JournalEntry> {
  /// Saves the journal entry to the database, using the name as the key.
  Future<void> saveEntry(JournalEntry entry) => save(entry.created, entry);

  /// Deletes the journal entry from the database based on the entry's date.
  Future<bool> removeEntry(JournalEntry entry) => remove(entry.created);

  /// Loads all journal entries as an iterable.
  /// Automatically removes entries which loaded as null.
  Future<Iterable<JournalEntry>> loadAllEntries() async => [
        for (var entry in (await loadAll()).values)
          if (entry != null) entry,
      ];
}

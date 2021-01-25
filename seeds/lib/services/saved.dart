import 'database.dart';

/// A database that stores user data based on keys and values.
/// D - Internal database class
/// K - Key
/// V - Value
abstract class SavedDatabase<D, K, V> extends CustomDatabase<D, K, V> {
  /// Associates the given value with the key.
  Future<void> save(K key, V value);

  /// Deletes the entry with the given key.
  /// Returns true if an entry was deleted, false otherwise.
  Future<bool> delete(K key);

  /// Clears all data from the database.
  Future<void> clear() async {
    for (var key in await loadKeys()) {
      await delete(key);
    }
  }

  /// Transfers entries to this database from another.
  Future<void> copyFrom(CustomDatabase<dynamic, K, V> other) async {
    final map = await other.loadAll();
    for (var entry in map.entries) {
      await save(entry.key, entry.value);
    }
  }
}

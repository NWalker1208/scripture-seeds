import 'service.dart';

/// A database that stores user data based on keys and values.
/// D - Internal database class
/// K - Key
/// V - Value
abstract class CustomDatabase<D, K, V> extends CustomService<D> {
  /// Loads the keys of every entry in the database.
  Future<Iterable<K>> loadKeys();

  /// Loads the value associated with the key.
  /// Returns null if no value exists.
  Future<V> load(K key);

  /// Loads all entries in the database.
  Future<Map<K, V>> loadAll() async => {
        for (var key in await loadKeys()) key: await load(key),
      };

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

  /// Transfers entries from this database to another.
  Future<void> transferTo(CustomDatabase<dynamic, K, V> destination) async {
    final map = await loadAll();
    for (var entry in map.entries) {
      await destination.save(entry.key, entry.value);
    }
  }
}

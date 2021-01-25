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
}

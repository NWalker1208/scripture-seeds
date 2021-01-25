import 'database.dart';

/// A database wrapper which stores a given database and caches values
/// that are retrieved. Closes internal database when closed.
/// D - Internal database class
/// K - Key
/// V - Value
class CachedDatabase<D extends CustomDatabase<dynamic, K, V>, K, V>
    extends CustomDatabase<_Cache<K, V>, K, V> {
  CachedDatabase(this.internal);

  final D internal;

  @override
  Future<V> load(K key) async {
    final c = await data;
    return c.data[key] ??= internal.load(key);
  }

  @override
  Future<Iterable<K>> loadKeys() async {
    final c = await data;
    return c.keys ??= internal.loadKeys();
  }

  @override
  Future<_Cache<K, V>> open() async => _Cache();

  @override
  Future<void> close() async {
    await internal.close();
    await super.close();
  }
}

class _Cache<K, V> {
  Future<Iterable<K>> keys;
  final data = <K, Future<V>>{};
}

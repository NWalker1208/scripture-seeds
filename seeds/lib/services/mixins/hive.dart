import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

import '../saved.dart';

/// Mixin for databases that use a Hive database for storage.
mixin HiveDatabaseMixin<K, V> on SavedDatabase<Box<V>, K, V> {
  /// Name of Hive box to store data.
  @protected
  String get boxName;

  /// Convert a key to a string for storage.
  @protected
  String keyToString(K key);

  /// Convert a string from storage back to a key.
  @protected
  K stringToKey(String string);

  @override
  Future<Box<V>> open() => Hive.openBox<V>(boxName);

  @override
  Future<V> load(K key) async {
    final box = await data;
    return box.get(keyToString(key));
  }

  @override
  Future<Iterable<K>> loadKeys() async {
    final box = await data;
    return [
      for (var key in box.keys)
        stringToKey(key as String),
    ];
  }

  @override
  Future<void> save(K key, V value) async {
    final box = await data;
    return box.put(keyToString(key), value);
  }

  @override
  Future<bool> delete(K key) async {
    final box = await data;
    final str = keyToString(key);
    if (box.containsKey(str)) {
      await box.delete(str);
      return true;
    }
    return false;
  }
}

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
  /// Return null for invalid keys.
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
      for (var key in box.keys) stringToKey(key as String),
    ].where((key) => key != null);
  }

  @override
  Future<void> save(K key, V value) async {
    final box = await data;
    return box.put(keyToString(key), value);
  }

  @override
  Future<bool> remove(K key) async {
    final box = await data;
    final str = keyToString(key);
    if (box.containsKey(str)) {
      await box.delete(str);
      return true;
    }
    return false;
  }

  @override
  Future<void> clear() async {
    final box = await data;
    await box.clear();
  }

  @override
  Future<void> delete() async {
    await super.delete();
    await Hive.deleteBoxFromDisk(boxName);
  }

  @override
  Future<void> close() async {
    final box = await data;
    await box.close();
    await super.close();
  }
}

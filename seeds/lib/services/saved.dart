import 'package:flutter/foundation.dart';

import 'database.dart';

/// A database that stores user data based on keys and values.
/// D - Internal database class
/// K - Key
/// V - Value
abstract class SavedDatabase<D, K, V> extends CustomDatabase<D, K, V> {
  /// Associates the given value with the key.
  Future<void> save(K key, V value);

  /// Removes the entry with the given key.
  /// Returns true if an entry was deleted, false otherwise.
  Future<bool> remove(K key);

  /// Clears all data from the database.
  Future<void> clear() async {
    for (var key in await loadKeys()) {
      await remove(key);
    }
  }

  /// Deletes the entire database from persistent storage and calls [close].
  @mustCallSuper
  Future<void> delete() => close();

  /// Transfers entries to this database from another.
  Future<void> copyFrom(
    CustomDatabase<dynamic, K, V> other, {
    bool overwrite = false,
  }) async {
    final map = await other.loadAll();
    final existing = await loadKeys();
    for (var entry in map.entries) {
      if (overwrite || !existing.contains(entry.key)) {
        await save(entry.key, entry.value);
      }
    }
  }

  /// Copies the contents of this database to [other], if [isOpen] is true.
  /// Returns true if anything was copied to the database.
  /// Closes this database when finished.
  Future<bool> upgrade(SavedDatabase<dynamic, K, V> newDatabase) async {
    var upgraded = false;
    if (isOpen) {
      final keys = await loadKeys();
      if (keys.isNotEmpty) {
        await newDatabase.copyFrom(this);
        upgraded = true;
        print('Upgraded ${keys.length} entries from '
            '$runtimeType to ${newDatabase.runtimeType}.');
      }
      await delete();
    }
    if (!upgraded) print('No data present in $runtimeType to upgrade.');
    return upgraded;
  }
}

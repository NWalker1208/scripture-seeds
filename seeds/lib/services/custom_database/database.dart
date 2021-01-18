import 'package:flutter/foundation.dart';

/// A database that stores user data based on keys and values.
/// Implementation of the database may vary.
/// D - Internal database class
/// K - Key
/// V - Value
abstract class CustomDatabase<D, K, V> {
  /// Creates a database and opens it with the given async function.
  /// The open function should complete once the database is ready.
  @mustCallSuper
  CustomDatabase() {
    _database = open();
  }

  /// Stores the future given by the open function.
  /// Set to null when closed.
  Future<D> _database;

  /// Used to create the internal database instance.
  /// Called during construction by CustomDatabase class.
  @protected
  Future<D> open();

  /// Used to obtain the internal database instance.
  /// Throws an exception if the database is closed.
  @protected
  Future<D> get database {
    assertOpen();
    return _database;
  }

  /// Completes once the database has been opened.
  /// Throws an exception if the database is closed.
  Future<void> get ready async {
    assertOpen();
    await _database;
  }

  /// Loads the keys of every entry in the database.
  Future<Iterable<K>> loadKeys();

  /// Loads the value associated with the key.
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

  /// Closes the database. Must call before disposing.
  /// Do not call if the database is already closed.
  @mustCallSuper
  Future<void> close() async {
    assertOpen();
    _database = null;
  }

  /// Returns true if the database has not been closed.
  bool get isOpen => _database != null;

  /// Throws an exception if the database is closed.
  void assertOpen() {
    if (!isOpen) throw DatabaseClosedException(this);
  }
}

/// Custom exception for access or modification of a closed database.
class DatabaseClosedException implements Exception {
  const DatabaseClosedException(this.source);

  /// The database which was accessed or modified.
  final CustomDatabase source;

  @override
  String toString() =>
      'Attempted to access or modify a closed database: $source';
}

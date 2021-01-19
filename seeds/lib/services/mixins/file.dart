import 'dart:async';
import 'dart:io';

import 'package:path/path.dart' as path;

import '../database.dart';

mixin FileDatabaseMixin<K, V> on CustomDatabase<Directory, K, V> {
  /// Get the directory where files should be read from and written to.
  Future<Directory> get directory;

  /// Get the extension that should be used for new files.
  String get extension;

  /// Convert a key to a string appropriate for a filename (exclude extension).
  String keyToFilename(K key);

  /// Convert a database value to a string for writing to a file.
  String writeValue(V value);

  /// Convert a filename (without extension) to a key.
  /// Returns null for invalid filenames.
  K filenameToKey(String file);

  /// Convert a string from a file to a database value.
  /// Returns null for invalid strings.
  V parseValue(String str);

  @override
  Future<Directory> open() => directory;

  @override
  Future<Iterable<K>> loadKeys() async {
    final dir = await source;
    final contents = await dir.list().toList();
    return [
      for (var entity in contents)
        if (entity is File)
          filenameToKey(path.basenameWithoutExtension(entity.path)),
    ]..removeWhere((key) => key == null);
  }

  @override
  Future<V> load(K key) async {
    final dir = await source;
    final file = File(path.join(dir.path, keyToFilename(key) + extension));
    if (!await file.exists()) return null;
    return parseValue(await file.readAsString());
  }

  @override
  Future<void> save(K key, V value) async {
    final dir = await source;
    final file = File(path.join(dir.path, keyToFilename(key) + extension));
    await file.create(recursive: true);
    await file.writeAsString(writeValue(value), flush: true);
  }

  @override
  Future<bool> delete(K key) async {
    final dir = await source;
    final file = File(path.join(dir.path, keyToFilename(key) + extension));
    if (!await file.exists()) return false;
    await file.delete();
    return true;
  }
}

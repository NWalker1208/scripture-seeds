import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'path.dart';

/// An interface for accessing files in the cloud.
/// T - Type of API.
/// P - Type of path for referencing API.
@immutable
abstract class CloudService<T, P extends CloudPath> {
  const CloudService(T api)
      : assert(api != null),
        _api = api;

  final T _api;

  @protected
  T get api => _api;

  /// The default path for this cloud service.
  P get defaultPath;

  /// Find the newest path with the given name.
  /// Returns null if it does not exist.
  /// Parent defaults to defaultPath.
  Future<P> find(String name, {P parent});

  /// Create file with the given name. Use find to ensure this doesn't create
  /// duplicate named files.
  /// Parent defaults to defaultPath.
  Future<P> create(String name, {P parent, bool isFolder = false});

  /// Find all children of the given path.
  Future<Iterable<P>> childrenOf(P path);

  /// Download file from cloud as bytes.
  Future<List<int>> downloadBytes(P file);

  /// Upload file to Google Drive as bytes.
  Future<void> uploadBytes(P file, List<int> bytes);

  /// Delete file in Google Drive.
  Future<void> delete(P path);

  /*/// Create a path if it doesn't exist. Otherwise, return the existing one.
  Future<P> createLazy(String name, {P parent, bool isFolder = false}) async {
    final path = await find(name, parent: parent) ??
        await create(name, parent: parent, isFolder: isFolder);
    assert(path.isFolder == isFolder);
    return path;
  }

  /// Download file from Google Drive as text (utf8).
  Future<String> download(P file) async =>
      utf8.decode(await downloadBytes(file));

  /// Upload file to Google Drive as text (utf8).
  Future<void> upload(P file, String text) async =>
      await uploadBytes(file, utf8.encode(text));*/

  @override
  bool operator ==(Object other) {
    if (other is CloudService) return api == other.api;
    return false;
  }

  @override
  int get hashCode => api.hashCode;
}

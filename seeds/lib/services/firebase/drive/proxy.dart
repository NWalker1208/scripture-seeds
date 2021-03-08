import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:googleapis/drive/v3.dart';
import 'package:path/path.dart' as p;
import 'package:provider/provider.dart';

import '../../saved.dart';
import '../provider.dart';

/// Stores a cache of ID's for paths in Google Drive
abstract class DriveCacheDatabase<D> extends SavedDatabase<D, String, String> {}

/// Provides an interface for accessing files in the AppData portion of
/// Google Drive.
class DriveProxy {
  static final _appData = 'appDataFolder';
  static final _folderType = 'application/vnd.google-apps.folder';

  const DriveProxy(this.api, this.cache);
  factory DriveProxy.fromContext(BuildContext context) => DriveProxy(
        Provider.of<FirebaseProvider>(context).driveApi,
        Provider.of<DriveCacheDatabase>(context),
      );

  final DriveApi api;
  final DriveCacheDatabase cache;

  bool get authenticated => api != null;

  /// Upload a file to Google Drive.
  /// If a file has the same path, it is replaced.
  Future<void> uploadFile(String path, String contents) async {
    assert(authenticated);
    final bytes = utf8.encode(contents);
    final stream = Future.value(bytes).asStream().asBroadcastStream();
    final media = Media(stream, bytes.length);

    final id = await _findId(path);
    if (id == null) {
      final name = p.basename(path);
      final parent = await _findParent(path, create: true);
      final file = await api.files.create(
        File()
          ..name = name
          ..parents = [parent],
        uploadMedia: media,
      );
      final id = file.id;
      // Save ID of new file to cache
      print('Created file in Google Drive: "$path" ($id)');
      await cache.save(path, id);
    } else {
      await api.files.update(File(), id, uploadMedia: media);
      print('Updated file in Google Drive: "$path" ($id)');
    }
  }

  /// Download a file from Google Drive.
  /// If the path does not exist, returns null.
  Future<String> downloadFile(String path) async {
    assert(authenticated);
    final id = await _findId(path);
    if (id == null) return null;
    final media = await api.files
        .get(id, downloadOptions: DownloadOptions.fullMedia) as Media;
    final bytes = await media.stream.last;
    print('Downloaded file from Google Drive: "$path" ($id)');
    return utf8.decode(bytes);
  }

  /// Returns true if the path is a folder.
  /// Returns null if the path does not exist.
  Future<bool> checkIsFolder(String path) async {
    assert(authenticated);
    final id = await _findId(path);
    if (id == null) return null;
    final file = (await api.files.get(id, $fields: 'mimeType')) as File;
    return file.mimeType == _folderType;
  }

  /// Gets a list of filenames within a path. If path is null, checks app data.
  /// Returns null if the path does not exist.
  /// Returns an empty list if the path is empty.
  Future<Iterable<String>> listFiles([String path]) async {
    assert(authenticated);
    final id = path == null ? _appData : await _findId(path);
    if (id == null) return null;
    final list = await api.files.list(
      spaces: _appData,
      q: '\'$id\' in parents',
      $fields: 'files(id,name)',
    );
    return list.files.map((file) => file.name);
  }

  /// Returns true if a path exists.
  Future<bool> exists(String path) async {
    assert(authenticated);
    return await _findId(path) != null;
  }

  /// Deletes a file if it exists.
  Future<void> delete(String path) async {
    assert(authenticated);
    final id = await _findId(path);
    if (id == null) return;
    await _deleteById([id]);
    await cache.remove(path);
  }

  /// Finds the Google Drive ID of the given path.
  /// Returns null if the path does not exist.
  Future<String> _findId(String path) async {
    // Check cache
    final cached = await cache.load(path);
    if (cached != null) {
      try {
        if (await api.files.get(cached) != null) return cached;
      } on ApiRequestError catch (e) {
        print('Cached Google Drive ID invalid: ${e.message}');
      }
      // Delete invalid cache
      await cache.remove(path);
    }
    // Find parent folders
    final parent = await _findParent(path);
    if (parent == null) return null;
    // Find file/folder at path
    final name = p.basename(path);
    final list = await api.files.list(
      spaces: _appData,
      q: 'name = \'$name\' and \'$parent\' in parents',
      $fields: 'files(id,modifiedTime)',
    );
    // Use most recent file from list. Delete old duplicates.
    final results = list.files.toList();
    if (results.isEmpty) return null;
    if (results.length > 1) {
      results.sort((a, b) => -a.modifiedTime.compareTo(b.modifiedTime));
      await _deleteById(results.skip(1).map((f) => f.id));
    }
    final id = results.first.id;
    // Save result to cache
    print('Found ID for path in Google Drive: "$path" ($id)');
    await cache.save(path, id);
    return id;
  }

  /// Returns the ID of the parent folder.
  /// If path has no directory, this is the app data folder.
  Future<String> _findParent(String path, {bool create = false}) async {
    final parentPath = p.dirname(path);
    if (parentPath == '.') {
      return _appData;
    } else {
      final parentId = await _findId(parentPath);
      if (parentId != null) {
        return parentId;
      } else if (create) {
        // The parent does not exist, so we should create it.
        final name = p.basename(parentPath);
        final folder = await api.files.create(
          File()
            ..mimeType = _folderType
            ..name = name
            ..parents = [await _findParent(parentPath, create: true)],
        );
        if (folder == null) return null;
        final id = folder.id;
        // Save ID of new folder to cache
        print('Created folder in Google Drive: "$parentPath" ($id)');
        await cache.save(parentPath, id);
        return id;
      } else {
        return null;
      }
    }
  }

  /// Deletes all files in the given list.
  Future<void> _deleteById(Iterable<String> ids) async {
    print('Deleting ${ids.length} files from Google Drive.');
    for (var id in ids) {
      await api.files.delete(id);
    }
  }
}

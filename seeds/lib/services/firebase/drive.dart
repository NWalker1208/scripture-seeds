import 'package:flutter/widgets.dart';
import 'package:googleapis/drive/v3.dart';

import '../cloud/service.dart';

const _appData = 'appDataFolder';
const _folderType = 'application/vnd.google-apps.folder';

/// Stores ID's of paths in Google Drive.
@immutable
class DrivePath extends CloudPath {
  const DrivePath._(
    this.name,
    this.isFolder,
    this._id, [
    this._parentId = _appData,
  ]);

  /// The AppData folder of Google Drive. Default path.
  const DrivePath.appData()
      : name = 'AppData',
        isFolder = true,
        _id = _appData,
        _parentId = null;

  @override
  final String name;
  @override
  final bool isFolder;
  final String _id;
  final String _parentId;

  @override
  String toString() => '"$name" ($_id)';

  String get cachePath => '$_parentId/$name';
}

/// An interface for accessing files in the AppData portion of Google Drive.
// TODO: Cache ID's and filenames in Google Drive
class DriveStorage extends CloudService<DriveApi, DrivePath> {
  const DriveStorage(DriveApi api) : super(api);

  @override
  final defaultPath = const DrivePath.appData();

  @override
  Future<DrivePath> find(String name, {DrivePath parent}) async {
    parent ??= defaultPath;
    final list = await api.files.list(
      spaces: _appData,
      q: 'name = \'$name\' and \'${parent._id}\' in parents',
      orderBy: 'modifiedTime desc',
      $fields: 'files(id,mimeType)',
    );
    if (list.files.isEmpty) return null;
    final file = list.files.first;
    return DrivePath._(name, file.mimeType == _folderType, file.id, parent._id);
  }

  @override
  Future<DrivePath> create(String name,
      {DrivePath parent, bool isFolder = false}) async {
    parent ??= defaultPath;
    final metadata = File()
      ..name = name
      ..parents = [parent._id];
    if (isFolder) metadata.mimeType = _folderType;
    final file = await api.files.create(metadata, $fields: 'id');
    return DrivePath._(name, isFolder, file.id, parent._id);
  }

  @override
  Future<Iterable<DrivePath>> childrenOf(DrivePath path) async {
    assert(path.isFolder);
    final list = await api.files.list(
      spaces: _appData,
      q: '\'${path._id}\' in parents',
      orderBy: 'name',
      $fields: 'files(name,id,mimeType)',
    );
    return list.files.map((file) => DrivePath._(
          file.name,
          file.mimeType == _folderType,
          file.id,
          path._id,
        ));
  }

  @override
  Future<DateTime> lastModified(DrivePath path) async {
    final file = await api.files.get(
      path._id,
      $fields: 'files(modifiedTime)',
    ) as File;
    return file.modifiedTime;
  }

  @override
  Future<String> retrieveProperty(DrivePath path, String key) async {
    final file = await api.files.get(
      path._id,
      $fields: 'files(appProperties)',
    ) as File;
    return file.appProperties[key];
  }

  @override
  Future<void> updateProperty(DrivePath path, String key, String value) async {
    final file = await api.files.get(
      path._id,
      $fields: 'files(appProperties)',
    ) as File;
    file.appProperties[key] = value;
    await api.files.update(file, path._id);
  }

  @override
  Future<List<int>> downloadBytes(DrivePath file) async {
    assert(!file.isFolder);
    final media = await api.files.get(
      file._id,
      downloadOptions: DownloadOptions.fullMedia,
    ) as Media;
    return media.stream.fold(<int>[], (buffer, bytes) => buffer..addAll(bytes));
  }

  @override
  Future<void> uploadBytes(DrivePath file, List<int> bytes) async {
    assert(!file.isFolder);
    final stream = Future.value(bytes).asStream();
    final media = Media(stream, bytes.length);
    await api.files.update(File(), file._id, uploadMedia: media);
  }

  @override
  Future<void> delete(DrivePath path) async => await api.files.delete(path._id);
}

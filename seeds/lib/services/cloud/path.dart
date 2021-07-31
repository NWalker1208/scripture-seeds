import 'package:flutter/foundation.dart';

/// A class for referring to paths in cloud storage.
@immutable
abstract class CloudPath {
  const CloudPath();

  /// The filename or directory name of this path.
  String get name;

  /// True if this path is a folder.
  bool get isFolder;

  /// Properties of the file or folder.
  Map<String, String> get properties;


}

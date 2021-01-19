import 'package:flutter/foundation.dart';

/// A service that stores some persistent state, such as preferences or points.
/// D - Internal source class
abstract class CustomService<S> {
  /// Opens the source by calling the open method.
  @mustCallSuper
  CustomService() {
    _source = open();
  }

  /// Stores the future given by the open function.
  /// Is set to null when the service is closed.
  Future<S> _source;

  /// Used to create the internal source instance.
  /// Called during construction of CustomService class.
  @protected
  Future<S> open();

  /// Used to obtain the internal source instance.
  /// Throws an exception if the source is closed.
  @protected
  Future<S> get source {
    assertOpen();
    return _source;
  }

  /// Completes once the service is ready.
  /// Throws an exception if the service is closed.
  Future<void> get ready async {
    assertOpen();
    await _source;
  }

  /// Closes the service. Must call before disposing.
  /// Do not call if the service is already closed.
  @mustCallSuper
  Future<void> close() async {
    assertOpen();
    _source = null;
  }

  /// Returns true if the service has not been closed.
  bool get isOpen => _source != null;

  /// Throws an exception if the service is closed.
  void assertOpen() {
    if (!isOpen) throw ServiceClosedException(this);
  }
}

/// Custom exception for access of a closed service.
class ServiceClosedException implements Exception {
  const ServiceClosedException(this.source);

  /// The service which was accessed.
  final CustomService source;

  @override
  String toString() => 'Attempted to access a closed service: $source';
}

import 'package:flutter/foundation.dart';

/// A service that stores some persistent state, such as preferences or points.
/// D - Internal data service class
abstract class CustomService<D> {
  /// Opens the source by calling the open method.
  @mustCallSuper
  CustomService() {
    _data = open().catchError((dynamic e) {
      print('Service failed to open: $e');
      return null;
    });
  }

  /// Stores the future given by the open function.
  /// Is set to null when the service is closed.
  Future<D> _data;

  /// Used to create the internal data service instance.
  /// Called during construction of CustomService class.
  @protected
  Future<D> open();

  /// Used to obtain the internal data service instance.
  /// Throws an exception if the source is closed.
  @protected
  Future<D> get data {
    assertOpen();
    return _data;
  }

  /// Completes once the service is ready.
  /// Throws an exception if the service is closed.
  Future<void> get ready async {
    assertOpen();
    await _data;
  }

  /// Closes the service. Must call before disposing.
  /// Do not call if the service is already closed.
  @mustCallSuper
  Future<void> close() async {
    assertOpen();
    _data = null;
  }

  /// Returns true if the service has not been closed.
  bool get isOpen => _data != null;

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

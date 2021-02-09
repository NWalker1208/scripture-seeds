import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'saved.dart';
import 'service.dart';

/// A ChangeNotifier that provides synchronous access to a service.
abstract class ServiceProvider<S extends CustomService<dynamic>>
    extends ChangeNotifier {
  ServiceProvider(S Function() create) : _create = create {
    _service = _create();
    reload();
  }

  final S Function() _create;

  bool _isLoaded = false;
  S _service;

  /// True if the provider has finished loading data from the service.
  bool get isLoaded => _isLoaded;

  /// Disposes of the service, creates it again, and reloads the data.
  /// The function [beforeClosing] will be run prior to closing the service,
  /// and is allowed to close the service itself, such as by calling
  /// [SavedDatabase.delete]. [isLoaded] will be false during reload.
  /// Optionally, subclasses may override this to reset any data they cache.
  @mustCallSuper
  Future<void> refresh([FutureOr<void> Function(S) beforeClosing]) async {
    _isLoaded = false;
    notifyListeners();
    await beforeClosing?.call(_service);
    if (_service.isOpen) await _service.close();
    _service = _create();
    await reload();
  }

  /// Reloads any data stored by the provider from the service and
  /// notifies listeners.
  Future<void> reload() async {
    try {
      await loadData(_service);
      _isLoaded = true;
    } on Exception catch (e) {
      print('Failed to load data from service: $e');
      _isLoaded = false;
    }
    assert(_service.isOpen);
    notifyListeners();
  }

  /// Allows access to the service via a callback. The service should not be
  /// modified. If modification is required, use [modify].
  Future<D> access<D>(Future<D> Function(S) callback) async {
    final result = await callback(_service);
    assert(_service.isOpen);
    return result;
  }

  /// Allows modification of the service via a callback. [reload] will be
  /// called automatically afterwards. [callback] may not close the service.
  Future<D> modify<D>(Future<D> Function(S) callback) async {
    final result = await callback(_service);
    assert(_service.isOpen);
    await reload();
    return result;
  }

  /// Notifies listeners and updates the service via the provided function.
  /// [update] may not close the service. Only accessible by subclasses.
  @protected
  Future<D> notifyService<D>(Future<D> Function(S) update) {
    notifyListeners();
    return update(_service).whenComplete(() {
      assert(_service.isOpen);
    });
  }

  /// Load any relevant data from the service. Should not close [service].
  /// [notifyListeners] will be called immediately afterwards.
  /// If an exception is thrown, isLoaded will be set to false.
  @protected
  Future<void> loadData(S service);

  @override
  void dispose() {
    _service?.close();
    super.dispose();
  }
}

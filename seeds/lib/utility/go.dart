import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../router.dart';
import '../services/scriptures/reference.dart';

// Utility class for quicker navigation
class Go {
  const Go._(this._delegate);

  final AppRouterDelegate _delegate;

  AppPage get _currentPage => _delegate.currentConfiguration.page;
  String get _currentTopic => _delegate.currentConfiguration.topic;
  bool get _fromPlant => _delegate.currentConfiguration.fromPlant;

  static Go from(BuildContext context) =>
      Go._(Provider.of<AppRouterDelegate>(context, listen: false));

  Future<void> to(AppRoutePath path) => _delegate.setNewRoutePath(path);

  Future<void> toHome() => to(AppRoutePath.home());
  Future<void> toSettings() => to(AppRoutePath.settings());
  Future<void> toTopics() => to(AppRoutePath.topics());

  Future<void> toPlant([String topic]) =>
      to(AppRoutePath.plant(topic ?? _currentTopic));

  Future<void> toJournal([String topic]) =>
      to(AppRoutePath.journal(topic ?? _currentTopic));

  Future<void> toDetails([String topic]) => to(AppRoutePath.details(
      topic ?? _currentTopic,
      _currentPage == AppPage.plant && _currentTopic == topic));

  Future<void> toScripture(ScriptureReference reference, [String topic]) =>
      to(AppRoutePath.scripture(topic ?? _currentTopic, reference, _fromPlant));

  Future<void> toActivity([String topic]) =>
      to(AppRoutePath.activity(topic ?? _currentTopic));
}

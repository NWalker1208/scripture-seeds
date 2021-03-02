import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'extensions/string.dart';
import 'pages/activity.dart';
import 'pages/dashboard.dart';
import 'pages/journal.dart';
import 'pages/loading.dart';
import 'pages/plant.dart';
import 'pages/scripture.dart';
import 'pages/settings.dart';
import 'pages/topic_details.dart';
import 'pages/topics.dart';
import 'services/scriptures/reference.dart';
import 'services/topics/provider.dart';

enum AppPage {
  home,
  settings,
  topics,
  plant,
  journal,
  details,
  activity,
  scripture
}

@immutable
class AppRoutePath {
  const AppRoutePath.home()
      : page = AppPage.home,
        topic = null,
        fromPlant = false,
        reference = null;
  const AppRoutePath.settings()
      : page = AppPage.settings,
        topic = null,
        fromPlant = false,
        reference = null;
  const AppRoutePath.topics()
      : page = AppPage.topics,
        topic = null,
        fromPlant = false,
        reference = null;
  const AppRoutePath.plant(this.topic)
      : page = AppPage.plant,
        fromPlant = false,
        reference = null;
  const AppRoutePath.journal([this.topic])
      : page = AppPage.journal,
        fromPlant = topic != null,
        reference = null;
  const AppRoutePath.details(this.topic, [this.fromPlant = false])
      : page = AppPage.details,
        reference = null;
  const AppRoutePath.activity(this.topic)
      : page = AppPage.activity,
        fromPlant = true,
        reference = null;
  const AppRoutePath.scripture(this.topic, this.reference,
      [this.fromPlant = false])
      : page = AppPage.scripture;

  factory AppRoutePath.parse(String location) {
    // TODO: Implement parsing
    final url = Uri.parse(location);
    final page = url.pathSegments;

    if (page.isEmpty) return AppRoutePath.home();
    if (page.first == 'settings') return AppRoutePath.settings();

    try {
      if (page.first == 'topics') {
        // Topic pages
        if (page.length == 1) return AppRoutePath.topics();
        final topic = page[1];
        if (page.length == 2) return AppRoutePath.details(topic);
        final reference = ScriptureReference.parse(url.queryParameters['ref']);
        return AppRoutePath.scripture(topic, reference);
      } else {
        // Other pages
        final topic = url.queryParameters['topic'];
        switch (page.first) {
          case 'plant':
            return AppRoutePath.plant(topic);
          case 'journal':
            return AppRoutePath.journal(topic);
          case 'activity':
            return AppRoutePath.activity(topic);
        }
      }
    } on Exception catch (e) {
      print('Failed to parse path "$location": $e');
    }
    return AppRoutePath.home();
  }

  final AppPage page;
  final String topic;
  final bool fromPlant;
  final ScriptureReference reference;

  String get location {
    var str = '/';
    if (page == AppPage.home) return str;
    if (page == AppPage.details) {
      str += 'topics/$topic';
    } else if (page == AppPage.scripture) {
      str += 'topics/$topic/scripture/?ref=$reference';
    } else {
      str += StringExtension.fromEnum(page);
      if (topic != null) {
        str += '?topic=$topic';
      }
    }
    return str;
  }
}

class AppRouteInformationParser extends RouteInformationParser<AppRoutePath> {
  const AppRouteInformationParser();

  @override
  Future<AppRoutePath> parseRouteInformation(
          RouteInformation information) async =>
      AppRoutePath.parse(information.location);

  @override
  RouteInformation restoreRouteInformation(AppRoutePath route) =>
      RouteInformation(location: route.location);
}

class AppRouterDelegate extends RouterDelegate<AppRoutePath>
    with PopNavigatorRouterDelegateMixin<AppRoutePath>, ChangeNotifier {
  @override
  final navigatorKey = GlobalKey<NavigatorState>();

  AppRoutePath _configuration = AppRoutePath.home();

  AppPage get _page => _configuration.page;
  String get _topicId => _configuration.topic;
  bool get _fromPlant => _configuration.fromPlant;

  @override
  AppRoutePath get currentConfiguration => _configuration;

  @override
  Future<void> setNewRoutePath(AppRoutePath configuration) async {
    _configuration = configuration;
    notifyListeners();
  }

  @override
  Widget build(BuildContext context) {
    final topics = Provider.of<TopicIndexProvider>(context);
    final topic =
        (_topicId != null && topics.isLoaded) ? topics.index[_topicId] : null;
    return Navigator(
      key: navigatorKey,
      pages: [
        const MaterialPage<void>(child: DashboardPage()),
        if (_page == AppPage.settings)
          const MaterialPage<void>(
            key: ValueKey('settings'),
            child: SettingsPage(),
          ),
        if (_page == AppPage.topics)
          const MaterialPage<void>(
            key: ValueKey('topics'),
            child: TopicsPage(),
          ),
        if (_fromPlant || _page == AppPage.plant)
          MaterialPage<void>(
            key: ValueKey('$_topicId-plant'),
            child: topic == null ? LoadingPage() : PlantPage(topic),
          ),
        if (_page == AppPage.journal)
          MaterialPage<void>(
            key: ValueKey('journal'),
            child: JournalPage(defaultFilter: _topicId),
          ),
        if (_page == AppPage.details || _page == AppPage.scripture)
          MaterialPage<void>(
            key: ValueKey('$_topicId-details'),
            child: topic == null ? LoadingPage() : TopicDetailsPage(topic),
          ),
        if (_page == AppPage.scripture)
          MaterialPage<void>(
            key: ValueKey(_configuration.reference),
            child: ScripturePage(_configuration.reference),
          ),
        if (_page == AppPage.activity)
          MaterialPage<void>(
            key: ValueKey('$_topicId-activity'),
            child: topic == null ? LoadingPage() : ActivityPage(topic),
          ),
      ],
      onPopPage: (route, dynamic result) {
        if (!route.didPop(result)) return false;
        if (_page == AppPage.home) return false;

        if (_page == AppPage.scripture) {
          _configuration = AppRoutePath.details(_topicId, _fromPlant);
        } else if (_fromPlant) {
          _configuration = AppRoutePath.plant(_topicId);
        } else {
          _configuration = AppRoutePath.home();
        }
        notifyListeners();
        return true;
      },
    );
  }
}

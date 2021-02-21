import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'pages/activity.dart';
import 'pages/dashboard.dart';
import 'pages/journal.dart';
import 'pages/plant.dart';
import 'pages/scripture.dart';
import 'pages/settings.dart';
import 'pages/topic_details.dart';
import 'pages/topics.dart';
import 'services/scriptures/reference.dart';
import 'services/theme/provider.dart';
import 'services/topics/provider.dart';
import 'services/tutorial/observer.dart';

class SeedsApp extends StatelessWidget {
  const SeedsApp({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Consumer<ThemeProvider>(
        builder: (context, theme, child) => MaterialApp(
          title: 'Scripture Seeds',
          theme: theme.light,
          darkTheme: theme.dark,
          themeMode: theme.mode,
          navigatorObservers: [TutorialObserver()],
          initialRoute: '/',
          routes: {
            '/': (context) => const DashboardPage(),
            '/settings': (context) => const SettingsPage(),
            '/topics': (context) => const TopicsPage(),
            '/topics/details': (context) => TopicDetailsPage(
                  Provider.of<TopicIndexProvider>(context).index[
                      ModalRoute.of(context).settings.arguments as String],
                ),
            '/scripture': (context) => ScripturePage(ScriptureReference.parse(
                ModalRoute.of(context).settings.arguments as String)),
            '/plant': (context) => PlantPage(
                  Provider.of<TopicIndexProvider>(context).index[
                      ModalRoute.of(context).settings.arguments as String],
                ),
            '/plant/activity': (context) => ActivityPage(
                  Provider.of<TopicIndexProvider>(context).index[
                      ModalRoute.of(context).settings.arguments as String],
                ),
            '/journal': (context) => JournalPage(
                  defaultFilter:
                      ModalRoute.of(context).settings.arguments as String,
                ),
          },
        ),
      );
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'pages/activity.dart';
import 'pages/dashboard.dart';
import 'pages/journal.dart';
import 'pages/plant.dart';
import 'pages/settings.dart';
import 'pages/topics.dart';
import 'services/settings/theme.dart';
import 'services/themes.dart' as theme;
import 'services/topics/provider.dart';

class SeedsApp extends StatelessWidget {
  const SeedsApp({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Consumer<ThemePreference>(
        builder: (context, setting, child) => MaterialApp(
          title: 'Seeds',
          theme: theme.lightTheme,
          darkTheme: theme.darkTheme,
          themeMode: setting.mode,
          initialRoute: '/',
          routes: {
            '/': (context) => const DashboardPage(),
            '/settings': (context) => const SettingsPage(),
            '/topics': (context) => const TopicsPage(),
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

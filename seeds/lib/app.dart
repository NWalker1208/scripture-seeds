import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seeds/pages/topics.dart';
import 'package:seeds/services/settings/theme.dart';
import 'package:seeds/services/themes.dart';
import 'package:seeds/pages/dashboard.dart';
import 'package:seeds/pages/settings.dart';
import 'package:seeds/pages/plant.dart';
import 'package:seeds/pages/activity.dart';
import 'package:seeds/pages/journal.dart';

class SeedsApp extends StatelessWidget {
  const SeedsApp({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemePreference>(
      builder: (context, setting, child) => MaterialApp(
        title: 'Seeds',

        theme: AppThemes.lightTheme,
        darkTheme: AppThemes.darkTheme,

        themeMode: setting.mode,

        initialRoute: '/',
        routes: {
          '/': (context) => const DashboardPage(),
          '/settings': (context) => const SettingsPage(),
          '/topics': (context) => const TopicsPage(),

          '/plant': (context) => PlantPage(plantName: ModalRoute.of(context).settings.arguments),
          '/plant/activity': (context) => ActivityPage(ModalRoute.of(context).settings.arguments),

          '/journal': (context) => JournalPage(defaultFilter: ModalRoute.of(context).settings.arguments),
        },
      )
  );
  }
}

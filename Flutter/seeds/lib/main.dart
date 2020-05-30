import 'package:flutter/material.dart';
import 'package:seeds/pages/home.dart';
import 'package:seeds/pages/plant.dart';
import 'package:seeds/pages/activity.dart';
import 'package:seeds/pages/settings.dart';
import 'package:seeds/services/theme_mode_setting.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(SeedsApp());
}

class SeedsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ThemeModeSetting>(
      create: (context) => ThemeModeSetting(),

      child: Consumer<ThemeModeSetting>(
        builder: (context, setting, child) =>
          MaterialApp(
            title: 'Seeds',

            theme: ThemeData(
              primarySwatch: Colors.green,
              accentColor: Colors.blue,
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            darkTheme: ThemeData(
              brightness: Brightness.dark,
              primarySwatch: Colors.green,
              accentColor: Colors.blue,
              textSelectionColor: Colors.green[500],
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),

            themeMode: setting.mode,

            initialRoute: '/',
            routes: {
              '/' : (context) => HomePage(),
              '/plant': (context) => PlantPage(ModalRoute.of(context).settings.arguments),
              '/plant/activity': (context) => ActivityPage(),
              '/settings' : (context) => SettingsPage(),
            },
          )
      )
    );
  }
}

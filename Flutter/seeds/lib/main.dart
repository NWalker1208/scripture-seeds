import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:seeds/pages/home.dart';
import 'package:seeds/pages/plant.dart';
import 'package:seeds/pages/activity.dart';
import 'package:seeds/pages/settings.dart';
import 'package:seeds/services/progress_data.dart';
import 'package:seeds/services/theme_preference.dart';
import 'package:seeds/services/themes.dart';
import 'package:provider/provider.dart';

void main() {
  // Make status bar transparent
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  // Start app
  runApp(SeedsApp());
}

class SeedsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // ThemePreference notifier
        ChangeNotifierProvider(create: (context) => ThemePreference()),
        // ThemePreference notifier
        ChangeNotifierProvider(create: (context) => ProgressData())
      ],

      child: Consumer<ThemePreference>(
        builder: (context, setting, child) => MaterialApp(
          title: 'Seeds',

          theme: AppThemes.lightTheme,
          darkTheme: AppThemes.darkTheme,

          themeMode: setting.mode,

          initialRoute: '/',
          routes: {
            '/': (context) => HomePage(),
            '/plant': (context) =>
              PlantPage(ModalRoute
                .of(context)
                .settings
                .arguments),
            '/plant/activity': (context) =>
              ActivityPage(ModalRoute
                .of(context)
                .settings
                .arguments),
            '/settings': (context) => SettingsPage(),
          },
        )
      )
    );
  }
}

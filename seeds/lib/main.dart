import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:seeds/pages/home.dart';
import 'package:seeds/pages/new_library_test.dart';
import 'package:seeds/pages/settings.dart';
import 'package:seeds/pages/plant.dart';
import 'package:seeds/pages/activity.dart';
import 'package:seeds/pages/journal.dart';
import 'package:seeds/services/journal_data.dart';
import 'package:seeds/services/library/library_history.dart';
import 'package:seeds/services/library/library_xml.dart';
import 'package:seeds/services/progress_data.dart';
import 'package:seeds/services/theme_preference.dart';
import 'package:seeds/services/themes.dart';
import 'package:provider/provider.dart';

void main() {
  // Make status bar transparent
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(statusBarColor: Colors.transparent));
  // Start app
  runApp(SeedsApp());
}

class SeedsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Begin loading resources for notifiers
    ThemePreference themePref = ThemePreference();
    ProgressData progress = ProgressData();
    JournalData journal = JournalData();
    Library library = Library(context);
    LibraryHistory history = LibraryHistory();

    return MultiProvider(
      providers: [
        // ThemePreference notifier
        ChangeNotifierProvider.value(value: themePref),
        // ProgressData notifier
        ChangeNotifierProvider.value(value: progress),
        // JournalData notifier
        ChangeNotifierProvider.value(value: journal),
        // Library notifier
        ChangeNotifierProvider.value(value: library),
        // JournalData notifier
        ChangeNotifierProvider.value(value: history),
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
            '/settings': (context) => SettingsPage(),

            '/plant': (context) {
              String plantName = ModalRoute.of(context).settings.arguments;
              return PlantPage(
                  plantName: plantName,
                  initialProgress: Provider.of<ProgressData>(context, listen: false).getProgressRecord(plantName).progress,
              );
            },

            '/plant/activity': (context) => ActivityPage(ModalRoute.of(context).settings.arguments),

            '/journal': (context) => JournalPage(),

            '/libtest': (context) => NewLibTest(),
          },
        )
      )
    );
  }
}

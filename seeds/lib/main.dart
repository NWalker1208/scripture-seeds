import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:seeds/pages/dashboard.dart';
import 'package:seeds/pages/settings.dart';
import 'package:seeds/pages/plant.dart';
import 'package:seeds/pages/activity.dart';
import 'package:seeds/pages/journal.dart';
import 'package:seeds/services/help_settings.dart';
import 'package:seeds/services/journal_data.dart';
import 'package:seeds/services/library/file_manager.dart';
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
    HelpSettings helpSettings = HelpSettings();
    ProgressData progress = ProgressData();
    JournalData journal = JournalData();

    Library library = Library();
    LibraryHistory history = LibraryHistory();

    LibraryFileManager(library, assets: DefaultAssetBundle.of(context)).initializeLibrary();

    return MultiProvider(
      providers: [
        // ThemePreference notifier
        ChangeNotifierProvider.value(value: themePref),
        // InstructionsSettings notifier
        ChangeNotifierProvider.value(value: helpSettings),
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
            '/': (context) => DashboardPage(),
            '/settings': (context) => SettingsPage(),

            '/plant': (context) {
              String plantName = ModalRoute.of(context).settings.arguments;
              return PlantPage(
                  plantName: plantName,
                  initialProgress: Provider.of<ProgressData>(context, listen: false).getProgressRecord(plantName).progress,
              );
            },

            '/plant/activity': (context) => ActivityPage(ModalRoute.of(context).settings.arguments),

            '/journal': (context) {
              String plantName = ModalRoute.of(context).settings.arguments;
              return JournalPage(defaultFilter: plantName);
            },
          },
        )
      )
    );
  }
}

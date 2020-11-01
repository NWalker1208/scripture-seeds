import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:seeds/services/settings/help.dart';
import 'package:seeds/services/data/journal.dart';
import 'package:seeds/services/data/progress.dart';
import 'package:seeds/services/settings/theme.dart';
import 'package:seeds/services/data/wallet.dart';
import 'package:seeds/services/library/manager.dart';
import 'package:seeds/services/library/history.dart';
import 'package:seeds/services/settings/library_filter.dart';
import 'package:seeds/app.dart';

void main() {
  // Needed to prevent errors while loading data
  WidgetsFlutterBinding.ensureInitialized();

  // Make status bar transparent
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(statusBarColor: Colors.transparent));

  // Load data
  ThemePreference themePref = ThemePreference();
  HelpSettings helpSettings = HelpSettings();
  ProgressData progress = ProgressData();
  WalletData wallet = WalletData();
  JournalData journal = JournalData();

  // Load library
  LibraryManager library = LibraryManager(assets: rootBundle);
  LibraryFilter libraryFilter = LibraryFilter();
  LibraryHistory history = LibraryHistory();

  // Start app
  runApp(
    MultiProvider(
      providers: [
        // ThemePreference notifier
        ChangeNotifierProvider.value(value: themePref),
        // InstructionsSettings notifier
        ChangeNotifierProvider.value(value: helpSettings),
        // ProgressData notifier
        ChangeNotifierProvider.value(value: progress),
        // WalletData notifier
        ChangeNotifierProvider.value(value: wallet),
        // JournalData notifier
        ChangeNotifierProvider.value(value: journal),

        // Library notifier
        ChangeNotifierProvider.value(value: library),
        // LibraryFilter notifier
        ChangeNotifierProvider.value(value: libraryFilter),
        // JournalData notifier
        ChangeNotifierProvider.value(value: history),
      ],

      child: const SeedsApp(),
    )
  );
}

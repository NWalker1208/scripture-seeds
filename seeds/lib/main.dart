import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'services/data/journal.dart';
import 'services/data/progress.dart';
import 'services/data/wallet.dart';
import 'services/library/history.dart';
import 'services/library/manager.dart';
import 'services/scriptures/pd_scriptures.dart';
import 'services/scriptures/provider.dart';
import 'services/settings/help.dart';
import 'services/settings/library_filter.dart';
import 'services/settings/theme.dart';
import 'services/topics/provider.dart';

void main() {
  // Needed to prevent errors while loading data
  WidgetsFlutterBinding.ensureInitialized();

  // Make status bar transparent
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.light.copyWith(statusBarColor: Colors.transparent));

  // Start app
  runApp(MultiProvider(
    providers: [
      // ThemePreference notifier
      ChangeNotifierProvider(create: (_) => ThemePreference(), lazy: false),
      ChangeNotifierProvider(create: (_) => HelpSettings(), lazy: false),

      ChangeNotifierProvider(create: (_) => ProgressData()),
      ChangeNotifierProvider(create: (_) => WalletData()),
      ChangeNotifierProvider(create: (_) => JournalData()),

      ChangeNotifierProvider(create: (_) => LibraryManager()),
      ChangeNotifierProvider(create: (_) => LibraryFilter()),
      ChangeNotifierProvider(create: (_) => LibraryHistory()),

      ChangeNotifierProvider(create: (_) => TopicIndexProvider(), lazy: false),
      ChangeNotifierProvider(
        create: (_) => ScriptureProvider(PublicDomainScriptures()),
        lazy: false,
      ),
    ],
    child: const SeedsApp(),
  ));
}

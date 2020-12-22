import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'services/data/journal.dart';
import 'services/data/progress.dart';
import 'services/data/wallet.dart';
import 'services/scriptures/database.dart';
import 'services/scriptures/pd_scriptures.dart';
import 'services/settings/help.dart';
import 'services/settings/study_filter.dart';
import 'services/settings/theme.dart';
import 'services/study/history.dart';
import 'services/study/provider.dart';
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
      // Settings
      ChangeNotifierProvider(create: (_) => ThemePreference(), lazy: false),
      ChangeNotifierProvider(create: (_) => StudyFilter(), lazy: false),
      ChangeNotifierProvider(create: (_) => HelpSettings(), lazy: false),

      // Scriptures and Topics
      Provider<ScriptureDatabase>(create: (_) => PublicDomainScriptures()),
      ChangeNotifierProvider(create: (_) => TopicIndexProvider()),

      // Study
      ChangeNotifierProvider(create: (_) => StudyHistory(), lazy: false),
      ProxyProvider4<ScriptureDatabase, TopicIndexProvider, StudyFilter,
              StudyHistory, StudyLibraryProvider>(
          update: (context, scriptures, topics, filter, history, _) =>
              StudyLibraryProvider(
                  scriptures: scriptures,
                  topics: topics,
                  filter: filter,
                  history: history)),

      // User data
      ChangeNotifierProvider(create: (_) => ProgressData()),
      ChangeNotifierProvider(create: (_) => WalletData()),
      ChangeNotifierProvider(create: (_) => JournalData()),
    ],
    child: const SeedsApp(),
  ));
}

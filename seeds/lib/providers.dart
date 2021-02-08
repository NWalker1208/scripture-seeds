import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'services/history/hive.dart';
import 'services/history/provider.dart';
import 'services/journal/hive.dart';
import 'services/journal/provider.dart';
import 'services/progress/hive.dart';
import 'services/progress/provider.dart';
import 'services/proxies/study_library.dart';
import 'services/scriptures/json.dart';
import 'services/scriptures/provider.dart';
import 'services/settings/study_filter.dart';
import 'services/theme/provider.dart';
import 'services/topics/provider.dart';
import 'services/tutorial/provider.dart';
import 'services/tutorial/shared_prefs.dart';
import 'services/wallet/provider.dart';
import 'services/wallet/shared_prefs.dart';

class AppProviders extends StatefulWidget {
  final Widget app;

  const AppProviders(this.app, {Key key}) : super(key: key);

  @override
  _AppProvidersState createState() => _AppProvidersState();
}

class _AppProvidersState extends State<AppProviders> {
  ThemeProvider themeProvider;

  @override
  void initState() {
    themeProvider = ThemeProvider();
    super.initState();
  }

  @override
  void dispose() {
    themeProvider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    themeProvider.refresh();
    return MultiProvider(
      providers: [
        // Settings
        ChangeNotifierProvider.value(value: themeProvider),
        ChangeNotifierProvider(create: (_) => StudyFilter(), lazy: false),
        ChangeNotifierProvider(
          create: (_) => TutorialProvider(SharedPrefsTutorialDatabase()),
          lazy: false,
        ),

        // Scriptures and Topics
        ChangeNotifierProvider(
          create: (_) => ScriptureProvider(JsonScriptureDatabase()),
          lazy: false,
        ),
        ChangeNotifierProvider(create: (_) => TopicIndexProvider()),

        // Study
        ChangeNotifierProvider(
          create: (_) => HistoryProvider(HiveHistoryDatabase()),
          lazy: false,
        ),
        ProxyProvider4<ScriptureProvider, TopicIndexProvider, StudyFilter,
            HistoryProvider, StudyLibraryProxy>(
          update: (context, scriptures, topics, filter, history, _) =>
              StudyLibraryProxy(
            scriptures: scriptures,
            topics: topics,
            filter: filter,
            history: history,
          ),
        ),

        // User data
        ChangeNotifierProvider(
          create: (_) => ProgressProvider(HiveProgressDatabase()),
          lazy: false,
        ),
        ChangeNotifierProvider(
            create: (_) => WalletProvider(SharedPrefsWalletService())),
        ChangeNotifierProvider(
            create: (_) => JournalProvider(HiveJournalDatabase())),
      ],
      child: widget.app,
    );
  }
}

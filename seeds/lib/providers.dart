import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'services/data/wallet.dart';
import 'services/history/provider.dart';
import 'services/history/sql.dart';
import 'services/journal/json.dart';
import 'services/journal/provider.dart';
import 'services/progress/provider.dart';
import 'services/progress/sql.dart';
import 'services/scriptures/database.dart';
import 'services/scriptures/pd_scriptures.dart';
import 'services/settings/help.dart';
import 'services/settings/study_filter.dart';
import 'services/study/provider.dart';
import 'services/theme/provider.dart';
import 'services/topics/provider.dart';

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
        ChangeNotifierProvider(create: (_) => HelpSettings(), lazy: false),

        // Scriptures and Topics
        Provider<ScriptureDatabase>(create: (_) => PublicDomainScriptures()),
        ChangeNotifierProvider(create: (_) => TopicIndexProvider()),

        // Study
        ChangeNotifierProvider(
          create: (_) => StudyHistory(SqlHistoryDatabase()),
          lazy: false,
        ),
        ProxyProvider4<ScriptureDatabase, TopicIndexProvider, StudyFilter,
            StudyHistory, StudyLibraryProvider>(
          update: (context, scriptures, topics, filter, history, _) =>
              StudyLibraryProvider(
            scriptures: scriptures,
            topics: topics,
            filter: filter,
            history: history,
          ),
        ),

        // User data
        ChangeNotifierProvider(
          create: (_) => ProgressProvider(SqlProgressDatabase()),
          lazy: false,
        ),
        ChangeNotifierProvider(create: (_) => WalletData()),
        ChangeNotifierProvider(
            create: (_) => JournalProvider(JsonJournalDatabase())),
      ],
      child: widget.app,
    );
  }
}

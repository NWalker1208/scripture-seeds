import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seeds/services/notifications/reminders.dart';

import 'services/history/hive.dart';
import 'services/history/provider.dart';
import 'services/history/sql.dart';
import 'services/journal/hive.dart';
import 'services/journal/json.dart';
import 'services/journal/provider.dart';
import 'services/notifications/service.dart';
import 'services/progress/hive.dart';
import 'services/progress/provider.dart';
import 'services/progress/sql.dart';
import 'services/proxies/study_library.dart';
import 'services/scriptures/database.dart';
import 'services/scriptures/json.dart';
import 'services/settings/filter.dart';
import 'services/theme/provider.dart';
import 'services/topics/provider.dart';
import 'services/tutorial/provider.dart';
import 'services/tutorial/shared_prefs.dart';
import 'services/wallet/provider.dart';
import 'services/wallet/shared_prefs.dart';

class AppProviders extends StatefulWidget {
  final Widget app;

  const AppProviders(this.app, {Key key}) : super(key: key);

  static AppProvidersState of(BuildContext context) =>
      context.findAncestorStateOfType<AppProvidersState>();

  @override
  AppProvidersState createState() => AppProvidersState();
}

class AppProvidersState extends State<AppProviders> {
  // App Data
  ScriptureDatabase scriptures = JsonScriptureDatabase();
  final topicIndex = TopicIndexProvider();

  // Settings
  final themes = ThemeProvider();
  final filters = FilterProvider();

  // User Data
  final tutorial = TutorialProvider(() => SharedPrefsTutorialDatabase());
  final wallet = WalletProvider(() => SharedPrefsWalletService());
  final progress = ProgressProvider(() => HiveProgressDatabase());
  final journal = JournalProvider(() => HiveJournalDatabase());
  final history = HistoryProvider(() => HiveHistoryDatabase());

  // Other
  final notifications = NotificationService();

  /// Refreshes all user data services.
  Future<void> refreshAll() async {
    await tutorial.refresh();
    await wallet.refresh();
    await progress.refresh();
    await journal.refresh();
    await history.refresh();
  }

  /// Upgrade data from old databases to the new systems.
  Future<void> attemptUpgrade() async {
    if (!kIsWeb) {
      await progress.modify((data) => SqlProgressDatabase().upgrade(data));
      await journal.modify((data) => JsonJournalDatabase().upgrade(data));
      await history.modify((data) => SqlHistoryDatabase().upgrade(data));
    }
  }

  /// Attempts upgrade of old data during setup
  @override
  void initState() {
    attemptUpgrade();
    super.initState();
  }

  /// Disposes of all providers.
  @override
  void dispose() {
    scriptures.close();
    themes.dispose();
    filters.dispose();
    topicIndex.dispose();
    tutorial.dispose();
    wallet.dispose();
    progress.dispose();
    journal.dispose();
    history.dispose();
    notifications.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // If debugging, refresh themes on rebuild
    assert(() {
      themes.refresh();
      return true;
    }());

    return MultiProvider(
      providers: [
        // Providers
        Provider.value(value: scriptures),
        ChangeNotifierProvider.value(value: topicIndex),
        ChangeNotifierProvider.value(value: themes),
        ChangeNotifierProvider.value(value: filters),
        ChangeNotifierProvider.value(value: tutorial),
        ChangeNotifierProvider.value(value: wallet),
        ChangeNotifierProvider.value(value: progress),
        ChangeNotifierProvider.value(value: journal),
        ChangeNotifierProvider.value(value: history),
        Provider.value(value: notifications),
        // Proxy
        ProxyProvider0<StudyLibraryProxy>(
          update: (context, _) => StudyLibraryProxy.fromContext(context),
        ),
        ProxyProvider0<RemindersProxy>(
          lazy: false,
          update: (context, old) => RemindersProxy.fromContext(context),
        ),
      ],
      child: widget.app,
    );
  }
}

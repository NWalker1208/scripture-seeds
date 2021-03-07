import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/tutorial/provider.dart';
import '../utility/go.dart';
import '../widgets/dialogs/about.dart';
import '../widgets/settings/data_management.dart';
import '../widgets/settings/library_filter.dart';
import '../widgets/settings/library_refresh.dart';
import '../widgets/settings/sign_in.dart';
import '../widgets/settings/theme_selector.dart';
import 'test.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text('Settings')),
        body: ListView(
          children: <Widget>[
            const GoogleSignInTile(),
            const ThemeSelectorTile(),
            const Divider(),
            const LibraryFilterSettings(),
            const Divider(),
            if (!kIsWeb) const LibraryRefreshTile(),
            const Divider(),
            const TutorialTile(),
            const DataManagementSettings(),
            const Divider(),
            const AboutTile(),
            if (!kReleaseMode) const DebugPageTile(),
          ],
        ),
      );
}

class TutorialTile extends StatelessWidget {
  const TutorialTile({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) => ListTile(
        leading: const Icon(Icons.help_outline),
        title: const Text('Restart Tutorial'),
        onTap: () {
          Go.from(context).toHome();
          Provider.of<TutorialProvider>(context, listen: false).reset();
        },
      );
}

class AboutTile extends StatelessWidget {
  const AboutTile({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) => ListTile(
        leading: const Icon(Icons.info_outline),
        title: const Text('About Scripture Seeds'),
        onTap: () => showDialog<void>(
          context: context,
          builder: (context) => CustomAboutDialog(),
        ),
      );
}

class DebugPageTile extends StatelessWidget {
  const DebugPageTile({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) => ListTile(
        tileColor: Colors.yellow,
        title: Text('Debug Page'),
        onTap: () => Navigator.of(context)
            .push(MaterialPageRoute<void>(builder: (context) => TestPage())),
      );
}

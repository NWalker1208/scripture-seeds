import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../widgets/dialogs/about.dart';
import '../widgets/settings/data_management.dart';
import '../widgets/settings/library_filter.dart';
import '../widgets/settings/library_refresh.dart';
import '../widgets/settings/theme_selector.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text('Settings')),
        body: ListView(
          children: <Widget>[
            const ThemeSelector(),
            const Divider(),
            const LibraryFilterSettings(),
            const Divider(),
            if (!kIsWeb) const LibraryRefreshTile(),
            const DataManagementSettings(),
            const AboutTile(),
          ],
        ),
      );
}

class AboutTile extends StatelessWidget {
  const AboutTile({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) => ListTile(
        title: const Text(
          'About Scripture Seeds',
          textAlign: TextAlign.center,
        ),
        onTap: () => showDialog<void>(
          context: context,
          builder: (context) => CustomAboutDialog(),
        ),
      );
}

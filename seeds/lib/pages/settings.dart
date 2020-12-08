import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';

import '../services/custom_icons.dart';
import '../widgets/settings/data_management.dart';
import '../widgets/settings/library_filter.dart';
import '../widgets/settings/library_refresh.dart';
import '../widgets/settings/theme_selector.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({
    Key key,
  }) : super(key: key);

  void _aboutHandler(BuildContext context) {
    PackageInfo.fromPlatform().then((info) => showAboutDialog(
          context: context,
          applicationName: 'Scripture Seeds',
          applicationIcon: const Icon(CustomIcons.seeds, size: 40),
          applicationVersion: info.version,
          children: [const Text('App developed by Nathan Walker.')],
        ));
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text('Settings')),
        body: ListView(
          children: <Widget>[
            const ThemeSelector(),
            const Divider(),
            const LibraryFilterSettings(),
            const Divider(),
            const LibraryRefreshTile(),
            const DataManagementSettings(),
            const Divider(),
            ListTile(
              title: const Text('About Scripture Seeds',
                  textAlign: TextAlign.center),
              onTap: () => _aboutHandler(context),
            )
          ],
        ),
      );
}

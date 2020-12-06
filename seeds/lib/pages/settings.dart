import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:seeds/widgets/settings/data_management.dart';
import 'package:seeds/widgets/settings/library_filter.dart';
import 'package:seeds/widgets/settings/theme_selector.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({
    Key key,
  }) : super(key: key);

  void _aboutHandler(BuildContext context) {
    PackageInfo.fromPlatform().then((info) => showAboutDialog(
      context: context,
      applicationName: 'Scripture Seeds',
      applicationIcon: const ImageIcon(AssetImage('assets/seeds_icon.ico'), size: 40),
      applicationVersion: info.version,
      children: [
        const Text('App developed by Nathan Walker.')
      ]
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings')
      ),

      body: ListView(
        children: <Widget>[
          const ThemeSelector(),
          const Divider(),
          const LibraryFilterSettings(),
          const Divider(),
          const DataManagementSettings(),
          const Divider(),
          ListTile(
            title: const Text('About Scripture Seeds', textAlign: TextAlign.center),
            onTap: () => _aboutHandler(context),
          )
        ],
      ),
    );
  }
}

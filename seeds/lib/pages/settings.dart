import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:seeds/widgets/settings/data_management.dart';
import 'package:seeds/widgets/settings/library_filter.dart';
import 'package:seeds/widgets/settings/theme_selector.dart';

class SettingsPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings')
      ),

      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ThemeSelector()
          ),

          Divider(),

          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: LibraryFilterSettings()
          ),

          Divider(),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: DataManagementSettings()
          ),

          Divider(),

          ListTile(
            title: Text('About Scripture Seeds', textAlign: TextAlign.center),
            onTap: () => PackageInfo.fromPlatform().then((info) => showAboutDialog(
              context: context,
              applicationName: 'Scripture Seeds',
              applicationIcon: ImageIcon(AssetImage('assets/seeds_icon.ico'), size: 40),
              applicationVersion: info.version,
              children: [
                Text('App developed by Nathan Walker.')
              ]
            ))
          )
        ],
      ),
    );
  }
}

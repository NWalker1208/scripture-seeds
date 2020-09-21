import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';
import 'package:seeds/services/library/file_manager.dart';
import 'package:seeds/services/library/library_xml.dart';
import 'package:seeds/widgets/dialogs/erase_journal.dart';
import 'package:seeds/widgets/dialogs/reset_progress.dart';
import 'package:seeds/widgets/theme_mode_selector.dart';

class SettingsPage extends StatelessWidget {

  void resetLibraryCache(BuildContext context) {
    LibraryFileManager libManager = LibraryFileManager(
      Provider.of<Library>(context, listen: false),
      assets: DefaultAssetBundle.of(context)
    );

    libManager.refreshLibrary().then(
      (_) => Scaffold.of(context).showSnackBar(SnackBar(
        content: Text('Library sync complete.'),
      ))
    );
  }

  void eraseJournal(BuildContext context) {
    showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (_) => EraseJournalDialog()
    ).then((bool erased) {
      if (erased ?? false)
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text('Your journal has been erased.'),
        ));
    });
  }

  void resetProgress(BuildContext context) {
    showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (_) => ResetProgressDialog()
    ).then((bool didReset) {
      if (didReset ?? false)
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text('Your progress has been reset.'),
        ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings')
      ),

      body: Builder(
        builder: (scaffoldContext) => ListView(
          children: <Widget>[
            // Theme Dropdown
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Theme', style: Theme.of(context).textTheme.subtitle1),
                  SizedBox(width: 16),
                  ThemeModeSelector()
                ],
              ),
            ),

            Divider(),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  RaisedButton(
                    child: Text('Sync Library'),
                    onPressed: () => resetLibraryCache(scaffoldContext),
                    textColor: Colors.white
                  ),

                  // Reset Progress Button
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: RaisedButton(
                          child: Text('Erase Journal'),
                          onPressed: () => eraseJournal(scaffoldContext),
                          textColor: Colors.white,
                          color: Theme.of(context).errorColor
                        ),
                      ),
                      SizedBox(width: 12.0),
                      Expanded(
                        child: RaisedButton(
                          child: Text('Reset Progress'),
                          onPressed: () => resetProgress(scaffoldContext),
                          textColor: Colors.white,
                          color: Theme.of(context).errorColor
                        ),
                      ),
                    ],
                  ),
                ],
              ),
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
      )
    );
  }
}

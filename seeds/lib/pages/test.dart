import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/proxies/google_drive.dart';

/// Debug-only test page for testing new features.
class TestPage extends StatefulWidget {
  const TestPage({Key key}) : super(key: key);

  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text('Test Page')),
        body: ListView(
          children: [
            ListTile(
              onTap: () => googleDriveUpload(context),
              title: Text('Upload Google Drive Test'),
            ),
            ListTile(
              onTap: () async {
                final result = await googleDriveDownload(context);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(result ?? 'Download failed.'),
                ));
              },
              title: Text('Download Google Drive Test'),
            ),
            ListTile(
              onTap: () async {
                final result = await googleDriveList(context);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(result ?? 'Download failed.'),
                ));
              },
              title: Text('List Google Drive Files'),
            ),
          ],
        ),
      );
}

void googleDriveUpload(BuildContext context) {
  final googleDrive = Provider.of<GoogleDriveProxy>(context, listen: false);
  if (!googleDrive.authenticated) return;
  googleDrive.uploadFile('test_folder/sub/sub2/test.txt', 'Hello World');
}

Future<String> googleDriveDownload(BuildContext context) async {
  final googleDrive = Provider.of<GoogleDriveProxy>(context, listen: false);
  if (!googleDrive.authenticated) return null;
  return await googleDrive.downloadFile('test.txt');
}

Future<String> googleDriveList(BuildContext context) async {
  final googleDrive = Provider.of<GoogleDriveProxy>(context, listen: false);
  if (!googleDrive.authenticated) return null;
  return (await googleDrive.listFiles()).toString();
}

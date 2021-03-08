import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/firebase/drive/proxy.dart';

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
              title: Text('Upload to Google Drive'),
            ),
            ListTile(
              onTap: () => googleDriveDelete(context),
              title: Text('Delete from Google Drive'),
            ),
            ListTile(
              onTap: () async {
                final result = await googleDriveDownload(context);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(result ?? 'Download failed.'),
                ));
              },
              title: Text('Download from Google Drive'),
            ),
            ListTile(
              onTap: () async {
                final result = await googleDriveList(context);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(result ?? 'Download failed.'),
                ));
              },
              title: Text('List files in Google Drive'),
            ),
          ],
        ),
      );
}

void googleDriveUpload(BuildContext context) {
  final googleDrive = Provider.of<DriveProxy>(context, listen: false);
  if (!googleDrive.authenticated) return;
  googleDrive.uploadFile('test.txt', 'Hello World');
}

void googleDriveDelete(BuildContext context) {
  final googleDrive = Provider.of<DriveProxy>(context, listen: false);
  if (!googleDrive.authenticated) return;
  googleDrive.delete('test.txt');
  googleDrive.delete('test_folder');
}

Future<String> googleDriveDownload(BuildContext context) async {
  final googleDrive = Provider.of<DriveProxy>(context, listen: false);
  if (!googleDrive.authenticated) return null;
  return await googleDrive.downloadFile('test.txt');
}

Future<String> googleDriveList(BuildContext context) async {
  final googleDrive = Provider.of<DriveProxy>(context, listen: false);
  if (!googleDrive.authenticated) return null;
  return (await googleDrive.listFiles()).toString();
}

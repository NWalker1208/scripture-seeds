import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/cloud/provider.dart';

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
              title: Consumer<CloudProvider>(
                builder: (context, cloud, child) =>
                    Text('Last sync: ${cloud.lastSync ?? 'Never'}'),
              ),
            ),
            ListTile(
              onTap: () => googleDriveUpload(context),
              title: Text('Start sync'),
            ),
          ],
        ),
      );
}

void googleDriveUpload(BuildContext context) {
  final cloud = Provider.of<CloudProvider>(context, listen: false);
  cloud.sync(context);
}

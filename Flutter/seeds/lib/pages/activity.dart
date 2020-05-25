import 'package:flutter/material.dart';
import 'package:seeds/widgets/highlight_text.dart';
import 'package:seeds/services/library.dart';
import 'package:seeds/services/scripture.dart';
import 'package:seeds/services/database_manager.dart';

class ActivityPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    String topic = ModalRoute.of(context).settings.arguments as String;
    List<Scripture> verses = Library.topics[topic].first;

    return Scaffold(
      appBar: AppBar(
        title: Text('Daily Activity'),
      ),

      body: Padding(
        padding: EdgeInsets.all(40.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Instructions
              Text('Study the following scripture and highlight the parts that stand out to you.'),
              SizedBox(height: 30),

              // Scripture reference
              Text(verses[0].toString(), style: Theme.of(context).textTheme.headline5),
              SizedBox(height: 15),

              // Scripture quote
              HighlightText(verses[0].text)
            ],
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.check),
        onPressed: () async {
          DatabaseManager db = await DatabaseManager.getDatabase();

          if (db.isOpen) {
            await db.updateProgress(topic);
            await db.close();
            Navigator.pop(context, true);
          }
          else
            print('Unable to save progress!');
        },
      ),
    );
  }
}

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:seeds/widgets/highlight_text.dart';
import 'package:seeds/services/library.dart';
import 'package:seeds/services/scripture.dart';
import 'package:seeds/services/database_manager.dart';

class ActivityPage extends StatelessWidget {
  final seed;

  ActivityPage({Key key}) :
    seed = DateTime.now().millisecondsSinceEpoch,
    super(key: key);

  @override
  Widget build(BuildContext context) {
    Random generator = Random(seed);

    String topic = ModalRoute.of(context).settings.arguments as String;
    int todayScripture = generator.nextInt(Library.topics[topic].length);
    List<Scripture> verses = Library.topics[topic][todayScripture];

    return Scaffold(
      appBar: AppBar(
        title: Text('Daily Activity'),
      ),

      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(40.0, 40.0, 40.0, 80.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                // Instructions
                Text('Study the following scripture and highlight the parts that are most important to you.',
                  style: Theme.of(context).textTheme.bodyText1,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                Text('Tap a word to highlight it.\nTap and hold to highlight a block of text.',
                  style: Theme.of(context).textTheme.bodyText2,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 30),

                // Chapter title
                Text(
                  verses[0].reference(showVerse: false),
                  style: Theme.of(context).textTheme.headline4.merge(TextStyle(fontFamily: 'Buenard')),
                  textAlign: TextAlign.center,
                ),

              ] + verses.map((scripture) {
                return Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: HighlightText('${scripture.verse}. ${scripture.text}', disabledWords: 1),
                );
              }).toList()
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.check),
        onPressed: () {
          if (DatabaseManager.isLoaded) {
            DatabaseManager.updateProgress(topic);
            DatabaseManager.saveData();
            Navigator.pop(context, true);
          }
          else
            print('Unable to save progress!');
        },
      ),
    );
  }
}

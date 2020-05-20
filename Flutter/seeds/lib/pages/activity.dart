import 'package:flutter/material.dart';
import 'package:seeds/services/scripture.dart';
import 'package:seeds/services/selectable_word.dart';

class ActivityPage extends StatelessWidget {

  final Scripture scripture = Scripture(
    book: 'Moroni', chapter: 10, verse: 5,
    text: 'And by the power of the Holy Ghost ye may know the truth of all things.'
  );

  List<Widget> createParagraph(BuildContext context, String str)
  {
    List<Widget> text = str.split(' ').map((word) => SelectableWord(word: word)).toList();

    return text;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daily Activity'),
      ),

      body: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Instructions
              Text('Study the following scripture and highlight the parts that stand out to you.'),
              SizedBox(height: 30),

              // Scripture reference
              Text(scripture.toString(), style: Theme.of(context).textTheme.headline5),
              SizedBox(height: 15),

              // Scripture quote
              Wrap(
                direction: Axis.horizontal,
                alignment: WrapAlignment.start,
                children: createParagraph(context, scripture.text)
              ),
            ],
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.check),
        onPressed: () {
          Navigator.pop(context, true);
        },
      ),
    );
  }
}

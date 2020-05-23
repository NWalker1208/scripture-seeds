import 'package:flutter/material.dart';
import 'package:seeds/services/highlight_text.dart';
import 'package:seeds/services/scripture.dart';

class ActivityPage extends StatelessWidget {

  final Scripture scripture = Scripture(
    book: 'Esther', chapter: 8, verse: 9,
    text: "Then were the king’s scribes called at that time in the third month, that is, the month Sivan, on the three and twentieth day thereof; and it was written according to all that Mordecai commanded unto the Jews, and to the lieutenants, and the deputies and rulers of the provinces which are from India unto Ethiopia, an hundred twenty and seven provinces, unto every province according to the writing thereof, and unto every people after their language, and to the Jews according to their writing, and according to their language."
  );

  @override
  Widget build(BuildContext context) {
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
              Text(scripture.toString(), style: Theme.of(context).textTheme.headline5),
              SizedBox(height: 15),

              // Scripture quote
              HighlightText(scripture.text)
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

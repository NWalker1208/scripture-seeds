import 'dart:async';
import 'package:flutter/material.dart';
import 'package:seeds/widgets/activities/activity_widget.dart';
import 'package:seeds/services/utility.dart';

class PonderActivity extends ActivityWidget {
  PonderActivity(String topic, {FutureOr<void> Function(bool, String) onProgressChange, Key key}) :
        super(topic, onProgressChange: onProgressChange, key: key);

  @override
  _PonderActivityState createState() => _PonderActivityState();
}

class _PonderActivityState extends State<PonderActivity> {
  static final int kMinWords = 8;

  int wordCount;

  void updateCount(String text) {
    setState(() {
      wordCount = text.wordCount;
      widget.onProgressChange(wordCount >= kMinWords, text);
    });
  }

  @override
  void initState() {
    super.initState();
    wordCount = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          // Instructions
          Text('Write down your thoughts on the previous scripture and what it teaches you about ${widget.topic}.',
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 30),

          // Ponder text
          TextField(
            textCapitalization: TextCapitalization.sentences,
            keyboardType: TextInputType.text,
            maxLines: null,

            decoration: InputDecoration(
              contentPadding: EdgeInsets.all(12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              /*focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.green, width: 2.0),
                borderRadius: BorderRadius.circular(12),
              ),*/
              
              hintText: '${widget.topic.capitalize()} is...',
              counterText: '$wordCount/$kMinWords words',
              counterStyle: DefaultTextStyle.of(context).style.copyWith(
                color: (wordCount < kMinWords) ? Colors.red : null
              )
            ),

            onChanged: (text) => updateCount(text),
          )
        ],
      ),
    );
  }
}


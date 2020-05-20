import 'package:flutter/material.dart';

class SelectableWord extends StatefulWidget {
  final String word;

  SelectableWord({
    key,
    this.word
  }) : super(key: key);

  @override
  _SelectableWordState createState() => _SelectableWordState();
}

class _SelectableWordState extends State<SelectableWord> {

  bool selected = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selected = !selected;
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 100),
        color: selected ? Theme.of(context).textSelectionColor : Theme.of(context).textSelectionColor.withAlpha(0),
        child: Text(
          '${widget.word} ',
          style: Theme.of(context).textTheme.bodyText2.merge(TextStyle(
            fontFamily: 'Buenard',
            fontSize: 20
          )),
        ),
      ),
    );
  }
}


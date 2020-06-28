import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class HighlightRichText extends StatefulWidget {
  final String text, leadingText;
  final TextStyle style;
  final Color highlightColor;

  final void Function(List<bool>) onChangeHighlight;

  HighlightRichText(this.text, {this.leadingText, this.style, this.highlightColor, this.onChangeHighlight, Key key}) :
      super(key: key);

  @override
  _HighlightRichTextState createState() => _HighlightRichTextState();
}

enum _HighlightAppearance {
  off, selected, on
}

class _HighlightRichTextState extends State<HighlightRichText> {
  List<String> words;
  List<bool> highlightedWords;
  List<TapGestureRecognizer> _tapRecognizers;

  _HighlightRichTextState();

  void _handleWordTap(int index) {
    print('Word[$index] (${words[index]}) was tapped');
    setState(() {
      highlightedWords[index] = !highlightedWords[index];
      widget.onChangeHighlight(highlightedWords);
    });
  }

  void initWords() {
    words = widget.text.split(' ');
    highlightedWords = List<bool>.filled(words.length, false);
    _tapRecognizers = List<TapGestureRecognizer>.generate(
      words.length,
      (index) => TapGestureRecognizer()
        ..onTap = () => _handleWordTap(index)
    );
  }

  @override
  void initState() {
    super.initState();
    initWords();
  }

  @override
  void didUpdateWidget(HighlightRichText oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.text != widget.text)
      setState(() {
        _tapRecognizers.forEach((e) => e.dispose());
        initWords();
      });
  }

  @override
  void dispose() {
    _tapRecognizers.forEach((e) => e.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color highlightColor = widget.highlightColor ?? Theme.of(context).textSelectionColor;

    TextStyle offStyle = widget.style ?? DefaultTextStyle.of(context).style;

    TextStyle onStyle = offStyle.copyWith(backgroundColor: highlightColor);

    return RichText(
      textAlign: TextAlign.justify,
      text: TextSpan(
        text: widget.leadingText,
        style: offStyle,
        // Generate a list of textSpans for the words and the spaces inbetween
        children: List<TextSpan>.generate(
          words.length,
          (index) {
            return TextSpan(
              text: '${words[index]} ',
              style: highlightedWords[index] ? onStyle : offStyle,
              recognizer: _tapRecognizers[index]
            );
          }
        )
      )
    );
  }
}

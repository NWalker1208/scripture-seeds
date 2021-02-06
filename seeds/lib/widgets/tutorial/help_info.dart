import 'package:flutter/material.dart';

import '../dialogs/help.dart';

class HelpInfo extends StatefulWidget {
  const HelpInfo({
    @required this.helpText,
    this.title = 'Help',
    this.child,
    this.tag,
    Key key,
  }) : super(key: key);

  final String helpText;
  final String title;
  final Object tag;
  final Widget child;

  static Iterable<HelpInfoState> allIn(BuildContext context) {
    final result = <HelpInfoState>[];

    void visitor(Element element) {
      if (element.widget is HelpInfo) {
        final info = element as StatefulElement;
        result.add(info.state as HelpInfoState);
      }
      element.visitChildren(visitor);
    }

    context.visitChildElements(visitor);
    return result;
  }

  static Future<void> open(BuildContext context, {Object filter}) async {
    var widgets = allIn(context);
    if (filter != null) {
      widgets = widgets.where((info) => info.widget.tag == filter);
    }
    for (var info in widgets) {
      await info.open();
    }
  }

  @override
  HelpInfoState createState() => HelpInfoState();
}

class HelpInfoState extends State<HelpInfo> {
  Future<void> open() => showDialog<void>(
        context: context,
        barrierDismissible: true,
        builder: (context) => HelpDialog(
          widget.helpText,
          title: widget.title,
        ),
      );

  @override
  Widget build(BuildContext context) => widget.child;
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/settings/help.dart';
import 'dialogs/help.dart';

class HelpPage extends StatefulWidget {
  final String pageName;
  final String helpText;
  final String title;
  final Widget Function(BuildContext, HelpPageState, Widget) pageBuilder;
  final Widget child;

  HelpPage(
    this.pageName, {
    @required this.helpText,
    this.title,
    this.pageBuilder,
    this.child,
    Key key,
  }) : super(key: key);

  @override
  HelpPageState createState() => HelpPageState();
}

class HelpPageState extends State<HelpPage> {
  Set<String> helpPagesShown;
  HelpSettings settings;

  void showHelpDialog({bool always = true}) {
    var helpSetting = settings?.getShowHelp(widget.pageName) ?? false;

    if (always || (helpSetting && !helpPagesShown.contains(widget.pageName))) {
      // Mark page as shown
      helpPagesShown.add(widget.pageName);

      // Open dialog on next frame
      WidgetsBinding.instance.addPostFrameCallback(
        (_) async => showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (context) => HelpDialog(
            widget.helpText,
            title: widget.title,
            page: widget.pageName,
          ),
        ),
      );
    } else {
      if (helpSetting) {
        print('Help dialog skipped, already shown.');
      } else {
        print('Help dialog skipped, user disabled or settings not loaded.');
      }
    }
  }

  @override
  void initState() {
    super.initState();

    helpPagesShown = <String>{};
    settings = null;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    print('Changed dependencies, showing help...');
    settings = Provider.of<HelpSettings>(context, listen: true);
    showHelpDialog(always: false);
  }

  @override
  void didUpdateWidget(HelpPage oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.pageName != widget.pageName) {
      print(
          'Updated page from ${oldWidget.pageName} to ${widget.pageName}, showing help...');
      showHelpDialog(always: false);
    }
  }

  @override
  Widget build(BuildContext context) =>
      widget.pageBuilder?.call(context, this, widget.child) ?? widget.child;
}

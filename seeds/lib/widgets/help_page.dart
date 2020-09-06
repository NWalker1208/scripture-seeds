import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seeds/services/help_settings.dart';
import 'package:seeds/widgets/dialogs/help.dart';

class HelpPage extends StatefulWidget {
  final String pageName;
  final String helpText;
  final String title;
  final Widget Function(BuildContext, HelpPageState, Widget) pageBuilder;
  final Widget child;

  HelpPage(
    this.pageName,
    {
      @required
      this.helpText,
      this.title,
      this.pageBuilder,
      this.child,
      Key key
    }
  ) : super(key: key);

  @override
  HelpPageState createState() => HelpPageState();
}

class HelpPageState extends State<HelpPage> {
  void showHelpDialog({bool always = true}) {
    // TODO: Handle times when settings are not yet loaded
    if (always || Provider.of<HelpSettings>(context, listen: false).getShowHelp(widget.pageName))
      WidgetsBinding.instance.addPostFrameCallback((_) async =>
        showDialog<bool>(
          context: context,
          barrierDismissible: true,
          builder: (context) => HelpDialog(widget.helpText, title: widget.title, page: widget.pageName)
        ));
  }

  @override
  void initState() {
    super.initState();
    showHelpDialog(always: false);
  }

  @override
  void didUpdateWidget(HelpPage oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.pageName != widget.pageName)
      showHelpDialog(always: false);
  }

  @override
  Widget build(BuildContext context) {
    return widget.pageBuilder?.call(context, this, widget.child) ?? widget.child;
  }
}

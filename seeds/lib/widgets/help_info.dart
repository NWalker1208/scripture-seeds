import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/settings/help.dart';
import 'dialogs/help.dart';

class HelpInfo extends StatefulWidget {
  final String page;
  final String helpText;
  final String title;
  final Widget child;

  HelpInfo(
    this.page, {
    @required this.helpText,
    this.title = 'Help',
    this.child,
    Key key,
  }) : super(key: key);

  @override
  HelpInfoState createState() => HelpInfoState();
}

class HelpInfoState extends State<HelpInfo> {
  static final _helpPagesShown = <String>{};
  HelpSettings settings;

  static void resetPagesShown() => _helpPagesShown.clear();

  void showHelpDialog() {
    // Mark page as shown
    _helpPagesShown.add(widget.page);

    // Open dialog on next frame
    print('Showing help dialog for ${widget.page}...');
    WidgetsBinding.instance.addPostFrameCallback(
      (_) async => showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (context) => HelpDialog(
          widget.helpText,
          title: widget.title,
          page: widget.page,
        ),
      ),
    );
  }

  bool _shouldShow() {
    var helpSetting = settings?.getShowHelp(widget.page) ?? false;
    return helpSetting && !_helpPagesShown.contains(widget.page);
  }

  @override
  void didChangeDependencies() {
    settings = Provider.of<HelpSettings>(context);
    if (_shouldShow()) showHelpDialog();
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(HelpInfo oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.page != widget.page) {
      if (_shouldShow()) showHelpDialog();
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

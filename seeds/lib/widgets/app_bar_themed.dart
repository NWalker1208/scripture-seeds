import 'package:flutter/material.dart';

class AppBarThemed extends StatelessWidget {
  final Widget child;

  const AppBarThemed(this.child, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final textTheme = theme.appBarTheme.textTheme ?? theme.primaryTextTheme;
    final brightness =
        theme.appBarTheme.brightness ?? theme.primaryColorBrightness;
    final background = theme.appBarTheme.backgroundColor ?? theme.primaryColor;
    final foreground =
        theme.appBarTheme.foregroundColor ?? theme.colorScheme.onPrimary;

    return Theme(
      data: theme.copyWith(
        textTheme: textTheme,
        iconTheme: theme.appBarTheme.iconTheme ?? theme.primaryIconTheme,
        chipTheme: ChipThemeData.fromDefaults(
          secondaryColor: theme.primaryColor,
          brightness: brightness,
          labelStyle: textTheme.bodyText1,
        ),
        canvasColor: background,
        backgroundColor: background,
        splashColor: foreground.withOpacity(0.2),
        highlightColor: foreground.withOpacity(0.1),
        brightness: brightness,
      ),
      child: DefaultTextStyle(
        style: DefaultTextStyle.of(context).style.copyWith(color: foreground),
        child: child,
      ),
    );
  }
}

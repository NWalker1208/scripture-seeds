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
    final color = theme.appBarTheme.backgroundColor ?? theme.primaryColor;

    return Theme(
      child: child,
      data: theme.copyWith(
        textTheme: textTheme,
        iconTheme: theme.appBarTheme.iconTheme ?? theme.primaryIconTheme,
        chipTheme: ChipThemeData.fromDefaults(
          secondaryColor: theme.primaryColor,
          brightness: brightness,
          labelStyle: textTheme.bodyText1,
        ),
        canvasColor: color,
        backgroundColor: color,
        brightness: brightness,
      ),
    );
  }
}

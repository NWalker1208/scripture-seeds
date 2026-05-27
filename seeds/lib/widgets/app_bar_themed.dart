import 'package:flutter/material.dart';

class AppBarThemed extends StatelessWidget {
  final Widget child;

  const AppBarThemed(this.child, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appBarTheme = theme.appBarTheme;

    final background = appBarTheme.backgroundColor ?? theme.primaryColor;
    final foreground =
        appBarTheme.foregroundColor ?? theme.colorScheme.onPrimary;
    final brightness = ThemeData.estimateBrightnessForColor(background);

    final textTheme = theme.primaryTextTheme.apply(
      bodyColor: foreground,
      displayColor: foreground,
    );
    final iconTheme = appBarTheme.iconTheme ?? theme.primaryIconTheme;

    return Theme(
      data: theme.copyWith(
        textTheme: textTheme,
        iconTheme: iconTheme,
        chipTheme: ChipThemeData.fromDefaults(
          secondaryColor: theme.primaryColor,
          brightness: brightness,
          labelStyle: textTheme.bodyLarge!,
        ),
        canvasColor: background,
        colorScheme: theme.colorScheme.copyWith(
          surface: background,
          brightness: brightness,
        ),
        splashColor: foreground.withOpacity(0.2),
        highlightColor: foreground.withOpacity(0.1),
      ),
      child: DefaultTextStyle(
        style: DefaultTextStyle.of(context).style.copyWith(color: foreground),
        child: child,
      ),
    );
  }
}

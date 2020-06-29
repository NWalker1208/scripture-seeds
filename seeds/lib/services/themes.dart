import 'package:flutter/material.dart';

class AppThemes {
  static final ThemeData lightTheme = ThemeData(
    primarySwatch: Colors.green,
    accentColor: Colors.blue,
    cursorColor: Colors.blue,

    dialogTheme: DialogTheme(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
    ),
    buttonTheme: ButtonThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
    ),
    cardTheme: CardTheme(
      color: Colors.green[100],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
    ),

    visualDensity: VisualDensity.adaptivePlatformDensity,
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    textSelectionColor: Colors.green[500],

    // Copied from above
    primarySwatch: Colors.green,
    accentColor: Colors.blue,
    cursorColor: Colors.blue,

    dialogTheme: DialogTheme(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
    ),
    buttonTheme: ButtonThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
    ),
    cardTheme: CardTheme(
        color: Colors.green.withAlpha(126),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
    ),

    visualDensity: VisualDensity.adaptivePlatformDensity,
  );
}
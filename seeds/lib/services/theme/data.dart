import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomThemeData {
  final ThemeData light;
  final ThemeData dark;

  const CustomThemeData._({this.light, this.dark});

  factory CustomThemeData() {
    // ColorSchemes
    final colorsLight = ColorScheme.fromSwatch(
      primarySwatch: Colors.green,
      primaryColorDark: Colors.green[200],
      accentColor: Colors.blue,
      backgroundColor: Colors.grey[50],
      errorColor: Colors.red,
    );
    final colorsDark = ColorScheme.fromSwatch(
      primarySwatch: Colors.green,
      primaryColorDark: Colors.green[900],
      accentColor: Colors.blue,
      backgroundColor: Colors.black,
      cardColor: Color(0xFF101010),
      errorColor: Colors.red[600],
      brightness: Brightness.dark,
    );

    // Typography
    final typography = Typography.material2014(platform: defaultTargetPlatform);

    // System Overlay
    final systemOverlayLight = SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: colorsLight.surface,
      systemNavigationBarDividerColor: colorsLight.onSurface.withOpacity(0.12),
      systemNavigationBarIconBrightness: Brightness.dark,
    );
    final systemOverlayDark = SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: ElevationOverlay.colorWithOverlay(
          colorsDark.surface, colorsDark.onSurface, 4),
      systemNavigationBarDividerColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.light,
    );

    // AppBars
    final appBarThemeLight = AppBarTheme(
      elevation: null,
      textTheme: typography.white,
      iconTheme: const IconThemeData(color: Colors.white),
      backgroundColor: colorsLight.primary,
      foregroundColor: colorsLight.onPrimary,
      backwardsCompatibility: false,
      systemOverlayStyle: systemOverlayLight,
    );
    final appBarThemeDark = AppBarTheme(
      elevation: 4,
      textTheme: typography.white,
      iconTheme: const IconThemeData(color: Colors.white),
      backgroundColor: colorsDark.surface,
      foregroundColor: colorsDark.onSurface,
      backwardsCompatibility: false,
      systemOverlayStyle: systemOverlayDark,
    );

    final bottomAppBarThemeLight = BottomAppBarTheme(
      elevation: null,
      color: colorsLight.surface,
    );
    final bottomAppBarThemeDark = BottomAppBarTheme(
      elevation: 4,
      color: colorsDark.surface,
    );

    // Dialog Theme
    final dialogThemeLight = DialogTheme(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
    final dialogThemeDark = DialogTheme(
      backgroundColor: colorsDark.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );

    // Text Selection Theme
    final textSelectionThemeLight = TextSelectionThemeData(
      cursorColor: Colors.green,
      selectionColor: Colors.green[300],
      selectionHandleColor: Colors.green,
    );
    final textSelectionThemeDark = TextSelectionThemeData(
      cursorColor: Colors.green,
      selectionColor: Colors.green[700],
      selectionHandleColor: Colors.green,
    );

    // Button Theme
    final buttonTheme = ButtonThemeData(
      textTheme: ButtonTextTheme.primary,
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );

    // Input Decoration Theme
    final inputTheme = InputDecorationTheme(
      contentPadding: EdgeInsets.all(12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.green, width: 3),
      ),
    );

    // Card Theme
    final cardTheme = CardTheme(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4.0,
    );

    // Divider Theme
    final dividerTheme = DividerThemeData(
      thickness: 1,
      indent: 0,
      endIndent: 0,
    );

    // ThemeData
    final light = ThemeData.from(
      colorScheme: colorsLight,
      textTheme: typography.black,
    ).copyWith(
      toggleableActiveColor: colorsLight.primary,
      highlightColor: colorsLight.onSurface.withOpacity(0.2),
      splashColor: colorsLight.onSurface.withOpacity(0.1),
      disabledColor: Colors.grey[500],
      appBarTheme: appBarThemeLight,
      bottomAppBarTheme: bottomAppBarThemeLight,
      dialogTheme: dialogThemeLight,
      textSelectionTheme: textSelectionThemeLight,
      buttonTheme: buttonTheme,
      inputDecorationTheme: inputTheme,
      cardTheme: cardTheme,
      dividerTheme: dividerTheme,
    );
    final dark = ThemeData.from(
      colorScheme: colorsDark,
      textTheme: typography.white,
    ).copyWith(
      toggleableActiveColor: colorsDark.primary,
      highlightColor: colorsDark.onSurface.withOpacity(0.2),
      splashColor: colorsDark.onSurface.withOpacity(0.1),
      disabledColor: Colors.grey[500],
      appBarTheme: appBarThemeDark,
      bottomAppBarTheme: bottomAppBarThemeDark,
      dialogTheme: dialogThemeDark,
      textSelectionTheme: textSelectionThemeDark,
      buttonTheme: buttonTheme,
      inputDecorationTheme: inputTheme,
      cardTheme: cardTheme,
      dividerTheme: dividerTheme,
    );

    return CustomThemeData._(light: light, dark: dark);
  }
}

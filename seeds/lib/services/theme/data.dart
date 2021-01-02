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
      primaryColorDark: Colors.green[800],
      accentColor: Colors.blue,
      backgroundColor: Colors.black,
      cardColor: Color(0xFF101010),
      errorColor: Colors.red[600],
      brightness: Brightness.dark,
    );

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
      backgroundColor: colorsLight.primary,
      foregroundColor: colorsLight.onPrimary,
      backwardsCompatibility: false,
      systemOverlayStyle: systemOverlayLight,
    );
    final appBarThemeDark = AppBarTheme(
      elevation: 4,
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

    // Button Theme
    final buttonTheme = ButtonThemeData(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );

    // Card Theme
    final cardTheme = CardTheme(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );

    // Divider Theme
    final dividerTheme = DividerThemeData(
      thickness: 1,
      indent: 0,
      endIndent: 0,
    );

    // ThemeData
    final light = ThemeData.from(colorScheme: colorsLight).copyWith(
      toggleableActiveColor: colorsLight.primary,
      appBarTheme: appBarThemeLight,
      bottomAppBarTheme: bottomAppBarThemeLight,
      dialogTheme: dialogThemeLight,
      buttonTheme: buttonTheme,
      cardTheme: cardTheme,
      dividerTheme: dividerTheme,
    );
    final dark = ThemeData.from(colorScheme: colorsDark).copyWith(
      toggleableActiveColor: colorsDark.primary,
      appBarTheme: appBarThemeDark,
      bottomAppBarTheme: bottomAppBarThemeDark,
      dialogTheme: dialogThemeDark,
      buttonTheme: buttonTheme,
      cardTheme: cardTheme,
      dividerTheme: dividerTheme,
    );

    return CustomThemeData._(light: light, dark: dark);
  }
}

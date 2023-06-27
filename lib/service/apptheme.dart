import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData lightTheme(ColorScheme? lightColor) {
    final scheme = lightColor ??
        ColorScheme.fromSeed(
          brightness: Brightness.light,
          seedColor: Colors.greenAccent,
        );
    return ThemeData(colorScheme: scheme, useMaterial3: true);
  }

  static ThemeData darkTheme(ColorScheme? darkColor) {
    final scheme = darkColor ??
        ColorScheme.fromSeed(
          brightness: Brightness.dark,
          seedColor: Colors.greenAccent,
        );
    return ThemeData(colorScheme: scheme, useMaterial3: true);
  }
}

import 'package:flutter/material.dart';

/// Material 3 theme. Brand primary #1B6FD8, light + dark from seed.
class AppTheme {
  AppTheme._();

  static const _seed = Color(0xFF1B6FD8);

  static ThemeData light() => _build(ColorScheme.fromSeed(seedColor: _seed));

  static ThemeData dark() => _build(
    ColorScheme.fromSeed(seedColor: _seed, brightness: Brightness.dark),
  );

  static ThemeData _build(ColorScheme scheme) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}

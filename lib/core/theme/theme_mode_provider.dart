import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _themeModePreferenceKey = 'app_theme_mode';

final themeModeNotifierProvider =
    AsyncNotifierProvider<ThemeModeNotifier, ThemeMode>(ThemeModeNotifier.new);

class ThemeModeNotifier extends AsyncNotifier<ThemeMode> {
  @override
  Future<ThemeMode> build() async {
    final prefs = await SharedPreferences.getInstance();
    return _decodeThemeMode(prefs.getString(_themeModePreferenceKey));
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeModePreferenceKey, _encodeThemeMode(mode));
    state = AsyncData(mode);
  }
}

ThemeMode _decodeThemeMode(String? value) => switch (value) {
  'system' => ThemeMode.system,
  'dark' => ThemeMode.dark,
  _ => ThemeMode.light,
};

String _encodeThemeMode(ThemeMode mode) => switch (mode) {
  ThemeMode.light => 'light',
  ThemeMode.dark => 'dark',
  ThemeMode.system => 'system',
};

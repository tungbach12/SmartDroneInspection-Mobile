import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _localePreferenceKey = 'app_locale';
const supportedAppLocales = [Locale('en'), Locale('vi')];

final localeNotifierProvider = AsyncNotifierProvider<LocaleNotifier, Locale>(
  LocaleNotifier.new,
);

class LocaleNotifier extends AsyncNotifier<Locale> {
  @override
  Future<Locale> build() async {
    final preferences = await SharedPreferences.getInstance();
    return _localeFromCode(preferences.getString(_localePreferenceKey));
  }

  Future<void> setLocale(Locale locale) async {
    final selectedLocale = _localeFromCode(locale.languageCode);
    if (selectedLocale != locale) {
      throw ArgumentError.value(locale, 'locale', 'Unsupported locale');
    }

    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(
      _localePreferenceKey,
      selectedLocale.languageCode,
    );
    state = AsyncData(selectedLocale);
  }
}

Locale _localeFromCode(String? languageCode) => switch (languageCode) {
  'vi' => const Locale('vi'),
  _ => const Locale('en'),
};

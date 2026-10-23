import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_drone_inspection/core/localization/locale_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('defaults to English regardless of the device locale', () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    expect(
      await container.read(localeNotifierProvider.future),
      const Locale('en'),
    );
  });

  test('restores the saved Vietnamese locale', () async {
    SharedPreferences.setMockInitialValues({'app_locale': 'vi'});
    final container = ProviderContainer();
    addTearDown(container.dispose);

    expect(
      await container.read(localeNotifierProvider.future),
      const Locale('vi'),
    );
  });

  test('falls back to English for an unsupported saved locale', () async {
    SharedPreferences.setMockInitialValues({'app_locale': 'fr'});
    final container = ProviderContainer();
    addTearDown(container.dispose);

    expect(
      await container.read(localeNotifierProvider.future),
      const Locale('en'),
    );
  });

  test('persists a user-selected locale', () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final controller = container.read(localeNotifierProvider.notifier);
    await container.read(localeNotifierProvider.future);

    await controller.setLocale(const Locale('vi'));

    expect(container.read(localeNotifierProvider).value, const Locale('vi'));
    expect(
      (await SharedPreferences.getInstance()).getString('app_locale'),
      'vi',
    );
  });
}

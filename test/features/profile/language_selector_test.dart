import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_drone_inspection/core/localization/locale_provider.dart';
import 'package:smart_drone_inspection/features/profile/presentation/profile_page.dart';
import 'package:smart_drone_inspection/l10n/app_localizations.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() => SharedPreferences.setMockInitialValues({}));

  testWidgets('shows language choices and applies a selected locale', (
    tester,
  ) async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          locale: const Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: supportedAppLocales,
          home: const Scaffold(body: ProfilePage()),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Language'), findsOneWidget);
    await tester.tap(find.byKey(const Key('language-selector')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Tiếng Việt').last);
    await tester.pumpAndSettle();

    expect(container.read(localeNotifierProvider).value, const Locale('vi'));

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpAndSettle();
    final restoredContainer = ProviderContainer();
    addTearDown(restoredContainer.dispose);
    expect(
      await restoredContainer.read(localeNotifierProvider.future),
      const Locale('vi'),
    );
  });
}

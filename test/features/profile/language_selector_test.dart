import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_drone_inspection/core/localization/locale_provider.dart';
import 'package:smart_drone_inspection/core/theme/theme_mode_provider.dart';
import 'package:smart_drone_inspection/features/auth/domain/models/auth_session.dart';
import 'package:smart_drone_inspection/features/auth/domain/models/auth_user.dart';
import 'package:smart_drone_inspection/features/auth/domain/models/user_role.dart';
import 'package:smart_drone_inspection/features/auth/presentation/providers/session_provider.dart';
import 'package:smart_drone_inspection/features/profile/presentation/profile_page.dart';
import 'package:smart_drone_inspection/l10n/app_localizations.dart';

class _TestAuthNotifier extends AuthNotifier {
  @override
  Future<AuthSession> build() async => const AuthSession.authenticated(
    AuthUser(
      id: 'cust-1',
      email: 'customer@example.com',
      fullName: 'Nguyen Van A',
      roles: [UserRole.customer],
      organizationId: 'org-1',
    ),
  );
}

void main() {
  testWidgets(
    'selecting Vietnamese and Dark theme persists choices without pilot license UI',
    (tester) async {
      SharedPreferences.setMockInitialValues({});

      await tester.pumpWidget(
        ProviderScope(
          overrides: [authNotifierProvider.overrideWith(_TestAuthNotifier.new)],
          child: Consumer(
            builder: (context, ref, _) {
              final locale =
                  ref.watch(localeNotifierProvider).value ?? const Locale('en');
              final themeMode =
                  ref.watch(themeModeNotifierProvider).value ?? ThemeMode.light;
              return MaterialApp(
                locale: locale,
                themeMode: themeMode,
                supportedLocales: const [Locale('en'), Locale('vi')],
                localizationsDelegates: AppLocalizations.localizationsDelegates,
                home: const ProfilePage(),
              );
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Verify Customer role pill appears, default theme is Light, and stale Pilot License text is gone.
      expect(find.text('Customer'), findsOneWidget);
      expect(find.text('Light'), findsOneWidget);
      expect(find.textContaining('Pilot license'), findsNothing);

      await tester.tap(find.byKey(const Key('language-selector')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Tiếng Việt').last);
      await tester.pumpAndSettle();

      expect(find.text('Ngôn ngữ'), findsOneWidget);
      expect(
        (await SharedPreferences.getInstance()).getString('app_locale'),
        'vi',
      );

      await tester.tap(find.byKey(const Key('theme-mode-selector')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Tối').last);
      await tester.pumpAndSettle();

      expect(
        (await SharedPreferences.getInstance()).getString('app_theme_mode'),
        'dark',
      );
    },
  );
}

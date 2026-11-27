import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_drone_inspection/core/network/api_failure.dart';
import 'package:smart_drone_inspection/core/network/api_result.dart';
import 'package:smart_drone_inspection/core/network/providers.dart';
import 'package:smart_drone_inspection/core/network/token_store.dart';
import 'package:smart_drone_inspection/features/auth/data/auth_repository.dart';
import 'package:smart_drone_inspection/main.dart';

class _InMemoryTokenStore extends TokenStore {
  String? _access;
  String? _refresh;

  @override
  Future<void> load() async {}

  @override
  String? get access => _access;

  @override
  String? get refresh => _refresh;

  @override
  Future<void> save({required String access, required String refresh}) async {
    _access = access;
    _refresh = refresh;
  }

  @override
  Future<void> clear() async {
    _access = null;
    _refresh = null;
  }
}

class _ConfigurableAuthRepository extends AuthRepository {
  _ConfigurableAuthRepository(this.onLogin) : super(Dio());

  final Future<ApiResult<AuthFlow>> Function(String email, String password)
  onLogin;

  @override
  Future<ApiResult<AuthFlow>> login({
    required String email,
    required String password,
  }) {
    return onLogin(email, password);
  }
}

void main() {
  testWidgets(
    'SmartDroneInspectionApp keeps LoginPage mounted and shows error on failed sign-in',
    (tester) async {
      SharedPreferences.setMockInitialValues({'app_locale': 'en'});
      final pendingLogin = Completer<ApiResult<AuthFlow>>();
      final repo = _ConfigurableAuthRepository((_, _) => pendingLogin.future);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            tokenStoreProvider.overrideWithValue(_InMemoryTokenStore()),
            authRepositoryProvider.overrideWithValue(repo),
          ],
          child: const SmartDroneInspectionApp(),
        ),
      );
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byKey(const Key('login-email-field')),
        'customer@skyview.local',
      );
      await tester.enterText(
        find.byKey(const Key('login-password-field')),
        'wrong-password',
      );
      await tester.tap(find.byKey(const Key('login-submit-btn')));
      await tester.pump();

      // LoginPage remains mounted during in-flight login instead of dropping back to splash.
      expect(find.byKey(const Key('login-email-field')), findsOneWidget);

      pendingLogin.complete(const ApiResult.failure(ApiFailure.unauthorized()));
      await tester.pumpAndSettle();

      expect(find.text('Invalid email or password.'), findsOneWidget);
      expect(find.text('customer@skyview.local'), findsOneWidget);
    },
  );

  testWidgets(
    'SmartDroneInspectionApp shows server connection error instead of clearing form',
    (tester) async {
      SharedPreferences.setMockInitialValues({'app_locale': 'en'});
      final repo = _ConfigurableAuthRepository(
        (_, _) async => const ApiResult.failure(ApiFailure.network()),
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            tokenStoreProvider.overrideWithValue(_InMemoryTokenStore()),
            authRepositoryProvider.overrideWithValue(repo),
          ],
          child: const SmartDroneInspectionApp(),
        ),
      );
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byKey(const Key('login-email-field')),
        'customer@skyview.local',
      );
      await tester.enterText(
        find.byKey(const Key('login-password-field')),
        'Lantern#Quartz88',
      );
      await tester.tap(find.byKey(const Key('login-submit-btn')));
      await tester.pumpAndSettle();

      expect(
        find.text('Cannot reach the server. Check your connection.'),
        findsOneWidget,
      );
      expect(find.text('customer@skyview.local'), findsOneWidget);
    },
  );
}

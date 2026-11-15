import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_drone_inspection/core/localization/locale_provider.dart';
import 'package:smart_drone_inspection/core/network/api_failure.dart';
import 'package:smart_drone_inspection/core/network/api_result.dart';
import 'package:smart_drone_inspection/core/network/providers.dart';
import 'package:smart_drone_inspection/core/network/token_store.dart';
import 'package:smart_drone_inspection/features/auth/data/auth_repository.dart';
import 'package:smart_drone_inspection/features/auth/domain/models/auth_session.dart';
import 'package:smart_drone_inspection/features/auth/domain/models/auth_user.dart';
import 'package:smart_drone_inspection/features/auth/domain/models/user_role.dart';
import 'package:smart_drone_inspection/features/auth/presentation/providers/session_provider.dart';

class FakeTokenStore extends TokenStore {
  FakeTokenStore({this.accessValue, this.refreshValue});

  String? accessValue;
  String? refreshValue;

  @override
  Future<void> load() async {}

  @override
  String? get access => accessValue;

  @override
  String? get refresh => refreshValue;

  @override
  Future<void> save({required String access, required String refresh}) async {
    accessValue = access;
    refreshValue = refresh;
  }

  @override
  Future<void> clear() async {
    accessValue = null;
    refreshValue = null;
  }
}

class FakeAuthRepository extends AuthRepository {
  FakeAuthRepository() : super(Dio());

  ApiResult<AuthFlow>? refreshResult;
  ApiResult<AuthFlow>? loginResult;
  ApiResult<AuthFlow>? verifyOtpResult;
  ApiResult<void> changePasswordResult = const ApiResult.success(null);
  ApiResult<void> logoutAllResult = const ApiResult.success(null);
  String? revokedRefreshToken;
  String? Function()? localeAtRefresh;
  String? localeObservedDuringRefresh;

  @override
  Future<ApiResult<AuthFlow>> refresh({required String refreshToken}) async {
    localeObservedDuringRefresh = localeAtRefresh?.call();
    return refreshResult!;
  }

  @override
  Future<ApiResult<AuthFlow>> login({
    required String email,
    required String password,
  }) async {
    return loginResult!;
  }

  @override
  Future<ApiResult<AuthFlow>> verifyLoginOtp({
    required String challengeToken,
    required String code,
  }) async {
    return verifyOtpResult!;
  }

  @override
  Future<ApiResult<void>> logout({required String refreshToken}) async {
    revokedRefreshToken = refreshToken;
    return const ApiResult.success(null);
  }

  @override
  Future<ApiResult<void>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    return changePasswordResult;
  }

  @override
  Future<ApiResult<void>> logoutAll() async {
    return logoutAllResult;
  }
}

AuthUser _customer() => const AuthUser(
  id: 'u1',
  email: 'customer@sdi.test',
  fullName: 'Customer User',
  roles: [UserRole.customer],
);

AuthUser _inspector() => const AuthUser(
  id: 'u2',
  email: 'inspector@sdi.test',
  fullName: 'Inspector User',
  roles: [UserRole.inspector],
);

void main() {
  ProviderContainer makeContainer({
    required FakeTokenStore tokens,
    required FakeAuthRepository repo,
  }) {
    SharedPreferences.setMockInitialValues({});
    return ProviderContainer(
      overrides: [
        localeNotifierProvider.overrideWith(LocaleNotifier.new),
        tokenStoreProvider.overrideWithValue(tokens),
        authRepositoryProvider.overrideWithValue(repo),
      ],
    );
  }

  test('hydrate with empty tokens yields anonymous', () async {
    final container = makeContainer(
      tokens: FakeTokenStore(),
      repo: FakeAuthRepository(),
    );
    addTearDown(container.dispose);

    final session = await container.read(authNotifierProvider.future);
    expect(session.isAnonymous, isTrue);
  });

  test('loads saved locale before refreshing an existing session', () async {
    SharedPreferences.setMockInitialValues({'app_locale': 'vi'});
    late final ProviderContainer container;
    final repo = FakeAuthRepository();
    repo.localeAtRefresh = () =>
        container.read(localeNotifierProvider).value?.languageCode;
    repo.refreshResult = ApiResult.success(
      AuthFlow(
        step: 'AUTHENTICATED',
        accessToken: 'access-2',
        refreshToken: 'refresh-2',
        accessTokenExpiresInSeconds: 3600,
        user: _customer(),
      ),
    );
    container = ProviderContainer(
      overrides: [
        tokenStoreProvider.overrideWithValue(
          FakeTokenStore(refreshValue: 'refresh-1'),
        ),
        authRepositoryProvider.overrideWithValue(repo),
      ],
    );
    addTearDown(container.dispose);

    await container.read(authNotifierProvider.future);

    expect(repo.localeObservedDuringRefresh, 'vi');
  });

  test(
    'hydrate with valid Customer refresh token yields authenticated',
    () async {
      final repo = FakeAuthRepository()
        ..refreshResult = ApiResult.success(
          AuthFlow(
            step: 'AUTHENTICATED',
            accessToken: 'access-2',
            refreshToken: 'refresh-2',
            accessTokenExpiresInSeconds: 3600,
            user: _customer(),
          ),
        );
      final tokens = FakeTokenStore(refreshValue: 'refresh-1');
      final container = makeContainer(tokens: tokens, repo: repo);
      addTearDown(container.dispose);

      final session = await container.read(authNotifierProvider.future);
      expect(session.isAuthenticated, isTrue);
      expect(session.user!.email, 'customer@sdi.test');
      expect(tokens.access, 'access-2');
      expect(tokens.refresh, 'refresh-2');
    },
  );

  test('hydrate rejects non-Customer user and clears tokens', () async {
    final repo = FakeAuthRepository()
      ..refreshResult = ApiResult.success(
        AuthFlow(
          step: 'AUTHENTICATED',
          accessToken: 'access-2',
          refreshToken: 'refresh-2',
          accessTokenExpiresInSeconds: 3600,
          user: _inspector(),
        ),
      );
    final tokens = FakeTokenStore(
      accessValue: 'old-access',
      refreshValue: 'old-refresh',
    );
    final container = makeContainer(tokens: tokens, repo: repo);
    addTearDown(container.dispose);

    final session = await container.read(authNotifierProvider.future);
    expect(session.isAnonymous, isTrue);
    expect(tokens.access, isNull);
    expect(tokens.refresh, isNull);
  });

  test('login rejects non-Customer account with CUSTOMER_ONLY_MOBILE and revokes token', () async {
    final repo = FakeAuthRepository()
      ..loginResult = ApiResult.success(
        AuthFlow(
          step: 'AUTHENTICATED',
          accessToken: 'acc-insp',
          refreshToken: 'ref-insp',
          accessTokenExpiresInSeconds: 3600,
          user: _inspector(),
        ),
      );
    final tokens = FakeTokenStore();
    final container = makeContainer(tokens: tokens, repo: repo);
    addTearDown(container.dispose);

    await container.read(authNotifierProvider.future);
    final res = await container
        .read(authNotifierProvider.notifier)
        .login(email: 'inspector@sdi.test', password: 'secret-password-15');

    expect(
      res,
      const ApiResult<AuthSession>.failure(
        ForbiddenFailure(customerOnlyErrorCode),
      ),
    );
    expect(repo.revokedRefreshToken, 'ref-insp');
    expect(tokens.access, isNull);
    expect(container.read(authNotifierProvider).value!.isAnonymous, isTrue);
  });

  test(
    'handleOAuthCallback rejects non-Customer tokens and clears store',
    () async {
      final repo = FakeAuthRepository()
        ..refreshResult = ApiResult.success(
          AuthFlow(
            step: 'AUTHENTICATED',
            accessToken: 'acc-mgr',
            refreshToken: 'ref-mgr',
            accessTokenExpiresInSeconds: 3600,
            user: const AuthUser(
              id: 'u-mgr',
              email: 'mgr@sdi.test',
              fullName: 'Manager',
              roles: [UserRole.manager],
            ),
          ),
        );
      final tokens = FakeTokenStore();
      final container = makeContainer(tokens: tokens, repo: repo);
      addTearDown(container.dispose);

      await container.read(authNotifierProvider.future);
      final res = await container
          .read(authNotifierProvider.notifier)
          .handleOAuthCallback(
            accessToken: 'oauth-acc',
            refreshToken: 'oauth-ref',
          );

      expect(
        res,
        const ApiResult<AuthSession>.failure(
          ForbiddenFailure(customerOnlyErrorCode),
        ),
      );
      expect(tokens.access, isNull);
      expect(tokens.refresh, isNull);
    },
  );

  test(
    'login handles OTP_REQUIRED step and verifyLoginOtp authenticates Customer',
    () async {
      final repo = FakeAuthRepository()
        ..loginResult = const ApiResult.success(
          AuthFlow(
            step: 'OTP_REQUIRED',
            accessToken: null,
            refreshToken: null,
            accessTokenExpiresInSeconds: 0,
            challengeToken: 'challenge-123',
            availableOtpChannels: ['EMAIL'],
          ),
        )
        ..verifyOtpResult = ApiResult.success(
          AuthFlow(
            step: 'AUTHENTICATED',
            accessToken: 'acc-1',
            refreshToken: 'ref-1',
            accessTokenExpiresInSeconds: 3600,
            user: _customer(),
          ),
        );
      final tokens = FakeTokenStore();
      final container = makeContainer(tokens: tokens, repo: repo);
      addTearDown(container.dispose);

      await container.read(authNotifierProvider.future);
      final step1 = await container
          .read(authNotifierProvider.notifier)
          .login(email: 'customer@sdi.test', password: 'password-1234567');
      expect(step1, isA<ApiSuccess<AuthSession>>());
      expect(container.read(authNotifierProvider).value!.requiresOtp, isTrue);

      final step2 = await container
          .read(authNotifierProvider.notifier)
          .verifyLoginOtp(challengeToken: 'challenge-123', code: '654321');
      expect(step2, isA<ApiSuccess<AuthSession>>());
      expect(
        container.read(authNotifierProvider).value!.isAuthenticated,
        isTrue,
      );
      expect(tokens.access, 'acc-1');
    },
  );

  test(
    'logoutAll clears persisted tokens and returns anonymous session',
    () async {
      final repo = FakeAuthRepository()
        ..refreshResult = ApiResult.success(
          AuthFlow(
            step: 'AUTHENTICATED',
            accessToken: 'access-2',
            refreshToken: 'refresh-2',
            accessTokenExpiresInSeconds: 3600,
            user: _customer(),
          ),
        );
      final tokens = FakeTokenStore(refreshValue: 'refresh-1');
      final container = makeContainer(tokens: tokens, repo: repo);
      addTearDown(container.dispose);

      await container.read(authNotifierProvider.future);
      await container.read(authNotifierProvider.notifier).logoutAll();

      expect(tokens.access, isNull);
      expect(tokens.refresh, isNull);
      expect(container.read(authNotifierProvider).value!.isAnonymous, isTrue);
    },
  );
}

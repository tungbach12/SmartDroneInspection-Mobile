import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_drone_inspection/core/network/api_failure.dart';
import 'package:smart_drone_inspection/core/network/api_result.dart';
import 'package:smart_drone_inspection/core/network/token_store.dart';
import 'package:smart_drone_inspection/core/network/providers.dart';
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

  @override
  Future<ApiResult<AuthFlow>> refresh({required String refreshToken}) async {
    return refreshResult!;
  }

  @override
  Future<ApiResult<AuthFlow>> login({
    required String email,
    required String password,
  }) async {
    return loginResult!;
  }
}

AuthUser _user() => const AuthUser(
  id: 'u1',
  email: 'a@b.c',
  fullName: 'A B',
  roles: [UserRole.inspector],
);

void main() {
  ProviderContainer makeContainer({
    required FakeTokenStore tokens,
    required FakeAuthRepository repo,
  }) {
    return ProviderContainer(
      overrides: [
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

  test('hydrate with valid refresh token yields authenticated', () async {
    final repo = FakeAuthRepository()
      ..refreshResult = ApiResult.success(
        AuthFlow(
          step: 'AUTHENTICATED',
          accessToken: 'access-2',
          refreshToken: 'refresh-2',
          accessTokenExpiresInSeconds: 3600,
          user: _user(),
        ),
      );
    final tokens = FakeTokenStore(refreshValue: 'refresh-1');
    final container = makeContainer(tokens: tokens, repo: repo);
    addTearDown(container.dispose);

    final session = await container.read(authNotifierProvider.future);
    expect(session.isAuthenticated, isTrue);
    expect(session.user!.email, 'a@b.c');
    // Rotated tokens persisted.
    expect(tokens.access, 'access-2');
    expect(tokens.refresh, 'refresh-2');
  });

  test(
    'hydrate with failed refresh clears tokens and yields anonymous',
    () async {
      final repo = FakeAuthRepository()
        ..refreshResult = const ApiResult.failure(UnauthorizedFailure());
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
    },
  );

  test('login success stores tokens and authenticates', () async {
    final repo = FakeAuthRepository()
      ..loginResult = ApiResult.success(
        AuthFlow(
          step: 'AUTHENTICATED',
          accessToken: 'access-1',
          refreshToken: 'refresh-1',
          accessTokenExpiresInSeconds: 3600,
          user: _user(),
        ),
      );
    final tokens = FakeTokenStore();
    final container = makeContainer(tokens: tokens, repo: repo);
    addTearDown(container.dispose);

    // Trigger initial hydration first.
    await container.read(authNotifierProvider.future);

    final result = await container
        .read(authNotifierProvider.notifier)
        .login(email: 'a@b.c', password: 'pw');
    expect(result, isA<ApiSuccess<AuthSession>>());
    expect(tokens.access, 'access-1');
    final state = container.read(authNotifierProvider);
    expect(state.value?.isAuthenticated, isTrue);
  });
}

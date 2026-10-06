import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_drone_inspection/core/network/api_result.dart';
import 'package:smart_drone_inspection/core/network/token_store.dart';
import 'package:smart_drone_inspection/features/auth/data/auth_repository.dart';
import 'package:smart_drone_inspection/features/auth/domain/models/auth_session.dart';

/// Session source of truth. Hydrates on first build: loads persisted tokens,
/// then best-effort refresh — valid session → authenticated; anything else
/// → tokens cleared, anonymous.
class AuthNotifier extends AsyncNotifier<AuthSession> {
  @override
  Future<AuthSession> build() async {
    final tokens = ref.watch(tokenStoreProvider);
    await tokens.load();
    final refresh = tokens.refresh;
    if (refresh == null || refresh.isEmpty) {
      return const AuthSession.anonymous();
    }
    try {
      final result = await ref
          .read(authRepositoryProvider)
          .refresh(refreshToken: refresh);
      switch (result) {
        case ApiSuccess(:final data):
          if (data.requiresPasswordChange) {
            return AuthSession.passwordChangeRequired(data.user);
          }
          final access = data.accessToken;
          final nextRefresh = data.refreshToken;
          if (access == null || nextRefresh == null) {
            await tokens.clear();
            return const AuthSession.anonymous();
          }
          await tokens.save(access: access, refresh: nextRefresh);
          return AuthSession.authenticated(data.user);
        case ApiError():
          await tokens.clear();
          return const AuthSession.anonymous();
      }
    } catch (_) {
      await tokens.clear();
      return const AuthSession.anonymous();
    }
  }

  Future<ApiResult<AuthSession>> login({
    required String email,
    required String password,
  }) async {
    state = const AsyncLoading<AuthSession>();
    final tokens = ref.read(tokenStoreProvider);
    final result = await ref
        .read(authRepositoryProvider)
        .login(email: email, password: password);
    switch (result) {
      case ApiSuccess(:final data):
        if (data.requiresPasswordChange) {
          final session = AuthSession.passwordChangeRequired(data.user);
          state = AsyncData<AuthSession>(session);
          return ApiResult<AuthSession>.success(session);
        }
        final access = data.accessToken;
        final nextRefresh = data.refreshToken;
        if (access == null || nextRefresh == null) {
          const session = AuthSession.anonymous();
          state = const AsyncData<AuthSession>(session);
          return const ApiResult<AuthSession>.success(session);
        }
        await tokens.save(access: access, refresh: nextRefresh);
        final session = AuthSession.authenticated(data.user);
        state = AsyncData<AuthSession>(session);
        return ApiResult<AuthSession>.success(session);
      case ApiError(:final failure):
        const session = AuthSession.anonymous();
        state = const AsyncData<AuthSession>(session);
        return ApiResult<AuthSession>.failure(failure);
    }
  }

  Future<ApiResult<AuthSession>> completeInitialPasswordSetup({
    required String email,
    required String currentPassword,
    required String newPassword,
  }) async {
    state = const AsyncLoading<AuthSession>();
    final tokens = ref.read(tokenStoreProvider);
    final result = await ref
        .read(authRepositoryProvider)
        .completeInitialPasswordSetup(
          email: email,
          currentPassword: currentPassword,
          newPassword: newPassword,
        );
    switch (result) {
      case ApiSuccess(:final data):
        final access = data.accessToken;
        final nextRefresh = data.refreshToken;
        if (data.requiresPasswordChange ||
            access == null ||
            nextRefresh == null) {
          const session = AuthSession.anonymous();
          state = const AsyncData<AuthSession>(session);
          return const ApiResult<AuthSession>.success(session);
        }
        await tokens.save(access: access, refresh: nextRefresh);
        final session = AuthSession.authenticated(data.user);
        state = AsyncData<AuthSession>(session);
        return ApiResult<AuthSession>.success(session);
      case ApiError(:final failure):
        const session = AuthSession.anonymous();
        state = const AsyncData<AuthSession>(session);
        return ApiResult<AuthSession>.failure(failure);
    }
  }

  Future<void> logout() async {
    final tokens = ref.read(tokenStoreProvider);
    final refresh = tokens.refresh;
    if (refresh != null && refresh.isNotEmpty) {
      try {
        await ref
            .read(authRepositoryProvider)
            .logout(refreshToken: refresh);
      } catch (_) {
        // Best effort — local sign-out proceeds regardless.
      }
    }
    await tokens.clear();
    state = const AsyncData<AuthSession>(AuthSession.anonymous());
  }

  /// Hard reset used by the AuthInterceptor when a refresh retry fails.
  void invalidateSession() {
    state = const AsyncData<AuthSession>(AuthSession.anonymous());
  }
}

final authNotifierProvider =
    AsyncNotifierProvider<AuthNotifier, AuthSession>(AuthNotifier.new);

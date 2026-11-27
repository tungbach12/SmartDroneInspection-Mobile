import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_drone_inspection/core/localization/locale_provider.dart';
import 'package:smart_drone_inspection/core/network/api_failure.dart';
import 'package:smart_drone_inspection/core/network/api_result.dart';
import 'package:smart_drone_inspection/core/network/providers.dart';
import 'package:smart_drone_inspection/features/auth/data/auth_repository.dart';
import 'package:smart_drone_inspection/features/auth/domain/models/auth_session.dart';

/// Session source of truth for the Customer-only mobile app.
/// Hydrates on startup and enforces that only CUSTOMER accounts can enter.
class AuthNotifier extends AsyncNotifier<AuthSession> {
  @override
  Future<AuthSession> build() async {
    await ref.read(localeNotifierProvider.future);

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
          final user = data.user;
          if (user == null || !user.isCustomer) {
            await tokens.clear();
            return const AuthSession.anonymous();
          }
          if (data.requiresPasswordChange) {
            return AuthSession.passwordChangeRequired(user);
          }
          final access = data.accessToken;
          final nextRefresh = data.refreshToken;
          if (access == null || nextRefresh == null) {
            await tokens.clear();
            return const AuthSession.anonymous();
          }
          await tokens.save(access: access, refresh: nextRefresh);
          return AuthSession.authenticated(user);
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
    final result = await ref
        .read(authRepositoryProvider)
        .login(email: email, password: password);
    return _applyAuthFlowResult(result, email: email);
  }

  Future<ApiResult<AuthSession>> verifyLoginOtp({
    required String challengeToken,
    required String code,
  }) async {
    final result = await ref
        .read(authRepositoryProvider)
        .verifyLoginOtp(challengeToken: challengeToken, code: code);
    return _applyAuthFlowResult(result);
  }

  Future<ApiResult<void>> sendLoginOtp({
    required String challengeToken,
    required String channel,
  }) {
    return ref
        .read(authRepositoryProvider)
        .sendLoginOtp(challengeToken: challengeToken, channel: channel);
  }

  Future<ApiResult<AuthSession>> handleOAuthCallback({
    required String accessToken,
    required String refreshToken,
  }) async {
    final tokens = ref.read(tokenStoreProvider);
    await tokens.save(access: accessToken, refresh: refreshToken);
    final result = await ref
        .read(authRepositoryProvider)
        .refresh(refreshToken: refreshToken);
    return _applyAuthFlowResult(result);
  }

  Future<ApiResult<AuthSession>> completeInitialPasswordSetup({
    required String email,
    required String currentPassword,
    required String newPassword,
  }) async {
    final result = await ref
        .read(authRepositoryProvider)
        .completeInitialPasswordSetup(
          email: email,
          currentPassword: currentPassword,
          newPassword: newPassword,
        );
    return _applyAuthFlowResult(result, email: email);
  }

  Future<ApiResult<void>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final result = await ref
        .read(authRepositoryProvider)
        .changePassword(
          currentPassword: currentPassword,
          newPassword: newPassword,
        );
    if (result is ApiSuccess<void>) {
      await ref.read(tokenStoreProvider).clear();
      state = const AsyncData<AuthSession>(AuthSession.anonymous());
    }
    return result;
  }

  Future<ApiResult<void>> logoutAll() async {
    final result = await ref.read(authRepositoryProvider).logoutAll();
    if (result is ApiSuccess<void>) {
      await ref.read(tokenStoreProvider).clear();
      state = const AsyncData<AuthSession>(AuthSession.anonymous());
    }
    return result;
  }

  Future<void> logout() async {
    final tokens = ref.read(tokenStoreProvider);
    final refresh = tokens.refresh;
    if (refresh != null && refresh.isNotEmpty) {
      try {
        await ref.read(authRepositoryProvider).logout(refreshToken: refresh);
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

  Future<ApiResult<AuthSession>> _applyAuthFlowResult(
    ApiResult<AuthFlow> result, {
    String? email,
  }) async {
    final tokens = ref.read(tokenStoreProvider);
    switch (result) {
      case ApiSuccess(:final data):
        if (data.requiresOtp && data.challengeToken != null) {
          final session = AuthSession.otpRequired(
            challengeToken: data.challengeToken!,
            availableOtpChannels: data.availableOtpChannels,
            pendingEmail: email,
            user: data.user,
          );
          state = AsyncData<AuthSession>(session);
          return ApiResult<AuthSession>.success(session);
        }

        final user = data.user;
        if (user != null && !user.isCustomer) {
          final refreshToRevoke = data.refreshToken ?? tokens.refresh;
          if (refreshToRevoke != null && refreshToRevoke.isNotEmpty) {
            try {
              await ref
                  .read(authRepositoryProvider)
                  .logout(refreshToken: refreshToRevoke);
            } catch (_) {
              // Ignore best-effort revocation failures.
            }
          }
          await tokens.clear();
          state = const AsyncData<AuthSession>(AuthSession.anonymous());
          return const ApiResult<AuthSession>.failure(
            ApiFailure.forbidden(customerOnlyErrorCode),
          );
        }

        if (data.requiresPasswordChange && user != null) {
          final session = AuthSession.passwordChangeRequired(user);
          state = AsyncData<AuthSession>(session);
          return ApiResult<AuthSession>.success(session);
        }

        final access = data.accessToken;
        final nextRefresh = data.refreshToken;
        if (user == null || access == null || nextRefresh == null) {
          await tokens.clear();
          const session = AuthSession.anonymous();
          state = const AsyncData<AuthSession>(session);
          return const ApiResult<AuthSession>.success(session);
        }

        await tokens.save(access: access, refresh: nextRefresh);
        final session = AuthSession.authenticated(user);
        state = AsyncData<AuthSession>(session);
        return ApiResult<AuthSession>.success(session);

      case ApiError(:final failure):
        await tokens.clear();
        const session = AuthSession.anonymous();
        state = const AsyncData<AuthSession>(session);
        return ApiResult<AuthSession>.failure(failure);
    }
  }
}

final authNotifierProvider = AsyncNotifierProvider<AuthNotifier, AuthSession>(
  AuthNotifier.new,
);

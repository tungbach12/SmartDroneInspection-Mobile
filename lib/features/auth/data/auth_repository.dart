import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_drone_inspection/core/network/api_failure.dart';
import 'package:smart_drone_inspection/core/network/api_result.dart';
import 'package:smart_drone_inspection/core/network/providers.dart';
import 'package:smart_drone_inspection/features/auth/domain/models/auth_user.dart';

/// Side-channel of the mobile auth endpoints.
///
/// Response envelope: {step, accessToken, refreshToken, accessTokenExpiresInSeconds, user}.
/// Uses the bare `refreshDioProvider` (ApiResponseInterceptor only) so login/refresh
/// never trip the AuthInterceptor recursion guard.
class AuthRepository {
  AuthRepository(this._dio);

  final Dio _dio;

  Future<ApiResult<AuthFlow>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/mobile/auth/login',
        data: {'email': email, 'password': password},
      );
      return ApiResult.success(AuthFlow.fromJson(response.data!));
    } on DioException catch (e) {
      return ApiResult.failure(mapDioError(e));
    }
  }

  Future<ApiResult<AuthFlow>> refresh({required String refreshToken}) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/mobile/auth/refresh',
        data: {'refreshToken': refreshToken},
      );
      return ApiResult.success(AuthFlow.fromJson(response.data!));
    } on DioException catch (e) {
      return ApiResult.failure(mapDioError(e));
    }
  }

  Future<ApiResult<void>> logout({required String refreshToken}) async {
    try {
      await _dio.post<void>(
        '/mobile/auth/logout',
        data: {'refreshToken': refreshToken},
      );
      return const ApiResult.success(null);
    } on DioException catch (e) {
      return ApiResult.failure(mapDioError(e));
    }
  }

  Future<ApiResult<AuthFlow>> completeInitialPasswordSetup({
    required String email,
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/mobile/auth/password/setup',
        data: {
          'email': email,
          'currentPassword': currentPassword,
          'password': newPassword,
        },
      );
      return ApiResult.success(AuthFlow.fromJson(response.data!));
    } on DioException catch (e) {
      return ApiResult.failure(mapDioError(e));
    }
  }
}

class AuthFlow {
  const AuthFlow({
    required this.step,
    required this.accessToken,
    required this.refreshToken,
    required this.accessTokenExpiresInSeconds,
    required this.user,
  });

  factory AuthFlow.fromJson(Map<String, dynamic> json) {
    return AuthFlow(
      step: json['step'] as String? ?? 'AUTHENTICATED',
      accessToken: json['accessToken'] as String?,
      refreshToken: json['refreshToken'] as String?,
      accessTokenExpiresInSeconds:
          (json['accessTokenExpiresInSeconds'] as num?)?.toInt() ?? 0,
      user: AuthUser.fromJson(json['user'] as Map<String, dynamic>),
    );
  }

  final String step;
  final String? accessToken;
  final String? refreshToken;
  final int accessTokenExpiresInSeconds;
  final AuthUser user;

  bool get requiresPasswordChange => step == 'PASSWORD_CHANGE_REQUIRED';
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(ref.watch(refreshDioProvider));
});

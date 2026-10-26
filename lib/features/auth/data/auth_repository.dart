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
  AuthRepository(this._dio, [Dio? authDio]) : _authDio = authDio ?? _dio;

  final Dio _dio;
  final Dio _authDio;

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

  Future<ApiResult<AuthUser>> updatePilotLicense({
    required String licenseNumber,
    required String licenseClass,
    required DateTime expiresAt,
    String? fileKey,
  }) async {
    try {
      final response = await _authDio.put(
        '/auth/me/pilot-license',
        data: {
          'pilotLicenseNumber': licenseNumber,
          'pilotLicenseClass': licenseClass,
          'pilotLicenseExpiresAt': expiresAt.toUtc().toIso8601String(),
          'pilotLicenseFileKey': ?fileKey,
        },
      );
      final raw = response.data;
      final userMap = raw is Map<String, dynamic>
          ? (raw['user'] is Map<String, dynamic>
              ? raw['user'] as Map<String, dynamic>
              : raw)
          : Map<String, dynamic>.from(raw as Map);
      return ApiResult.success(AuthUser.fromJson(userMap));
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
  return AuthRepository(ref.watch(refreshDioProvider), ref.watch(dioProvider));
});

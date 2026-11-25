import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_drone_inspection/core/network/api_failure.dart';
import 'package:smart_drone_inspection/core/network/api_result.dart';
import 'package:smart_drone_inspection/core/network/providers.dart';
import 'package:smart_drone_inspection/features/auth/domain/models/auth_user.dart';

const String webCookieSessionToken = '__browser_cookie_session__';

class AuthFlow {
  const AuthFlow({
    required this.step,
    required this.accessToken,
    required this.refreshToken,
    required this.accessTokenExpiresInSeconds,
    this.user,
    this.challengeToken,
    this.availableOtpChannels = const <String>[],
  });

  factory AuthFlow.fromJson(
    Map<String, dynamic> json, {
    String? fallbackRefreshToken,
  }) {
    final userRaw = json['user'];
    final channelsRaw = json['availableOtpChannels'];
    return AuthFlow(
      step: json['step'] as String? ?? 'AUTHENTICATED',
      accessToken: json['accessToken'] as String?,
      refreshToken: (json['refreshToken'] as String?) ?? fallbackRefreshToken,
      accessTokenExpiresInSeconds:
          (json['accessTokenExpiresInSeconds'] as num?)?.toInt() ?? 0,
      user: userRaw is Map<String, dynamic>
          ? AuthUser.fromJson(userRaw)
          : (userRaw is Map
                ? AuthUser.fromJson(Map<String, dynamic>.from(userRaw))
                : null),
      challengeToken: json['challengeToken'] as String?,
      availableOtpChannels: channelsRaw is List
          ? channelsRaw.map((e) => e.toString()).toList()
          : const <String>[],
    );
  }

  final String step;
  final String? accessToken;
  final String? refreshToken;
  final int accessTokenExpiresInSeconds;
  final AuthUser? user;
  final String? challengeToken;
  final List<String> availableOtpChannels;

  bool get requiresPasswordChange => step == 'PASSWORD_CHANGE_REQUIRED';
  bool get requiresOtp => step == 'OTP_REQUIRED';
}

class RegistrationOtpResponse {
  const RegistrationOtpResponse({
    required this.challengeToken,
    required this.channel,
    required this.expiresInSeconds,
  });

  factory RegistrationOtpResponse.fromJson(Map<String, dynamic> json) {
    return RegistrationOtpResponse(
      challengeToken: json['challengeToken'] as String,
      channel: json['channel'] as String? ?? 'EMAIL',
      expiresInSeconds: (json['expiresInSeconds'] as num?)?.toInt() ?? 300,
    );
  }

  final String challengeToken;
  final String channel;
  final int expiresInSeconds;
}

class PasswordResetOtpResponse {
  const PasswordResetOtpResponse({
    required this.challengeToken,
    required this.expiresInSeconds,
  });

  factory PasswordResetOtpResponse.fromJson(Map<String, dynamic> json) {
    return PasswordResetOtpResponse(
      challengeToken: json['challengeToken'] as String,
      expiresInSeconds: (json['expiresInSeconds'] as num?)?.toInt() ?? 300,
    );
  }

  final String challengeToken;
  final int expiresInSeconds;
}

class CustomerRegistrationResult {
  const CustomerRegistrationResult({
    required this.organizationName,
    required this.organizationCode,
    this.registrationStatus,
    this.airspaceClassification,
    this.reviewMessage,
    this.user,
  });

  factory CustomerRegistrationResult.fromJson(Map<String, dynamic> json) {
    final userRaw = json['user'];
    return CustomerRegistrationResult(
      organizationName: json['organizationName'] as String? ?? '',
      organizationCode: json['organizationCode'] as String? ?? '',
      registrationStatus: json['registrationStatus'] as String?,
      airspaceClassification: json['airspaceClassification'] as String?,
      reviewMessage: json['reviewMessage'] as String?,
      user: userRaw is Map
          ? AuthUser.fromJson(Map<String, dynamic>.from(userRaw))
          : null,
    );
  }

  final String organizationName;
  final String organizationCode;
  final String? registrationStatus;
  final String? airspaceClassification;
  final String? reviewMessage;
  final AuthUser? user;

  bool get isPendingAirspaceReview => false;

  bool get isRestrictedAirspace =>
      airspaceClassification != null && airspaceClassification != 'CLEAR_ZONE';
}

/// Customer mobile authentication repository.
///
/// Uses bare `_dio` (refreshDioProvider) for `/mobile/auth/*` and CSRF-protected
/// `/auth/*` endpoints; uses authenticated `_authDio` (dioProvider) for `/users/me`
/// and authenticated security calls.
class AuthRepository {
  AuthRepository(this._dio, [Dio? authDio]) : _authDio = authDio ?? _dio;

  final Dio _dio;
  final Dio _authDio;

  Future<ApiResult<AuthFlow>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = kIsWeb
          ? await _postWithCsrf(
              _dio,
              '/auth/login',
              data: {'email': email, 'password': password},
            )
          : await _dio.post<Map<String, dynamic>>(
              '/mobile/auth/login',
              data: {'email': email, 'password': password},
            );
      return ApiResult.success(
        AuthFlow.fromJson(
          Map<String, dynamic>.from(response.data as Map),
          fallbackRefreshToken: kIsWeb ? webCookieSessionToken : null,
        ),
      );
    } on DioException catch (e) {
      return ApiResult.failure(mapDioError(e));
    }
  }

  Future<ApiResult<AuthFlow>> refresh({required String refreshToken}) async {
    try {
      final response = kIsWeb
          ? await _postWithCsrf(_dio, '/auth/refresh')
          : await _dio.post<Map<String, dynamic>>(
              '/mobile/auth/refresh',
              data: {'refreshToken': refreshToken},
            );
      return ApiResult.success(
        AuthFlow.fromJson(
          Map<String, dynamic>.from(response.data as Map),
          fallbackRefreshToken: kIsWeb ? webCookieSessionToken : null,
        ),
      );
    } on DioException catch (e) {
      return ApiResult.failure(mapDioError(e));
    }
  }

  Future<ApiResult<void>> logout({required String refreshToken}) async {
    try {
      if (kIsWeb) {
        await _postWithCsrf(_authDio, '/auth/logout');
      } else {
        await _dio.post<void>(
          '/mobile/auth/logout',
          data: {'refreshToken': refreshToken},
        );
      }
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
      final payload = {
        'email': email,
        'currentPassword': currentPassword,
        'password': newPassword,
      };
      final response = kIsWeb
          ? await _postWithCsrf(_dio, '/auth/password/setup', data: payload)
          : await _dio.post<Map<String, dynamic>>(
              '/mobile/auth/password/setup',
              data: payload,
            );
      return ApiResult.success(
        AuthFlow.fromJson(
          Map<String, dynamic>.from(response.data as Map),
          fallbackRefreshToken: kIsWeb ? webCookieSessionToken : null,
        ),
      );
    } on DioException catch (e) {
      return ApiResult.failure(mapDioError(e));
    }
  }

  Future<ApiResult<void>> sendLoginOtp({
    required String challengeToken,
    required String channel,
  }) async {
    try {
      await _postWithCsrf(
        _dio,
        '/auth/otp/send',
        data: {'challengeToken': challengeToken, 'channel': channel},
      );
      return const ApiResult.success(null);
    } on DioException catch (e) {
      return ApiResult.failure(mapDioError(e));
    }
  }

  Future<ApiResult<AuthFlow>> verifyLoginOtp({
    required String challengeToken,
    required String code,
  }) async {
    try {
      final response = await _postWithCsrf(
        _dio,
        '/auth/otp/verify',
        data: {'challengeToken': challengeToken, 'code': code},
      );
      final refreshFromCookie = _extractCookieValue(
        response.headers.map['set-cookie'],
        'sdi_refresh',
      );
      return ApiResult.success(
        AuthFlow.fromJson(
          Map<String, dynamic>.from(response.data as Map),
          fallbackRefreshToken: kIsWeb
              ? webCookieSessionToken
              : refreshFromCookie,
        ),
      );
    } on DioException catch (e) {
      return ApiResult.failure(mapDioError(e));
    }
  }

  Future<ApiResult<RegistrationOtpResponse>> sendRegistrationOtp({
    required String email,
    String? phoneNumber,
  }) async {
    try {
      final response = await _postWithCsrf(
        _dio,
        '/auth/registration/otp/send',
        data: {
          'email': email,
          'channel': 'EMAIL',
          if (phoneNumber != null && phoneNumber.isNotEmpty)
            'phoneNumber': phoneNumber,
        },
      );
      return ApiResult.success(
        RegistrationOtpResponse.fromJson(
          Map<String, dynamic>.from(response.data as Map),
        ),
      );
    } on DioException catch (e) {
      return ApiResult.failure(mapDioError(e));
    }
  }

  Future<ApiResult<CustomerRegistrationResult>> registerCustomer({
    required String fullName,
    required String email,
    required String password,
    String? phoneNumber,
    required String otpChallengeToken,
    required String otpCode,
  }) async {
    try {
      final orgCode = _deriveOrganizationCode(email);
      final response = await _postWithCsrf(
        _dio,
        '/auth/register',
        data: {
          'email': email,
          'fullName': fullName,
          if (phoneNumber != null && phoneNumber.isNotEmpty)
            'phoneNumber': phoneNumber,
          'organizationName': fullName,
          'organizationCode': orgCode,
          'password': password,
          'otpChallengeToken': otpChallengeToken,
          'otpCode': otpCode,
        },
      );
      return ApiResult.success(
        CustomerRegistrationResult.fromJson(
          Map<String, dynamic>.from(response.data as Map),
        ),
      );
    } on DioException catch (e) {
      return ApiResult.failure(mapDioError(e));
    }
  }

  Future<ApiResult<PasswordResetOtpResponse>> sendPasswordResetOtp({
    required String email,
  }) async {
    try {
      final response = await _postWithCsrf(
        _dio,
        '/auth/password-reset/otp/send',
        data: {'email': email},
      );
      return ApiResult.success(
        PasswordResetOtpResponse.fromJson(
          Map<String, dynamic>.from(response.data as Map),
        ),
      );
    } on DioException catch (e) {
      return ApiResult.failure(mapDioError(e));
    }
  }

  Future<ApiResult<void>> confirmPasswordReset({
    required String email,
    required String challengeToken,
    required String code,
    required String newPassword,
  }) async {
    try {
      await _postWithCsrf(
        _dio,
        '/auth/password-reset/confirm',
        data: {
          'email': email,
          'challengeToken': challengeToken,
          'code': code,
          'newPassword': newPassword,
        },
      );
      return const ApiResult.success(null);
    } on DioException catch (e) {
      return ApiResult.failure(mapDioError(e));
    }
  }

  Future<ApiResult<AuthUser>> fetchMe() async {
    try {
      final response = await _authDio.get<Map<String, dynamic>>('/users/me');
      return ApiResult.success(AuthUser.fromJson(response.data!));
    } on DioException catch (e) {
      return ApiResult.failure(mapDioError(e));
    }
  }

  Future<ApiResult<void>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      await _postWithCsrf(
        _authDio,
        '/auth/password/change',
        data: {'currentPassword': currentPassword, 'newPassword': newPassword},
      );
      return const ApiResult.success(null);
    } on DioException catch (e) {
      return ApiResult.failure(mapDioError(e));
    }
  }

  Future<ApiResult<void>> logoutAll() async {
    try {
      await _postWithCsrf(_authDio, '/auth/logout-all');
      return const ApiResult.success(null);
    } on DioException catch (e) {
      return ApiResult.failure(mapDioError(e));
    }
  }

  Future<Response<dynamic>> _postWithCsrf(
    Dio client,
    String path, {
    Object? data,
  }) async {
    final csrfResponse = await client.get<dynamic>(
      '/auth/csrf',
      options: Options(extra: const {'withCredentials': true}),
    );
    final csrfMap = csrfResponse.data is Map
        ? Map<String, dynamic>.from(csrfResponse.data as Map)
        : const <String, dynamic>{};
    final token = csrfMap['token']?.toString();
    final headerName = csrfMap['headerName']?.toString() ?? 'X-XSRF-TOKEN';
    final xsrfCookie = kIsWeb
        ? null
        : _extractCookieValue(
            csrfResponse.headers.map['set-cookie'],
            'XSRF-TOKEN',
          );
    final headers = <String, dynamic>{};
    if (token != null && token.isNotEmpty) {
      headers[headerName] = token;
    }
    if (!kIsWeb && xsrfCookie != null && xsrfCookie.isNotEmpty) {
      headers['Cookie'] = 'XSRF-TOKEN=$xsrfCookie';
    }
    return client.post<dynamic>(
      path,
      data: data,
      options: Options(
        headers: headers,
        extra: const {'withCredentials': true},
      ),
    );
  }

  String? _extractCookieValue(List<String>? setCookies, String name) {
    if (setCookies == null) return null;
    for (final raw in setCookies) {
      final firstPart = raw.split(';').first.trim();
      final prefix = '$name=';
      if (firstPart.startsWith(prefix)) {
        return firstPart.substring(prefix.length);
      }
    }
    return null;
  }

  String _deriveOrganizationCode(String email) {
    final local = email
        .split('@')
        .first
        .replaceAll(RegExp(r'[^A-Za-z0-9_-]'), '')
        .replaceAll(RegExp(r'^[^A-Za-z0-9]+'), '');
    final upper = local.isEmpty ? 'ORG' : local.toUpperCase();
    final prefix = upper.length > 20 ? upper.substring(0, 20) : upper;
    final suffix = DateTime.now().millisecondsSinceEpoch
        .toRadixString(36)
        .toUpperCase();
    return '${prefix}_$suffix';
  }
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(ref.watch(refreshDioProvider), ref.watch(dioProvider));
});

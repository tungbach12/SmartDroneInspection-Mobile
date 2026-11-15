import 'package:dio/dio.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'api_failure.freezed.dart';

const String customerOnlyErrorCode = 'CUSTOMER_ONLY_MOBILE';

/// Typed failure — mirrors ProblemDetails status codes.
@freezed
sealed class ApiFailure with _$ApiFailure {
  const factory ApiFailure.network() = NetworkFailure;
  const factory ApiFailure.validation(Map<String, String> errors) =
      ValidationFailure;
  const factory ApiFailure.unauthorized() = UnauthorizedFailure;
  const factory ApiFailure.forbidden([String? detail]) = ForbiddenFailure;
  const factory ApiFailure.notFound() = NotFoundFailure;
  const factory ApiFailure.server(int? status, String? detail) = ServerFailure;
  const factory ApiFailure.unknown(String message) = UnknownFailure;
}

class ApiFailureException implements Exception {
  const ApiFailureException(this.failure);

  final ApiFailure failure;

  @override
  String toString() => switch (failure) {
    NetworkFailure() => 'NetworkFailure',
    ValidationFailure(:final errors) => errors.values.join(' '),
    UnauthorizedFailure() => 'UnauthorizedFailure',
    ForbiddenFailure(:final detail) => detail ?? 'ForbiddenFailure',
    NotFoundFailure() => 'NotFoundFailure',
    ServerFailure(:final detail) => detail ?? 'ServerFailure',
    UnknownFailure(:final message) => message,
  };
}

extension ApiFailureMessage on ApiFailure {
  String get message => ApiFailureException(this).toString();
}

/// Maps DioException to typed ApiFailure (ProblemDetails-aware).
ApiFailure mapDioError(DioException e) => switch (e.type) {
  DioExceptionType.connectionTimeout ||
  DioExceptionType.connectionError ||
  DioExceptionType.sendTimeout ||
  DioExceptionType.receiveTimeout => const NetworkFailure(),
  _ => switch (e.response?.statusCode) {
    400 => ValidationFailure(_parseErrors(e.response?.data)),
    401 => const UnauthorizedFailure(),
    403 => ForbiddenFailure(_parseDetail(e.response?.data)),
    404 => const NotFoundFailure(),
    _ => ServerFailure(e.response?.statusCode, _parseDetail(e.response?.data)),
  },
};

Map<String, String> _parseErrors(dynamic data) {
  if (data is Map<String, dynamic> && data['errors'] is Map<String, dynamic>) {
    return (data['errors'] as Map<String, dynamic>).map(
      (key, value) =>
          MapEntry(key, value is List ? value.join('; ') : value.toString()),
    );
  }
  return {'': _parseDetail(data) ?? 'Validation failed'};
}

String? _parseDetail(dynamic data) {
  if (data is Map<String, dynamic>) {
    final detail = data['detail'] ?? data['message'] ?? data['title'];
    return detail is String && detail.trim().isNotEmpty ? detail : null;
  }
  return null;
}

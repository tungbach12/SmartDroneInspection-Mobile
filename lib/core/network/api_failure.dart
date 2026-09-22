import 'package:dio/dio.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'api_failure.freezed.dart';

/// Typed failure — mirrors ASP.NET ProblemDetails status codes.
@freezed
sealed class ApiFailure with _$ApiFailure {
  const factory ApiFailure.network() = NetworkFailure;
  const factory ApiFailure.validation(Map<String, String> errors) =
      ValidationFailure;
  const factory ApiFailure.unauthorized() = UnauthorizedFailure;
  const factory ApiFailure.notFound() = NotFoundFailure;
  const factory ApiFailure.server(int? status, String? detail) = ServerFailure;
  const factory ApiFailure.unknown(String message) = UnknownFailure;
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
    403 => const UnauthorizedFailure(),
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
    return (data['detail'] ?? data['title']) as String?;
  }
  return null;
}

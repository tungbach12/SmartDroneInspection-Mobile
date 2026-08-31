import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:smart_drone_inspection/core/network/api_failure.dart';

part 'api_result.freezed.dart';

/// Sealed result for API calls. Success carries data; Failure carries typed ApiFailure.
@freezed
sealed class ApiResult<T> with _$ApiResult<T> {
  const factory ApiResult.success(T data) = ApiSuccess<T>;
  const factory ApiResult.failure(ApiFailure failure) = ApiError<T>;
}

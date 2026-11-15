import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_drone_inspection/core/network/api_failure.dart';
import 'package:smart_drone_inspection/core/network/api_result.dart';
import 'package:smart_drone_inspection/core/network/providers.dart';
import 'package:smart_drone_inspection/features/contracts/domain/models/service_request.dart';

class ContractRepository {
  ContractRepository(this._dio);

  final Dio _dio;

  Future<ApiResult<List<ServiceRequest>>> listRequests() async {
    try {
      final response = await _dio.get<dynamic>('/contracts/requests');
      final list = response.data is List
          ? response.data as List<dynamic>
          : const <dynamic>[];
      return ApiResult.success(
        list
            .map(
              (e) =>
                  ServiceRequest.fromJson(Map<String, dynamic>.from(e as Map)),
            )
            .toList(),
      );
    } on DioException catch (e) {
      return ApiResult.failure(mapDioError(e));
    }
  }

  Future<ApiResult<ServiceRequest>> getRequest(String requestId) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '/contracts/requests/$requestId',
      );
      return ApiResult.success(ServiceRequest.fromJson(response.data!));
    } on DioException catch (e) {
      return ApiResult.failure(mapDioError(e));
    }
  }

  Future<ApiResult<ServiceRequest>> createRequest(
    CreateServiceRequestInput input,
  ) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/contracts/requests',
        data: input.toJson(),
      );
      return ApiResult.success(ServiceRequest.fromJson(response.data!));
    } on DioException catch (e) {
      return ApiResult.failure(mapDioError(e));
    }
  }

  Future<ApiResult<ServiceRequest>> acceptQuote({
    required String requestId,
    required int quoteRowVersion,
  }) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/contracts/requests/$requestId/accept',
        data: {'quoteRowVersion': quoteRowVersion},
      );
      return ApiResult.success(ServiceRequest.fromJson(response.data!));
    } on DioException catch (e) {
      return ApiResult.failure(mapDioError(e));
    }
  }

  Future<ApiResult<ServiceRequest>> postMessage({
    required String requestId,
    required String body,
  }) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/contracts/requests/$requestId/messages',
        data: {'body': body},
      );
      return ApiResult.success(ServiceRequest.fromJson(response.data!));
    } on DioException catch (e) {
      return ApiResult.failure(mapDioError(e));
    }
  }

  Future<ApiResult<ServiceRequest>> markMessagesRead(String requestId) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/contracts/requests/$requestId/messages/read',
      );
      return ApiResult.success(ServiceRequest.fromJson(response.data!));
    } on DioException catch (e) {
      return ApiResult.failure(mapDioError(e));
    }
  }

  Future<ApiResult<Uint8List>> downloadSignedContractBytes(
    String requestId,
  ) async {
    try {
      final response = await _dio.get<List<int>>(
        '/contracts/requests/$requestId/signed-contract',
        options: Options(responseType: ResponseType.bytes),
      );
      return ApiResult.success(
        Uint8List.fromList(response.data ?? const <int>[]),
      );
    } on DioException catch (e) {
      return ApiResult.failure(mapDioError(e));
    }
  }
}

final contractRepositoryProvider = Provider<ContractRepository>((ref) {
  return ContractRepository(ref.watch(dioProvider));
});

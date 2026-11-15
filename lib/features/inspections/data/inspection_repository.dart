import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_drone_inspection/core/network/api_failure.dart';
import 'package:smart_drone_inspection/core/network/api_result.dart';
import 'package:smart_drone_inspection/core/network/providers.dart';
import 'package:smart_drone_inspection/features/inspections/domain/models/inspection.dart';
import 'package:smart_drone_inspection/features/inspections/domain/models/inspection_evidence.dart';

class InspectionRepository {
  InspectionRepository(this._dio);

  final Dio _dio;

  Future<ApiResult<List<Inspection>>> listInspections({
    int page = 1,
    int pageSize = 50,
  }) async {
    try {
      final response = await _dio.get<dynamic>(
        '/inspections',
        queryParameters: {'page': page, 'pageSize': pageSize},
      );
      final raw = response.data;
      final List<dynamic> list;
      if (raw is Map && raw['items'] is List) {
        list = raw['items'] as List<dynamic>;
      } else if (raw is List) {
        list = raw;
      } else {
        list = const <dynamic>[];
      }
      return ApiResult.success(
        list
            .map(
              (e) => Inspection.fromJson(Map<String, dynamic>.from(e as Map)),
            )
            .toList(),
      );
    } on DioException catch (error) {
      return ApiResult.failure(mapDioError(error));
    }
  }

  Future<ApiResult<Inspection>> getInspection(String id) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>('/inspections/$id');
      return ApiResult.success(Inspection.fromJson(response.data!));
    } on DioException catch (error) {
      return ApiResult.failure(mapDioError(error));
    }
  }

  Future<ApiResult<InspectionWorkflowState>> getWorkflowState(
    String inspectionId,
  ) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '/inspections/$inspectionId/workflow-state',
      );
      return ApiResult.success(
        InspectionWorkflowState.fromJson(response.data!),
      );
    } on DioException catch (error) {
      return ApiResult.failure(mapDioError(error));
    }
  }

  Future<ApiResult<List<FieldSessionSummary>>> listFieldSessions(
    String inspectionId,
  ) async {
    try {
      final response = await _dio.get<dynamic>(
        '/inspections/$inspectionId/field-sessions',
      );
      final list = response.data is List
          ? response.data as List<dynamic>
          : const <dynamic>[];
      return ApiResult.success(
        list
            .map(
              (e) => FieldSessionSummary.fromJson(
                Map<String, dynamic>.from(e as Map),
              ),
            )
            .toList(),
      );
    } on DioException catch (error) {
      return ApiResult.failure(mapDioError(error));
    }
  }

  Future<ApiResult<List<InspectionEvidence>>> listEvidence(
    String inspectionId,
  ) async {
    try {
      final response = await _dio.get<dynamic>(
        '/inspections/$inspectionId/evidence',
      );
      final list = response.data is List
          ? response.data as List<dynamic>
          : const <dynamic>[];
      return ApiResult.success(
        list
            .map(
              (e) => InspectionEvidence.fromJson(
                Map<String, dynamic>.from(e as Map),
              ),
            )
            .toList(),
      );
    } on DioException catch (error) {
      return ApiResult.failure(mapDioError(error));
    }
  }

  Future<ApiResult<Uint8List>> downloadEvidenceBytes({
    required String inspectionId,
    required String evidenceId,
  }) async {
    try {
      final response = await _dio.get<List<int>>(
        '/inspections/$inspectionId/evidence/$evidenceId/content',
        options: Options(responseType: ResponseType.bytes),
      );
      return ApiResult.success(
        Uint8List.fromList(response.data ?? const <int>[]),
      );
    } on DioException catch (error) {
      return ApiResult.failure(mapDioError(error));
    }
  }

  Future<ApiResult<List<InspectionFinding>>> listFindings(
    String inspectionId,
  ) async {
    try {
      final response = await _dio.get<dynamic>(
        '/inspections/$inspectionId/findings',
      );
      final list = response.data is List
          ? response.data as List<dynamic>
          : const <dynamic>[];
      return ApiResult.success(
        list
            .map(
              (e) => InspectionFinding.fromJson(
                Map<String, dynamic>.from(e as Map),
              ),
            )
            .where((f) => !f.isDeleted)
            .toList(),
      );
    } on DioException catch (error) {
      return ApiResult.failure(mapDioError(error));
    }
  }

  Future<ApiResult<List<InspectionReportVersion>>> listReportVersions(
    String inspectionId,
  ) async {
    try {
      final response = await _dio.get<dynamic>(
        '/inspections/$inspectionId/report/versions',
      );
      final list = response.data is List
          ? response.data as List<dynamic>
          : const <dynamic>[];
      return ApiResult.success(
        list
            .map(
              (e) => InspectionReportVersion.fromJson(
                Map<String, dynamic>.from(e as Map),
              ),
            )
            .toList(),
      );
    } on DioException catch (error) {
      return ApiResult.failure(mapDioError(error));
    }
  }

  Future<ApiResult<ReportAiSummary>> getReportAiSummary({
    required String inspectionId,
    required String versionId,
  }) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '/inspections/$inspectionId/report/versions/$versionId/ai-summary',
      );
      return ApiResult.success(ReportAiSummary.fromJson(response.data!));
    } on DioException catch (error) {
      return ApiResult.failure(mapDioError(error));
    }
  }

  Future<ApiResult<Uint8List>> downloadOfficialReportPdf({
    required String inspectionId,
    required String versionId,
  }) async {
    try {
      final response = await _dio.get<List<int>>(
        '/inspections/$inspectionId/report/versions/$versionId/document',
        options: Options(responseType: ResponseType.bytes),
      );
      return ApiResult.success(
        Uint8List.fromList(response.data ?? const <int>[]),
      );
    } on DioException catch (error) {
      return ApiResult.failure(mapDioError(error));
    }
  }

  Future<ApiResult<void>> acceptReport({
    required String inspectionId,
    required String versionId,
  }) async {
    try {
      await _dio.post<void>(
        '/inspections/$inspectionId/report/versions/$versionId/accept',
      );
      return const ApiResult.success(null);
    } on DioException catch (error) {
      return ApiResult.failure(mapDioError(error));
    }
  }

  Future<ApiResult<void>> requestReportClarification({
    required String inspectionId,
    required String versionId,
    required String reason,
  }) async {
    try {
      await _dio.post<void>(
        '/inspections/$inspectionId/report/versions/$versionId/clarification',
        queryParameters: {'reason': reason},
      );
      return const ApiResult.success(null);
    } on DioException catch (error) {
      return ApiResult.failure(mapDioError(error));
    }
  }

  Future<ApiResult<ReportPaymentStatus>> getReportPaymentStatus(
    String inspectionId,
  ) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '/inspections/$inspectionId/report/payment-status',
      );
      return ApiResult.success(ReportPaymentStatus.fromJson(response.data!));
    } on DioException catch (error) {
      return ApiResult.failure(mapDioError(error));
    }
  }

  Future<ApiResult<PayosCheckoutDetails>> createPayosPaymentLink(
    String inspectionId,
  ) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/inspections/$inspectionId/payos/create-payment-link',
      );
      return ApiResult.success(PayosCheckoutDetails.fromJson(response.data!));
    } on DioException catch (error) {
      return ApiResult.failure(mapDioError(error));
    }
  }

  Future<ApiResult<VnpayCheckoutDetails>> createVnpayPaymentUrl(
    String inspectionId,
  ) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/inspections/$inspectionId/vnpay/create-payment-url',
      );
      return ApiResult.success(VnpayCheckoutDetails.fromJson(response.data!));
    } on DioException catch (error) {
      return ApiResult.failure(mapDioError(error));
    }
  }
}

final inspectionRepositoryProvider = Provider<InspectionRepository>((ref) {
  return InspectionRepository(ref.watch(dioProvider));
});

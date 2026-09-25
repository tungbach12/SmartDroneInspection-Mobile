import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_drone_inspection/core/network/api_failure.dart';
import 'package:smart_drone_inspection/core/network/api_result.dart';
import 'package:smart_drone_inspection/core/network/providers.dart';
import 'package:smart_drone_inspection/features/inspections/domain/models/inspection_assignment.dart';
import 'package:smart_drone_inspection/features/inspections/domain/models/inspection_checklist_item.dart';
import 'package:smart_drone_inspection/features/inspections/domain/models/inspection_evidence.dart';
import 'package:smart_drone_inspection/features/inspections/domain/models/started_inspection.dart';

class InspectionRepository {
  InspectionRepository(this._dio);

  final Dio _dio;

  Future<ApiResult<List<InspectionAssignment>>>
  listAcceptedAssignments() async {
    try {
      final response = await _dio.get(
        '/inspections/assignments',
        queryParameters: const {'status': 'ACCEPTED'},
      );
      final assignments = (response.data as List<dynamic>)
          .map(
            (item) =>
                InspectionAssignment.fromJson(item as Map<String, dynamic>),
          )
          .toList();
      return ApiResult.success(assignments);
    } on DioException catch (error) {
      return ApiResult.failure(mapDioError(error));
    }
  }

  Future<ApiResult<StartedInspection>> start(String assignmentId) async {
    try {
      final response = await _dio.post(
        '/inspections/start',
        data: {'assignmentId': assignmentId},
      );
      return ApiResult.success(
        StartedInspection.fromJson(response.data as Map<String, dynamic>),
      );
    } on DioException catch (error) {
      return ApiResult.failure(mapDioError(error));
    }
  }

  Future<ApiResult<List<InspectionChecklistItem>>> checklist(
    String inspectionId,
  ) async {
    try {
      final response = await _dio.get('/inspections/$inspectionId/checklist');
      final items = (response.data as List<dynamic>)
          .map(
            (item) => InspectionChecklistItem.fromJson(
              Map<String, dynamic>.from(item as Map),
            ),
          )
          .toList();
      return ApiResult.success(items);
    } on DioException catch (error) {
      return ApiResult.failure(mapDioError(error));
    }
  }

  Future<ApiResult<void>> saveChecklistResponse({
    required String inspectionId,
    required String itemId,
    required Map<String, dynamic> responseValue,
    String? notes,
  }) async {
    try {
      await _dio.put(
        '/inspections/$inspectionId/checklist-responses/$itemId',
        data: {'responseValue': responseValue, 'notes': notes},
      );
      return const ApiResult.success(null);
    } on DioException catch (error) {
      return ApiResult.failure(mapDioError(error));
    }
  }

  Future<ApiResult<List<InspectionEvidence>>> listEvidence(
    String inspectionId,
  ) async {
    try {
      final response = await _dio.get('/inspections/$inspectionId/evidence');
      final items = (response.data as List<dynamic>)
          .map(
            (item) => InspectionEvidence.fromJson(
              Map<String, dynamic>.from(item as Map),
            ),
          )
          .toList();
      return ApiResult.success(items);
    } on DioException catch (error) {
      return ApiResult.failure(mapDioError(error));
    }
  }

  Future<ApiResult<InspectionEvidence>> uploadEvidence({
    required String inspectionId,
    required XFile photo,
    required DateTime captureTime,
  }) async {
    try {
      final file = await MultipartFile.fromFile(
        photo.path,
        filename: photo.name,
      );
      final form = FormData.fromMap({
        'file': file,
        'source': 'MOBILE_UPLOAD',
        'captureTime': captureTime.toUtc().toIso8601String(),
      });
      final response = await _dio.post(
        '/inspections/$inspectionId/evidence',
        data: form,
      );
      return ApiResult.success(
        InspectionEvidence.fromJson(
          Map<String, dynamic>.from(response.data as Map),
        ),
      );
    } on DioException catch (error) {
      return ApiResult.failure(mapDioError(error));
    } on Exception catch (error) {
      return ApiResult.failure(ApiFailure.unknown(error.toString()));
    }
  }
}

final inspectionRepositoryProvider = Provider<InspectionRepository>((ref) {
  return InspectionRepository(ref.watch(dioProvider));
});

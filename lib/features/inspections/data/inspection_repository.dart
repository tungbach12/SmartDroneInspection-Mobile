import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smart_drone_inspection/core/network/api_failure.dart';
import 'package:smart_drone_inspection/core/network/api_result.dart';
import 'package:smart_drone_inspection/core/network/providers.dart';
import 'package:smart_drone_inspection/features/inspections/domain/models/field_session.dart';
import 'package:smart_drone_inspection/features/inspections/domain/models/inspection.dart';
import 'package:smart_drone_inspection/features/inspections/domain/models/inspection_evidence.dart';

class InspectionRepository {
  InspectionRepository(this._dio);

  final Dio _dio;

  /// Fetches inspections assigned to the current user.
  Future<ApiResult<List<Inspection>>> listInspections() async {
    try {
      final response = await _dio.get('/inspections');
      final inspections = (response.data as List<dynamic>)
          .map(
            (item) => Inspection.fromJson(
              Map<String, dynamic>.from(item as Map),
            ),
          )
          .toList();
      return ApiResult.success(inspections);
    } on DioException catch (error) {
      return ApiResult.failure(mapDioError(error));
    }
  }

  /// Fetches an individual inspection by ID.
  Future<ApiResult<Inspection>> getInspection(String id) async {
    try {
      final response = await _dio.get('/inspections/$id');
      return ApiResult.success(
        Inspection.fromJson(
          Map<String, dynamic>.from(response.data as Map),
        ),
      );
    } on DioException catch (error) {
      return ApiResult.failure(mapDioError(error));
    }
  }

  /// Uploads flight permit for an assigned inspection, transitioning ASSIGNED -> READY_FOR_FLIGHT.
  Future<ApiResult<Inspection>> uploadFlightPermit({
    required String inspectionId,
    required XFile file,
  }) async {
    try {
      final multipartFile = await MultipartFile.fromFile(
        file.path,
        filename: file.name,
      );
      final form = FormData.fromMap({
        'file': multipartFile,
      });
      final response = await _dio.post(
        '/inspections/$inspectionId/flight-permit',
        data: form,
      );
      return ApiResult.success(
        Inspection.fromJson(
          Map<String, dynamic>.from(response.data as Map),
        ),
      );
    } on DioException catch (error) {
      return ApiResult.failure(mapDioError(error));
    } on Exception catch (error) {
      return ApiResult.failure(ApiFailure.unknown(error.toString()));
    }
  }

  /// Starts a field session against the inspection.
  Future<ApiResult<FieldSession>> startFieldSession({
    required String inspectionId,
    required String preFlightChecklistNote,
  }) async {
    try {
      final response = await _dio.post(
        '/inspections/$inspectionId/field-sessions',
        data: {'preFlightChecklistNote': preFlightChecklistNote},
      );
      return ApiResult.success(
        FieldSession.fromJson(Map<String, dynamic>.from(response.data as Map)),
      );
    } on DioException catch (error) {
      return ApiResult.failure(mapDioError(error));
    }
  }

  Future<ApiResult<List<FieldSession>>> listFieldSessions(
    String inspectionId,
  ) async {
    try {
      final response = await _dio.get(
        '/inspections/$inspectionId/field-sessions',
      );
      final sessions = (response.data as List<dynamic>)
          .map(
            (item) =>
                FieldSession.fromJson(Map<String, dynamic>.from(item as Map)),
          )
          .toList();
      return ApiResult.success(sessions);
    } on DioException catch (error) {
      return ApiResult.failure(mapDioError(error));
    }
  }

  Future<ApiResult<FieldSession>> postponeFieldSession({
    required String inspectionId,
    required String sessionId,
    required String reason,
  }) async {
    try {
      final response = await _dio.post(
        '/inspections/$inspectionId/field-sessions/$sessionId/postponement',
        data: {'reason': reason},
      );
      return ApiResult.success(
        FieldSession.fromJson(Map<String, dynamic>.from(response.data as Map)),
      );
    } on DioException catch (error) {
      return ApiResult.failure(mapDioError(error));
    }
  }

  Future<ApiResult<FieldSession>> completeFieldSession({
    required String inspectionId,
    required String sessionId,
    required String outcomeNotes,
  }) async {
    try {
      final response = await _dio.post(
        '/inspections/$inspectionId/field-sessions/$sessionId/completion',
        data: {'outcomeNotes': outcomeNotes},
      );
      return ApiResult.success(
        FieldSession.fromJson(Map<String, dynamic>.from(response.data as Map)),
      );
    } on DioException catch (error) {
      return ApiResult.failure(mapDioError(error));
    }
  }

  Future<ApiResult<FieldSession>> abortFieldSession({
    required String inspectionId,
    required String sessionId,
    required String reason,
  }) async {
    try {
      final response = await _dio.post(
        '/inspections/$inspectionId/field-sessions/$sessionId/abort',
        data: {'reason': reason},
      );
      return ApiResult.success(
        FieldSession.fromJson(Map<String, dynamic>.from(response.data as Map)),
      );
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
    String? fieldSessionId,
  }) async {
    try {
      final file = await MultipartFile.fromFile(
        photo.path,
        filename: photo.name,
      );
      final form = FormData.fromMap({
        'file': file,
        'captureTime': captureTime.toUtc().toIso8601String(),
        'fieldSessionId': ?fieldSessionId,
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

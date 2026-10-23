import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_drone_inspection/core/network/api_failure.dart';
import 'package:smart_drone_inspection/core/network/api_result.dart';
import 'package:smart_drone_inspection/core/network/providers.dart';
import 'package:smart_drone_inspection/features/inspections/domain/models/field_session.dart';
import 'package:smart_drone_inspection/features/inspections/domain/models/inspection_checklist_item.dart';
import 'package:smart_drone_inspection/features/inspections/domain/models/inspection_evidence.dart';
import 'package:smart_drone_inspection/features/inspections/domain/models/inspection_preparation.dart';
import 'package:smart_drone_inspection/features/inspections/domain/models/inspector_assignment.dart';

class InspectionRepository {
  InspectionRepository(this._dio);

  final Dio _dio;

  /// MF2-01: the pairings an administrator opened for this Inspector that are still unanswered.
  ///
  /// Replaces `listAcceptedAssignments`, which called `/inspections/assignments` — an endpoint this
  /// backend does not have, so nothing could have called it successfully.
  Future<ApiResult<List<InspectorAssignment>>> listMyAssignments() async {
    try {
      final response = await _dio.get('/inspection-assignments/mine');
      final assignments = (response.data as List<dynamic>)
          .map(
            (item) => InspectorAssignment.fromJson(
              Map<String, dynamic>.from(item as Map),
            ),
          )
          .toList();
      return ApiResult.success(assignments);
    } on DioException catch (error) {
      return ApiResult.failure(mapDioError(error));
    }
  }

  /// MF2-02: recording the answer to a pairing.
  ///
  /// A decline needs a reason the Inspector writes, because only they know whether they lack a
  /// qualification, a date or a willingness. The server refuses a decline without one.
  Future<ApiResult<InspectorAssignment>> respondToAssignment({
    required String assignmentId,
    required String response,
    String? rejectionReason,
  }) async {
    try {
      final posted = await _dio.post(
        '/inspection-assignments/$assignmentId/response',
        data: {'response': response, 'rejectionReason': rejectionReason},
      );
      return ApiResult.success(
        InspectorAssignment.fromJson(
          Map<String, dynamic>.from(posted.data as Map),
        ),
      );
    } on DioException catch (error) {
      return ApiResult.failure(mapDioError(error));
    }
  }

  Future<ApiResult<List<InspectionPreparation>>> listPreparations(
    String inspectionId,
  ) async {
    try {
      final response = await _dio.get('/inspections/$inspectionId/preparation');
      final preparations = (response.data as List<dynamic>)
          .map(
            (item) => InspectionPreparation.fromJson(
              Map<String, dynamic>.from(item as Map),
            ),
          )
          .toList();
      return ApiResult.success(preparations);
    } on DioException catch (error) {
      return ApiResult.failure(mapDioError(error));
    }
  }

  Future<ApiResult<InspectionPreparation>> savePreparation({
    required String inspectionId,
    required String shotList,
    String? evidenceTypes,
    String? accessConstraints,
    String? safetyObservations,
    DateTime? plannedStartAt,
    DateTime? plannedEndAt,
  }) async {
    try {
      final response = await _dio.put(
        '/inspections/$inspectionId/preparation',
        data: {
          'shotList': shotList,
          'evidenceTypes': evidenceTypes,
          'accessConstraints': accessConstraints,
          'safetyObservations': safetyObservations,
          if (plannedStartAt != null)
            'plannedStartAt': plannedStartAt.toUtc().toIso8601String(),
          if (plannedEndAt != null)
            'plannedEndAt': plannedEndAt.toUtc().toIso8601String(),
        },
      );
      return ApiResult.success(
        InspectionPreparation.fromJson(
          Map<String, dynamic>.from(response.data as Map),
        ),
      );
    } on DioException catch (error) {
      return ApiResult.failure(mapDioError(error));
    }
  }

  Future<ApiResult<InspectionPreparation>> requestAdditionalSession({
    required String inspectionId,
    required String reason,
  }) async {
    try {
      final response = await _dio.post(
        '/inspections/$inspectionId/field-sessions/additional-session',
        data: {'reason': reason},
      );
      return ApiResult.success(
        InspectionPreparation.fromJson(
          Map<String, dynamic>.from(response.data as Map),
        ),
      );
    } on DioException catch (error) {
      return ApiResult.failure(mapDioError(error));
    }
  }

  Future<ApiResult<InspectionPreparation>> submitPreparation({
    required String inspectionId,
    required String preparationId,
    required String acknowledgment,
  }) async {
    try {
      final response = await _dio.post(
        '/inspections/$inspectionId/preparation/$preparationId/submission',
        data: {'acknowledgment': acknowledgment},
      );
      return ApiResult.success(
        InspectionPreparation.fromJson(
          Map<String, dynamic>.from(response.data as Map),
        ),
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

  /// MF2-10: starts a field session against the inspection's current approved readiness
  /// decision. The server re-checks that decision at the moment of the start rather than trusting
  /// it from when it was made, so a refusal here is the server catching a stale approval.
  Future<ApiResult<FieldSession>> startFieldSession({
    required String inspectionId,
    required String? checklistTemplateId,
    required String preFlightChecklistNote,
  }) async {
    try {
      final response = await _dio.post(
        '/inspections/$inspectionId/field-sessions',
        data: {
          'checklistTemplateId': checklistTemplateId,
          'preFlightChecklistNote': preFlightChecklistNote,
        },
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

  /// MF2-09: weather or site safety stopped the session. The inspection stays startable.
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

  /// MF2-12: records the completed field outcome and hands the inspection back to MF3.
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

  /// MF2-11: the session cannot continue. Distinct from a postponement, which the server treats as
  /// an attempt the organization may retry.
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

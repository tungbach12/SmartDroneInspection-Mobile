import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smart_drone_inspection/core/network/api_failure.dart';
import 'package:smart_drone_inspection/core/network/api_result.dart';
import 'package:smart_drone_inspection/core/network/providers.dart';
import 'package:smart_drone_inspection/features/tasks/domain/models/maintenance_task.dart';

class MaintenanceTaskRepository {
  MaintenanceTaskRepository(this._dio);

  final Dio _dio;

  Future<ApiResult<List<MaintenanceTask>>> listMyTasks() async {
    try {
      final response = await _dio.get('/maintenance-execution/my-assignments');
      final tasks = (response.data as List<dynamic>)
          .map((item) => MaintenanceTask.fromJson(item as Map<String, dynamic>))
          .toList();
      return ApiResult.success(tasks);
    } on DioException catch (error) {
      return ApiResult.failure(mapDioError(error));
    }
  }

  Future<ApiResult<String>> uploadEvidence({
    required String orderId,
    required String kind,
    required XFile photo,
  }) async {
    try {
      final bytes = await photo.readAsBytes();
      final formData = FormData.fromMap({
        'file': MultipartFile.fromBytes(
          bytes,
          filename: photo.name,
        ),
      });

      final response = await _dio.post(
        '/maintenance-execution/orders/$orderId/evidence',
        queryParameters: {'kind': kind},
        data: formData,
      );
      return ApiResult.success(response.data as String);
    } on DioException catch (error) {
      return ApiResult.failure(mapDioError(error));
    }
  }

  Future<ApiResult<String>> submitWorkLog({
    required String orderId,
    required String assignmentId,
    required String workSummary,
    required String materialsUsed,
    required double laborHours,
    required double progressPercent,
    required String beforeEvidenceId,
    required String afterEvidenceId,
  }) async {
    try {
      final response = await _dio.post(
        '/maintenance-execution/orders/$orderId/work-logs',
        data: {
          'executionAssignmentId': assignmentId,
          'startedAt': DateTime.now().subtract(const Duration(hours: 4)).toIso8601String(),
          'endedAt': DateTime.now().toIso8601String(),
          'progressPercent': progressPercent,
          'workSummary': workSummary,
          'materialsUsed': materialsUsed,
          'laborHours': laborHours,
          'beforeEvidenceId': beforeEvidenceId,
          'afterEvidenceId': afterEvidenceId,
        },
      );
      return ApiResult.success(response.data as String);
    } on DioException catch (error) {
      return ApiResult.failure(mapDioError(error));
    }
  }
}

final maintenanceTaskRepositoryProvider = Provider<MaintenanceTaskRepository>((ref) {
  return MaintenanceTaskRepository(ref.watch(dioProvider));
});

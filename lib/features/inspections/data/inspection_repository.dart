import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_drone_inspection/core/network/api_failure.dart';
import 'package:smart_drone_inspection/core/network/api_result.dart';
import 'package:smart_drone_inspection/core/network/providers.dart';
import 'package:smart_drone_inspection/features/inspections/domain/models/inspection_assignment.dart';
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
}

final inspectionRepositoryProvider = Provider<InspectionRepository>((ref) {
  return InspectionRepository(ref.watch(dioProvider));
});

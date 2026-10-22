import 'package:dio/dio.dart';
import 'package:smart_drone_inspection/core/network/api_failure.dart';
import 'package:smart_drone_inspection/core/network/api_result.dart';
import 'package:smart_drone_inspection/features/tasks/domain/models/mobile_task_item.dart';
import 'package:smart_drone_inspection/features/tasks/domain/models/mobile_work_log.dart';
import 'package:smart_drone_inspection/features/tasks/domain/models/mobile_work_order.dart';

class MaintenanceRepository {
  MaintenanceRepository(this._dio);

  final Dio _dio;

  /// Fetches work orders assigned to the logged-in engineer.
  Future<ApiResult<List<MobileWorkOrder>>> listMyWorkOrders() async {
    try {
      final response = await _dio.get('/maintenance/work-orders');
      final data = response.data;
      List<dynamic> rawList = [];
      if (data is Map && data['items'] is List) {
        rawList = data['items'] as List<dynamic>;
      } else if (data is List) {
        rawList = data;
      }
      final orders = rawList
          .map((item) => MobileWorkOrder.fromJson(Map<String, dynamic>.from(item as Map)))
          .toList();
      return ApiResult.success(orders);
    } on DioException catch (error) {
      return ApiResult.failure(mapDioError(error));
    }
  }

  /// Fetches a single work order header by ID.
  Future<ApiResult<MobileWorkOrder>> getWorkOrder(String workOrderId) async {
    try {
      final response = await _dio.get('/maintenance/work-orders/$workOrderId');
      final order = MobileWorkOrder.fromJson(Map<String, dynamic>.from(response.data as Map));
      return ApiResult.success(order);
    } on DioException catch (error) {
      return ApiResult.failure(mapDioError(error));
    }
  }

  /// Fetches the planned task list for a work order.
  Future<ApiResult<List<MobileTaskItem>>> getTasks(String workOrderId) async {
    try {
      final response = await _dio.get('/maintenance/work-orders/$workOrderId/tasks');
      final list = (response.data as List<dynamic>)
          .map((item) => MobileTaskItem.fromJson(Map<String, dynamic>.from(item as Map)))
          .toList();
      return ApiResult.success(list);
    } on DioException catch (error) {
      return ApiResult.failure(mapDioError(error));
    }
  }

  /// Fetches the recorded work logs for a work order.
  Future<ApiResult<List<MobileWorkLog>>> getWorkLogs(String workOrderId) async {
    try {
      final response = await _dio.get('/maintenance/work-orders/$workOrderId/work-logs');
      final list = (response.data as List<dynamic>)
          .map((item) => MobileWorkLog.fromJson(Map<String, dynamic>.from(item as Map)))
          .toList();
      return ApiResult.success(list);
    } on DioException catch (error) {
      return ApiResult.failure(mapDioError(error));
    }
  }

  /// Starts execution on an approved/ready work order.
  Future<ApiResult<void>> startWork(String workOrderId) async {
    try {
      await _dio.post('/maintenance/work-orders/$workOrderId/start');
      return const ApiResult.success(null);
    } on DioException catch (error) {
      return ApiResult.failure(mapDioError(error));
    }
  }

  /// Records hours and progress, then automatically submits the log for review.
  Future<ApiResult<void>> recordWorkLog({
    required String workOrderId,
    required String taskId,
    required double hours,
    String? asLeftCondition,
    String? testReadings,
  }) async {
    try {
      final now = DateTime.now();
      final started = now.subtract(Duration(minutes: (hours * 60).round()));

      final response = await _dio.post(
        '/maintenance/work-orders/$workOrderId/work-logs',
        data: {
          'taskId': taskId,
          'hours': hours,
          'startedAt': started.toIso8601String(),
          'endedAt': now.toIso8601String(),
          if (asLeftCondition != null && asLeftCondition.isNotEmpty)
            'asLeftCondition': asLeftCondition,
          if (testReadings != null && testReadings.isNotEmpty)
            'testReadings': testReadings,
        },
      );

      final logId = (response.data as Map)['id'] as String;
      await _dio.post('/maintenance/work-orders/$workOrderId/work-logs/$logId/submit');

      return const ApiResult.success(null);
    } on DioException catch (error) {
      return ApiResult.failure(mapDioError(error));
    }
  }

  /// Declares physical work complete (MF4-14).
  Future<ApiResult<void>> declareComplete(String workOrderId) async {
    try {
      await _dio.post('/maintenance/work-orders/$workOrderId/declare-complete');
      return const ApiResult.success(null);
    } on DioException catch (error) {
      return ApiResult.failure(mapDioError(error));
    }
  }
}

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_drone_inspection/core/network/api_failure.dart';
import 'package:smart_drone_inspection/core/network/api_result.dart';
import 'package:smart_drone_inspection/core/network/providers.dart';
import 'package:smart_drone_inspection/features/notifications/domain/models/app_notification.dart';

class NotificationRepository {
  NotificationRepository(this._dio);

  final Dio _dio;

  Future<ApiResult<List<AppNotification>>> list({
    int page = 1,
    int pageSize = 30,
    bool? unreadOnly,
  }) async {
    try {
      final response = await _dio.get<dynamic>(
        '/notifications',
        queryParameters: {
          'page': page,
          'pageSize': pageSize,
          'unreadOnly': ?unreadOnly,
        },
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
              (e) =>
                  AppNotification.fromJson(Map<String, dynamic>.from(e as Map)),
            )
            .toList(),
      );
    } on DioException catch (e) {
      return ApiResult.failure(mapDioError(e));
    }
  }

  Future<ApiResult<int>> getUnreadCount() async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '/notifications/unread-count',
      );
      final count = (response.data?['unreadCount'] as num?)?.toInt() ?? 0;
      return ApiResult.success(count);
    } on DioException catch (e) {
      return ApiResult.failure(mapDioError(e));
    }
  }

  Future<ApiResult<AppNotification>> markAsRead(String id) async {
    try {
      final response = await _dio.patch<Map<String, dynamic>>(
        '/notifications/$id/read',
      );
      return ApiResult.success(AppNotification.fromJson(response.data!));
    } on DioException catch (patchError) {
      if (patchError.response?.statusCode == 405 ||
          patchError.response?.statusCode == 403) {
        try {
          final response = await _dio.put<Map<String, dynamic>>(
            '/notifications/$id/read',
          );
          return ApiResult.success(AppNotification.fromJson(response.data!));
        } on DioException catch (putError) {
          return ApiResult.failure(mapDioError(putError));
        }
      }
      return ApiResult.failure(mapDioError(patchError));
    }
  }
}

final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  return NotificationRepository(ref.watch(dioProvider));
});

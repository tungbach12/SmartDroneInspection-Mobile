import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_drone_inspection/core/network/api_result.dart';
import 'package:smart_drone_inspection/features/notifications/data/notification_repository.dart';
import 'package:smart_drone_inspection/features/notifications/domain/models/app_notification.dart';

void main() {
  test(
    'resolveMobileNotificationRoute maps web paths to Customer mobile routes',
    () {
      expect(
        resolveMobileNotificationRoute('/client/requests/req-1'),
        '/requests/req-1',
      );
      expect(
        resolveMobileNotificationRoute('/client/requests/req-1?tab=chat'),
        '/requests/req-1/chat',
      );
      expect(
        resolveMobileNotificationRoute('/client/inspections/insp-42'),
        '/inspections/insp-42',
      );
      expect(
        resolveMobileNotificationRoute('/client/reports/insp-42'),
        '/inspections/insp-42?tab=1',
      );
      expect(
        resolveMobileNotificationRoute('/client/assets/asset-7'),
        '/assets/asset-7',
      );
      expect(resolveMobileNotificationRoute('/client/contracts'), '/requests');
      expect(resolveMobileNotificationRoute(''), isNull);
    },
  );

  test('NotificationRepository handles list pagination and PATCH->PUT markAsRead fallback', () async {
    final methods = <String>[];
    final dio = Dio(BaseOptions(baseUrl: 'https://api.example.test/api/v1'));
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          methods.add('${options.method} ${options.path}');
          if (options.method == 'GET' && options.path == '/notifications') {
            handler.resolve(
              Response(
                requestOptions: options,
                statusCode: 200,
                data: {
                  'items': [
                    {
                      'id': 'n-1',
                      'eventType': 'REPORT_PUBLISHED',
                      'title': 'Official Report Published',
                      'body': 'Report v1 is ready for review.',
                      'targetPath': '/client/reports/insp-1',
                      'status': 'SENT',
                      'createdAt': '2026-10-03T12:00:00Z',
                    },
                  ],
                },
              ),
            );
            return;
          }
          if (options.method == 'PATCH' &&
              options.path == '/notifications/n-1/read') {
            handler.reject(
              DioException(
                requestOptions: options,
                type: DioExceptionType.badResponse,
                response: Response(requestOptions: options, statusCode: 405),
              ),
            );
            return;
          }
          if (options.method == 'PUT' &&
              options.path == '/notifications/n-1/read') {
            handler.resolve(
              Response(
                requestOptions: options,
                statusCode: 200,
                data: {
                  'id': 'n-1',
                  'eventType': 'REPORT_PUBLISHED',
                  'title': 'Official Report Published',
                  'body': 'Report v1 is ready for review.',
                  'targetPath': '/client/reports/insp-1',
                  'status': 'READ',
                  'readAt': '2026-10-03T12:05:00Z',
                  'createdAt': '2026-10-03T12:00:00Z',
                },
              ),
            );
            return;
          }
          handler.reject(DioException(requestOptions: options));
        },
      ),
    );
    final repo = NotificationRepository(dio);

    final listRes = await repo.list();
    final items = (listRes as ApiSuccess<List<AppNotification>>).data;
    expect(items, hasLength(1));
    expect(items.first.read, isFalse);

    final markRes = await repo.markAsRead('n-1');
    expect((markRes as ApiSuccess<AppNotification>).data.read, isTrue);
    expect(methods, [
      'GET /notifications',
      'PATCH /notifications/n-1/read',
      'PUT /notifications/n-1/read',
    ]);
  });
}

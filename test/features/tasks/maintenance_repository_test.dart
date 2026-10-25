import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_drone_inspection/core/network/api_result.dart';
import 'package:smart_drone_inspection/features/tasks/data/maintenance_repository.dart';
import 'package:smart_drone_inspection/features/tasks/domain/models/mobile_task_item.dart';
import 'package:smart_drone_inspection/features/tasks/domain/models/mobile_work_log.dart';
import 'package:smart_drone_inspection/features/tasks/domain/models/mobile_work_order.dart';

void main() {
  late Dio dio;
  late MaintenanceRepository repository;
  late List<RequestOptions> requests;

  Map<String, dynamic> sampleWorkOrder() => {
        'id': 'wo-12345678-abcd',
        'assetId': 'asset-1',
        'status': 'READY',
        'priority': 'HIGH',
        'correctiveScope': 'Repair cracked beam',
        'acceptanceCriteria': 'Pass ultrasonic inspection',
        'dueAt': null,
        'createdAt': '2026-10-15T00:00:00Z',
      };

  Map<String, dynamic> sampleTask() => {
        'id': 'task-1',
        'taskNumber': 1,
        'name': 'Surface prep and weld',
        'method': 'MIG welding',
        'status': 'PLANNED',
      };

  Map<String, dynamic> sampleWorkLog() => {
        'id': 'log-1',
        'taskId': 'task-1',
        'engineerUserId': 'eng-1',
        'startedAt': '2026-10-15T08:00:00Z',
        'endedAt': '2026-10-15T10:30:00Z',
        'hours': 2.5,
        'asLeftCondition': 'Clean and welded',
        'testReadings': 'UPV >= 90%',
        'status': 'SUBMITTED',
      };

  setUp(() {
    requests = [];
    dio = Dio(BaseOptions(baseUrl: 'https://api.example.test/api/v1'));
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          requests.add(options);
          if (options.path.endsWith('/tasks')) {
            handler.resolve(
              Response(
                requestOptions: options,
                statusCode: 200,
                data: [sampleTask()],
              ),
            );
            return;
          }
          if (options.path.endsWith('/work-logs') && options.method == 'GET') {
            handler.resolve(
              Response(
                requestOptions: options,
                statusCode: 200,
                data: [sampleWorkLog()],
              ),
            );
            return;
          }
          if (options.path.endsWith('/work-logs') && options.method == 'POST') {
            handler.resolve(
              Response(
                requestOptions: options,
                statusCode: 200,
                data: {'id': 'log-new-1'},
              ),
            );
            return;
          }
          if (options.path.contains('/submit') ||
              options.path.contains('/verify') ||
              options.path.endsWith('/release') ||
              options.path.endsWith('/start') ||
              options.path.endsWith('/resume-after-rework') ||
              options.path.endsWith('/declare-complete')) {
            handler.resolve(
              Response(
                requestOptions: options,
                statusCode: 200,
                data: {'success': true},
              ),
            );
            return;
          }
          handler.resolve(
            Response(
              requestOptions: options,
              statusCode: 200,
              data: {
                'items': [sampleWorkOrder()],
                'page': 0,
                'size': 20,
                'total': 1,
              },
            ),
          );
        },
      ),
    );
    repository = MaintenanceRepository(dio);
  });

  tearDown(() => dio.close(force: true));

  test('listMyWorkOrders fetches and parses assigned work orders', () async {
    final result = await repository.listMyWorkOrders();

    expect(result, isA<ApiSuccess<List<MobileWorkOrder>>>());
    final orders = (result as ApiSuccess<List<MobileWorkOrder>>).data;
    expect(orders.length, 1);
    expect(orders.first.id, 'wo-12345678-abcd');
    expect(orders.first.priority, 'HIGH');
    expect(orders.first.isReady, isTrue);
    expect(requests.first.path, '/maintenance/work-orders');
  });

  test('getTasks fetches task list for an order', () async {
    final result = await repository.getTasks('wo-1');

    expect(result, isA<ApiSuccess<List<MobileTaskItem>>>());
    final tasks = (result as ApiSuccess<List<MobileTaskItem>>).data;
    expect(tasks.length, 1);
    expect(tasks.first.name, 'Surface prep and weld');
    expect(tasks.first.taskNumber, 1);
    expect(tasks.first.status, 'PLANNED');
  });

  test('getWorkLogs parses streamlined WorkLogResponse payload', () async {
    final result = await repository.getWorkLogs('wo-1');

    expect(result, isA<ApiSuccess<List<MobileWorkLog>>>());
    final logs = (result as ApiSuccess<List<MobileWorkLog>>).data;
    expect(logs.length, 1);
    expect(logs.first.id, 'log-1');
    expect(logs.first.workHours, 2.5);
    expect(logs.first.status, 'SUBMITTED');
  });

  test('startWork sends POST request to start endpoint', () async {
    final result = await repository.startWork('wo-123');

    expect(result, isA<ApiSuccess<void>>());
    expect(requests.last.path, '/maintenance/work-orders/wo-123/start');
    expect(requests.last.method, 'POST');
  });

  test('recordWorkLog posts new log and submits it', () async {
    final result = await repository.recordWorkLog(
      workOrderId: 'wo-123',
      taskId: 'task-1',
      hours: 2.5,
      asLeftCondition: 'Clean and welded',
      testReadings: 'Passed',
    );

    expect(result, isA<ApiSuccess<void>>());
    expect(
        requests
            .any((r) => r.path == '/maintenance/work-orders/wo-123/work-logs'),
        isTrue);
    expect(
      requests.any((r) =>
          r.path ==
          '/maintenance/work-orders/wo-123/work-logs/log-new-1/submit'),
      isTrue,
    );
  });

  test('declareComplete sends POST request to declare-complete endpoint',
      () async {
    final result = await repository.declareComplete('wo-123');

    expect(result, isA<ApiSuccess<void>>());
    expect(
        requests.last.path, '/maintenance/work-orders/wo-123/declare-complete');
    expect(requests.last.method, 'POST');
  });

  test(
      'releaseWork, verifyWorkLog and resumeAfterRework call their named endpoints',
      () async {
    expect(await repository.releaseWork('wo-123'), isA<ApiSuccess<void>>());
    expect(requests.last.path, '/maintenance/work-orders/wo-123/release');

    expect(await repository.verifyWorkLog('wo-123', 'log-1'),
        isA<ApiSuccess<void>>());
    expect(requests.last.path,
        '/maintenance/work-orders/wo-123/work-logs/log-1/verify');

    expect(
        await repository.resumeAfterRework('wo-123'), isA<ApiSuccess<void>>());
    expect(requests.last.path,
        '/maintenance/work-orders/wo-123/resume-after-rework');
  });
}

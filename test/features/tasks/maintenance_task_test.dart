import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_drone_inspection/core/network/api_result.dart';
import 'package:smart_drone_inspection/features/tasks/data/maintenance_task_repository.dart';
import 'package:smart_drone_inspection/features/tasks/domain/models/maintenance_task.dart';

void main() {
  test('maps maintenance task response correctly from json', () {
    final task = MaintenanceTask.fromJson({
      'id': 'task-100',
      'maintenanceTicketId': 'ticket-200',
      'maintenanceOrderId': 'order-300',
      'engineerUserId': 'eng-400',
      'assignedByUserId': 'pm-500',
      'assignmentType': 'EXECUTION',
      'status': 'PENDING',
      'deadline': '2026-11-01T12:00:00Z',
      'respondedAt': null,
      'rejectionReason': null,
      'createdAt': '2026-10-06T08:00:00Z',
    });

    expect(task.id, 'task-100');
    expect(task.maintenanceTicketId, 'ticket-200');
    expect(task.maintenanceOrderId, 'order-300');
    expect(task.assignmentType, 'EXECUTION');
    expect(task.status, 'PENDING');
    expect(task.deadline, '2026-11-01T12:00:00Z');
  });

  test('listMyTasks returns success with mapped task list', () async {
    final dio = Dio(BaseOptions(baseUrl: 'https://api.example.test/api/v1'));
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          handler.resolve(
            Response(
              requestOptions: options,
              statusCode: 200,
              data: [
                {
                  'id': 'task-1',
                  'maintenanceTicketId': 'ticket-1',
                  'maintenanceOrderId': 'order-1',
                  'engineerUserId': 'eng-1',
                  'assignedByUserId': 'pm-1',
                  'assignmentType': 'EXECUTION',
                  'status': 'PENDING',
                  'deadline': null,
                  'respondedAt': null,
                  'rejectionReason': null,
                  'createdAt': '2026-10-06T08:00:00Z',
                },
              ],
            ),
          );
        },
      ),
    );

    final repository = MaintenanceTaskRepository(dio);
    final result = await repository.listMyTasks();

    expect(result, isA<ApiSuccess<List<MaintenanceTask>>>());
    final tasks = (result as ApiSuccess<List<MaintenanceTask>>).data;
    expect(tasks.length, 1);
    expect(tasks.first.id, 'task-1');
  });
}

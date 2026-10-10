import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_drone_inspection/core/network/api_failure.dart';
import 'package:smart_drone_inspection/core/network/api_result.dart';
import 'package:smart_drone_inspection/features/inspections/data/inspection_repository.dart';
import 'package:smart_drone_inspection/features/inspections/domain/models/inspector_assignment.dart';

void main() {
  late Dio dio;
  late InspectionRepository repository;
  late List<RequestOptions> requests;

  setUp(() {
    requests = [];
    dio = Dio(BaseOptions(baseUrl: 'https://api.example.test/api/v1'));
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          requests.add(options);
          if (options.method == 'GET') {
            handler.resolve(
              Response(
                requestOptions: options,
                statusCode: 200,
                data: [_assignment()],
              ),
            );
            return;
          }
          handler.resolve(
            Response(
              requestOptions: options,
              statusCode: 200,
              data: {
                ..._assignment(),
                'assignmentResponse': options.data['response'] == 'ACCEPTED'
                    ? 'ACCEPTED'
                    : 'REJECTED',
                'reason': options.data['rejectionReason'],
              },
            ),
          );
        },
      ),
    );
    repository = InspectionRepository(dio);
  });

  tearDown(() => dio.close(force: true));

  test(
    'lists the pairings an administrator opened for this inspector',
    () async {
      final result = await repository.listMyAssignments();

      expect(result, isA<ApiSuccess<List<InspectorAssignment>>>());
      final assignment =
          (result as ApiSuccess<List<InspectorAssignment>>).data.single;
      expect(assignment.assetName, 'Sung Han Bridge');
      expect(assignment.droneSerialNumber, 'DJI-M350-001');
      expect(assignment.assignmentResponse, isNull);

      expect(requests.single.method, 'GET');
      expect(requests.single.path, '/inspection-assignments/mine');
    },
  );

  test('accepts a pairing without a reason', () async {
    final result = await repository.respondToAssignment(
      assignmentId: 'assignment-1',
      response: 'ACCEPTED',
    );

    expect(
      (result as ApiSuccess<InspectorAssignment>).data.assignmentResponse,
      'ACCEPTED',
    );
    expect(requests.single.method, 'POST');
    expect(
      requests.single.path,
      '/inspection-assignments/assignment-1/response',
    );
    expect((requests.single.data as Map)['response'], 'ACCEPTED');
  });

  test('sends the inspector-written reason when declining', () async {
    await repository.respondToAssignment(
      assignmentId: 'assignment-1',
      response: 'REJECTED',
      rejectionReason: 'No night-flight qualification',
    );

    expect(
      (requests.single.data as Map)['rejectionReason'],
      'No night-flight qualification',
    );
  });

  test('maps a refused response onto the server reason', () async {
    dio.interceptors.clear();
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          requests.add(options);
          handler.reject(
            DioException(
              requestOptions: options,
              response: Response(
                requestOptions: options,
                statusCode: 409,
                data: {
                  'code': 'ASSIGNMENT_NOT_ACTIVE',
                  'detail': 'This assignment is no longer open for a response.',
                },
              ),
            ),
          );
        },
      ),
    );

    final result = await repository.respondToAssignment(
      assignmentId: 'assignment-1',
      response: 'ACCEPTED',
    );

    expect(result, isA<ApiError>());
    final failure = (result as ApiError).failure as ServerFailure;
    expect(failure.status, 409);
    expect(failure.detail, contains('no longer open for a response'));
  });

  test(
    'maps a cross-tenant pairing read to not found rather than an empty list',
    () async {
      dio.interceptors.clear();
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            requests.add(options);
            handler.reject(
              DioException(
                requestOptions: options,
                response: Response(
                  requestOptions: options,
                  statusCode: 404,
                  data: const {'code': 'ASSIGNMENT_NOT_FOUND'},
                ),
              ),
            );
          },
        ),
      );

      final result = await repository.listMyAssignments();

      expect((result as ApiError).failure, isA<NotFoundFailure>());
    },
  );
}

Map<String, dynamic> _assignment() => {
  'id': 'assignment-1',
  'organizationId': 'org-1',
  'assetId': 'asset-1',
  'assetName': 'Sung Han Bridge',
  'inspectorUserId': 'inspector-1',
  'droneId': 'drone-1',
  'droneSerialNumber': 'DJI-M350-001',
  'droneServiceability': 'ACTIVE',
  'validFrom': '2026-11-01T00:00:00Z',
  'validUntil': '2026-11-30T00:00:00Z',
  'status': 'ACTIVE',
  'reason': null,
  'assignmentResponse': null,
  'respondedAt': null,
  'assignedAt': '2026-10-09T09:00:00Z',
};

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_drone_inspection/core/network/api_failure.dart';
import 'package:smart_drone_inspection/core/network/api_result.dart';
import 'package:smart_drone_inspection/features/inspections/data/inspection_repository.dart';
import 'package:smart_drone_inspection/features/inspections/domain/models/field_session.dart';

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
                data: [_sessionToJson('IN_PROGRESS')],
              ),
            );
            return;
          }
          final status = options.path.endsWith('/postponement')
              ? 'POSTPONED'
              : options.path.endsWith('/abort')
              ? 'ABORTED'
              : 'IN_PROGRESS';
          handler.resolve(
            Response(
              requestOptions: options,
              statusCode: 200,
              data: _sessionToJson(status),
            ),
          );
        },
      ),
    );
    repository = InspectionRepository(dio);
  });

  tearDown(() => dio.close(force: true));

  test(
    'starts a field session against the current readiness decision',
    () async {
      final result = await repository.startFieldSession(
        inspectionId: 'inspection-1',
        checklistTemplateId: null,
        preFlightChecklistNote: 'Drone identified; bridge accessible',
      );

      expect(result, isA<ApiSuccess<FieldSession>>());
      final session = (result as ApiSuccess<FieldSession>).data;
      expect(session.status, 'IN_PROGRESS');
      expect(session.readinessDecisionId, 'decision-1');
      expect(session.isOpen, isTrue);

      expect(requests.single.method, 'POST');
      expect(requests.single.path, '/inspections/inspection-1/field-sessions');
      expect(
        (requests.single.data
            as Map<String, dynamic>)['preFlightChecklistNote'],
        'Drone identified; bridge accessible',
      );
    },
  );

  test('lists the sessions of an inspection', () async {
    final result = await repository.listFieldSessions('inspection-1');

    expect(result, isA<ApiSuccess<List<FieldSession>>>());
    expect(
      (result as ApiSuccess<List<FieldSession>>).data.single.id,
      'session-1',
    );
    expect(requests.single.method, 'GET');
  });

  test('posts a postponement with its reason', () async {
    final result = await repository.postponeFieldSession(
      inspectionId: 'inspection-1',
      sessionId: 'session-1',
      reason: 'High wind above 10 m/s',
    );

    expect((result as ApiSuccess<FieldSession>).data.status, 'POSTPONED');
    expect(
      requests.single.path,
      contains('/field-sessions/session-1/postponement'),
    );
    expect(
      (requests.single.data as Map<String, dynamic>)['reason'],
      'High wind above 10 m/s',
    );
  });

  test(
    'aborts through its own endpoint rather than the postponement one',
    () async {
      final result = await repository.abortFieldSession(
        inspectionId: 'inspection-1',
        sessionId: 'session-1',
        reason: 'Structure found unsafe on site',
      );

      expect((result as ApiSuccess<FieldSession>).data.status, 'ABORTED');
      expect(requests.single.path, contains('/field-sessions/session-1/abort'));
    },
  );

  test('names both the inspection and the session when closing one', () async {
    await repository.postponeFieldSession(
      inspectionId: 'inspection-1',
      sessionId: 'session-1',
      reason: 'Wind',
    );

    // The inspection id is part of the path, so a session of another inspection cannot be closed
    // through this one.
    expect(
      requests.single.path,
      '/inspections/inspection-1/field-sessions/session-1/postponement',
    );
  });

  test('maps a refused start onto the server reason', () async {
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
                  'code': 'READINESS_NOT_APPROVED',
                  'detail': 'No current approved readiness decision covers this inspection.',
                },
              ),
            ),
          );
        },
      ),
    );

    final result = await repository.startFieldSession(
      inspectionId: 'inspection-1',
      checklistTemplateId: null,
      preFlightChecklistNote: 'Ready',
    );

    expect(result, isA<ApiError>());
    // A business-rule refusal arrives as a server failure carrying the Problem Details detail, so
    // the field screen can show the server's own wording rather than a generic message.
    final failure = (result as ApiError).failure;
    expect(failure, isA<ServerFailure>());
    final server = failure as ServerFailure;
    expect(server.status, 409);
    expect(server.detail, contains('No current approved readiness decision'));
  });
}

Map<String, dynamic> _sessionToJson(String status) => {
  'id': 'session-1',
  'inspectionId': 'inspection-1',
  'organizationId': 'org-1',
  'inspectorUserId': 'inspector-1',
  'droneId': 'drone-1',
  'readinessDecisionId': 'decision-1',
  'checklistTemplateId': null,
  'readinessVersion': 1,
  'status': status,
  'startedAt': '2026-11-01T09:05:00Z',
  'endedAt': status == 'IN_PROGRESS' ? null : '2026-11-01T09:30:00Z',
  'postponementReason': status == 'POSTPONED' ? 'High wind above 10 m/s' : null,
  'abortReason': status == 'ABORTED' ? 'Structure found unsafe on site' : null,
};

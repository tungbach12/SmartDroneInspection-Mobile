import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smart_drone_inspection/core/network/api_result.dart';
import 'package:smart_drone_inspection/features/inspections/data/inspection_repository.dart';

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
          if (options.path.endsWith('/checklist')) {
            handler.resolve(
              Response(
                requestOptions: options,
                statusCode: 200,
                data: [
                  {
                    'itemId': 'item-1',
                    'itemCode': 'SURFACE',
                    'sectionName': 'Deck',
                    'prompt': 'Check deck condition',
                    'responseType': 'PASS_FAIL',
                    'required': true,
                    'displayOrder': 0,
                    'guidance': null,
                    'validationConfig': null,
                    'responseValue': null,
                    'notes': null,
                    'completedAt': null,
                  },
                ],
              ),
            );
            return;
          }
          if (options.method == 'PUT') {
            handler.resolve(
              Response(requestOptions: options, statusCode: 200, data: {}),
            );
            return;
          }
          if (options.method == 'POST') {
            if (options.path.endsWith('/additional-session')) {
              handler.resolve(
                Response(
                  requestOptions: options,
                  statusCode: 200,
                  data: _preparationResponse(),
                ),
              );
              return;
            }
            handler.resolve(
              Response(
                requestOptions: options,
                statusCode: 201,
                data: _evidenceResponse(),
              ),
            );
            return;
          }
          handler.resolve(
            Response(
              requestOptions: options,
              statusCode: 200,
              data: options.path.endsWith('/evidence')
                  ? [_evidenceResponse(retiredAt: '2026-09-25T08:30:00Z')]
                  : [],
            ),
          );
        },
      ),
    );
    repository = InspectionRepository(dio);
  });

  tearDown(() => dio.close(force: true));

  test(
    'loads and saves checklist responses through the scoped API contract',
    () async {
      final checklist = await repository.checklist('inspection-1');
      expect(checklist, isA<ApiSuccess>());
      expect(
        (checklist as ApiSuccess).data.single.prompt,
        'Check deck condition',
      );

      final result = await repository.saveChecklistResponse(
        inspectionId: 'inspection-1',
        itemId: 'item-1',
        responseValue: {'value': 'PASS'},
        notes: 'No visible crack',
      );
      expect(result, isA<ApiSuccess<void>>());
      expect(requests.map((request) => request.method), ['GET', 'PUT']);
      expect(
        requests.last.path,
        '/inspections/inspection-1/checklist-responses/item-1',
      );
      expect(requests.last.data, {
        'responseValue': {'value': 'PASS'},
        'notes': 'No visible crack',
      });
    },
  );

  test(
    'requests an additional field session through MF2 preparation',
    () async {
      final result = await repository.requestAdditionalSession(
        inspectionId: 'inspection-1',
        reason: 'The east face was not covered during the completed session.',
      );

      expect(result, isA<ApiSuccess>());
      expect((result as ApiSuccess).data.preparationVersion, 2);
      expect(requests.single.method, 'POST');
      expect(
        requests.single.path,
        '/inspections/inspection-1/field-sessions/additional-session',
      );
      expect(requests.single.data, {
        'reason': 'The east face was not covered during the completed session.',
      });
    },
  );

  test('parses evidence responses without retired API fields and retains retiredAt', () async {
    final result = await repository.listEvidence('inspection-1');

    expect(result, isA<ApiSuccess>());
    final evidence = (result as ApiSuccess).data.single;
    expect(evidence.retiredAt, '2026-09-25T08:30:00Z');
    expect(evidence.toJson().keys, contains('retiredAt'));
    expect(evidence.toJson().keys, isNot(contains('checksumSha256')));
    expect(evidence.toJson().keys, isNot(contains('source')));
    expect(evidence.toJson().keys, isNot(contains('externalReference')));
    expect(evidence.toJson().keys, isNot(contains('uploadedByUserId')));
    expect(evidence.toJson().keys, isNot(contains('retiredByUserId')));
    expect(evidence.toJson().keys, isNot(contains('retirementReason')));
  });

  test('uploads a captured file as multipart without a source field', () async {
    final directory = await Directory.systemTemp.createTemp(
      'inspection-photo-',
    );
    addTearDown(() => directory.delete(recursive: true));
    final photoPath =
        '${directory.path}${Platform.pathSeparator}north-span.jpg';
    await File(photoPath).writeAsBytes([0xff, 0xd8, 0xff, 0xd9]);
    final capturedAt = DateTime.utc(2026, 9, 24, 8, 30);

    final result = await repository.uploadEvidence(
      inspectionId: 'inspection-1',
      photo: XFile(photoPath, name: 'north-span.jpg'),
      captureTime: capturedAt,
    );

    expect(result, isA<ApiSuccess>());
    final request = requests.single;
    expect(request.method, 'POST');
    expect(request.path, '/inspections/inspection-1/evidence');
    final form = request.data as FormData;
    expect(form.fields.map((entry) => entry.key), isNot(contains('source')));
    expect(
      form.fields.any(
        (entry) =>
            entry.key == 'captureTime' &&
            entry.value == capturedAt.toIso8601String(),
      ),
      isTrue,
    );
    expect(form.files.single.key, 'file');
    expect(form.files.single.value.filename, 'north-span.jpg');
  });
}

Map<String, dynamic> _evidenceResponse({String? retiredAt}) => {
  'id': 'evidence-1',
  'inspectionId': 'inspection-1',
  'fieldSessionId': null,
  'fileName': 'north-span.jpg',
  'contentType': 'image/jpeg',
  'sizeBytes': 4,
  'captureTime': '2026-09-24T08:30:00Z',
  'latitude': null,
  'longitude': null,
  'uploadStatus': 'AVAILABLE',
  'createdAt': '2026-09-24T08:30:01Z',
  'retiredAt': retiredAt,
};

Map<String, dynamic> _preparationResponse() => {
  'id': 'preparation-2',
  'inspectionId': 'inspection-1',
  'inspectorUserId': 'inspector-1',
  'preparationVersion': 2,
  'plannedStartAt': '2026-11-01T09:00:00Z',
  'plannedEndAt': '2026-11-01T10:00:00Z',
  'shotList': '{"areas": ["east face"]}',
  'evidenceTypes': null,
  'accessConstraints': null,
  'safetyObservations': null,
  'permitDocumentReferences': null,
  'status': 'DRAFT',
  'submittedAt': null,
  'createdAt': '2026-10-12T00:00:00Z',
  'updatedAt': '2026-10-12T00:00:00Z',
};

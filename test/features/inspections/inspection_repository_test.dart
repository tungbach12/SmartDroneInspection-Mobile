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
            Response(requestOptions: options, statusCode: 200, data: []),
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

  test('uploads a captured file as multipart with server-verifiable source metadata', () async {
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
    expect(
      form.fields.any(
        (entry) => entry.key == 'source' && entry.value == 'MOBILE_UPLOAD',
      ),
      isTrue,
    );
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
    expect(
      form.fields.map((entry) => entry.key),
      isNot(contains('checksumSha256')),
    );
  });
}

Map<String, dynamic> _evidenceResponse() => {
  'evidenceId': 'evidence-1',
  'fileName': 'north-span.jpg',
  'contentType': 'image/jpeg',
  'sizeBytes': 4,
  'checksumSha256': 'a' * 64,
  'source': 'MOBILE_UPLOAD',
  'captureTime': '2026-09-24T08:30:00Z',
  'latitude': null,
  'longitude': null,
  'externalReference': null,
  'uploadStatus': 'AVAILABLE',
  'createdAt': '2026-09-24T08:30:01Z',
};

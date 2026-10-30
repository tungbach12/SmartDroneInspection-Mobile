import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smart_drone_inspection/core/network/api_result.dart';
import 'package:smart_drone_inspection/features/inspections/data/inspection_repository.dart';
import 'package:smart_drone_inspection/features/inspections/domain/models/inspection.dart';

void main() {
  late Dio dio;
  late InspectionRepository repository;
  late List<RequestOptions> requests;
  late List<FormData> uploadedForms;

  setUp(() {
    uploadedForms = [];
    requests = [];
    dio = Dio(BaseOptions(baseUrl: 'https://api.example.test/api/v1'));
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          requests.add(options);
          if (options.method == 'GET' &&
              options.path.endsWith('/inspections')) {
            handler.resolve(
              Response(
                requestOptions: options,
                statusCode: 200,
                data: [_inspectionResponse()],
              ),
            );
            return;
          }
          if (options.method == 'GET' &&
              options.path.contains('/inspections/inspection-1') &&
              !options.path.endsWith('/evidence') &&
              !options.path.endsWith('/field-sessions')) {
            handler.resolve(
              Response(
                requestOptions: options,
                statusCode: 200,
                data: _inspectionResponse(),
              ),
            );
            return;
          }
          if (options.method == 'POST' &&
              options.path.endsWith('/flight-permit')) {
            handler.resolve(
              Response(
                requestOptions: options,
                statusCode: 200,
                data: _inspectionResponse(
                  status: 'READY_FOR_FLIGHT',
                  permitFileKey: 'permits/flight-permit.pdf',
                  permitFileName: 'flight-permit.pdf',
                ),
              ),
            );
            return;
          }
          if (options.method == 'POST' && options.path.endsWith('/evidence')) {
            uploadedForms.add(options.data as FormData);
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
                  ? [_evidenceResponse(isDeleted: true)]
                  : [],
            ),
          );
        },
      ),
    );
    repository = InspectionRepository(dio);
  });

  tearDown(() => dio.close(force: true));

  test('lists assigned inspections and parses inspection items', () async {
    final result = await repository.listInspections();
    expect(result, isA<ApiSuccess<List<Inspection>>>());
    final inspections = (result as ApiSuccess<List<Inspection>>).data;
    expect(inspections.single.id, 'inspection-1');
    expect(inspections.single.assetName, 'Bridge Alpha');
    expect(inspections.single.inspectionItems, ['Deck', 'Piers']);
    expect(inspections.single.status, 'ASSIGNED');
    expect(requests.single.method, 'GET');
    expect(requests.single.path, '/inspections');
  });

  test('gets inspection detail by ID', () async {
    final result = await repository.getInspection('inspection-1');
    expect(result, isA<ApiSuccess<Inspection>>());
    final inspection = (result as ApiSuccess<Inspection>).data;
    expect(inspection.id, 'inspection-1');
    expect(inspection.droneModel, 'Matrice 300');
    expect(requests.single.path, '/inspections/inspection-1');
  });

  test(
    'uploads flight permit transitioning status to READY_FOR_FLIGHT',
    () async {
      final directory = await Directory.systemTemp.createTemp('permit-');
      addTearDown(() => directory.delete(recursive: true));
      final permitPath =
          '${directory.path}${Platform.pathSeparator}flight-permit.pdf';
      await File(permitPath).writeAsBytes([0x25, 0x50, 0x44, 0x46]);

      final result = await repository.uploadFlightPermit(
        inspectionId: 'inspection-1',
        file: XFile(permitPath, name: 'flight-permit.pdf'),
      );

      expect(result, isA<ApiSuccess<Inspection>>());
      final inspection = (result as ApiSuccess<Inspection>).data;
      expect(inspection.status, 'READY_FOR_FLIGHT');
      expect(inspection.flightPermitFileName, 'flight-permit.pdf');

      final request = requests.single;
      expect(request.method, 'POST');
      expect(request.path, '/inspections/inspection-1/flight-permit');
      final form = request.data as FormData;
      expect(form.files.single.key, 'file');
      expect(form.files.single.value.filename, 'flight-permit.pdf');
    },
  );

  test('parses evidence responses without retired API fields and retains isDeleted', () async {
    final result = await repository.listEvidence('inspection-1');

    expect(result, isA<ApiSuccess>());
    final evidence = (result as ApiSuccess).data.single;
    expect(evidence.isDeleted, isTrue);
    expect(evidence.toJson().keys, contains('isDeleted'));
    expect(evidence.toJson().keys, isNot(contains('uploadStatus')));
    expect(evidence.toJson().keys, isNot(contains('retiredAt')));
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
      file: XFile(photoPath, name: 'north-span.jpg'),
      captureTime: capturedAt,
    );

    expect(result, isA<ApiSuccess>());
    final request = requests.single;
    expect(request.method, 'POST');
    expect(request.path, '/inspections/inspection-1/evidence');
    final form = uploadedForms.single;
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

  test(
    'uploads a video with session linkage and no invented capture time',
    () async {
      final directory = await Directory.systemTemp.createTemp(
        'inspection-video-',
      );
      addTearDown(() => directory.delete(recursive: true));
      final videoPath =
          '${directory.path}${Platform.pathSeparator}north-span.mp4';
      await File(videoPath).writeAsBytes([0, 0, 0, 24, 102, 116, 121, 112]);

      final result = await repository.uploadEvidence(
        inspectionId: 'inspection-1',
        file: XFile(videoPath, name: 'north-span.mp4'),
        fieldSessionId: 'session-1',
      );

      expect(result, isA<ApiSuccess>());
      final request = requests.single;
      expect(request.method, 'POST');
      expect(request.path, '/inspections/inspection-1/evidence');
      final form = uploadedForms.single;
      expect(form.fields.map((entry) => entry.key), contains('fieldSessionId'));
      expect(
        form.fields.any(
          (entry) =>
              entry.key == 'fieldSessionId' && entry.value == 'session-1',
        ),
        isTrue,
      );
      expect(
        form.fields.map((entry) => entry.key),
        isNot(contains('captureTime')),
      );
      expect(form.files.single.key, 'file');
      expect(form.files.single.value.filename, 'north-span.mp4');
    },
  );
}

Map<String, dynamic> _inspectionResponse({
  String status = 'ASSIGNED',
  String? permitFileKey,
  String? permitFileName,
}) => {
  'id': 'inspection-1',
  'assetId': 'asset-1',
  'assetName': 'Bridge Alpha',
  'droneSerialNumber': 'DR-001',
  'droneModel': 'Matrice 300',
  'status': status,
  'flightPermitFileKey': permitFileKey,
  'flightPermitFileName': permitFileName,
  'flightPermitUploadedAt': permitFileKey != null
      ? '2026-10-01T10:00:00Z'
      : null,
  'inspectionItems': ['Deck', 'Piers'],
};

Map<String, dynamic> _evidenceResponse({bool isDeleted = false}) => {
  'id': 'evidence-1',
  'inspectionId': 'inspection-1',
  'fieldSessionId': null,
  'fileName': 'north-span.jpg',
  'contentType': 'image/jpeg',
  'sizeBytes': 4,
  'captureTime': '2026-09-24T08:30:00Z',
  'latitude': null,
  'longitude': null,
  'createdAt': '2026-09-24T08:30:01Z',
  'isDeleted': isDeleted,
};

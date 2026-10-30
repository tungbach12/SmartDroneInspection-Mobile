import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smart_drone_inspection/core/network/api_failure.dart';
import 'package:smart_drone_inspection/core/network/api_result.dart';
import 'package:smart_drone_inspection/features/inspections/data/inspection_repository.dart';
import 'package:smart_drone_inspection/features/inspections/domain/models/field_session.dart';
import 'package:smart_drone_inspection/features/inspections/domain/models/inspection.dart';
import 'package:smart_drone_inspection/features/inspections/domain/models/inspection_evidence.dart';
import 'package:smart_drone_inspection/features/inspections/presentation/inspection_detail_page.dart';
import 'package:smart_drone_inspection/features/inspections/presentation/providers/inspection_detail_provider.dart';

void main() {
  test(
    'native picker filters permit files and MP4 and supports cancel',
    () async {
      final originalPlatform = FilePickerPlatform.instance;
      final platform = _FakeFilePickerPlatform([
        _FakePlatformFile('permit.pdf'),
        _FakePlatformFile('permit-scan.png'),
        _FakePlatformFile('north-span.mp4'),
        null,
      ]);
      FilePickerPlatform.instance = platform;
      addTearDown(() => FilePickerPlatform.instance = originalPlatform);

      final container = ProviderContainer();
      addTearDown(container.dispose);

      expect(
        (await container.read(flightPermitPickerProvider)())?.path,
        '/tmp/permit.pdf',
      );
      expect(
        (await container.read(flightPermitPickerProvider)())?.path,
        '/tmp/permit-scan.png',
      );
      expect(
        (await container.read(inspectionVideoPickerProvider)())?.path,
        '/tmp/north-span.mp4',
      );
      expect(await container.read(inspectionVideoPickerProvider)(), isNull);
      expect(platform.allowedExtensions, [
        ['pdf', 'png', 'jpg', 'jpeg'],
        ['pdf', 'png', 'jpg', 'jpeg'],
        ['mp4'],
        ['mp4'],
      ]);
    },
  );

  testWidgets(
    'displays inspection items, uploads flight permit, captures photo, and preserves upload for retry',
    (tester) async {
      tester.view.physicalSize = const Size(800, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      final repository = _FakeInspectionRepository();
      var cameraInvoked = false;
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            inspectionRepositoryProvider.overrideWithValue(repository),
            inspectionPhotoPickerProvider.overrideWith(
              (ref) => () async {
                cameraInvoked = true;
                return XFile('span.jpg');
              },
            ),
            flightPermitPickerProvider.overrideWith(
              (ref) =>
                  () async => XFile('permit.pdf'),
            ),
          ],
          child: const MaterialApp(
            home: InspectionDetailPage(inspectionId: 'inspection-1'),
          ),
        ),
      );
      await _pumpAsync(tester);

      // Verify read-only inspection items from asset
      expect(find.text('Check deck condition'), findsOneWidget);
      expect(find.text('Check pier base'), findsOneWidget);

      // Verify flight permit upload card
      expect(find.text('Select Permit File'), findsOneWidget);
      await tester.tap(find.text('Select Permit File'));
      await _pumpAsync(tester);
      expect(find.text('Selected: permit.pdf'), findsOneWidget);

      await tester.tap(find.text('Upload Flight Permit'));
      await _pumpAsync(tester);
      expect(repository.permitUploadAttempts, 1);
      expect(repository.permitFileName, 'permit.pdf');

      // Capture photo and upload
      await tester.ensureVisible(find.text('Capture inspection photo'));
      await tester.tap(find.text('Capture inspection photo'));
      await _pumpAsync(tester);
      expect(cameraInvoked, isTrue, reason: _visibleText(tester));
      expect(
        find.text('Selected: span.jpg'),
        findsOneWidget,
        reason: _visibleText(tester),
      );

      repository.failNextUpload = true;
      await tester.tap(find.text('Upload photo'));
      await _pumpAsync(tester);
      expect(find.text('Retry upload'), findsOneWidget);
      expect(find.textContaining('selected photo is kept'), findsOneWidget);

      await tester.tap(find.text('Retry upload'));
      await _pumpAsync(tester);
      expect(repository.uploadAttempts, 2);
      expect(find.text('span.jpg'), findsOneWidget);
    },
  );

  testWidgets('shows error message when permit upload fails', (tester) async {
    final repository = _FakeInspectionRepository(failPermitUpload: true);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          inspectionRepositoryProvider.overrideWithValue(repository),
          flightPermitPickerProvider.overrideWith(
            (ref) =>
                () async => XFile('permit.pdf'),
          ),
        ],
        child: const MaterialApp(
          home: InspectionDetailPage(inspectionId: 'inspection-1'),
        ),
      ),
    );
    await _pumpAsync(tester);
    await tester.tap(find.text('Select Permit File'));
    await _pumpAsync(tester);
    await tester.tap(find.text('Upload Flight Permit'));
    await _pumpAsync(tester);

    expect(repository.permitUploadAttempts, 1);
    expect(
      find.textContaining('Permit upload rejected', skipOffstage: false),
      findsOneWidget,
    );
  });

  testWidgets('picks and uploads an MP4 against the latest completed session', (
    tester,
  ) async {
    final repository = _FakeInspectionRepository();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          inspectionRepositoryProvider.overrideWithValue(repository),
          inspectionVideoPickerProvider.overrideWith(
            (ref) =>
                () async => XFile.fromData(
                  Uint8List.fromList([0, 0, 0, 24, 102, 116, 121, 112]),
                  name: 'north-span.mp4',
                  path: 'north-span.mp4',
                ),
          ),
        ],
        child: const MaterialApp(
          home: InspectionDetailPage(inspectionId: 'inspection-1'),
        ),
      ),
    );
    await _pumpAsync(tester);

    await tester.scrollUntilVisible(
      find.byKey(const Key('choose-video-file-btn')),
      400,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.byKey(const Key('choose-video-file-btn')));
    await _pumpAsync(tester);
    expect(
      find.text('Selected video: north-span.mp4'),
      findsOneWidget,
      reason: _visibleText(tester),
    );

    await tester.tap(find.text('Upload video evidence'));
    await _pumpAsync(tester);

    expect(repository.uploadAttempts, 1);
    expect(repository.uploadedFileName, 'north-span.mp4');
    expect(repository.uploadedCaptureTime, isNull);
    expect(repository.uploadedFieldSessionId, 'session-1');
    expect(find.text('Selected video: north-span.mp4'), findsNothing);
    await tester.pumpAndSettle();
    expect(find.text('video/mp4 · 4 bytes'), findsOneWidget);
    expect(find.byIcon(Icons.video_file_outlined), findsOneWidget);
    expect(find.text('Capture inspection photo'), findsOneWidget);
    expect(find.text('Select video file'), findsOneWidget);
  });

  testWidgets('rejects a video larger than the backend limit before upload', (
    tester,
  ) async {
    final repository = _FakeInspectionRepository();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          inspectionRepositoryProvider.overrideWithValue(repository),
          inspectionVideoPickerProvider.overrideWith(
            (ref) =>
                () async => XFile.fromData(
                  Uint8List(EvidenceUploadLimit.maxBytes + 1),
                  name: 'oversized.mp4',
                  path: 'oversized.mp4',
                ),
          ),
        ],
        child: const MaterialApp(
          home: InspectionDetailPage(inspectionId: 'inspection-1'),
        ),
      ),
    );
    await _pumpAsync(tester);

    await tester.scrollUntilVisible(
      find.byKey(const Key('choose-video-file-btn')),
      400,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.byKey(const Key('choose-video-file-btn')));
    await _pumpAsync(tester);
    await tester.tap(find.text('Upload video evidence'));
    await _pumpAsync(tester);

    expect(repository.uploadAttempts, 0);
    expect(find.textContaining('10 MiB'), findsOneWidget);
    expect(find.text('Selected video: oversized.mp4'), findsOneWidget);
  });

  testWidgets('keeps a selected video after session and upload failures', (
    tester,
  ) async {
    final repository = _FakeInspectionRepository()..hasCompletedSession = false;
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          inspectionRepositoryProvider.overrideWithValue(repository),
          inspectionVideoPickerProvider.overrideWith(
            (ref) =>
                () async => XFile.fromData(
                  Uint8List.fromList([0, 0, 0, 24, 102, 116, 121, 112]),
                  name: 'north-span.mp4',
                  path: 'north-span.mp4',
                ),
          ),
        ],
        child: const MaterialApp(
          home: InspectionDetailPage(inspectionId: 'inspection-1'),
        ),
      ),
    );
    await _pumpAsync(tester);

    await tester.scrollUntilVisible(
      find.byKey(const Key('choose-video-file-btn')),
      400,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.byKey(const Key('choose-video-file-btn')));
    await _pumpAsync(tester);
    await tester.tap(find.text('Upload video evidence'));
    await _pumpAsync(tester);
    expect(repository.uploadAttempts, 0);
    expect(
      find.text('Complete the field session before attaching evidence.'),
      findsOneWidget,
    );
    expect(find.text('Selected video: north-span.mp4'), findsOneWidget);

    repository.hasCompletedSession = true;
    repository.failNextUpload = true;
    await tester.tap(find.text('Retry video upload'));
    await _pumpAsync(tester);
    expect(repository.uploadAttempts, 1);
    expect(find.text('Selected video: north-span.mp4'), findsOneWidget);

    await tester.tap(find.text('Retry video upload'));
    await _pumpAsync(tester);
    expect(repository.uploadAttempts, 2);
    expect(repository.uploadedFieldSessionId, 'session-1');
    expect(repository.uploadedCaptureTime, isNull);
    expect(repository.uploadedFileName, 'north-span.mp4');
  });
}

String _visibleText(WidgetTester tester) => tester
    .widgetList<Text>(find.byType(Text))
    .map((widget) => widget.data ?? '')
    .join(' | ');

class _FakeFilePickerPlatform extends FilePickerPlatform {
  _FakeFilePickerPlatform(this._files);

  final List<PlatformFile?> _files;
  final List<List<String>?> allowedExtensions = [];
  int _index = 0;

  @override
  Future<PlatformFile?> pickFile({
    String? dialogTitle,
    String? initialDirectory,
    FileType type = FileType.any,
    List<String>? allowedExtensions,
    Function(FilePickerStatus)? onFileLoading,
    int compressionQuality = 0,
    AndroidOptions androidOptions = const AndroidOptions(),
    DarwinOptions darwinOptions = const DarwinOptions(),
    WindowsOptions windowsOptions = const WindowsOptions(),
    LinuxOptions linuxOptions = const LinuxOptions(),
    WebOptions webOptions = const WebOptions(),
  }) async {
    this.allowedExtensions.add(allowedExtensions);
    return _files[_index++];
  }
}

base class _FakePlatformFile extends PlatformFile {
  _FakePlatformFile(this.name);

  @override
  final String name;

  @override
  Uri get uri => Uri.file('/tmp/$name');

  @override
  XFile get xFile =>
      XFile.fromData(Uint8List.fromList([1]), name: name, path: '/tmp/$name');

  @override
  int? lengthSync() => 1;

  @override
  Future<int> length() async => 1;

  @override
  Future<Uint8List> readAsBytes() async => Uint8List.fromList([1]);

  @override
  Stream<Uint8List> readAsByteStream() async* {
    yield Uint8List.fromList([1]);
  }
}

Future<void> _pumpAsync(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 500));
}

class _FakeInspectionRepository extends InspectionRepository {
  _FakeInspectionRepository({this.failPermitUpload = false}) : super(Dio());

  final bool failPermitUpload;
  bool failNextUpload = false;
  bool hasEvidence = false;
  bool hasCompletedSession = true;
  String? uploadedFileName;
  DateTime? uploadedCaptureTime;
  String? uploadedFieldSessionId;
  String? _evidenceFileName;
  int uploadAttempts = 0;
  int permitUploadAttempts = 0;
  String? permitFileName;

  Inspection _inspection = const Inspection(
    id: 'inspection-1',
    assetId: 'asset-1',
    assetName: 'Bridge Alpha',
    droneSerialNumber: 'DR-001',
    droneModel: 'Matrice 300',
    status: 'ASSIGNED',
    inspectionItems: ['Check deck condition', 'Check pier base'],
  );

  @override
  Future<ApiResult<Inspection>> getInspection(String id) async {
    return ApiResult.success(_inspection);
  }

  @override
  Future<ApiResult<Inspection>> uploadFlightPermit({
    required String inspectionId,
    required XFile file,
  }) async {
    permitUploadAttempts++;
    permitFileName = file.name;
    if (failPermitUpload) {
      return const ApiResult.failure(
        ApiFailure.server(400, 'Permit upload rejected'),
      );
    }
    _inspection = _inspection.copyWith(
      status: 'READY_FOR_FLIGHT',
      flightPermitFileName: file.name,
      flightPermitFileKey: 'permits/${file.name}',
      flightPermitUploadedAt: '2026-10-01T10:00:00Z',
    );
    return ApiResult.success(_inspection);
  }

  @override
  Future<ApiResult<List<InspectionEvidence>>> listEvidence(
    String inspectionId,
  ) async => ApiResult.success(hasEvidence ? [_evidence()] : []);

  @override
  Future<ApiResult<List<FieldSession>>> listFieldSessions(
    String inspectionId,
  ) async => ApiResult.success(
    hasCompletedSession ? [_completedSession()] : const <FieldSession>[],
  );

  @override
  Future<ApiResult<InspectionEvidence>> uploadEvidence({
    required String inspectionId,
    required XFile file,
    DateTime? captureTime,
    String? fieldSessionId,
  }) async {
    uploadAttempts++;
    if (failNextUpload) {
      failNextUpload = false;
      return const ApiResult.failure(
        ApiFailure.server(503, 'Storage unavailable'),
      );
    }
    hasEvidence = true;
    _evidenceFileName = file.name;
    uploadedFileName = file.name;
    uploadedCaptureTime = captureTime;
    uploadedFieldSessionId = fieldSessionId;
    return ApiResult.success(_evidence(fileName: file.name));
  }

  FieldSession _completedSession() => const FieldSession(
    id: 'session-1',
    inspectionId: 'inspection-1',
    status: 'FIELD_COMPLETED',
    startedAt: '2026-09-24T08:00:00Z',
    endedAt: '2026-09-24T09:00:00Z',
    postponementReason: null,
    abortReason: null,
    outcomeNotes: 'Span surveyed',
  );

  InspectionEvidence _evidence({String fileName = 'span.jpg'}) =>
      InspectionEvidence(
        id: 'evidence-1',
        inspectionId: 'inspection-1',
        fieldSessionId: uploadedFieldSessionId,
        fileName: _evidenceFileName ?? fileName,
        contentType: (_evidenceFileName ?? fileName).endsWith('.mp4')
            ? 'video/mp4'
            : 'image/jpeg',
        sizeBytes: 4,
        captureTime: uploadedCaptureTime?.toUtc().toIso8601String(),
        latitude: null,
        longitude: null,
        createdAt: '2026-09-24T08:31:00Z',
        isDeleted: false,
      );
}

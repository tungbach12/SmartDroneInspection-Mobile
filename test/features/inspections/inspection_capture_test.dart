import 'package:dio/dio.dart';
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
              (ref) => () async => XFile('permit.pdf'),
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

  testWidgets(
    'shows error message when permit upload fails',
    (tester) async {
      final repository = _FakeInspectionRepository(failPermitUpload: true);
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            inspectionRepositoryProvider.overrideWithValue(repository),
            flightPermitPickerProvider.overrideWith(
              (ref) => () async => XFile('permit.pdf'),
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
    },
  );
}

String _visibleText(WidgetTester tester) => tester
    .widgetList<Text>(find.byType(Text))
    .map((widget) => widget.data ?? '')
    .join(' | ');

Future<void> _pumpAsync(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 500));
}

class _FakeInspectionRepository extends InspectionRepository {
  _FakeInspectionRepository({this.failPermitUpload = false})
      : super(Dio());

  final bool failPermitUpload;
  bool failNextUpload = false;
  bool hasEvidence = false;
  int uploadAttempts = 0;
  int permitUploadAttempts = 0;

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
  ) async => ApiResult.success([_completedSession()]);

  @override
  Future<ApiResult<InspectionEvidence>> uploadEvidence({
    required String inspectionId,
    required XFile photo,
    required DateTime captureTime,
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
    return ApiResult.success(_evidence());
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

  InspectionEvidence _evidence() => const InspectionEvidence(
    id: 'evidence-1',
    inspectionId: 'inspection-1',
    fieldSessionId: null,
    fileName: 'span.jpg',
    contentType: 'image/jpeg',
    sizeBytes: 4,
    captureTime: '2026-09-24T08:30:00Z',
    latitude: null,
    longitude: null,
    createdAt: '2026-09-24T08:31:00Z',
    isDeleted: false,
  );
}

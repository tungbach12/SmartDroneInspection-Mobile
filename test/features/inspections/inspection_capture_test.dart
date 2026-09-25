import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smart_drone_inspection/core/network/api_failure.dart';
import 'package:smart_drone_inspection/core/network/api_result.dart';
import 'package:smart_drone_inspection/features/inspections/data/inspection_repository.dart';
import 'package:smart_drone_inspection/features/inspections/domain/models/inspection_checklist_item.dart';
import 'package:smart_drone_inspection/features/inspections/domain/models/inspection_evidence.dart';
import 'package:smart_drone_inspection/features/inspections/presentation/inspection_detail_page.dart';
import 'package:smart_drone_inspection/features/inspections/presentation/providers/inspection_detail_provider.dart';

void main() {
  testWidgets(
    'saves checklist, captures photo, and preserves upload for retry',
    (tester) async {
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
          ],
          child: const MaterialApp(
            home: InspectionDetailPage(inspectionId: 'inspection-1'),
          ),
        ),
      );
      await _pumpAsync(tester);
      expect(find.text('Check deck condition'), findsOneWidget);

      await tester.tap(find.byType(DropdownButtonFormField<String>));
      await _pumpAsync(tester);
      await tester.tap(find.text('PASS').last);
      await _pumpAsync(tester);
      await tester.ensureVisible(find.text('Save response'));
      await tester.tap(find.text('Save response'));
      await _pumpAsync(tester);
      expect(repository.savedResponse, {'value': 'PASS'});
      expect(find.text('Saved'), findsOneWidget);

      await tester.ensureVisible(find.text('Capture inspection photo'));
      await tester.tap(find.text('Capture inspection photo'));
      await _pumpAsync(tester);
      expect(cameraInvoked, isTrue, reason: _visibleText(tester));
      expect(
        find.textContaining('Camera could not be opened'),
        findsNothing,
        reason: _visibleText(tester),
      );
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
    'shows assignment-scope failures without losing the checklist input',
    (tester) async {
      final repository = _FakeInspectionRepository(failChecklistSave: true);
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            inspectionRepositoryProvider.overrideWithValue(repository),
            inspectionPhotoPickerProvider.overrideWith(
              (ref) =>
                  () async => null,
            ),
          ],
          child: const MaterialApp(
            home: InspectionDetailPage(inspectionId: 'inspection-1'),
          ),
        ),
      );
      await _pumpAsync(tester);
      await tester.tap(find.byType(DropdownButtonFormField<String>));
      await _pumpAsync(tester);
      await tester.tap(find.text('PASS').last);
      await _pumpAsync(tester);
      await tester.ensureVisible(find.text('Save response'));
      await tester.tap(find.text('Save response'));
      await _pumpAsync(tester);
      expect(repository.saveAttempts, 1, reason: _visibleText(tester));
      expect(
        find.textContaining('Checklist was not saved'),
        findsOneWidget,
        reason: _visibleText(tester),
      );
      expect(find.textContaining('not authorized to access'), findsOneWidget);
      expect(find.byType(DropdownButtonFormField<String>), findsOneWidget);
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
  _FakeInspectionRepository({this.failChecklistSave = false}) : super(Dio());

  final bool failChecklistSave;
  bool failNextUpload = false;
  bool hasEvidence = false;
  int uploadAttempts = 0;
  int saveAttempts = 0;
  Map<String, dynamic>? savedResponse;

  @override
  Future<ApiResult<List<InspectionChecklistItem>>> checklist(
    String inspectionId,
  ) async => ApiResult.success([
    InspectionChecklistItem.fromJson({
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
    }),
  ]);

  @override
  Future<ApiResult<List<InspectionEvidence>>> listEvidence(
    String inspectionId,
  ) async => ApiResult.success(hasEvidence ? [_evidence()] : []);

  @override
  Future<ApiResult<void>> saveChecklistResponse({
    required String inspectionId,
    required String itemId,
    required Map<String, dynamic> responseValue,
    String? notes,
  }) async {
    saveAttempts++;
    if (failChecklistSave) {
      return const ApiResult.failure(ApiFailure.unauthorized());
    }
    savedResponse = responseValue;
    return const ApiResult.success(null);
  }

  @override
  Future<ApiResult<InspectionEvidence>> uploadEvidence({
    required String inspectionId,
    required XFile photo,
    required DateTime captureTime,
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

  InspectionEvidence _evidence() => InspectionEvidence(
    evidenceId: 'evidence-1',
    fileName: 'span.jpg',
    contentType: 'image/jpeg',
    sizeBytes: 4,
    checksumSha256: 'b' * 64,
    source: 'MOBILE_UPLOAD',
    captureTime: '2026-09-24T08:30:00Z',
    latitude: null,
    longitude: null,
    externalReference: null,
    uploadStatus: 'AVAILABLE',
    createdAt: '2026-09-24T08:31:00Z',
  );
}

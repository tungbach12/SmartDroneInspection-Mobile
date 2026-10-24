import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_drone_inspection/core/network/api_result.dart';
import 'package:smart_drone_inspection/features/inspections/data/inspection_repository.dart';
import 'package:smart_drone_inspection/features/inspections/domain/models/field_session.dart';
import 'package:smart_drone_inspection/features/inspections/domain/models/inspection_evidence.dart';
import 'package:smart_drone_inspection/features/inspections/domain/models/inspection_preparation.dart';
import 'package:smart_drone_inspection/features/inspections/presentation/inspection_preparation_page.dart';
import 'package:smart_drone_inspection/features/inspections/presentation/providers/field_session_provider.dart';
import 'package:smart_drone_inspection/features/inspections/presentation/providers/inspection_detail_provider.dart';
import 'package:smart_drone_inspection/features/inspections/presentation/providers/inspection_preparation_provider.dart';

class _PreparationRepository implements InspectionRepository {
  String? requestedReason;

  @override
  Future<ApiResult<InspectionPreparation>> requestAdditionalSession({
    required String inspectionId,
    required String reason,
  }) async {
    requestedReason = reason;
    return ApiResult.success(_preparation(version: 2, status: 'DRAFT'));
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

InspectionPreparation _preparation({
  required int version,
  required String status,
}) => InspectionPreparation(
  id: 'preparation-$version',
  inspectionId: 'inspection-1',
  inspectorUserId: 'inspector-1',
  preparationVersion: version,
  shotList: '{"areas": ["east face"]}',
  evidenceTypes: null,
  accessConstraints: null,
  safetyObservations: null,
  permitDocumentReferences: null,
  status: status,
  submittedAt: null,
  plannedStartAt: null,
  plannedEndAt: null,
);

FieldSession _completedSession() => const FieldSession(
  id: 'session-1',
  inspectionId: 'inspection-1',
  organizationId: 'org-1',
  inspectorUserId: 'inspector-1',
  droneId: null,
  readinessDecisionId: 'readiness-1',
  checklistTemplateId: null,
  readinessVersion: 1,
  status: 'FIELD_COMPLETED',
  startedAt: '2026-10-12T08:00:00Z',
  endedAt: '2026-10-12T09:00:00Z',
  postponementReason: null,
  abortReason: null,
  outcomeNotes: 'East face not covered',
);

InspectionEvidence _activeEvidence() => const InspectionEvidence(
  id: 'evidence-1',
  inspectionId: 'inspection-1',
  fieldSessionId: 'session-1',
  fileName: 'east-face.jpg',
  contentType: 'image/jpeg',
  sizeBytes: 1024,
  captureTime: null,
  latitude: null,
  longitude: null,
  createdAt: '2026-10-12T09:01:00Z',
  isDeleted: false,
);

void main() {
  testWidgets('requests another field session from MF2 preparation', (
    tester,
  ) async {
    final repository = _PreparationRepository();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          inspectionRepositoryProvider.overrideWithValue(repository),
          inspectionPreparationsProvider.overrideWith(
            (ref, inspectionId) async => [
              _preparation(version: 1, status: 'READY'),
            ],
          ),
          fieldSessionsProvider.overrideWith(
            (ref, inspectionId) async => [_completedSession()],
          ),
          inspectionEvidenceProvider.overrideWith(
            (ref, inspectionId) async => [_activeEvidence()],
          ),
        ],
        child: const MaterialApp(
          home: InspectionPreparationPage(inspectionId: 'inspection-1'),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Request additional field session'), findsOneWidget);
    final requestButton = tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, 'Request additional field session'),
    );
    expect(requestButton.onPressed, isNull);

    await tester.enterText(
      find.byKey(const Key('additional-session-reason')),
      'The east face was not covered during the completed session.',
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Request additional field session'));
    await tester.pumpAndSettle();

    expect(
      repository.requestedReason,
      'The east face was not covered during the completed session.',
    );
    expect(find.textContaining('Preparation version 2'), findsOneWidget);
  });

  testWidgets(
    'does not offer an additional session without the MF2 preconditions',
    (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            inspectionRepositoryProvider.overrideWithValue(
              _PreparationRepository(),
            ),
            inspectionPreparationsProvider.overrideWith(
              (ref, inspectionId) async => [
                _preparation(version: 1, status: 'DRAFT'),
              ],
            ),
            fieldSessionsProvider.overrideWith(
              (ref, inspectionId) async => [_completedSession()],
            ),
            inspectionEvidenceProvider.overrideWith(
              (ref, inspectionId) async => [_activeEvidence()],
            ),
          ],
          child: const MaterialApp(
            home: InspectionPreparationPage(inspectionId: 'inspection-1'),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Request additional field session'), findsNothing);
    },
  );
}

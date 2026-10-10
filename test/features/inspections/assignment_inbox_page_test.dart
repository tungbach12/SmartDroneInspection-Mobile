import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_drone_inspection/core/network/api_failure.dart';
import 'package:smart_drone_inspection/core/network/api_result.dart';
import 'package:smart_drone_inspection/features/inspections/data/inspection_repository.dart';
import 'package:smart_drone_inspection/features/inspections/domain/models/inspector_assignment.dart';
import 'package:smart_drone_inspection/features/inspections/presentation/inspections_page.dart';

class _FakeAssignmentRepository implements InspectionRepository {
  _FakeAssignmentRepository({this.assignments = const [], this.refusal});

  final List<InspectorAssignment> assignments;
  final ApiFailure? refusal;
  String? lastReason;
  String? lastResponse;

  @override
  Future<ApiResult<List<InspectorAssignment>>> listMyAssignments() async =>
      ApiResult.success(assignments);

  @override
  Future<ApiResult<InspectorAssignment>> respondToAssignment({
    required String assignmentId,
    required String response,
    String? rejectionReason,
  }) async {
    lastResponse = response;
    lastReason = rejectionReason;
    if (refusal != null) {
      return ApiResult.failure(refusal!);
    }
    return ApiResult.success(
      assignments.first.copyWith(
        assignmentResponse: response == 'ACCEPTED' ? 'ACCEPTED' : 'REJECTED',
        reason: rejectionReason,
        status: response == 'ACCEPTED' ? 'ACTIVE' : 'SUSPENDED',
      ),
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

InspectorAssignment _assignment({String status = 'ACTIVE'}) =>
    InspectorAssignment(
      id: 'assignment-1',
      organizationId: 'org-1',
      assetId: 'asset-1',
      assetName: 'Sung Han Bridge',
      inspectorUserId: 'inspector-1',
      droneId: 'drone-1',
      droneSerialNumber: 'DJI-M350-001',
      droneServiceability: 'ACTIVE',
      validFrom: '2026-11-01T00:00:00Z',
      validUntil: '2026-11-30T00:00:00Z',
      status: status,
      reason: null,
      assignmentResponse: null,
      respondedAt: null,
      assignedAt: '2026-10-09T09:00:00Z',
    );

Widget _host(_FakeAssignmentRepository repository) => ProviderScope(
  overrides: [inspectionRepositoryProvider.overrideWithValue(repository)],
  child: const MaterialApp(home: InspectionsPage()),
);

void main() {
  testWidgets('shows what the administrator paired the inspector with', (
    tester,
  ) async {
    final repository = _FakeAssignmentRepository(assignments: [_assignment()]);

    await tester.pumpWidget(_host(repository));
    await tester.pumpAndSettle();

    expect(find.text('Sung Han Bridge'), findsOneWidget);
    expect(find.textContaining('DJI-M350-001'), findsOneWidget);
    expect(find.textContaining('2026-11-01'), findsOneWidget);
  });

  testWidgets('says accepting is not flight clearance', (tester) async {
    final repository = _FakeAssignmentRepository(assignments: [_assignment()]);

    await tester.pumpWidget(_host(repository));
    await tester.pumpAndSettle();

    expect(
      find.textContaining('does not mean the mission may fly'),
      findsOneWidget,
    );
  });

  testWidgets('accepts without requiring a reason', (tester) async {
    final repository = _FakeAssignmentRepository(assignments: [_assignment()]);

    await tester.pumpWidget(_host(repository));
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(FilledButton, 'Accept'));
    await tester.pumpAndSettle();

    expect(repository.lastResponse, 'ACCEPTED');
    expect(repository.lastReason, isNull);
  });

  testWidgets('keeps decline disabled until a reason is written', (
    tester,
  ) async {
    final repository = _FakeAssignmentRepository(assignments: [_assignment()]);

    await tester.pumpWidget(_host(repository));
    await tester.pumpAndSettle();

    expect(
      tester
          .widget<OutlinedButton>(
            find.widgetWithText(OutlinedButton, 'Decline'),
          )
          .onPressed,
      isNull,
    );
  });

  testWidgets('sends the inspector-written reason when declining', (
    tester,
  ) async {
    final repository = _FakeAssignmentRepository(assignments: [_assignment()]);

    await tester.pumpWidget(_host(repository));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const Key('decline-reason')),
      'No night-flight qualification',
    );
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(OutlinedButton, 'Decline'));
    await tester.pumpAndSettle();

    expect(repository.lastResponse, 'REJECTED');
    expect(repository.lastReason, 'No night-flight qualification');
  });

  testWidgets('shows the server reason when the response is refused', (
    tester,
  ) async {
    final repository = _FakeAssignmentRepository(
      assignments: [_assignment()],
      refusal: const ServerFailure(
        409,
        'This assignment is no longer open for a response.',
      ),
    );

    await tester.pumpWidget(_host(repository));
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(FilledButton, 'Accept'));
    await tester.pumpAndSettle();

    expect(
      find.textContaining('no longer open for a response'),
      findsOneWidget,
    );
  });

  testWidgets('tells an inspector with nothing to answer where to go', (
    tester,
  ) async {
    final repository = _FakeAssignmentRepository();

    await tester.pumpWidget(_host(repository));
    await tester.pumpAndSettle();

    expect(find.textContaining('Nothing to answer'), findsOneWidget);
    expect(find.textContaining('preparation can start'), findsOneWidget);
  });
}

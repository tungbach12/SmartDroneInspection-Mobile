import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_drone_inspection/core/network/api_failure.dart';
import 'package:smart_drone_inspection/core/network/api_result.dart';
import 'package:smart_drone_inspection/features/inspections/data/inspection_repository.dart';
import 'package:smart_drone_inspection/features/inspections/domain/models/field_session.dart';
import 'package:smart_drone_inspection/features/inspections/presentation/field_session_panel.dart';

class _FakeFieldSessionRepository implements InspectionRepository {
  _FakeFieldSessionRepository({
    this.startResult,
    this.sessions = const <FieldSession>[],
  });

  final ApiResult<FieldSession>? startResult;
  final List<FieldSession> sessions;
  String? lastNote;
  String? lastPostponeReason;
  String? lastAbortReason;

  @override
  Future<ApiResult<FieldSession>> startFieldSession({
    required String inspectionId,
    required String? checklistTemplateId,
    required String preFlightChecklistNote,
  }) async {
    lastNote = preFlightChecklistNote;
    return startResult ?? ApiResult.success(_session(status: 'IN_PROGRESS'));
  }

  @override
  Future<ApiResult<List<FieldSession>>> listFieldSessions(
    String inspectionId,
  ) async => ApiResult.success(sessions);

  @override
  Future<ApiResult<FieldSession>> postponeFieldSession({
    required String inspectionId,
    required String sessionId,
    required String reason,
  }) async {
    lastPostponeReason = reason;
    return ApiResult.success(_session(status: 'POSTPONED'));
  }

  @override
  Future<ApiResult<FieldSession>> abortFieldSession({
    required String inspectionId,
    required String sessionId,
    required String reason,
  }) async {
    lastAbortReason = reason;
    return ApiResult.success(_session(status: 'ABORTED'));
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

FieldSession _session({required String status}) => FieldSession(
  id: 'session-1',
  inspectionId: 'inspection-1',
  organizationId: 'org-1',
  inspectorUserId: 'inspector-1',
  droneId: 'drone-1',
  readinessDecisionId: 'decision-1',
  checklistTemplateId: null,
  readinessVersion: 1,
  status: status,
  startedAt: '2026-11-01T09:05:00Z',
  endedAt: status == 'IN_PROGRESS' ? null : '2026-11-01T09:30:00Z',
  postponementReason: status == 'POSTPONED' ? 'High wind' : null,
  abortReason: null,
);

Widget _host(_FakeFieldSessionRepository repository) => ProviderScope(
  overrides: [inspectionRepositoryProvider.overrideWithValue(repository)],
  child: const MaterialApp(
    home: Scaffold(body: FieldSessionPanel(inspectionId: 'inspection-1')),
  ),
);

void main() {
  testWidgets('asks for a written pre-flight note before starting', (
    tester,
  ) async {
    final repository = _FakeFieldSessionRepository();

    await tester.pumpWidget(_host(repository));
    await tester.pumpAndSettle();

    expect(find.text('Start field session'), findsOneWidget);
    // Nothing typed yet, so the button must be unavailable rather than letting the server refuse.
    final button = tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, 'Start field session'),
    );
    expect(button.onPressed, isNull);
  });

  testWidgets('starts a session with the note the inspector wrote', (
    tester,
  ) async {
    final repository = _FakeFieldSessionRepository();

    await tester.pumpWidget(_host(repository));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const Key('pre-flight-note')),
      'Drone identified; bridge accessible',
    );
    await tester.pumpAndSettle();
    final button = tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, 'Start field session'),
    );
    expect(
      button.onPressed,
      isNotNull,
      reason: 'button must enable once a note is typed',
    );
    await tester.tap(find.widgetWithText(FilledButton, 'Start field session'));
    await tester.pumpAndSettle();

    expect(repository.lastNote, 'Drone identified; bridge accessible');
  });

  testWidgets('shows the server reason when the start is refused', (
    tester,
  ) async {
    final repository = _FakeFieldSessionRepository(
      startResult: const ApiError(
        ServerFailure(
          409,
          'No current approved readiness decision covers this inspection.',
        ),
      ),
    );

    await tester.pumpWidget(_host(repository));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const Key('pre-flight-note')),
      'Ready to fly',
    );
    await tester.pumpAndSettle();
    final button = tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, 'Start field session'),
    );
    expect(
      button.onPressed,
      isNotNull,
      reason: 'start must enable once a note is typed',
    );
    await tester.tap(find.widgetWithText(FilledButton, 'Start field session'));
    await tester.pumpAndSettle();

    expect(
      find.textContaining('No current approved readiness decision'),
      findsOneWidget,
    );
  });

  testWidgets('requires a reason before postponing', (tester) async {
    final repository = _FakeFieldSessionRepository(
      sessions: [_session(status: 'IN_PROGRESS')],
    );

    await tester.pumpWidget(_host(repository));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const Key('postpone-reason')),
      'High wind above 10 m/s',
    );
    await tester.pumpAndSettle();
    final button = tester.widget<OutlinedButton>(
      find.widgetWithText(OutlinedButton, 'Postpone'),
    );
    expect(
      button.onPressed,
      isNotNull,
      reason: 'postpone must enable once a reason is typed',
    );
    await tester.tap(find.widgetWithText(OutlinedButton, 'Postpone'));
    await tester.pumpAndSettle();

    expect(repository.lastPostponeReason, 'High wind above 10 m/s');
  });

  testWidgets(
    'asks for confirmation before aborting, because a mistaken tap loses the session',
    (tester) async {
      final repository = _FakeFieldSessionRepository(
        sessions: [_session(status: 'IN_PROGRESS')],
      );

      await tester.pumpWidget(_host(repository));
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byKey(const Key('abort-reason')),
        'Structure found unsafe on site',
      );
      await tester.pumpAndSettle();
      // The abort control sits below both reason fields, which is off-screen at the default test
      // surface size, so it has to be scrolled into view before it can be tapped.
      await tester.ensureVisible(
        find.widgetWithText(OutlinedButton, 'Abort session'),
      );
      await tester.tap(find.widgetWithText(OutlinedButton, 'Abort session'));
      await tester.pumpAndSettle();

      // The first tap must not have aborted anything yet.
      expect(repository.lastAbortReason, isNull);
      expect(find.text('Abort this session?'), findsOneWidget);

      await tester.tap(find.widgetWithText(FilledButton, 'Abort'));
      await tester.pumpAndSettle();

      expect(repository.lastAbortReason, 'Structure found unsafe on site');
    },
  );

  testWidgets('shows an open session instead of offering another start', (
    tester,
  ) async {
    final repository = _FakeFieldSessionRepository(
      sessions: [_session(status: 'IN_PROGRESS')],
    );

    await tester.pumpWidget(_host(repository));
    await tester.pumpAndSettle();

    expect(find.text('Start field session'), findsNothing);
    expect(find.text('In progress'), findsOneWidget);
    expect(find.text('Postpone'), findsOneWidget);
  });

  testWidgets('offers a new attempt after a postponement', (tester) async {
    final repository = _FakeFieldSessionRepository(
      sessions: [_session(status: 'POSTPONED')],
    );

    await tester.pumpWidget(_host(repository));
    await tester.pumpAndSettle();

    // A postponement leaves the inspection startable, because the approval was not consumed.
    expect(find.text('Start field session'), findsOneWidget);
    expect(find.text('Postponed'), findsOneWidget);
  });
}

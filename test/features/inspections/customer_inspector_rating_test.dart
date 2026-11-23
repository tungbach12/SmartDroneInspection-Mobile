import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_drone_inspection/core/network/api_result.dart';
import 'package:smart_drone_inspection/features/inspections/data/inspection_repository.dart';
import 'package:smart_drone_inspection/features/inspections/domain/models/inspection.dart';
import 'package:smart_drone_inspection/features/inspections/domain/models/inspector_rating.dart';
import 'package:smart_drone_inspection/features/inspections/presentation/widgets/customer_inspector_rating_card.dart';
import 'package:smart_drone_inspection/l10n/app_localizations.dart';

class _StubRatingRepository extends InspectionRepository {
  _StubRatingRepository() : super(Dio());

  UpsertInspectorRatingRequest? submitted;

  @override
  Future<ApiResult<InspectorRatingBundle>> getInspectorRating(
    String inspectionId,
  ) async {
    return ApiResult.success(
      const InspectorRatingBundle(
        inspectionId: 'insp-1',
        inspectorId: 'u-insp',
        inspectorName: 'Phạm Văn Bay',
        canRate: true,
        actorRole: 'CUSTOMER',
        expectedCriteriaKeys: <String>[
          'evidenceQuality',
          'communication',
          'professionalism',
        ],
        inspectorAverageRating: 4.5,
        inspectorRatingCount: 2,
      ),
    );
  }

  @override
  Future<ApiResult<InspectorRatingBundle>> upsertInspectorRating({
    required String inspectionId,
    required UpsertInspectorRatingRequest request,
  }) async {
    submitted = request;
    return ApiResult.success(
      InspectorRatingBundle(
        inspectionId: inspectionId,
        inspectorId: 'u-insp',
        inspectorName: 'Phạm Văn Bay',
        canRate: true,
        actorRole: 'CUSTOMER',
        expectedCriteriaKeys: const <String>[
          'evidenceQuality',
          'communication',
          'professionalism',
        ],
        myRating: InspectorRatingItem(
          id: 'r-1',
          inspectionId: inspectionId,
          inspectorId: 'u-insp',
          raterUserId: 'u-cust',
          raterRole: 'CUSTOMER',
          overallScore: request.overallScore,
          criterionScores: request.criterionScores,
          comment: request.comment,
          createdAt: '2026-11-23T10:00:00Z',
          updatedAt: '2026-11-23T10:00:00Z',
          editableUntil: '2026-11-30T10:00:00Z',
          editable: true,
        ),
        inspectorAverageRating: 4.7,
        inspectorRatingCount: 3,
      ),
    );
  }
}

void main() {
  test('Inspection.fromJson parses inspector rating fields', () {
    final model = Inspection.fromJson(const <String, dynamic>{
      'id': 'insp-1',
      'assetId': 'asset-1',
      'status': 'COMPLETED',
      'inspectorName': 'Phạm Văn Bay',
      'inspectorAverageRating': 4.8,
      'inspectorRatingCount': 12,
    });
    expect(model.inspectorAverageRating, 4.8);
    expect(model.inspectorRatingCount, 12);
  });

  testWidgets('CustomerInspectorRatingCard submits rating via bottom sheet', (
    tester,
  ) async {
    final repo = _StubRatingRepository();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          inspectionRepositoryProvider.overrideWithValue(repo),
        ],
        child: const MaterialApp(
          locale: Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: CustomerInspectorRatingCard(inspectionId: 'insp-1'),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Phạm Văn Bay'), findsOneWidget);
    expect(find.byKey(const Key('rate-inspector-btn')), findsOneWidget);

    await tester.tap(find.byKey(const Key('rate-inspector-btn')));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'Good photos');
    await tester.tap(find.byKey(const Key('submit-inspector-rating-btn')));
    await tester.pumpAndSettle();

    expect(repo.submitted, isNotNull);
    expect(repo.submitted!.overallScore, 5);
    expect(repo.submitted!.comment, 'Good photos');
    expect(repo.submitted!.criterionScores['evidenceQuality'], 5);
  });
}

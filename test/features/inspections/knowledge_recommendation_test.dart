import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_drone_inspection/features/inspections/domain/models/knowledge_recommendation.dart';
import 'package:smart_drone_inspection/features/inspections/presentation/providers/inspection_detail_provider.dart';
import 'package:smart_drone_inspection/features/inspections/presentation/widgets/knowledge_references_strip.dart';
import 'package:smart_drone_inspection/l10n/app_localizations.dart';

KnowledgeRecommendationResponse _response() {
  return KnowledgeRecommendationResponse.fromJson({
    'retrievalMode': 'HYBRID',
    'cases': [
      {
        'id': 'case-1',
        'defectLabel': 'Bolt corrosion',
        'severity': 'HIGH',
        'assetCategory': 'BRIDGE',
        'assetLabel': 'Nhat Tan Bridge',
        'sameAsset': true,
        'sameOrganization': true,
        'similarity': 0.92,
        'technicalNotes': 'Reseal expansion joint',
        'outcome': 'RESOLVED',
        'publishedAt': '2026-09-01T08:00:00Z',
      },
    ],
    'guidelines': [
      {
        'id': 'guide-1',
        'standardCode': 'TCVN 9343:2012',
        'title': 'Steel bridge inspection',
        'severity': 'HIGH',
        'similarity': 0.88,
        'guidance': 'Measure residual bolt diameter',
        'referenceUrl': 'https://example.test/standard',
      },
    ],
  });
}

Widget _wrap(Widget child, KnowledgeRecommendationResponse? data) {
  return ProviderScope(
    overrides: [
      knowledgeRecommendationsProvider('insp-1')
          .overrideWith((ref) async => data),
    ],
    child: MaterialApp(
      locale: const Locale('en'),
      supportedLocales: const [Locale('en'), Locale('vi')],
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      home: Scaffold(body: SingleChildScrollView(child: child)),
    ),
  );
}

void main() {
  test(
    'parses knowledge response, cases, guidelines, and match percentages',
    () {
      final data = _response();
      expect(data.retrievalMode, 'HYBRID');
      expect(data.isEmpty, isFalse);
      expect(data.cases.single.matchPercent, 92);
      expect(data.cases.single.sameAsset, isTrue);
      expect(data.cases.single.technicalNotes, 'Reseal expansion joint');
      expect(data.guidelines.single.standardCode, 'TCVN 9343:2012');
      expect(data.guidelines.single.matchPercent, 88);
    },
  );

  test('empty payload reports isEmpty', () {
    expect(
      KnowledgeRecommendationResponse.fromJson({'retrievalMode': 'KEYWORD'})
          .isEmpty,
      isTrue,
    );
  });

  testWidgets('compact chip strip expands to concise case and standard rows', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(
        const KnowledgeReferencesStrip(inspectionId: 'insp-1'),
        _response(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Matched cases & standards'), findsOneWidget);
    expect(find.text('92% match'), findsOneWidget);
    expect(find.text('TCVN 9343:2012'), findsOneWidget);
    expect(find.textContaining('Bolt corrosion'), findsNothing);

    await tester.tap(find.text('Matched cases & standards'));
    await tester.pumpAndSettle();

    expect(find.textContaining('Bolt corrosion'), findsOneWidget);
    expect(find.text('Reseal expansion joint · RESOLVED'), findsOneWidget);
    expect(find.text('Steel bridge inspection'), findsOneWidget);
    expect(find.text('Measure residual bolt diameter'), findsOneWidget);
  });

  testWidgets('hides entirely when the endpoint has no data', (tester) async {
    await tester.pumpWidget(
      _wrap(const KnowledgeReferencesStrip(inspectionId: 'insp-1'), null),
    );
    await tester.pumpAndSettle();
    expect(find.text('Matched cases & standards'), findsNothing);
  });
}

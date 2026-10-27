import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_drone_inspection/features/inspections/presentation/widgets/airspace_advisory_card.dart';

void main() {
  testWidgets(
    'AirspaceAdvisoryCard evaluates prohibited, restricted, and clear zones with MSG28',
    (tester) async {
      final noFly = evaluateMobileAirspace(10.8188, 106.6519);
      expect(noFly.classification, 'NO_FLY_ZONE');
      expect(noFly.messageCode, 'MSG28');

      final restricted = evaluateMobileAirspace(10.7789, 106.7082);
      expect(restricted.classification, 'RESTRICTED_ZONE');
      expect(restricted.messageCode, 'MSG28');

      final clear = evaluateMobileAirspace(10.5500, 106.8500);
      expect(clear.classification, 'CLEAR_ZONE');
      expect(clear.messageCode, 'AIRSPACE_CLEAR');

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: AirspaceAdvisoryCard(
                assetName: 'Cầu Thủ Thiêm 2',
                latitude: 10.7789,
                longitude: 106.7082,
              ),
            ),
          ),
        ),
      );

      expect(find.textContaining('MSG28'), findsWidgets);
      expect(find.textContaining('cambay.mod.gov.vn'), findsOneWidget);
      expect(
        find.textContaining(
          'Hành Lang An Toàn Hàng Không & Cầu Trọng Điểm Sông Sài Gòn',
        ),
        findsOneWidget,
      );
    },
  );
}

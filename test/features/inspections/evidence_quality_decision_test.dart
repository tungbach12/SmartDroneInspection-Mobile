import 'package:flutter_test/flutter_test.dart';
import 'package:smart_drone_inspection/features/inspections/domain/models/evidence_quality_decision.dart';

EvidenceQualityDecision _decision(String decision) {
  return EvidenceQualityDecision(
    id: 'decision-1',
    inspectionId: 'inspection-1',
    decision: decision,
    decidedByUserId: 'inspector-1',
    decidedAt: '2026-10-12T00:00:00Z',
  );
}

void main() {
  group('EvidenceQualityDecisionX.acceptsEvidenceSet', () {
    test('only ACCEPTED unlocks detection and drafting', () {
      expect(_decision('ACCEPTED').acceptsEvidenceSet, isTrue);
    });

    test('LIMITED stays ineligible, matching the backend gate', () {
      expect(_decision('LIMITED').acceptsEvidenceSet, isFalse);
    });

    test('re-upload and additional-session outcomes stay ineligible', () {
      expect(_decision('REUPLOAD_REQUIRED').acceptsEvidenceSet, isFalse);
      expect(
        _decision('ADDITIONAL_SESSION_REQUIRED').acceptsEvidenceSet,
        isFalse,
      );
    });
  });
}

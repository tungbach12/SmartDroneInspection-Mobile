import 'package:flutter_test/flutter_test.dart';
import 'package:smart_drone_inspection/features/inspections/domain/models/reinspection_verification.dart';
import 'package:smart_drone_inspection/features/inspections/domain/verdict_expiry.dart';

void main() {
  final now = DateTime.utc(2026, 11, 19, 8);

  ReinspectionVerification verification({
    required String id,
    required String status,
    String? validUntil,
  }) {
    return ReinspectionVerification.fromJson({
      'id': id,
      'reinspectionId': 're-1',
      'sourceFindingId': 'f-$id',
      'resolutionStatus': status,
      'verifiedAt': '2026-11-01T08:00:00Z',
      'validUntil': ?validUntil,
    });
  }

  test('parses verifiedAt and validUntil from JSON', () {
    final item = verification(
      id: 'v1',
      status: 'RESOLVED',
      validUntil: '2026-12-01T08:00:00Z',
    );
    expect(item.isResolved, isTrue);
    expect(item.verifiedAt, '2026-11-01T08:00:00Z');
    expect(item.validUntil, '2026-12-01T08:00:00Z');
  });

  test('splits RESOLVED verdicts into expired and expiring within 14 days', () {
    final summary = summarizeVerdictExpiry([
      verification(
        id: 'expired',
        status: 'RESOLVED',
        validUntil: '2026-11-18T08:00:00Z',
      ),
      verification(
        id: 'soon',
        status: 'RESOLVED',
        validUntil: '2026-11-25T08:00:00Z',
      ),
      verification(
        id: 'later',
        status: 'RESOLVED',
        validUntil: '2026-12-31T08:00:00Z',
      ),
      verification(
        id: 'unresolved',
        status: 'UNRESOLVED',
        validUntil: '2026-11-20T08:00:00Z',
      ),
      verification(id: 'no-date', status: 'RESOLVED'),
      verification(id: 'invalid', status: 'RESOLVED', validUntil: 'not-a-date'),
    ], now: now);

    expect(summary.expiredCount, 1);
    expect(summary.expired.single.id, 'expired');
    expect(summary.expiringSoon.map((e) => e.id), ['soon']);
    expect(summary.isEmpty, isFalse);
  });

  test('treats a verdict expiring exactly at the boundary as soon', () {
    final summary = summarizeVerdictExpiry([
      verification(
        id: 'boundary',
        status: 'RESOLVED',
        validUntil: now.add(const Duration(days: 14)).toIso8601String(),
      ),
    ], now: now);
    expect(summary.expired, isEmpty);
    expect(summary.expiringSoon.single.id, 'boundary');
  });

  test('empty input yields an empty summary', () {
    expect(summarizeVerdictExpiry(null, now: now).isEmpty, isTrue);
    expect(summarizeVerdictExpiry([], now: now).expiredCount, 0);
  });
}

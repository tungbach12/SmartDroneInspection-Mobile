import 'package:smart_drone_inspection/features/inspections/domain/models/reinspection_verification.dart';

/// A verdict inside this window is worth flagging before the report stage blocks it.
const Duration verdictSoonWindow = Duration(days: 14);

/// Result of splitting RESOLVED verdicts by their validity window.
class VerdictExpirySummary {
  const VerdictExpirySummary({
    this.expired = const <ReinspectionVerification>[],
    this.expiringSoon = const <ReinspectionVerification>[],
  });

  final List<ReinspectionVerification> expired;
  final List<ReinspectionVerification> expiringSoon;

  int get expiredCount => expired.length;
  bool get isEmpty => expired.isEmpty && expiringSoon.isEmpty;
}

/// Splits RESOLVED verdicts of a re-inspection into already lapsed and those
/// about to lapse. Verdicts without a parseable `validUntil` are ignored.
VerdictExpirySummary summarizeVerdictExpiry(
  List<ReinspectionVerification>? items, {
  DateTime? now,
}) {
  final reference = now ?? DateTime.now();
  final expired = <ReinspectionVerification>[];
  final expiringSoon = <ReinspectionVerification>[];

  for (final item in items ?? const <ReinspectionVerification>[]) {
    if (!item.isResolved || item.validUntil == null) continue;
    final expiresAt = DateTime.tryParse(item.validUntil!)?.toLocal();
    if (expiresAt == null) continue;
    if (!expiresAt.isAfter(reference)) {
      expired.add(item);
    } else if (expiresAt.difference(reference) <= verdictSoonWindow) {
      expiringSoon.add(item);
    }
  }

  return VerdictExpirySummary(expired: expired, expiringSoon: expiringSoon);
}

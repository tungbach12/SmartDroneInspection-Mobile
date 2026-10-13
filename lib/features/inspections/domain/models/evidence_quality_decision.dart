import 'package:freezed_annotation/freezed_annotation.dart';

part 'evidence_quality_decision.freezed.dart';
part 'evidence_quality_decision.g.dart';

/// MF3-03/04: the assigned Inspector's substantive adequacy decision. Only an accepted decision
/// makes the evidence set eligible for advisory detection and report drafting.
@freezed
abstract class EvidenceQualityDecision with _$EvidenceQualityDecision {
  const factory EvidenceQualityDecision({
    required String id,
    required String inspectionId,
    String? fieldSessionId,
    required String decision,
    String? shotListComparison,
    String? limitationReason,
    required String decidedByUserId,
    required String decidedAt,
  }) = _EvidenceQualityDecision;

  factory EvidenceQualityDecision.fromJson(Map<String, dynamic> json) =>
      _$EvidenceQualityDecisionFromJson(json);
}

extension EvidenceQualityDecisionX on EvidenceQualityDecision {
  /// Only an ACCEPTED decision makes the set eligible for advisory detection and report drafting;
  /// LIMITED stays ineligible on the backend (`EvidenceQualityDecision.isAccepted`).
  bool get acceptsEvidenceSet => decision == 'ACCEPTED';
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'evidence_quality_decision.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_EvidenceQualityDecision _$EvidenceQualityDecisionFromJson(
  Map<String, dynamic> json,
) => _EvidenceQualityDecision(
  id: json['id'] as String,
  inspectionId: json['inspectionId'] as String,
  fieldSessionId: json['fieldSessionId'] as String?,
  decision: json['decision'] as String,
  shotListComparison: json['shotListComparison'] as String?,
  limitationReason: json['limitationReason'] as String?,
  decidedByUserId: json['decidedByUserId'] as String,
  decidedAt: json['decidedAt'] as String,
);

Map<String, dynamic> _$EvidenceQualityDecisionToJson(
  _EvidenceQualityDecision instance,
) => <String, dynamic>{
  'id': instance.id,
  'inspectionId': instance.inspectionId,
  'fieldSessionId': instance.fieldSessionId,
  'decision': instance.decision,
  'shotListComparison': instance.shotListComparison,
  'limitationReason': instance.limitationReason,
  'decidedByUserId': instance.decidedByUserId,
  'decidedAt': instance.decidedAt,
};

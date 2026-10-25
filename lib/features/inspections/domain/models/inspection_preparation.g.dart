// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inspection_preparation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_InspectionPreparation _$InspectionPreparationFromJson(
  Map<String, dynamic> json,
) => _InspectionPreparation(
  id: json['id'] as String,
  inspectionId: json['inspectionId'] as String,
  preparationVersion: (json['preparationVersion'] as num).toInt(),
  shotList: json['shotList'] as String,
  evidenceTypes: json['evidenceTypes'] as String?,
  accessConstraints: json['accessConstraints'] as String?,
  safetyObservations: json['safetyObservations'] as String?,
  permitDocumentReferences: json['permitDocumentReferences'] as String?,
  status: json['status'] as String?,
  submittedAt: json['submittedAt'] as String?,
  reviewedByUserId: json['reviewedByUserId'] as String?,
  reviewedAt: json['reviewedAt'] == null
      ? null
      : DateTime.parse(json['reviewedAt'] as String),
  reviewReason: json['reviewReason'] as String?,
  plannedStartAt: json['plannedStartAt'] == null
      ? null
      : DateTime.parse(json['plannedStartAt'] as String),
  plannedEndAt: json['plannedEndAt'] == null
      ? null
      : DateTime.parse(json['plannedEndAt'] as String),
);

Map<String, dynamic> _$InspectionPreparationToJson(
  _InspectionPreparation instance,
) => <String, dynamic>{
  'id': instance.id,
  'inspectionId': instance.inspectionId,
  'preparationVersion': instance.preparationVersion,
  'shotList': instance.shotList,
  'evidenceTypes': instance.evidenceTypes,
  'accessConstraints': instance.accessConstraints,
  'safetyObservations': instance.safetyObservations,
  'permitDocumentReferences': instance.permitDocumentReferences,
  'status': instance.status,
  'submittedAt': instance.submittedAt,
  'reviewedByUserId': instance.reviewedByUserId,
  'reviewedAt': instance.reviewedAt?.toIso8601String(),
  'reviewReason': instance.reviewReason,
  'plannedStartAt': instance.plannedStartAt?.toIso8601String(),
  'plannedEndAt': instance.plannedEndAt?.toIso8601String(),
};

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'started_inspection.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_StartedInspection _$StartedInspectionFromJson(Map<String, dynamic> json) =>
    _StartedInspection(
      inspectionId: json['inspectionId'] as String,
      assignmentId: json['assignmentId'] as String,
      serviceOrderId: json['serviceOrderId'] as String,
      assetId: json['assetId'] as String,
      checklistTemplateId: json['checklistTemplateId'] as String,
      status: json['status'] as String,
      startedAt: json['startedAt'] as String,
    );

Map<String, dynamic> _$StartedInspectionToJson(_StartedInspection instance) =>
    <String, dynamic>{
      'inspectionId': instance.inspectionId,
      'assignmentId': instance.assignmentId,
      'serviceOrderId': instance.serviceOrderId,
      'assetId': instance.assetId,
      'checklistTemplateId': instance.checklistTemplateId,
      'status': instance.status,
      'startedAt': instance.startedAt,
    };

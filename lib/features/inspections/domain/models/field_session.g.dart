// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'field_session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FieldSession _$FieldSessionFromJson(Map<String, dynamic> json) =>
    _FieldSession(
      id: json['id'] as String,
      inspectionId: json['inspectionId'] as String,
      organizationId: json['organizationId'] as String,
      inspectorUserId: json['inspectorUserId'] as String,
      droneId: json['droneId'] as String?,
      readinessDecisionId: json['readinessDecisionId'] as String?,
      checklistTemplateId: json['checklistTemplateId'] as String?,
      readinessVersion: (json['readinessVersion'] as num?)?.toInt(),
      status: json['status'] as String,
      startedAt: json['startedAt'] as String?,
      endedAt: json['endedAt'] as String?,
      postponementReason: json['postponementReason'] as String?,
      abortReason: json['abortReason'] as String?,
    );

Map<String, dynamic> _$FieldSessionToJson(_FieldSession instance) =>
    <String, dynamic>{
      'id': instance.id,
      'inspectionId': instance.inspectionId,
      'organizationId': instance.organizationId,
      'inspectorUserId': instance.inspectorUserId,
      'droneId': instance.droneId,
      'readinessDecisionId': instance.readinessDecisionId,
      'checklistTemplateId': instance.checklistTemplateId,
      'readinessVersion': instance.readinessVersion,
      'status': instance.status,
      'startedAt': instance.startedAt,
      'endedAt': instance.endedAt,
      'postponementReason': instance.postponementReason,
      'abortReason': instance.abortReason,
    };

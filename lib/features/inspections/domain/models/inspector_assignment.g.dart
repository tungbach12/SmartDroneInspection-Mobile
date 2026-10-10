// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inspector_assignment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_InspectorAssignment _$InspectorAssignmentFromJson(Map<String, dynamic> json) =>
    _InspectorAssignment(
      id: json['id'] as String,
      organizationId: json['organizationId'] as String,
      assetId: json['assetId'] as String,
      assetName: json['assetName'] as String,
      inspectorUserId: json['inspectorUserId'] as String,
      droneId: json['droneId'] as String,
      droneSerialNumber: json['droneSerialNumber'] as String,
      droneServiceability: json['droneServiceability'] as String,
      validFrom: json['validFrom'] as String?,
      validUntil: json['validUntil'] as String?,
      status: json['status'] as String,
      reason: json['reason'] as String?,
      assignmentResponse: json['assignmentResponse'] as String?,
      respondedAt: json['respondedAt'] as String?,
      assignedAt: json['assignedAt'] as String,
    );

Map<String, dynamic> _$InspectorAssignmentToJson(
  _InspectorAssignment instance,
) => <String, dynamic>{
  'id': instance.id,
  'organizationId': instance.organizationId,
  'assetId': instance.assetId,
  'assetName': instance.assetName,
  'inspectorUserId': instance.inspectorUserId,
  'droneId': instance.droneId,
  'droneSerialNumber': instance.droneSerialNumber,
  'droneServiceability': instance.droneServiceability,
  'validFrom': instance.validFrom,
  'validUntil': instance.validUntil,
  'status': instance.status,
  'reason': instance.reason,
  'assignmentResponse': instance.assignmentResponse,
  'respondedAt': instance.respondedAt,
  'assignedAt': instance.assignedAt,
};

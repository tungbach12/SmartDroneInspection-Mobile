// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inspection_assignment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_InspectionAssignment _$InspectionAssignmentFromJson(
  Map<String, dynamic> json,
) => _InspectionAssignment(
  assignmentId: json['assignmentId'] as String,
  serviceOrderId: json['serviceOrderId'] as String,
  assetId: json['assetId'] as String,
  deadline: json['deadline'] as String?,
  status: json['status'] as String,
  inspectionId: json['inspectionId'] as String?,
);

Map<String, dynamic> _$InspectionAssignmentToJson(
  _InspectionAssignment instance,
) => <String, dynamic>{
  'assignmentId': instance.assignmentId,
  'serviceOrderId': instance.serviceOrderId,
  'assetId': instance.assetId,
  'deadline': instance.deadline,
  'status': instance.status,
  'inspectionId': instance.inspectionId,
};

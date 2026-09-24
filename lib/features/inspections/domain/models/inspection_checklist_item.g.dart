// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inspection_checklist_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_InspectionChecklistItem _$InspectionChecklistItemFromJson(
  Map<String, dynamic> json,
) => _InspectionChecklistItem(
  itemId: json['itemId'] as String,
  itemCode: json['itemCode'] as String,
  sectionName: json['sectionName'] as String?,
  prompt: json['prompt'] as String,
  responseType: json['responseType'] as String,
  required: json['required'] as bool,
  displayOrder: (json['displayOrder'] as num).toInt(),
  guidance: json['guidance'] as String?,
  validationConfig: json['validationConfig'] as String?,
  responseValue: json['responseValue'] as Map<String, dynamic>?,
  notes: json['notes'] as String?,
  completedAt: json['completedAt'] as String?,
);

Map<String, dynamic> _$InspectionChecklistItemToJson(
  _InspectionChecklistItem instance,
) => <String, dynamic>{
  'itemId': instance.itemId,
  'itemCode': instance.itemCode,
  'sectionName': instance.sectionName,
  'prompt': instance.prompt,
  'responseType': instance.responseType,
  'required': instance.required,
  'displayOrder': instance.displayOrder,
  'guidance': instance.guidance,
  'validationConfig': instance.validationConfig,
  'responseValue': instance.responseValue,
  'notes': instance.notes,
  'completedAt': instance.completedAt,
};

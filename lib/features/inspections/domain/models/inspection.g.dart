// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inspection.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Inspection _$InspectionFromJson(Map<String, dynamic> json) => _Inspection(
  id: json['id'] as String,
  assetId: json['assetId'] as String,
  assetName: json['assetName'] as String?,
  droneSerialNumber: json['droneSerialNumber'] as String?,
  droneModel: json['droneModel'] as String?,
  status: json['status'] as String,
  flightPermitFileKey: json['flightPermitFileKey'] as String?,
  flightPermitFileName: json['flightPermitFileName'] as String?,
  flightPermitUploadedAt: json['flightPermitUploadedAt'] as String?,
  inspectionItems:
      (json['inspectionItems'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const <String>[],
);

Map<String, dynamic> _$InspectionToJson(_Inspection instance) =>
    <String, dynamic>{
      'id': instance.id,
      'assetId': instance.assetId,
      'assetName': instance.assetName,
      'droneSerialNumber': instance.droneSerialNumber,
      'droneModel': instance.droneModel,
      'status': instance.status,
      'flightPermitFileKey': instance.flightPermitFileKey,
      'flightPermitFileName': instance.flightPermitFileName,
      'flightPermitUploadedAt': instance.flightPermitUploadedAt,
      'inspectionItems': instance.inspectionItems,
    };

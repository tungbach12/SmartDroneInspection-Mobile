// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inspection_evidence.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_InspectionEvidence _$InspectionEvidenceFromJson(Map<String, dynamic> json) =>
    _InspectionEvidence(
      id: json['id'] as String,
      inspectionId: json['inspectionId'] as String,
      fieldSessionId: json['fieldSessionId'] as String?,
      fileName: json['fileName'] as String,
      contentType: json['contentType'] as String,
      sizeBytes: (json['sizeBytes'] as num).toInt(),
      captureTime: json['captureTime'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      uploadStatus: json['uploadStatus'] as String,
      createdAt: json['createdAt'] as String,
      retiredAt: json['retiredAt'] as String?,
    );

Map<String, dynamic> _$InspectionEvidenceToJson(_InspectionEvidence instance) =>
    <String, dynamic>{
      'id': instance.id,
      'inspectionId': instance.inspectionId,
      'fieldSessionId': instance.fieldSessionId,
      'fileName': instance.fileName,
      'contentType': instance.contentType,
      'sizeBytes': instance.sizeBytes,
      'captureTime': instance.captureTime,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'uploadStatus': instance.uploadStatus,
      'createdAt': instance.createdAt,
      'retiredAt': instance.retiredAt,
    };

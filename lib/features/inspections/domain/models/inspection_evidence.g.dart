// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inspection_evidence.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_InspectionEvidence _$InspectionEvidenceFromJson(Map<String, dynamic> json) =>
    _InspectionEvidence(
      evidenceId: json['evidenceId'] as String,
      fileName: json['fileName'] as String,
      contentType: json['contentType'] as String,
      sizeBytes: (json['sizeBytes'] as num).toInt(),
      checksumSha256: json['checksumSha256'] as String,
      source: json['source'] as String,
      captureTime: json['captureTime'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      externalReference: json['externalReference'] as String?,
      uploadStatus: json['uploadStatus'] as String,
      createdAt: json['createdAt'] as String,
    );

Map<String, dynamic> _$InspectionEvidenceToJson(_InspectionEvidence instance) =>
    <String, dynamic>{
      'evidenceId': instance.evidenceId,
      'fileName': instance.fileName,
      'contentType': instance.contentType,
      'sizeBytes': instance.sizeBytes,
      'checksumSha256': instance.checksumSha256,
      'source': instance.source,
      'captureTime': instance.captureTime,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'externalReference': instance.externalReference,
      'uploadStatus': instance.uploadStatus,
      'createdAt': instance.createdAt,
    };

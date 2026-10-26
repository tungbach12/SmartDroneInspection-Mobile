// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'field_session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FieldSession _$FieldSessionFromJson(Map<String, dynamic> json) =>
    _FieldSession(
      id: json['id'] as String,
      inspectionId: json['inspectionId'] as String,
      status: json['status'] as String,
      startedAt: json['startedAt'] as String?,
      endedAt: json['endedAt'] as String?,
      postponementReason: json['postponementReason'] as String?,
      abortReason: json['abortReason'] as String?,
      outcomeNotes: json['outcomeNotes'] as String?,
    );

Map<String, dynamic> _$FieldSessionToJson(_FieldSession instance) =>
    <String, dynamic>{
      'id': instance.id,
      'inspectionId': instance.inspectionId,
      'status': instance.status,
      'startedAt': instance.startedAt,
      'endedAt': instance.endedAt,
      'postponementReason': instance.postponementReason,
      'abortReason': instance.abortReason,
      'outcomeNotes': instance.outcomeNotes,
    };

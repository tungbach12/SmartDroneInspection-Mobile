// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'asset.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Asset _$AssetFromJson(Map<String, dynamic> json) => _Asset(
  id: json['id'] as String,
  name: json['name'] as String,
  assetCode: json['assetCode'] as String,
  description: json['description'] as String?,
  location: json['location'] as String?,
  status: json['status'] as String? ?? 'Active',
  createdAt: json['createdAt'] as String,
);

Map<String, dynamic> _$AssetToJson(_Asset instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'assetCode': instance.assetCode,
  'description': instance.description,
  'location': instance.location,
  'status': instance.status,
  'createdAt': instance.createdAt,
};

// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'inspection_evidence.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$InspectionEvidence {

 String get id; String get inspectionId; String? get fieldSessionId; String get fileName; String get contentType; int get sizeBytes; String? get captureTime; double? get latitude; double? get longitude; String get createdAt; bool get isDeleted;
/// Create a copy of InspectionEvidence
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InspectionEvidenceCopyWith<InspectionEvidence> get copyWith => _$InspectionEvidenceCopyWithImpl<InspectionEvidence>(this as InspectionEvidence, _$identity);

  /// Serializes this InspectionEvidence to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as InspectionEvidence;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InspectionEvidence&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.inspectionId, _this.inspectionId) || other.inspectionId == _this.inspectionId)&&(identical(other.fieldSessionId, _this.fieldSessionId) || other.fieldSessionId == _this.fieldSessionId)&&(identical(other.fileName, _this.fileName) || other.fileName == _this.fileName)&&(identical(other.contentType, _this.contentType) || other.contentType == _this.contentType)&&(identical(other.sizeBytes, _this.sizeBytes) || other.sizeBytes == _this.sizeBytes)&&(identical(other.captureTime, _this.captureTime) || other.captureTime == _this.captureTime)&&(identical(other.latitude, _this.latitude) || other.latitude == _this.latitude)&&(identical(other.longitude, _this.longitude) || other.longitude == _this.longitude)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.isDeleted, _this.isDeleted) || other.isDeleted == _this.isDeleted));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as InspectionEvidence;
  return Object.hash(runtimeType,_this.id,_this.inspectionId,_this.fieldSessionId,_this.fileName,_this.contentType,_this.sizeBytes,_this.captureTime,_this.latitude,_this.longitude,_this.createdAt,_this.isDeleted);
}

@override
String toString() {
  final _this = this as InspectionEvidence;
  return 'InspectionEvidence(id: ${_this.id}, inspectionId: ${_this.inspectionId}, fieldSessionId: ${_this.fieldSessionId}, fileName: ${_this.fileName}, contentType: ${_this.contentType}, sizeBytes: ${_this.sizeBytes}, captureTime: ${_this.captureTime}, latitude: ${_this.latitude}, longitude: ${_this.longitude}, createdAt: ${_this.createdAt}, isDeleted: ${_this.isDeleted})';
}


}

/// @nodoc
abstract mixin class $InspectionEvidenceCopyWith<$Res>  {
  factory $InspectionEvidenceCopyWith(InspectionEvidence value, $Res Function(InspectionEvidence) _then) = _$InspectionEvidenceCopyWithImpl;
@useResult
$Res call({
 String id, String inspectionId, String? fieldSessionId, String fileName, String contentType, int sizeBytes, String? captureTime, double? latitude, double? longitude, String createdAt, bool isDeleted
});




}
/// @nodoc
class _$InspectionEvidenceCopyWithImpl<$Res>
    implements $InspectionEvidenceCopyWith<$Res> {
  _$InspectionEvidenceCopyWithImpl(this._self, this._then);

  final InspectionEvidence _self;
  final $Res Function(InspectionEvidence) _then;

/// Create a copy of InspectionEvidence
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? inspectionId = null,Object? fieldSessionId = freezed,Object? fileName = null,Object? contentType = null,Object? sizeBytes = null,Object? captureTime = freezed,Object? latitude = freezed,Object? longitude = freezed,Object? createdAt = null,Object? isDeleted = null,}) {
  return _then(InspectionEvidence(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,inspectionId: null == inspectionId ? _self.inspectionId : inspectionId // ignore: cast_nullable_to_non_nullable
as String,fieldSessionId: freezed == fieldSessionId ? _self.fieldSessionId : fieldSessionId // ignore: cast_nullable_to_non_nullable
as String?,fileName: null == fileName ? _self.fileName : fileName // ignore: cast_nullable_to_non_nullable
as String,contentType: null == contentType ? _self.contentType : contentType // ignore: cast_nullable_to_non_nullable
as String,sizeBytes: null == sizeBytes ? _self.sizeBytes : sizeBytes // ignore: cast_nullable_to_non_nullable
as int,captureTime: freezed == captureTime ? _self.captureTime : captureTime // ignore: cast_nullable_to_non_nullable
as String?,latitude: freezed == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double?,longitude: freezed == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,isDeleted: null == isDeleted ? _self.isDeleted : isDeleted // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [InspectionEvidence].
extension InspectionEvidencePatterns on InspectionEvidence {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InspectionEvidence value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InspectionEvidence() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InspectionEvidence value)  $default,){
final _that = this;
switch (_that) {
case _InspectionEvidence():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InspectionEvidence value)?  $default,){
final _that = this;
switch (_that) {
case _InspectionEvidence() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String inspectionId,  String? fieldSessionId,  String fileName,  String contentType,  int sizeBytes,  String? captureTime,  double? latitude,  double? longitude,  String createdAt,  bool isDeleted)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InspectionEvidence() when $default != null:
return $default(_that.id,_that.inspectionId,_that.fieldSessionId,_that.fileName,_that.contentType,_that.sizeBytes,_that.captureTime,_that.latitude,_that.longitude,_that.createdAt,_that.isDeleted);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String inspectionId,  String? fieldSessionId,  String fileName,  String contentType,  int sizeBytes,  String? captureTime,  double? latitude,  double? longitude,  String createdAt,  bool isDeleted)  $default,) {final _that = this;
switch (_that) {
case _InspectionEvidence():
return $default(_that.id,_that.inspectionId,_that.fieldSessionId,_that.fileName,_that.contentType,_that.sizeBytes,_that.captureTime,_that.latitude,_that.longitude,_that.createdAt,_that.isDeleted);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String inspectionId,  String? fieldSessionId,  String fileName,  String contentType,  int sizeBytes,  String? captureTime,  double? latitude,  double? longitude,  String createdAt,  bool isDeleted)?  $default,) {final _that = this;
switch (_that) {
case _InspectionEvidence() when $default != null:
return $default(_that.id,_that.inspectionId,_that.fieldSessionId,_that.fileName,_that.contentType,_that.sizeBytes,_that.captureTime,_that.latitude,_that.longitude,_that.createdAt,_that.isDeleted);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _InspectionEvidence implements InspectionEvidence {
  const _InspectionEvidence({required this.id, required this.inspectionId, this.fieldSessionId, required this.fileName, required this.contentType, required this.sizeBytes, this.captureTime, this.latitude, this.longitude, required this.createdAt, this.isDeleted = false});
  factory _InspectionEvidence.fromJson(Map<String, dynamic> json) => _$InspectionEvidenceFromJson(json);

@override final  String id;
@override final  String inspectionId;
@override final  String? fieldSessionId;
@override final  String fileName;
@override final  String contentType;
@override final  int sizeBytes;
@override final  String? captureTime;
@override final  double? latitude;
@override final  double? longitude;
@override final  String createdAt;
@override@JsonKey() final  bool isDeleted;

/// Create a copy of InspectionEvidence
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InspectionEvidenceCopyWith<_InspectionEvidence> get copyWith => __$InspectionEvidenceCopyWithImpl<_InspectionEvidence>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$InspectionEvidenceToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _InspectionEvidence&&(identical(other.id, id) || other.id == id)&&(identical(other.inspectionId, inspectionId) || other.inspectionId == inspectionId)&&(identical(other.fieldSessionId, fieldSessionId) || other.fieldSessionId == fieldSessionId)&&(identical(other.fileName, fileName) || other.fileName == fileName)&&(identical(other.contentType, contentType) || other.contentType == contentType)&&(identical(other.sizeBytes, sizeBytes) || other.sizeBytes == sizeBytes)&&(identical(other.captureTime, captureTime) || other.captureTime == captureTime)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.isDeleted, isDeleted) || other.isDeleted == isDeleted));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,inspectionId,fieldSessionId,fileName,contentType,sizeBytes,captureTime,latitude,longitude,createdAt,isDeleted);
}

@override
String toString() {
    return 'InspectionEvidence(id: $id, inspectionId: $inspectionId, fieldSessionId: $fieldSessionId, fileName: $fileName, contentType: $contentType, sizeBytes: $sizeBytes, captureTime: $captureTime, latitude: $latitude, longitude: $longitude, createdAt: $createdAt, isDeleted: $isDeleted)';
}


}

/// @nodoc
abstract mixin class _$InspectionEvidenceCopyWith<$Res> implements $InspectionEvidenceCopyWith<$Res> {
  factory _$InspectionEvidenceCopyWith(_InspectionEvidence value, $Res Function(_InspectionEvidence) _then) = __$InspectionEvidenceCopyWithImpl;
@override @useResult
$Res call({
 String id, String inspectionId, String? fieldSessionId, String fileName, String contentType, int sizeBytes, String? captureTime, double? latitude, double? longitude, String createdAt, bool isDeleted
});




}
/// @nodoc
class __$InspectionEvidenceCopyWithImpl<$Res>
    implements _$InspectionEvidenceCopyWith<$Res> {
  __$InspectionEvidenceCopyWithImpl(this._self, this._then);

  final _InspectionEvidence _self;
  final $Res Function(_InspectionEvidence) _then;

/// Create a copy of InspectionEvidence
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? inspectionId = null,Object? fieldSessionId = freezed,Object? fileName = null,Object? contentType = null,Object? sizeBytes = null,Object? captureTime = freezed,Object? latitude = freezed,Object? longitude = freezed,Object? createdAt = null,Object? isDeleted = null,}) {
  return _then(_InspectionEvidence(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,inspectionId: null == inspectionId ? _self.inspectionId : inspectionId // ignore: cast_nullable_to_non_nullable
as String,fieldSessionId: freezed == fieldSessionId ? _self.fieldSessionId : fieldSessionId // ignore: cast_nullable_to_non_nullable
as String?,fileName: null == fileName ? _self.fileName : fileName // ignore: cast_nullable_to_non_nullable
as String,contentType: null == contentType ? _self.contentType : contentType // ignore: cast_nullable_to_non_nullable
as String,sizeBytes: null == sizeBytes ? _self.sizeBytes : sizeBytes // ignore: cast_nullable_to_non_nullable
as int,captureTime: freezed == captureTime ? _self.captureTime : captureTime // ignore: cast_nullable_to_non_nullable
as String?,latitude: freezed == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double?,longitude: freezed == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,isDeleted: null == isDeleted ? _self.isDeleted : isDeleted // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on

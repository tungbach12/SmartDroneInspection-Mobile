// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'inspection.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Inspection {

 String get id; String get assetId; String? get assetName; String? get droneSerialNumber; String? get droneModel; String get status; String? get flightPermitFileKey; String? get flightPermitFileName; String? get flightPermitUploadedAt; List<String> get inspectionItems;
/// Create a copy of Inspection
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InspectionCopyWith<Inspection> get copyWith => _$InspectionCopyWithImpl<Inspection>(this as Inspection, _$identity);

  /// Serializes this Inspection to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Inspection;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Inspection&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.assetId, _this.assetId) || other.assetId == _this.assetId)&&(identical(other.assetName, _this.assetName) || other.assetName == _this.assetName)&&(identical(other.droneSerialNumber, _this.droneSerialNumber) || other.droneSerialNumber == _this.droneSerialNumber)&&(identical(other.droneModel, _this.droneModel) || other.droneModel == _this.droneModel)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.flightPermitFileKey, _this.flightPermitFileKey) || other.flightPermitFileKey == _this.flightPermitFileKey)&&(identical(other.flightPermitFileName, _this.flightPermitFileName) || other.flightPermitFileName == _this.flightPermitFileName)&&(identical(other.flightPermitUploadedAt, _this.flightPermitUploadedAt) || other.flightPermitUploadedAt == _this.flightPermitUploadedAt)&&const DeepCollectionEquality().equals(other.inspectionItems, _this.inspectionItems));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Inspection;
  return Object.hash(runtimeType,_this.id,_this.assetId,_this.assetName,_this.droneSerialNumber,_this.droneModel,_this.status,_this.flightPermitFileKey,_this.flightPermitFileName,_this.flightPermitUploadedAt,const DeepCollectionEquality().hash(_this.inspectionItems));
}

@override
String toString() {
  final _this = this as Inspection;
  return 'Inspection(id: ${_this.id}, assetId: ${_this.assetId}, assetName: ${_this.assetName}, droneSerialNumber: ${_this.droneSerialNumber}, droneModel: ${_this.droneModel}, status: ${_this.status}, flightPermitFileKey: ${_this.flightPermitFileKey}, flightPermitFileName: ${_this.flightPermitFileName}, flightPermitUploadedAt: ${_this.flightPermitUploadedAt}, inspectionItems: ${_this.inspectionItems})';
}


}

/// @nodoc
abstract mixin class $InspectionCopyWith<$Res>  {
  factory $InspectionCopyWith(Inspection value, $Res Function(Inspection) _then) = _$InspectionCopyWithImpl;
@useResult
$Res call({
 String id, String assetId, String? assetName, String? droneSerialNumber, String? droneModel, String status, String? flightPermitFileKey, String? flightPermitFileName, String? flightPermitUploadedAt, List<String> inspectionItems
});




}
/// @nodoc
class _$InspectionCopyWithImpl<$Res>
    implements $InspectionCopyWith<$Res> {
  _$InspectionCopyWithImpl(this._self, this._then);

  final Inspection _self;
  final $Res Function(Inspection) _then;

/// Create a copy of Inspection
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? assetId = null,Object? assetName = freezed,Object? droneSerialNumber = freezed,Object? droneModel = freezed,Object? status = null,Object? flightPermitFileKey = freezed,Object? flightPermitFileName = freezed,Object? flightPermitUploadedAt = freezed,Object? inspectionItems = null,}) {
  return _then(Inspection(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,assetId: null == assetId ? _self.assetId : assetId // ignore: cast_nullable_to_non_nullable
as String,assetName: freezed == assetName ? _self.assetName : assetName // ignore: cast_nullable_to_non_nullable
as String?,droneSerialNumber: freezed == droneSerialNumber ? _self.droneSerialNumber : droneSerialNumber // ignore: cast_nullable_to_non_nullable
as String?,droneModel: freezed == droneModel ? _self.droneModel : droneModel // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,flightPermitFileKey: freezed == flightPermitFileKey ? _self.flightPermitFileKey : flightPermitFileKey // ignore: cast_nullable_to_non_nullable
as String?,flightPermitFileName: freezed == flightPermitFileName ? _self.flightPermitFileName : flightPermitFileName // ignore: cast_nullable_to_non_nullable
as String?,flightPermitUploadedAt: freezed == flightPermitUploadedAt ? _self.flightPermitUploadedAt : flightPermitUploadedAt // ignore: cast_nullable_to_non_nullable
as String?,inspectionItems: null == inspectionItems ? _self.inspectionItems : inspectionItems // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [Inspection].
extension InspectionPatterns on Inspection {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Inspection value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Inspection() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Inspection value)  $default,){
final _that = this;
switch (_that) {
case _Inspection():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Inspection value)?  $default,){
final _that = this;
switch (_that) {
case _Inspection() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String assetId,  String? assetName,  String? droneSerialNumber,  String? droneModel,  String status,  String? flightPermitFileKey,  String? flightPermitFileName,  String? flightPermitUploadedAt,  List<String> inspectionItems)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Inspection() when $default != null:
return $default(_that.id,_that.assetId,_that.assetName,_that.droneSerialNumber,_that.droneModel,_that.status,_that.flightPermitFileKey,_that.flightPermitFileName,_that.flightPermitUploadedAt,_that.inspectionItems);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String assetId,  String? assetName,  String? droneSerialNumber,  String? droneModel,  String status,  String? flightPermitFileKey,  String? flightPermitFileName,  String? flightPermitUploadedAt,  List<String> inspectionItems)  $default,) {final _that = this;
switch (_that) {
case _Inspection():
return $default(_that.id,_that.assetId,_that.assetName,_that.droneSerialNumber,_that.droneModel,_that.status,_that.flightPermitFileKey,_that.flightPermitFileName,_that.flightPermitUploadedAt,_that.inspectionItems);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String assetId,  String? assetName,  String? droneSerialNumber,  String? droneModel,  String status,  String? flightPermitFileKey,  String? flightPermitFileName,  String? flightPermitUploadedAt,  List<String> inspectionItems)?  $default,) {final _that = this;
switch (_that) {
case _Inspection() when $default != null:
return $default(_that.id,_that.assetId,_that.assetName,_that.droneSerialNumber,_that.droneModel,_that.status,_that.flightPermitFileKey,_that.flightPermitFileName,_that.flightPermitUploadedAt,_that.inspectionItems);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Inspection extends Inspection {
  const _Inspection({required this.id, required this.assetId, this.assetName, this.droneSerialNumber, this.droneModel, required this.status, this.flightPermitFileKey, this.flightPermitFileName, this.flightPermitUploadedAt,  List<String> inspectionItems = const <String>[]}): _inspectionItems = inspectionItems,super._();
  factory _Inspection.fromJson(Map<String, dynamic> json) => _$InspectionFromJson(json);

@override final  String id;
@override final  String assetId;
@override final  String? assetName;
@override final  String? droneSerialNumber;
@override final  String? droneModel;
@override final  String status;
@override final  String? flightPermitFileKey;
@override final  String? flightPermitFileName;
@override final  String? flightPermitUploadedAt;
 final  List<String> _inspectionItems;
@override@JsonKey() List<String> get inspectionItems {
  if (_inspectionItems is EqualUnmodifiableListView) return _inspectionItems;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_inspectionItems);
}


/// Create a copy of Inspection
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InspectionCopyWith<_Inspection> get copyWith => __$InspectionCopyWithImpl<_Inspection>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$InspectionToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Inspection&&(identical(other.id, id) || other.id == id)&&(identical(other.assetId, assetId) || other.assetId == assetId)&&(identical(other.assetName, assetName) || other.assetName == assetName)&&(identical(other.droneSerialNumber, droneSerialNumber) || other.droneSerialNumber == droneSerialNumber)&&(identical(other.droneModel, droneModel) || other.droneModel == droneModel)&&(identical(other.status, status) || other.status == status)&&(identical(other.flightPermitFileKey, flightPermitFileKey) || other.flightPermitFileKey == flightPermitFileKey)&&(identical(other.flightPermitFileName, flightPermitFileName) || other.flightPermitFileName == flightPermitFileName)&&(identical(other.flightPermitUploadedAt, flightPermitUploadedAt) || other.flightPermitUploadedAt == flightPermitUploadedAt)&&const DeepCollectionEquality().equals(other.inspectionItems, _inspectionItems));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,assetId,assetName,droneSerialNumber,droneModel,status,flightPermitFileKey,flightPermitFileName,flightPermitUploadedAt,const DeepCollectionEquality().hash(_inspectionItems));
}

@override
String toString() {
    return 'Inspection(id: $id, assetId: $assetId, assetName: $assetName, droneSerialNumber: $droneSerialNumber, droneModel: $droneModel, status: $status, flightPermitFileKey: $flightPermitFileKey, flightPermitFileName: $flightPermitFileName, flightPermitUploadedAt: $flightPermitUploadedAt, inspectionItems: $inspectionItems)';
}


}

/// @nodoc
abstract mixin class _$InspectionCopyWith<$Res> implements $InspectionCopyWith<$Res> {
  factory _$InspectionCopyWith(_Inspection value, $Res Function(_Inspection) _then) = __$InspectionCopyWithImpl;
@override @useResult
$Res call({
 String id, String assetId, String? assetName, String? droneSerialNumber, String? droneModel, String status, String? flightPermitFileKey, String? flightPermitFileName, String? flightPermitUploadedAt, List<String> inspectionItems
});




}
/// @nodoc
class __$InspectionCopyWithImpl<$Res>
    implements _$InspectionCopyWith<$Res> {
  __$InspectionCopyWithImpl(this._self, this._then);

  final _Inspection _self;
  final $Res Function(_Inspection) _then;

/// Create a copy of Inspection
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? assetId = null,Object? assetName = freezed,Object? droneSerialNumber = freezed,Object? droneModel = freezed,Object? status = null,Object? flightPermitFileKey = freezed,Object? flightPermitFileName = freezed,Object? flightPermitUploadedAt = freezed,Object? inspectionItems = null,}) {
  return _then(_Inspection(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,assetId: null == assetId ? _self.assetId : assetId // ignore: cast_nullable_to_non_nullable
as String,assetName: freezed == assetName ? _self.assetName : assetName // ignore: cast_nullable_to_non_nullable
as String?,droneSerialNumber: freezed == droneSerialNumber ? _self.droneSerialNumber : droneSerialNumber // ignore: cast_nullable_to_non_nullable
as String?,droneModel: freezed == droneModel ? _self.droneModel : droneModel // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,flightPermitFileKey: freezed == flightPermitFileKey ? _self.flightPermitFileKey : flightPermitFileKey // ignore: cast_nullable_to_non_nullable
as String?,flightPermitFileName: freezed == flightPermitFileName ? _self.flightPermitFileName : flightPermitFileName // ignore: cast_nullable_to_non_nullable
as String?,flightPermitUploadedAt: freezed == flightPermitUploadedAt ? _self.flightPermitUploadedAt : flightPermitUploadedAt // ignore: cast_nullable_to_non_nullable
as String?,inspectionItems: null == inspectionItems ? _self._inspectionItems : inspectionItems // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on

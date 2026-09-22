// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'started_inspection.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$StartedInspection {

 String get inspectionId; String get assignmentId; String get serviceOrderId; String get assetId; String get checklistTemplateId; String get status; String get startedAt;
/// Create a copy of StartedInspection
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StartedInspectionCopyWith<StartedInspection> get copyWith => _$StartedInspectionCopyWithImpl<StartedInspection>(this as StartedInspection, _$identity);

  /// Serializes this StartedInspection to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as StartedInspection;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StartedInspection&&(identical(other.inspectionId, _this.inspectionId) || other.inspectionId == _this.inspectionId)&&(identical(other.assignmentId, _this.assignmentId) || other.assignmentId == _this.assignmentId)&&(identical(other.serviceOrderId, _this.serviceOrderId) || other.serviceOrderId == _this.serviceOrderId)&&(identical(other.assetId, _this.assetId) || other.assetId == _this.assetId)&&(identical(other.checklistTemplateId, _this.checklistTemplateId) || other.checklistTemplateId == _this.checklistTemplateId)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.startedAt, _this.startedAt) || other.startedAt == _this.startedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as StartedInspection;
  return Object.hash(runtimeType,_this.inspectionId,_this.assignmentId,_this.serviceOrderId,_this.assetId,_this.checklistTemplateId,_this.status,_this.startedAt);
}

@override
String toString() {
  final _this = this as StartedInspection;
  return 'StartedInspection(inspectionId: ${_this.inspectionId}, assignmentId: ${_this.assignmentId}, serviceOrderId: ${_this.serviceOrderId}, assetId: ${_this.assetId}, checklistTemplateId: ${_this.checklistTemplateId}, status: ${_this.status}, startedAt: ${_this.startedAt})';
}


}

/// @nodoc
abstract mixin class $StartedInspectionCopyWith<$Res>  {
  factory $StartedInspectionCopyWith(StartedInspection value, $Res Function(StartedInspection) _then) = _$StartedInspectionCopyWithImpl;
@useResult
$Res call({
 String inspectionId, String assignmentId, String serviceOrderId, String assetId, String checklistTemplateId, String status, String startedAt
});




}
/// @nodoc
class _$StartedInspectionCopyWithImpl<$Res>
    implements $StartedInspectionCopyWith<$Res> {
  _$StartedInspectionCopyWithImpl(this._self, this._then);

  final StartedInspection _self;
  final $Res Function(StartedInspection) _then;

/// Create a copy of StartedInspection
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? inspectionId = null,Object? assignmentId = null,Object? serviceOrderId = null,Object? assetId = null,Object? checklistTemplateId = null,Object? status = null,Object? startedAt = null,}) {
  return _then(StartedInspection(
inspectionId: null == inspectionId ? _self.inspectionId : inspectionId // ignore: cast_nullable_to_non_nullable
as String,assignmentId: null == assignmentId ? _self.assignmentId : assignmentId // ignore: cast_nullable_to_non_nullable
as String,serviceOrderId: null == serviceOrderId ? _self.serviceOrderId : serviceOrderId // ignore: cast_nullable_to_non_nullable
as String,assetId: null == assetId ? _self.assetId : assetId // ignore: cast_nullable_to_non_nullable
as String,checklistTemplateId: null == checklistTemplateId ? _self.checklistTemplateId : checklistTemplateId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,startedAt: null == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [StartedInspection].
extension StartedInspectionPatterns on StartedInspection {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StartedInspection value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StartedInspection() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StartedInspection value)  $default,){
final _that = this;
switch (_that) {
case _StartedInspection():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StartedInspection value)?  $default,){
final _that = this;
switch (_that) {
case _StartedInspection() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String inspectionId,  String assignmentId,  String serviceOrderId,  String assetId,  String checklistTemplateId,  String status,  String startedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StartedInspection() when $default != null:
return $default(_that.inspectionId,_that.assignmentId,_that.serviceOrderId,_that.assetId,_that.checklistTemplateId,_that.status,_that.startedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String inspectionId,  String assignmentId,  String serviceOrderId,  String assetId,  String checklistTemplateId,  String status,  String startedAt)  $default,) {final _that = this;
switch (_that) {
case _StartedInspection():
return $default(_that.inspectionId,_that.assignmentId,_that.serviceOrderId,_that.assetId,_that.checklistTemplateId,_that.status,_that.startedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String inspectionId,  String assignmentId,  String serviceOrderId,  String assetId,  String checklistTemplateId,  String status,  String startedAt)?  $default,) {final _that = this;
switch (_that) {
case _StartedInspection() when $default != null:
return $default(_that.inspectionId,_that.assignmentId,_that.serviceOrderId,_that.assetId,_that.checklistTemplateId,_that.status,_that.startedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StartedInspection implements StartedInspection {
  const _StartedInspection({required this.inspectionId, required this.assignmentId, required this.serviceOrderId, required this.assetId, required this.checklistTemplateId, required this.status, required this.startedAt});
  factory _StartedInspection.fromJson(Map<String, dynamic> json) => _$StartedInspectionFromJson(json);

@override final  String inspectionId;
@override final  String assignmentId;
@override final  String serviceOrderId;
@override final  String assetId;
@override final  String checklistTemplateId;
@override final  String status;
@override final  String startedAt;

/// Create a copy of StartedInspection
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StartedInspectionCopyWith<_StartedInspection> get copyWith => __$StartedInspectionCopyWithImpl<_StartedInspection>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StartedInspectionToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _StartedInspection&&(identical(other.inspectionId, inspectionId) || other.inspectionId == inspectionId)&&(identical(other.assignmentId, assignmentId) || other.assignmentId == assignmentId)&&(identical(other.serviceOrderId, serviceOrderId) || other.serviceOrderId == serviceOrderId)&&(identical(other.assetId, assetId) || other.assetId == assetId)&&(identical(other.checklistTemplateId, checklistTemplateId) || other.checklistTemplateId == checklistTemplateId)&&(identical(other.status, status) || other.status == status)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,inspectionId,assignmentId,serviceOrderId,assetId,checklistTemplateId,status,startedAt);
}

@override
String toString() {
    return 'StartedInspection(inspectionId: $inspectionId, assignmentId: $assignmentId, serviceOrderId: $serviceOrderId, assetId: $assetId, checklistTemplateId: $checklistTemplateId, status: $status, startedAt: $startedAt)';
}


}

/// @nodoc
abstract mixin class _$StartedInspectionCopyWith<$Res> implements $StartedInspectionCopyWith<$Res> {
  factory _$StartedInspectionCopyWith(_StartedInspection value, $Res Function(_StartedInspection) _then) = __$StartedInspectionCopyWithImpl;
@override @useResult
$Res call({
 String inspectionId, String assignmentId, String serviceOrderId, String assetId, String checklistTemplateId, String status, String startedAt
});




}
/// @nodoc
class __$StartedInspectionCopyWithImpl<$Res>
    implements _$StartedInspectionCopyWith<$Res> {
  __$StartedInspectionCopyWithImpl(this._self, this._then);

  final _StartedInspection _self;
  final $Res Function(_StartedInspection) _then;

/// Create a copy of StartedInspection
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? inspectionId = null,Object? assignmentId = null,Object? serviceOrderId = null,Object? assetId = null,Object? checklistTemplateId = null,Object? status = null,Object? startedAt = null,}) {
  return _then(_StartedInspection(
inspectionId: null == inspectionId ? _self.inspectionId : inspectionId // ignore: cast_nullable_to_non_nullable
as String,assignmentId: null == assignmentId ? _self.assignmentId : assignmentId // ignore: cast_nullable_to_non_nullable
as String,serviceOrderId: null == serviceOrderId ? _self.serviceOrderId : serviceOrderId // ignore: cast_nullable_to_non_nullable
as String,assetId: null == assetId ? _self.assetId : assetId // ignore: cast_nullable_to_non_nullable
as String,checklistTemplateId: null == checklistTemplateId ? _self.checklistTemplateId : checklistTemplateId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,startedAt: null == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on

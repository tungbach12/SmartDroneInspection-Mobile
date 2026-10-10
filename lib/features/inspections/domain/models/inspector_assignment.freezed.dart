// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'inspector_assignment.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$InspectorAssignment {

 String get id; String get organizationId; String get assetId; String get assetName; String get inspectorUserId; String get droneId; String get droneSerialNumber; String get droneServiceability; String? get validFrom; String? get validUntil; String get status; String? get reason; String? get assignmentResponse; String? get respondedAt; String get assignedAt;
/// Create a copy of InspectorAssignment
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InspectorAssignmentCopyWith<InspectorAssignment> get copyWith => _$InspectorAssignmentCopyWithImpl<InspectorAssignment>(this as InspectorAssignment, _$identity);

  /// Serializes this InspectorAssignment to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as InspectorAssignment;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InspectorAssignment&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.organizationId, _this.organizationId) || other.organizationId == _this.organizationId)&&(identical(other.assetId, _this.assetId) || other.assetId == _this.assetId)&&(identical(other.assetName, _this.assetName) || other.assetName == _this.assetName)&&(identical(other.inspectorUserId, _this.inspectorUserId) || other.inspectorUserId == _this.inspectorUserId)&&(identical(other.droneId, _this.droneId) || other.droneId == _this.droneId)&&(identical(other.droneSerialNumber, _this.droneSerialNumber) || other.droneSerialNumber == _this.droneSerialNumber)&&(identical(other.droneServiceability, _this.droneServiceability) || other.droneServiceability == _this.droneServiceability)&&(identical(other.validFrom, _this.validFrom) || other.validFrom == _this.validFrom)&&(identical(other.validUntil, _this.validUntil) || other.validUntil == _this.validUntil)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.reason, _this.reason) || other.reason == _this.reason)&&(identical(other.assignmentResponse, _this.assignmentResponse) || other.assignmentResponse == _this.assignmentResponse)&&(identical(other.respondedAt, _this.respondedAt) || other.respondedAt == _this.respondedAt)&&(identical(other.assignedAt, _this.assignedAt) || other.assignedAt == _this.assignedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as InspectorAssignment;
  return Object.hash(runtimeType,_this.id,_this.organizationId,_this.assetId,_this.assetName,_this.inspectorUserId,_this.droneId,_this.droneSerialNumber,_this.droneServiceability,_this.validFrom,_this.validUntil,_this.status,_this.reason,_this.assignmentResponse,_this.respondedAt,_this.assignedAt);
}

@override
String toString() {
  final _this = this as InspectorAssignment;
  return 'InspectorAssignment(id: ${_this.id}, organizationId: ${_this.organizationId}, assetId: ${_this.assetId}, assetName: ${_this.assetName}, inspectorUserId: ${_this.inspectorUserId}, droneId: ${_this.droneId}, droneSerialNumber: ${_this.droneSerialNumber}, droneServiceability: ${_this.droneServiceability}, validFrom: ${_this.validFrom}, validUntil: ${_this.validUntil}, status: ${_this.status}, reason: ${_this.reason}, assignmentResponse: ${_this.assignmentResponse}, respondedAt: ${_this.respondedAt}, assignedAt: ${_this.assignedAt})';
}


}

/// @nodoc
abstract mixin class $InspectorAssignmentCopyWith<$Res>  {
  factory $InspectorAssignmentCopyWith(InspectorAssignment value, $Res Function(InspectorAssignment) _then) = _$InspectorAssignmentCopyWithImpl;
@useResult
$Res call({
 String id, String organizationId, String assetId, String assetName, String inspectorUserId, String droneId, String droneSerialNumber, String droneServiceability, String? validFrom, String? validUntil, String status, String? reason, String? assignmentResponse, String? respondedAt, String assignedAt
});




}
/// @nodoc
class _$InspectorAssignmentCopyWithImpl<$Res>
    implements $InspectorAssignmentCopyWith<$Res> {
  _$InspectorAssignmentCopyWithImpl(this._self, this._then);

  final InspectorAssignment _self;
  final $Res Function(InspectorAssignment) _then;

/// Create a copy of InspectorAssignment
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? organizationId = null,Object? assetId = null,Object? assetName = null,Object? inspectorUserId = null,Object? droneId = null,Object? droneSerialNumber = null,Object? droneServiceability = null,Object? validFrom = freezed,Object? validUntil = freezed,Object? status = null,Object? reason = freezed,Object? assignmentResponse = freezed,Object? respondedAt = freezed,Object? assignedAt = null,}) {
  return _then(InspectorAssignment(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,organizationId: null == organizationId ? _self.organizationId : organizationId // ignore: cast_nullable_to_non_nullable
as String,assetId: null == assetId ? _self.assetId : assetId // ignore: cast_nullable_to_non_nullable
as String,assetName: null == assetName ? _self.assetName : assetName // ignore: cast_nullable_to_non_nullable
as String,inspectorUserId: null == inspectorUserId ? _self.inspectorUserId : inspectorUserId // ignore: cast_nullable_to_non_nullable
as String,droneId: null == droneId ? _self.droneId : droneId // ignore: cast_nullable_to_non_nullable
as String,droneSerialNumber: null == droneSerialNumber ? _self.droneSerialNumber : droneSerialNumber // ignore: cast_nullable_to_non_nullable
as String,droneServiceability: null == droneServiceability ? _self.droneServiceability : droneServiceability // ignore: cast_nullable_to_non_nullable
as String,validFrom: freezed == validFrom ? _self.validFrom : validFrom // ignore: cast_nullable_to_non_nullable
as String?,validUntil: freezed == validUntil ? _self.validUntil : validUntil // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,reason: freezed == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String?,assignmentResponse: freezed == assignmentResponse ? _self.assignmentResponse : assignmentResponse // ignore: cast_nullable_to_non_nullable
as String?,respondedAt: freezed == respondedAt ? _self.respondedAt : respondedAt // ignore: cast_nullable_to_non_nullable
as String?,assignedAt: null == assignedAt ? _self.assignedAt : assignedAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [InspectorAssignment].
extension InspectorAssignmentPatterns on InspectorAssignment {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InspectorAssignment value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InspectorAssignment() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InspectorAssignment value)  $default,){
final _that = this;
switch (_that) {
case _InspectorAssignment():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InspectorAssignment value)?  $default,){
final _that = this;
switch (_that) {
case _InspectorAssignment() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String organizationId,  String assetId,  String assetName,  String inspectorUserId,  String droneId,  String droneSerialNumber,  String droneServiceability,  String? validFrom,  String? validUntil,  String status,  String? reason,  String? assignmentResponse,  String? respondedAt,  String assignedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InspectorAssignment() when $default != null:
return $default(_that.id,_that.organizationId,_that.assetId,_that.assetName,_that.inspectorUserId,_that.droneId,_that.droneSerialNumber,_that.droneServiceability,_that.validFrom,_that.validUntil,_that.status,_that.reason,_that.assignmentResponse,_that.respondedAt,_that.assignedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String organizationId,  String assetId,  String assetName,  String inspectorUserId,  String droneId,  String droneSerialNumber,  String droneServiceability,  String? validFrom,  String? validUntil,  String status,  String? reason,  String? assignmentResponse,  String? respondedAt,  String assignedAt)  $default,) {final _that = this;
switch (_that) {
case _InspectorAssignment():
return $default(_that.id,_that.organizationId,_that.assetId,_that.assetName,_that.inspectorUserId,_that.droneId,_that.droneSerialNumber,_that.droneServiceability,_that.validFrom,_that.validUntil,_that.status,_that.reason,_that.assignmentResponse,_that.respondedAt,_that.assignedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String organizationId,  String assetId,  String assetName,  String inspectorUserId,  String droneId,  String droneSerialNumber,  String droneServiceability,  String? validFrom,  String? validUntil,  String status,  String? reason,  String? assignmentResponse,  String? respondedAt,  String assignedAt)?  $default,) {final _that = this;
switch (_that) {
case _InspectorAssignment() when $default != null:
return $default(_that.id,_that.organizationId,_that.assetId,_that.assetName,_that.inspectorUserId,_that.droneId,_that.droneSerialNumber,_that.droneServiceability,_that.validFrom,_that.validUntil,_that.status,_that.reason,_that.assignmentResponse,_that.respondedAt,_that.assignedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _InspectorAssignment extends InspectorAssignment {
  const _InspectorAssignment({required this.id, required this.organizationId, required this.assetId, required this.assetName, required this.inspectorUserId, required this.droneId, required this.droneSerialNumber, required this.droneServiceability, this.validFrom, this.validUntil, required this.status, this.reason, this.assignmentResponse, this.respondedAt, required this.assignedAt}): super._();
  factory _InspectorAssignment.fromJson(Map<String, dynamic> json) => _$InspectorAssignmentFromJson(json);

@override final  String id;
@override final  String organizationId;
@override final  String assetId;
@override final  String assetName;
@override final  String inspectorUserId;
@override final  String droneId;
@override final  String droneSerialNumber;
@override final  String droneServiceability;
@override final  String? validFrom;
@override final  String? validUntil;
@override final  String status;
@override final  String? reason;
@override final  String? assignmentResponse;
@override final  String? respondedAt;
@override final  String assignedAt;

/// Create a copy of InspectorAssignment
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InspectorAssignmentCopyWith<_InspectorAssignment> get copyWith => __$InspectorAssignmentCopyWithImpl<_InspectorAssignment>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$InspectorAssignmentToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _InspectorAssignment&&(identical(other.id, id) || other.id == id)&&(identical(other.organizationId, organizationId) || other.organizationId == organizationId)&&(identical(other.assetId, assetId) || other.assetId == assetId)&&(identical(other.assetName, assetName) || other.assetName == assetName)&&(identical(other.inspectorUserId, inspectorUserId) || other.inspectorUserId == inspectorUserId)&&(identical(other.droneId, droneId) || other.droneId == droneId)&&(identical(other.droneSerialNumber, droneSerialNumber) || other.droneSerialNumber == droneSerialNumber)&&(identical(other.droneServiceability, droneServiceability) || other.droneServiceability == droneServiceability)&&(identical(other.validFrom, validFrom) || other.validFrom == validFrom)&&(identical(other.validUntil, validUntil) || other.validUntil == validUntil)&&(identical(other.status, status) || other.status == status)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.assignmentResponse, assignmentResponse) || other.assignmentResponse == assignmentResponse)&&(identical(other.respondedAt, respondedAt) || other.respondedAt == respondedAt)&&(identical(other.assignedAt, assignedAt) || other.assignedAt == assignedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,organizationId,assetId,assetName,inspectorUserId,droneId,droneSerialNumber,droneServiceability,validFrom,validUntil,status,reason,assignmentResponse,respondedAt,assignedAt);
}

@override
String toString() {
    return 'InspectorAssignment(id: $id, organizationId: $organizationId, assetId: $assetId, assetName: $assetName, inspectorUserId: $inspectorUserId, droneId: $droneId, droneSerialNumber: $droneSerialNumber, droneServiceability: $droneServiceability, validFrom: $validFrom, validUntil: $validUntil, status: $status, reason: $reason, assignmentResponse: $assignmentResponse, respondedAt: $respondedAt, assignedAt: $assignedAt)';
}


}

/// @nodoc
abstract mixin class _$InspectorAssignmentCopyWith<$Res> implements $InspectorAssignmentCopyWith<$Res> {
  factory _$InspectorAssignmentCopyWith(_InspectorAssignment value, $Res Function(_InspectorAssignment) _then) = __$InspectorAssignmentCopyWithImpl;
@override @useResult
$Res call({
 String id, String organizationId, String assetId, String assetName, String inspectorUserId, String droneId, String droneSerialNumber, String droneServiceability, String? validFrom, String? validUntil, String status, String? reason, String? assignmentResponse, String? respondedAt, String assignedAt
});




}
/// @nodoc
class __$InspectorAssignmentCopyWithImpl<$Res>
    implements _$InspectorAssignmentCopyWith<$Res> {
  __$InspectorAssignmentCopyWithImpl(this._self, this._then);

  final _InspectorAssignment _self;
  final $Res Function(_InspectorAssignment) _then;

/// Create a copy of InspectorAssignment
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? organizationId = null,Object? assetId = null,Object? assetName = null,Object? inspectorUserId = null,Object? droneId = null,Object? droneSerialNumber = null,Object? droneServiceability = null,Object? validFrom = freezed,Object? validUntil = freezed,Object? status = null,Object? reason = freezed,Object? assignmentResponse = freezed,Object? respondedAt = freezed,Object? assignedAt = null,}) {
  return _then(_InspectorAssignment(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,organizationId: null == organizationId ? _self.organizationId : organizationId // ignore: cast_nullable_to_non_nullable
as String,assetId: null == assetId ? _self.assetId : assetId // ignore: cast_nullable_to_non_nullable
as String,assetName: null == assetName ? _self.assetName : assetName // ignore: cast_nullable_to_non_nullable
as String,inspectorUserId: null == inspectorUserId ? _self.inspectorUserId : inspectorUserId // ignore: cast_nullable_to_non_nullable
as String,droneId: null == droneId ? _self.droneId : droneId // ignore: cast_nullable_to_non_nullable
as String,droneSerialNumber: null == droneSerialNumber ? _self.droneSerialNumber : droneSerialNumber // ignore: cast_nullable_to_non_nullable
as String,droneServiceability: null == droneServiceability ? _self.droneServiceability : droneServiceability // ignore: cast_nullable_to_non_nullable
as String,validFrom: freezed == validFrom ? _self.validFrom : validFrom // ignore: cast_nullable_to_non_nullable
as String?,validUntil: freezed == validUntil ? _self.validUntil : validUntil // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,reason: freezed == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String?,assignmentResponse: freezed == assignmentResponse ? _self.assignmentResponse : assignmentResponse // ignore: cast_nullable_to_non_nullable
as String?,respondedAt: freezed == respondedAt ? _self.respondedAt : respondedAt // ignore: cast_nullable_to_non_nullable
as String?,assignedAt: null == assignedAt ? _self.assignedAt : assignedAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on

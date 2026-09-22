// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'inspection_assignment.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$InspectionAssignment {

 String get assignmentId; String get serviceOrderId; String get assetId; String? get deadline; String get status; String? get inspectionId;
/// Create a copy of InspectionAssignment
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InspectionAssignmentCopyWith<InspectionAssignment> get copyWith => _$InspectionAssignmentCopyWithImpl<InspectionAssignment>(this as InspectionAssignment, _$identity);

  /// Serializes this InspectionAssignment to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as InspectionAssignment;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InspectionAssignment&&(identical(other.assignmentId, _this.assignmentId) || other.assignmentId == _this.assignmentId)&&(identical(other.serviceOrderId, _this.serviceOrderId) || other.serviceOrderId == _this.serviceOrderId)&&(identical(other.assetId, _this.assetId) || other.assetId == _this.assetId)&&(identical(other.deadline, _this.deadline) || other.deadline == _this.deadline)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.inspectionId, _this.inspectionId) || other.inspectionId == _this.inspectionId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as InspectionAssignment;
  return Object.hash(runtimeType,_this.assignmentId,_this.serviceOrderId,_this.assetId,_this.deadline,_this.status,_this.inspectionId);
}

@override
String toString() {
  final _this = this as InspectionAssignment;
  return 'InspectionAssignment(assignmentId: ${_this.assignmentId}, serviceOrderId: ${_this.serviceOrderId}, assetId: ${_this.assetId}, deadline: ${_this.deadline}, status: ${_this.status}, inspectionId: ${_this.inspectionId})';
}


}

/// @nodoc
abstract mixin class $InspectionAssignmentCopyWith<$Res>  {
  factory $InspectionAssignmentCopyWith(InspectionAssignment value, $Res Function(InspectionAssignment) _then) = _$InspectionAssignmentCopyWithImpl;
@useResult
$Res call({
 String assignmentId, String serviceOrderId, String assetId, String? deadline, String status, String? inspectionId
});




}
/// @nodoc
class _$InspectionAssignmentCopyWithImpl<$Res>
    implements $InspectionAssignmentCopyWith<$Res> {
  _$InspectionAssignmentCopyWithImpl(this._self, this._then);

  final InspectionAssignment _self;
  final $Res Function(InspectionAssignment) _then;

/// Create a copy of InspectionAssignment
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? assignmentId = null,Object? serviceOrderId = null,Object? assetId = null,Object? deadline = freezed,Object? status = null,Object? inspectionId = freezed,}) {
  return _then(InspectionAssignment(
assignmentId: null == assignmentId ? _self.assignmentId : assignmentId // ignore: cast_nullable_to_non_nullable
as String,serviceOrderId: null == serviceOrderId ? _self.serviceOrderId : serviceOrderId // ignore: cast_nullable_to_non_nullable
as String,assetId: null == assetId ? _self.assetId : assetId // ignore: cast_nullable_to_non_nullable
as String,deadline: freezed == deadline ? _self.deadline : deadline // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,inspectionId: freezed == inspectionId ? _self.inspectionId : inspectionId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [InspectionAssignment].
extension InspectionAssignmentPatterns on InspectionAssignment {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InspectionAssignment value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InspectionAssignment() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InspectionAssignment value)  $default,){
final _that = this;
switch (_that) {
case _InspectionAssignment():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InspectionAssignment value)?  $default,){
final _that = this;
switch (_that) {
case _InspectionAssignment() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String assignmentId,  String serviceOrderId,  String assetId,  String? deadline,  String status,  String? inspectionId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InspectionAssignment() when $default != null:
return $default(_that.assignmentId,_that.serviceOrderId,_that.assetId,_that.deadline,_that.status,_that.inspectionId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String assignmentId,  String serviceOrderId,  String assetId,  String? deadline,  String status,  String? inspectionId)  $default,) {final _that = this;
switch (_that) {
case _InspectionAssignment():
return $default(_that.assignmentId,_that.serviceOrderId,_that.assetId,_that.deadline,_that.status,_that.inspectionId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String assignmentId,  String serviceOrderId,  String assetId,  String? deadline,  String status,  String? inspectionId)?  $default,) {final _that = this;
switch (_that) {
case _InspectionAssignment() when $default != null:
return $default(_that.assignmentId,_that.serviceOrderId,_that.assetId,_that.deadline,_that.status,_that.inspectionId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _InspectionAssignment implements InspectionAssignment {
  const _InspectionAssignment({required this.assignmentId, required this.serviceOrderId, required this.assetId, this.deadline, required this.status, this.inspectionId});
  factory _InspectionAssignment.fromJson(Map<String, dynamic> json) => _$InspectionAssignmentFromJson(json);

@override final  String assignmentId;
@override final  String serviceOrderId;
@override final  String assetId;
@override final  String? deadline;
@override final  String status;
@override final  String? inspectionId;

/// Create a copy of InspectionAssignment
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InspectionAssignmentCopyWith<_InspectionAssignment> get copyWith => __$InspectionAssignmentCopyWithImpl<_InspectionAssignment>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$InspectionAssignmentToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _InspectionAssignment&&(identical(other.assignmentId, assignmentId) || other.assignmentId == assignmentId)&&(identical(other.serviceOrderId, serviceOrderId) || other.serviceOrderId == serviceOrderId)&&(identical(other.assetId, assetId) || other.assetId == assetId)&&(identical(other.deadline, deadline) || other.deadline == deadline)&&(identical(other.status, status) || other.status == status)&&(identical(other.inspectionId, inspectionId) || other.inspectionId == inspectionId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,assignmentId,serviceOrderId,assetId,deadline,status,inspectionId);
}

@override
String toString() {
    return 'InspectionAssignment(assignmentId: $assignmentId, serviceOrderId: $serviceOrderId, assetId: $assetId, deadline: $deadline, status: $status, inspectionId: $inspectionId)';
}


}

/// @nodoc
abstract mixin class _$InspectionAssignmentCopyWith<$Res> implements $InspectionAssignmentCopyWith<$Res> {
  factory _$InspectionAssignmentCopyWith(_InspectionAssignment value, $Res Function(_InspectionAssignment) _then) = __$InspectionAssignmentCopyWithImpl;
@override @useResult
$Res call({
 String assignmentId, String serviceOrderId, String assetId, String? deadline, String status, String? inspectionId
});




}
/// @nodoc
class __$InspectionAssignmentCopyWithImpl<$Res>
    implements _$InspectionAssignmentCopyWith<$Res> {
  __$InspectionAssignmentCopyWithImpl(this._self, this._then);

  final _InspectionAssignment _self;
  final $Res Function(_InspectionAssignment) _then;

/// Create a copy of InspectionAssignment
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? assignmentId = null,Object? serviceOrderId = null,Object? assetId = null,Object? deadline = freezed,Object? status = null,Object? inspectionId = freezed,}) {
  return _then(_InspectionAssignment(
assignmentId: null == assignmentId ? _self.assignmentId : assignmentId // ignore: cast_nullable_to_non_nullable
as String,serviceOrderId: null == serviceOrderId ? _self.serviceOrderId : serviceOrderId // ignore: cast_nullable_to_non_nullable
as String,assetId: null == assetId ? _self.assetId : assetId // ignore: cast_nullable_to_non_nullable
as String,deadline: freezed == deadline ? _self.deadline : deadline // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,inspectionId: freezed == inspectionId ? _self.inspectionId : inspectionId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on

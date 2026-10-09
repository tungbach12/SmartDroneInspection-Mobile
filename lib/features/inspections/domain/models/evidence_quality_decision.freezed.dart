// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'evidence_quality_decision.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$EvidenceQualityDecision {

 String get id; String get inspectionId; String? get fieldSessionId; String get decision; String? get shotListComparison; String? get limitationReason; String get decidedByUserId; String get decidedAt;
/// Create a copy of EvidenceQualityDecision
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EvidenceQualityDecisionCopyWith<EvidenceQualityDecision> get copyWith => _$EvidenceQualityDecisionCopyWithImpl<EvidenceQualityDecision>(this as EvidenceQualityDecision, _$identity);

  /// Serializes this EvidenceQualityDecision to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as EvidenceQualityDecision;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EvidenceQualityDecision&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.inspectionId, _this.inspectionId) || other.inspectionId == _this.inspectionId)&&(identical(other.fieldSessionId, _this.fieldSessionId) || other.fieldSessionId == _this.fieldSessionId)&&(identical(other.decision, _this.decision) || other.decision == _this.decision)&&(identical(other.shotListComparison, _this.shotListComparison) || other.shotListComparison == _this.shotListComparison)&&(identical(other.limitationReason, _this.limitationReason) || other.limitationReason == _this.limitationReason)&&(identical(other.decidedByUserId, _this.decidedByUserId) || other.decidedByUserId == _this.decidedByUserId)&&(identical(other.decidedAt, _this.decidedAt) || other.decidedAt == _this.decidedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as EvidenceQualityDecision;
  return Object.hash(runtimeType,_this.id,_this.inspectionId,_this.fieldSessionId,_this.decision,_this.shotListComparison,_this.limitationReason,_this.decidedByUserId,_this.decidedAt);
}

@override
String toString() {
  final _this = this as EvidenceQualityDecision;
  return 'EvidenceQualityDecision(id: ${_this.id}, inspectionId: ${_this.inspectionId}, fieldSessionId: ${_this.fieldSessionId}, decision: ${_this.decision}, shotListComparison: ${_this.shotListComparison}, limitationReason: ${_this.limitationReason}, decidedByUserId: ${_this.decidedByUserId}, decidedAt: ${_this.decidedAt})';
}


}

/// @nodoc
abstract mixin class $EvidenceQualityDecisionCopyWith<$Res>  {
  factory $EvidenceQualityDecisionCopyWith(EvidenceQualityDecision value, $Res Function(EvidenceQualityDecision) _then) = _$EvidenceQualityDecisionCopyWithImpl;
@useResult
$Res call({
 String id, String inspectionId, String? fieldSessionId, String decision, String? shotListComparison, String? limitationReason, String decidedByUserId, String decidedAt
});




}
/// @nodoc
class _$EvidenceQualityDecisionCopyWithImpl<$Res>
    implements $EvidenceQualityDecisionCopyWith<$Res> {
  _$EvidenceQualityDecisionCopyWithImpl(this._self, this._then);

  final EvidenceQualityDecision _self;
  final $Res Function(EvidenceQualityDecision) _then;

/// Create a copy of EvidenceQualityDecision
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? inspectionId = null,Object? fieldSessionId = freezed,Object? decision = null,Object? shotListComparison = freezed,Object? limitationReason = freezed,Object? decidedByUserId = null,Object? decidedAt = null,}) {
  return _then(EvidenceQualityDecision(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,inspectionId: null == inspectionId ? _self.inspectionId : inspectionId // ignore: cast_nullable_to_non_nullable
as String,fieldSessionId: freezed == fieldSessionId ? _self.fieldSessionId : fieldSessionId // ignore: cast_nullable_to_non_nullable
as String?,decision: null == decision ? _self.decision : decision // ignore: cast_nullable_to_non_nullable
as String,shotListComparison: freezed == shotListComparison ? _self.shotListComparison : shotListComparison // ignore: cast_nullable_to_non_nullable
as String?,limitationReason: freezed == limitationReason ? _self.limitationReason : limitationReason // ignore: cast_nullable_to_non_nullable
as String?,decidedByUserId: null == decidedByUserId ? _self.decidedByUserId : decidedByUserId // ignore: cast_nullable_to_non_nullable
as String,decidedAt: null == decidedAt ? _self.decidedAt : decidedAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [EvidenceQualityDecision].
extension EvidenceQualityDecisionPatterns on EvidenceQualityDecision {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EvidenceQualityDecision value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EvidenceQualityDecision() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EvidenceQualityDecision value)  $default,){
final _that = this;
switch (_that) {
case _EvidenceQualityDecision():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EvidenceQualityDecision value)?  $default,){
final _that = this;
switch (_that) {
case _EvidenceQualityDecision() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String inspectionId,  String? fieldSessionId,  String decision,  String? shotListComparison,  String? limitationReason,  String decidedByUserId,  String decidedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EvidenceQualityDecision() when $default != null:
return $default(_that.id,_that.inspectionId,_that.fieldSessionId,_that.decision,_that.shotListComparison,_that.limitationReason,_that.decidedByUserId,_that.decidedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String inspectionId,  String? fieldSessionId,  String decision,  String? shotListComparison,  String? limitationReason,  String decidedByUserId,  String decidedAt)  $default,) {final _that = this;
switch (_that) {
case _EvidenceQualityDecision():
return $default(_that.id,_that.inspectionId,_that.fieldSessionId,_that.decision,_that.shotListComparison,_that.limitationReason,_that.decidedByUserId,_that.decidedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String inspectionId,  String? fieldSessionId,  String decision,  String? shotListComparison,  String? limitationReason,  String decidedByUserId,  String decidedAt)?  $default,) {final _that = this;
switch (_that) {
case _EvidenceQualityDecision() when $default != null:
return $default(_that.id,_that.inspectionId,_that.fieldSessionId,_that.decision,_that.shotListComparison,_that.limitationReason,_that.decidedByUserId,_that.decidedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _EvidenceQualityDecision implements EvidenceQualityDecision {
  const _EvidenceQualityDecision({required this.id, required this.inspectionId, this.fieldSessionId, required this.decision, this.shotListComparison, this.limitationReason, required this.decidedByUserId, required this.decidedAt});
  factory _EvidenceQualityDecision.fromJson(Map<String, dynamic> json) => _$EvidenceQualityDecisionFromJson(json);

@override final  String id;
@override final  String inspectionId;
@override final  String? fieldSessionId;
@override final  String decision;
@override final  String? shotListComparison;
@override final  String? limitationReason;
@override final  String decidedByUserId;
@override final  String decidedAt;

/// Create a copy of EvidenceQualityDecision
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EvidenceQualityDecisionCopyWith<_EvidenceQualityDecision> get copyWith => __$EvidenceQualityDecisionCopyWithImpl<_EvidenceQualityDecision>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EvidenceQualityDecisionToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _EvidenceQualityDecision&&(identical(other.id, id) || other.id == id)&&(identical(other.inspectionId, inspectionId) || other.inspectionId == inspectionId)&&(identical(other.fieldSessionId, fieldSessionId) || other.fieldSessionId == fieldSessionId)&&(identical(other.decision, decision) || other.decision == decision)&&(identical(other.shotListComparison, shotListComparison) || other.shotListComparison == shotListComparison)&&(identical(other.limitationReason, limitationReason) || other.limitationReason == limitationReason)&&(identical(other.decidedByUserId, decidedByUserId) || other.decidedByUserId == decidedByUserId)&&(identical(other.decidedAt, decidedAt) || other.decidedAt == decidedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,inspectionId,fieldSessionId,decision,shotListComparison,limitationReason,decidedByUserId,decidedAt);
}

@override
String toString() {
    return 'EvidenceQualityDecision(id: $id, inspectionId: $inspectionId, fieldSessionId: $fieldSessionId, decision: $decision, shotListComparison: $shotListComparison, limitationReason: $limitationReason, decidedByUserId: $decidedByUserId, decidedAt: $decidedAt)';
}


}

/// @nodoc
abstract mixin class _$EvidenceQualityDecisionCopyWith<$Res> implements $EvidenceQualityDecisionCopyWith<$Res> {
  factory _$EvidenceQualityDecisionCopyWith(_EvidenceQualityDecision value, $Res Function(_EvidenceQualityDecision) _then) = __$EvidenceQualityDecisionCopyWithImpl;
@override @useResult
$Res call({
 String id, String inspectionId, String? fieldSessionId, String decision, String? shotListComparison, String? limitationReason, String decidedByUserId, String decidedAt
});




}
/// @nodoc
class __$EvidenceQualityDecisionCopyWithImpl<$Res>
    implements _$EvidenceQualityDecisionCopyWith<$Res> {
  __$EvidenceQualityDecisionCopyWithImpl(this._self, this._then);

  final _EvidenceQualityDecision _self;
  final $Res Function(_EvidenceQualityDecision) _then;

/// Create a copy of EvidenceQualityDecision
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? inspectionId = null,Object? fieldSessionId = freezed,Object? decision = null,Object? shotListComparison = freezed,Object? limitationReason = freezed,Object? decidedByUserId = null,Object? decidedAt = null,}) {
  return _then(_EvidenceQualityDecision(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,inspectionId: null == inspectionId ? _self.inspectionId : inspectionId // ignore: cast_nullable_to_non_nullable
as String,fieldSessionId: freezed == fieldSessionId ? _self.fieldSessionId : fieldSessionId // ignore: cast_nullable_to_non_nullable
as String?,decision: null == decision ? _self.decision : decision // ignore: cast_nullable_to_non_nullable
as String,shotListComparison: freezed == shotListComparison ? _self.shotListComparison : shotListComparison // ignore: cast_nullable_to_non_nullable
as String?,limitationReason: freezed == limitationReason ? _self.limitationReason : limitationReason // ignore: cast_nullable_to_non_nullable
as String?,decidedByUserId: null == decidedByUserId ? _self.decidedByUserId : decidedByUserId // ignore: cast_nullable_to_non_nullable
as String,decidedAt: null == decidedAt ? _self.decidedAt : decidedAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on

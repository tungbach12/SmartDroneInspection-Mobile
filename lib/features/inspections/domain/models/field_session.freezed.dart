// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'field_session.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FieldSession {

 String get id; String get inspectionId; String get organizationId; String get inspectorUserId; String? get droneId; String? get readinessDecisionId; String? get checklistTemplateId; int? get readinessVersion; String get status; String? get startedAt; String? get endedAt; String? get postponementReason; String? get abortReason;
/// Create a copy of FieldSession
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FieldSessionCopyWith<FieldSession> get copyWith => _$FieldSessionCopyWithImpl<FieldSession>(this as FieldSession, _$identity);

  /// Serializes this FieldSession to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as FieldSession;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FieldSession&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.inspectionId, _this.inspectionId) || other.inspectionId == _this.inspectionId)&&(identical(other.organizationId, _this.organizationId) || other.organizationId == _this.organizationId)&&(identical(other.inspectorUserId, _this.inspectorUserId) || other.inspectorUserId == _this.inspectorUserId)&&(identical(other.droneId, _this.droneId) || other.droneId == _this.droneId)&&(identical(other.readinessDecisionId, _this.readinessDecisionId) || other.readinessDecisionId == _this.readinessDecisionId)&&(identical(other.checklistTemplateId, _this.checklistTemplateId) || other.checklistTemplateId == _this.checklistTemplateId)&&(identical(other.readinessVersion, _this.readinessVersion) || other.readinessVersion == _this.readinessVersion)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.startedAt, _this.startedAt) || other.startedAt == _this.startedAt)&&(identical(other.endedAt, _this.endedAt) || other.endedAt == _this.endedAt)&&(identical(other.postponementReason, _this.postponementReason) || other.postponementReason == _this.postponementReason)&&(identical(other.abortReason, _this.abortReason) || other.abortReason == _this.abortReason));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as FieldSession;
  return Object.hash(runtimeType,_this.id,_this.inspectionId,_this.organizationId,_this.inspectorUserId,_this.droneId,_this.readinessDecisionId,_this.checklistTemplateId,_this.readinessVersion,_this.status,_this.startedAt,_this.endedAt,_this.postponementReason,_this.abortReason);
}

@override
String toString() {
  final _this = this as FieldSession;
  return 'FieldSession(id: ${_this.id}, inspectionId: ${_this.inspectionId}, organizationId: ${_this.organizationId}, inspectorUserId: ${_this.inspectorUserId}, droneId: ${_this.droneId}, readinessDecisionId: ${_this.readinessDecisionId}, checklistTemplateId: ${_this.checklistTemplateId}, readinessVersion: ${_this.readinessVersion}, status: ${_this.status}, startedAt: ${_this.startedAt}, endedAt: ${_this.endedAt}, postponementReason: ${_this.postponementReason}, abortReason: ${_this.abortReason})';
}


}

/// @nodoc
abstract mixin class $FieldSessionCopyWith<$Res>  {
  factory $FieldSessionCopyWith(FieldSession value, $Res Function(FieldSession) _then) = _$FieldSessionCopyWithImpl;
@useResult
$Res call({
 String id, String inspectionId, String organizationId, String inspectorUserId, String? droneId, String? readinessDecisionId, String? checklistTemplateId, int? readinessVersion, String status, String? startedAt, String? endedAt, String? postponementReason, String? abortReason
});




}
/// @nodoc
class _$FieldSessionCopyWithImpl<$Res>
    implements $FieldSessionCopyWith<$Res> {
  _$FieldSessionCopyWithImpl(this._self, this._then);

  final FieldSession _self;
  final $Res Function(FieldSession) _then;

/// Create a copy of FieldSession
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? inspectionId = null,Object? organizationId = null,Object? inspectorUserId = null,Object? droneId = freezed,Object? readinessDecisionId = freezed,Object? checklistTemplateId = freezed,Object? readinessVersion = freezed,Object? status = null,Object? startedAt = freezed,Object? endedAt = freezed,Object? postponementReason = freezed,Object? abortReason = freezed,}) {
  return _then(FieldSession(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,inspectionId: null == inspectionId ? _self.inspectionId : inspectionId // ignore: cast_nullable_to_non_nullable
as String,organizationId: null == organizationId ? _self.organizationId : organizationId // ignore: cast_nullable_to_non_nullable
as String,inspectorUserId: null == inspectorUserId ? _self.inspectorUserId : inspectorUserId // ignore: cast_nullable_to_non_nullable
as String,droneId: freezed == droneId ? _self.droneId : droneId // ignore: cast_nullable_to_non_nullable
as String?,readinessDecisionId: freezed == readinessDecisionId ? _self.readinessDecisionId : readinessDecisionId // ignore: cast_nullable_to_non_nullable
as String?,checklistTemplateId: freezed == checklistTemplateId ? _self.checklistTemplateId : checklistTemplateId // ignore: cast_nullable_to_non_nullable
as String?,readinessVersion: freezed == readinessVersion ? _self.readinessVersion : readinessVersion // ignore: cast_nullable_to_non_nullable
as int?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,startedAt: freezed == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as String?,endedAt: freezed == endedAt ? _self.endedAt : endedAt // ignore: cast_nullable_to_non_nullable
as String?,postponementReason: freezed == postponementReason ? _self.postponementReason : postponementReason // ignore: cast_nullable_to_non_nullable
as String?,abortReason: freezed == abortReason ? _self.abortReason : abortReason // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [FieldSession].
extension FieldSessionPatterns on FieldSession {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FieldSession value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FieldSession() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FieldSession value)  $default,){
final _that = this;
switch (_that) {
case _FieldSession():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FieldSession value)?  $default,){
final _that = this;
switch (_that) {
case _FieldSession() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String inspectionId,  String organizationId,  String inspectorUserId,  String? droneId,  String? readinessDecisionId,  String? checklistTemplateId,  int? readinessVersion,  String status,  String? startedAt,  String? endedAt,  String? postponementReason,  String? abortReason)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FieldSession() when $default != null:
return $default(_that.id,_that.inspectionId,_that.organizationId,_that.inspectorUserId,_that.droneId,_that.readinessDecisionId,_that.checklistTemplateId,_that.readinessVersion,_that.status,_that.startedAt,_that.endedAt,_that.postponementReason,_that.abortReason);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String inspectionId,  String organizationId,  String inspectorUserId,  String? droneId,  String? readinessDecisionId,  String? checklistTemplateId,  int? readinessVersion,  String status,  String? startedAt,  String? endedAt,  String? postponementReason,  String? abortReason)  $default,) {final _that = this;
switch (_that) {
case _FieldSession():
return $default(_that.id,_that.inspectionId,_that.organizationId,_that.inspectorUserId,_that.droneId,_that.readinessDecisionId,_that.checklistTemplateId,_that.readinessVersion,_that.status,_that.startedAt,_that.endedAt,_that.postponementReason,_that.abortReason);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String inspectionId,  String organizationId,  String inspectorUserId,  String? droneId,  String? readinessDecisionId,  String? checklistTemplateId,  int? readinessVersion,  String status,  String? startedAt,  String? endedAt,  String? postponementReason,  String? abortReason)?  $default,) {final _that = this;
switch (_that) {
case _FieldSession() when $default != null:
return $default(_that.id,_that.inspectionId,_that.organizationId,_that.inspectorUserId,_that.droneId,_that.readinessDecisionId,_that.checklistTemplateId,_that.readinessVersion,_that.status,_that.startedAt,_that.endedAt,_that.postponementReason,_that.abortReason);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FieldSession extends FieldSession {
  const _FieldSession({required this.id, required this.inspectionId, required this.organizationId, required this.inspectorUserId, this.droneId, this.readinessDecisionId, this.checklistTemplateId, this.readinessVersion, required this.status, this.startedAt, this.endedAt, this.postponementReason, this.abortReason}): super._();
  factory _FieldSession.fromJson(Map<String, dynamic> json) => _$FieldSessionFromJson(json);

@override final  String id;
@override final  String inspectionId;
@override final  String organizationId;
@override final  String inspectorUserId;
@override final  String? droneId;
@override final  String? readinessDecisionId;
@override final  String? checklistTemplateId;
@override final  int? readinessVersion;
@override final  String status;
@override final  String? startedAt;
@override final  String? endedAt;
@override final  String? postponementReason;
@override final  String? abortReason;

/// Create a copy of FieldSession
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FieldSessionCopyWith<_FieldSession> get copyWith => __$FieldSessionCopyWithImpl<_FieldSession>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FieldSessionToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _FieldSession&&(identical(other.id, id) || other.id == id)&&(identical(other.inspectionId, inspectionId) || other.inspectionId == inspectionId)&&(identical(other.organizationId, organizationId) || other.organizationId == organizationId)&&(identical(other.inspectorUserId, inspectorUserId) || other.inspectorUserId == inspectorUserId)&&(identical(other.droneId, droneId) || other.droneId == droneId)&&(identical(other.readinessDecisionId, readinessDecisionId) || other.readinessDecisionId == readinessDecisionId)&&(identical(other.checklistTemplateId, checklistTemplateId) || other.checklistTemplateId == checklistTemplateId)&&(identical(other.readinessVersion, readinessVersion) || other.readinessVersion == readinessVersion)&&(identical(other.status, status) || other.status == status)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.endedAt, endedAt) || other.endedAt == endedAt)&&(identical(other.postponementReason, postponementReason) || other.postponementReason == postponementReason)&&(identical(other.abortReason, abortReason) || other.abortReason == abortReason));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,inspectionId,organizationId,inspectorUserId,droneId,readinessDecisionId,checklistTemplateId,readinessVersion,status,startedAt,endedAt,postponementReason,abortReason);
}

@override
String toString() {
    return 'FieldSession(id: $id, inspectionId: $inspectionId, organizationId: $organizationId, inspectorUserId: $inspectorUserId, droneId: $droneId, readinessDecisionId: $readinessDecisionId, checklistTemplateId: $checklistTemplateId, readinessVersion: $readinessVersion, status: $status, startedAt: $startedAt, endedAt: $endedAt, postponementReason: $postponementReason, abortReason: $abortReason)';
}


}

/// @nodoc
abstract mixin class _$FieldSessionCopyWith<$Res> implements $FieldSessionCopyWith<$Res> {
  factory _$FieldSessionCopyWith(_FieldSession value, $Res Function(_FieldSession) _then) = __$FieldSessionCopyWithImpl;
@override @useResult
$Res call({
 String id, String inspectionId, String organizationId, String inspectorUserId, String? droneId, String? readinessDecisionId, String? checklistTemplateId, int? readinessVersion, String status, String? startedAt, String? endedAt, String? postponementReason, String? abortReason
});




}
/// @nodoc
class __$FieldSessionCopyWithImpl<$Res>
    implements _$FieldSessionCopyWith<$Res> {
  __$FieldSessionCopyWithImpl(this._self, this._then);

  final _FieldSession _self;
  final $Res Function(_FieldSession) _then;

/// Create a copy of FieldSession
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? inspectionId = null,Object? organizationId = null,Object? inspectorUserId = null,Object? droneId = freezed,Object? readinessDecisionId = freezed,Object? checklistTemplateId = freezed,Object? readinessVersion = freezed,Object? status = null,Object? startedAt = freezed,Object? endedAt = freezed,Object? postponementReason = freezed,Object? abortReason = freezed,}) {
  return _then(_FieldSession(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,inspectionId: null == inspectionId ? _self.inspectionId : inspectionId // ignore: cast_nullable_to_non_nullable
as String,organizationId: null == organizationId ? _self.organizationId : organizationId // ignore: cast_nullable_to_non_nullable
as String,inspectorUserId: null == inspectorUserId ? _self.inspectorUserId : inspectorUserId // ignore: cast_nullable_to_non_nullable
as String,droneId: freezed == droneId ? _self.droneId : droneId // ignore: cast_nullable_to_non_nullable
as String?,readinessDecisionId: freezed == readinessDecisionId ? _self.readinessDecisionId : readinessDecisionId // ignore: cast_nullable_to_non_nullable
as String?,checklistTemplateId: freezed == checklistTemplateId ? _self.checklistTemplateId : checklistTemplateId // ignore: cast_nullable_to_non_nullable
as String?,readinessVersion: freezed == readinessVersion ? _self.readinessVersion : readinessVersion // ignore: cast_nullable_to_non_nullable
as int?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,startedAt: freezed == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as String?,endedAt: freezed == endedAt ? _self.endedAt : endedAt // ignore: cast_nullable_to_non_nullable
as String?,postponementReason: freezed == postponementReason ? _self.postponementReason : postponementReason // ignore: cast_nullable_to_non_nullable
as String?,abortReason: freezed == abortReason ? _self.abortReason : abortReason // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on

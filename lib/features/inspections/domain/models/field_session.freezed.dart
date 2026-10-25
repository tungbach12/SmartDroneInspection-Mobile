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

 String get id; String get inspectionId; String? get preparationId; String get status; String? get startedAt; String? get endedAt; String? get postponementReason; String? get abortReason; String? get outcomeNotes;
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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FieldSession&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.inspectionId, _this.inspectionId) || other.inspectionId == _this.inspectionId)&&(identical(other.preparationId, _this.preparationId) || other.preparationId == _this.preparationId)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.startedAt, _this.startedAt) || other.startedAt == _this.startedAt)&&(identical(other.endedAt, _this.endedAt) || other.endedAt == _this.endedAt)&&(identical(other.postponementReason, _this.postponementReason) || other.postponementReason == _this.postponementReason)&&(identical(other.abortReason, _this.abortReason) || other.abortReason == _this.abortReason)&&(identical(other.outcomeNotes, _this.outcomeNotes) || other.outcomeNotes == _this.outcomeNotes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as FieldSession;
  return Object.hash(runtimeType,_this.id,_this.inspectionId,_this.preparationId,_this.status,_this.startedAt,_this.endedAt,_this.postponementReason,_this.abortReason,_this.outcomeNotes);
}

@override
String toString() {
  final _this = this as FieldSession;
  return 'FieldSession(id: ${_this.id}, inspectionId: ${_this.inspectionId}, preparationId: ${_this.preparationId}, status: ${_this.status}, startedAt: ${_this.startedAt}, endedAt: ${_this.endedAt}, postponementReason: ${_this.postponementReason}, abortReason: ${_this.abortReason}, outcomeNotes: ${_this.outcomeNotes})';
}


}

/// @nodoc
abstract mixin class $FieldSessionCopyWith<$Res>  {
  factory $FieldSessionCopyWith(FieldSession value, $Res Function(FieldSession) _then) = _$FieldSessionCopyWithImpl;
@useResult
$Res call({
 String id, String inspectionId, String? preparationId, String status, String? startedAt, String? endedAt, String? postponementReason, String? abortReason, String? outcomeNotes
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
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? inspectionId = null,Object? preparationId = freezed,Object? status = null,Object? startedAt = freezed,Object? endedAt = freezed,Object? postponementReason = freezed,Object? abortReason = freezed,Object? outcomeNotes = freezed,}) {
  return _then(FieldSession(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,inspectionId: null == inspectionId ? _self.inspectionId : inspectionId // ignore: cast_nullable_to_non_nullable
as String,preparationId: freezed == preparationId ? _self.preparationId : preparationId // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,startedAt: freezed == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as String?,endedAt: freezed == endedAt ? _self.endedAt : endedAt // ignore: cast_nullable_to_non_nullable
as String?,postponementReason: freezed == postponementReason ? _self.postponementReason : postponementReason // ignore: cast_nullable_to_non_nullable
as String?,abortReason: freezed == abortReason ? _self.abortReason : abortReason // ignore: cast_nullable_to_non_nullable
as String?,outcomeNotes: freezed == outcomeNotes ? _self.outcomeNotes : outcomeNotes // ignore: cast_nullable_to_non_nullable
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String inspectionId,  String? preparationId,  String status,  String? startedAt,  String? endedAt,  String? postponementReason,  String? abortReason,  String? outcomeNotes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FieldSession() when $default != null:
return $default(_that.id,_that.inspectionId,_that.preparationId,_that.status,_that.startedAt,_that.endedAt,_that.postponementReason,_that.abortReason,_that.outcomeNotes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String inspectionId,  String? preparationId,  String status,  String? startedAt,  String? endedAt,  String? postponementReason,  String? abortReason,  String? outcomeNotes)  $default,) {final _that = this;
switch (_that) {
case _FieldSession():
return $default(_that.id,_that.inspectionId,_that.preparationId,_that.status,_that.startedAt,_that.endedAt,_that.postponementReason,_that.abortReason,_that.outcomeNotes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String inspectionId,  String? preparationId,  String status,  String? startedAt,  String? endedAt,  String? postponementReason,  String? abortReason,  String? outcomeNotes)?  $default,) {final _that = this;
switch (_that) {
case _FieldSession() when $default != null:
return $default(_that.id,_that.inspectionId,_that.preparationId,_that.status,_that.startedAt,_that.endedAt,_that.postponementReason,_that.abortReason,_that.outcomeNotes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FieldSession extends FieldSession {
  const _FieldSession({required this.id, required this.inspectionId, this.preparationId, required this.status, this.startedAt, this.endedAt, this.postponementReason, this.abortReason, this.outcomeNotes}): super._();
  factory _FieldSession.fromJson(Map<String, dynamic> json) => _$FieldSessionFromJson(json);

@override final  String id;
@override final  String inspectionId;
@override final  String? preparationId;
@override final  String status;
@override final  String? startedAt;
@override final  String? endedAt;
@override final  String? postponementReason;
@override final  String? abortReason;
@override final  String? outcomeNotes;

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
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _FieldSession&&(identical(other.id, id) || other.id == id)&&(identical(other.inspectionId, inspectionId) || other.inspectionId == inspectionId)&&(identical(other.preparationId, preparationId) || other.preparationId == preparationId)&&(identical(other.status, status) || other.status == status)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.endedAt, endedAt) || other.endedAt == endedAt)&&(identical(other.postponementReason, postponementReason) || other.postponementReason == postponementReason)&&(identical(other.abortReason, abortReason) || other.abortReason == abortReason)&&(identical(other.outcomeNotes, outcomeNotes) || other.outcomeNotes == outcomeNotes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,inspectionId,preparationId,status,startedAt,endedAt,postponementReason,abortReason,outcomeNotes);
}

@override
String toString() {
    return 'FieldSession(id: $id, inspectionId: $inspectionId, preparationId: $preparationId, status: $status, startedAt: $startedAt, endedAt: $endedAt, postponementReason: $postponementReason, abortReason: $abortReason, outcomeNotes: $outcomeNotes)';
}


}

/// @nodoc
abstract mixin class _$FieldSessionCopyWith<$Res> implements $FieldSessionCopyWith<$Res> {
  factory _$FieldSessionCopyWith(_FieldSession value, $Res Function(_FieldSession) _then) = __$FieldSessionCopyWithImpl;
@override @useResult
$Res call({
 String id, String inspectionId, String? preparationId, String status, String? startedAt, String? endedAt, String? postponementReason, String? abortReason, String? outcomeNotes
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
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? inspectionId = null,Object? preparationId = freezed,Object? status = null,Object? startedAt = freezed,Object? endedAt = freezed,Object? postponementReason = freezed,Object? abortReason = freezed,Object? outcomeNotes = freezed,}) {
  return _then(_FieldSession(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,inspectionId: null == inspectionId ? _self.inspectionId : inspectionId // ignore: cast_nullable_to_non_nullable
as String,preparationId: freezed == preparationId ? _self.preparationId : preparationId // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,startedAt: freezed == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as String?,endedAt: freezed == endedAt ? _self.endedAt : endedAt // ignore: cast_nullable_to_non_nullable
as String?,postponementReason: freezed == postponementReason ? _self.postponementReason : postponementReason // ignore: cast_nullable_to_non_nullable
as String?,abortReason: freezed == abortReason ? _self.abortReason : abortReason // ignore: cast_nullable_to_non_nullable
as String?,outcomeNotes: freezed == outcomeNotes ? _self.outcomeNotes : outcomeNotes // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on

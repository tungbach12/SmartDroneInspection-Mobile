// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'inspection_preparation.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$InspectionPreparation {

 String get id; String get inspectionId; int get preparationVersion; String get shotList; String? get evidenceTypes; String? get accessConstraints; String? get safetyObservations; String? get permitDocumentReferences; String? get status; String? get submittedAt; String? get reviewedByUserId; DateTime? get reviewedAt; String? get reviewReason; DateTime? get plannedStartAt; DateTime? get plannedEndAt;
/// Create a copy of InspectionPreparation
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InspectionPreparationCopyWith<InspectionPreparation> get copyWith => _$InspectionPreparationCopyWithImpl<InspectionPreparation>(this as InspectionPreparation, _$identity);

  /// Serializes this InspectionPreparation to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as InspectionPreparation;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InspectionPreparation&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.inspectionId, _this.inspectionId) || other.inspectionId == _this.inspectionId)&&(identical(other.preparationVersion, _this.preparationVersion) || other.preparationVersion == _this.preparationVersion)&&(identical(other.shotList, _this.shotList) || other.shotList == _this.shotList)&&(identical(other.evidenceTypes, _this.evidenceTypes) || other.evidenceTypes == _this.evidenceTypes)&&(identical(other.accessConstraints, _this.accessConstraints) || other.accessConstraints == _this.accessConstraints)&&(identical(other.safetyObservations, _this.safetyObservations) || other.safetyObservations == _this.safetyObservations)&&(identical(other.permitDocumentReferences, _this.permitDocumentReferences) || other.permitDocumentReferences == _this.permitDocumentReferences)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.submittedAt, _this.submittedAt) || other.submittedAt == _this.submittedAt)&&(identical(other.reviewedByUserId, _this.reviewedByUserId) || other.reviewedByUserId == _this.reviewedByUserId)&&(identical(other.reviewedAt, _this.reviewedAt) || other.reviewedAt == _this.reviewedAt)&&(identical(other.reviewReason, _this.reviewReason) || other.reviewReason == _this.reviewReason)&&(identical(other.plannedStartAt, _this.plannedStartAt) || other.plannedStartAt == _this.plannedStartAt)&&(identical(other.plannedEndAt, _this.plannedEndAt) || other.plannedEndAt == _this.plannedEndAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as InspectionPreparation;
  return Object.hash(runtimeType,_this.id,_this.inspectionId,_this.preparationVersion,_this.shotList,_this.evidenceTypes,_this.accessConstraints,_this.safetyObservations,_this.permitDocumentReferences,_this.status,_this.submittedAt,_this.reviewedByUserId,_this.reviewedAt,_this.reviewReason,_this.plannedStartAt,_this.plannedEndAt);
}

@override
String toString() {
  final _this = this as InspectionPreparation;
  return 'InspectionPreparation(id: ${_this.id}, inspectionId: ${_this.inspectionId}, preparationVersion: ${_this.preparationVersion}, shotList: ${_this.shotList}, evidenceTypes: ${_this.evidenceTypes}, accessConstraints: ${_this.accessConstraints}, safetyObservations: ${_this.safetyObservations}, permitDocumentReferences: ${_this.permitDocumentReferences}, status: ${_this.status}, submittedAt: ${_this.submittedAt}, reviewedByUserId: ${_this.reviewedByUserId}, reviewedAt: ${_this.reviewedAt}, reviewReason: ${_this.reviewReason}, plannedStartAt: ${_this.plannedStartAt}, plannedEndAt: ${_this.plannedEndAt})';
}


}

/// @nodoc
abstract mixin class $InspectionPreparationCopyWith<$Res>  {
  factory $InspectionPreparationCopyWith(InspectionPreparation value, $Res Function(InspectionPreparation) _then) = _$InspectionPreparationCopyWithImpl;
@useResult
$Res call({
 String id, String inspectionId, int preparationVersion, String shotList, String? evidenceTypes, String? accessConstraints, String? safetyObservations, String? permitDocumentReferences, String? status, String? submittedAt, String? reviewedByUserId, DateTime? reviewedAt, String? reviewReason, DateTime? plannedStartAt, DateTime? plannedEndAt
});




}
/// @nodoc
class _$InspectionPreparationCopyWithImpl<$Res>
    implements $InspectionPreparationCopyWith<$Res> {
  _$InspectionPreparationCopyWithImpl(this._self, this._then);

  final InspectionPreparation _self;
  final $Res Function(InspectionPreparation) _then;

/// Create a copy of InspectionPreparation
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? inspectionId = null,Object? preparationVersion = null,Object? shotList = null,Object? evidenceTypes = freezed,Object? accessConstraints = freezed,Object? safetyObservations = freezed,Object? permitDocumentReferences = freezed,Object? status = freezed,Object? submittedAt = freezed,Object? reviewedByUserId = freezed,Object? reviewedAt = freezed,Object? reviewReason = freezed,Object? plannedStartAt = freezed,Object? plannedEndAt = freezed,}) {
  return _then(InspectionPreparation(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,inspectionId: null == inspectionId ? _self.inspectionId : inspectionId // ignore: cast_nullable_to_non_nullable
as String,preparationVersion: null == preparationVersion ? _self.preparationVersion : preparationVersion // ignore: cast_nullable_to_non_nullable
as int,shotList: null == shotList ? _self.shotList : shotList // ignore: cast_nullable_to_non_nullable
as String,evidenceTypes: freezed == evidenceTypes ? _self.evidenceTypes : evidenceTypes // ignore: cast_nullable_to_non_nullable
as String?,accessConstraints: freezed == accessConstraints ? _self.accessConstraints : accessConstraints // ignore: cast_nullable_to_non_nullable
as String?,safetyObservations: freezed == safetyObservations ? _self.safetyObservations : safetyObservations // ignore: cast_nullable_to_non_nullable
as String?,permitDocumentReferences: freezed == permitDocumentReferences ? _self.permitDocumentReferences : permitDocumentReferences // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,submittedAt: freezed == submittedAt ? _self.submittedAt : submittedAt // ignore: cast_nullable_to_non_nullable
as String?,reviewedByUserId: freezed == reviewedByUserId ? _self.reviewedByUserId : reviewedByUserId // ignore: cast_nullable_to_non_nullable
as String?,reviewedAt: freezed == reviewedAt ? _self.reviewedAt : reviewedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,reviewReason: freezed == reviewReason ? _self.reviewReason : reviewReason // ignore: cast_nullable_to_non_nullable
as String?,plannedStartAt: freezed == plannedStartAt ? _self.plannedStartAt : plannedStartAt // ignore: cast_nullable_to_non_nullable
as DateTime?,plannedEndAt: freezed == plannedEndAt ? _self.plannedEndAt : plannedEndAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [InspectionPreparation].
extension InspectionPreparationPatterns on InspectionPreparation {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InspectionPreparation value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InspectionPreparation() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InspectionPreparation value)  $default,){
final _that = this;
switch (_that) {
case _InspectionPreparation():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InspectionPreparation value)?  $default,){
final _that = this;
switch (_that) {
case _InspectionPreparation() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String inspectionId,  int preparationVersion,  String shotList,  String? evidenceTypes,  String? accessConstraints,  String? safetyObservations,  String? permitDocumentReferences,  String? status,  String? submittedAt,  String? reviewedByUserId,  DateTime? reviewedAt,  String? reviewReason,  DateTime? plannedStartAt,  DateTime? plannedEndAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InspectionPreparation() when $default != null:
return $default(_that.id,_that.inspectionId,_that.preparationVersion,_that.shotList,_that.evidenceTypes,_that.accessConstraints,_that.safetyObservations,_that.permitDocumentReferences,_that.status,_that.submittedAt,_that.reviewedByUserId,_that.reviewedAt,_that.reviewReason,_that.plannedStartAt,_that.plannedEndAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String inspectionId,  int preparationVersion,  String shotList,  String? evidenceTypes,  String? accessConstraints,  String? safetyObservations,  String? permitDocumentReferences,  String? status,  String? submittedAt,  String? reviewedByUserId,  DateTime? reviewedAt,  String? reviewReason,  DateTime? plannedStartAt,  DateTime? plannedEndAt)  $default,) {final _that = this;
switch (_that) {
case _InspectionPreparation():
return $default(_that.id,_that.inspectionId,_that.preparationVersion,_that.shotList,_that.evidenceTypes,_that.accessConstraints,_that.safetyObservations,_that.permitDocumentReferences,_that.status,_that.submittedAt,_that.reviewedByUserId,_that.reviewedAt,_that.reviewReason,_that.plannedStartAt,_that.plannedEndAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String inspectionId,  int preparationVersion,  String shotList,  String? evidenceTypes,  String? accessConstraints,  String? safetyObservations,  String? permitDocumentReferences,  String? status,  String? submittedAt,  String? reviewedByUserId,  DateTime? reviewedAt,  String? reviewReason,  DateTime? plannedStartAt,  DateTime? plannedEndAt)?  $default,) {final _that = this;
switch (_that) {
case _InspectionPreparation() when $default != null:
return $default(_that.id,_that.inspectionId,_that.preparationVersion,_that.shotList,_that.evidenceTypes,_that.accessConstraints,_that.safetyObservations,_that.permitDocumentReferences,_that.status,_that.submittedAt,_that.reviewedByUserId,_that.reviewedAt,_that.reviewReason,_that.plannedStartAt,_that.plannedEndAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _InspectionPreparation implements InspectionPreparation {
  const _InspectionPreparation({required this.id, required this.inspectionId, required this.preparationVersion, required this.shotList, this.evidenceTypes, this.accessConstraints, this.safetyObservations, this.permitDocumentReferences, this.status, this.submittedAt, this.reviewedByUserId, this.reviewedAt, this.reviewReason, this.plannedStartAt, this.plannedEndAt});
  factory _InspectionPreparation.fromJson(Map<String, dynamic> json) => _$InspectionPreparationFromJson(json);

@override final  String id;
@override final  String inspectionId;
@override final  int preparationVersion;
@override final  String shotList;
@override final  String? evidenceTypes;
@override final  String? accessConstraints;
@override final  String? safetyObservations;
@override final  String? permitDocumentReferences;
@override final  String? status;
@override final  String? submittedAt;
@override final  String? reviewedByUserId;
@override final  DateTime? reviewedAt;
@override final  String? reviewReason;
@override final  DateTime? plannedStartAt;
@override final  DateTime? plannedEndAt;

/// Create a copy of InspectionPreparation
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InspectionPreparationCopyWith<_InspectionPreparation> get copyWith => __$InspectionPreparationCopyWithImpl<_InspectionPreparation>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$InspectionPreparationToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _InspectionPreparation&&(identical(other.id, id) || other.id == id)&&(identical(other.inspectionId, inspectionId) || other.inspectionId == inspectionId)&&(identical(other.preparationVersion, preparationVersion) || other.preparationVersion == preparationVersion)&&(identical(other.shotList, shotList) || other.shotList == shotList)&&(identical(other.evidenceTypes, evidenceTypes) || other.evidenceTypes == evidenceTypes)&&(identical(other.accessConstraints, accessConstraints) || other.accessConstraints == accessConstraints)&&(identical(other.safetyObservations, safetyObservations) || other.safetyObservations == safetyObservations)&&(identical(other.permitDocumentReferences, permitDocumentReferences) || other.permitDocumentReferences == permitDocumentReferences)&&(identical(other.status, status) || other.status == status)&&(identical(other.submittedAt, submittedAt) || other.submittedAt == submittedAt)&&(identical(other.reviewedByUserId, reviewedByUserId) || other.reviewedByUserId == reviewedByUserId)&&(identical(other.reviewedAt, reviewedAt) || other.reviewedAt == reviewedAt)&&(identical(other.reviewReason, reviewReason) || other.reviewReason == reviewReason)&&(identical(other.plannedStartAt, plannedStartAt) || other.plannedStartAt == plannedStartAt)&&(identical(other.plannedEndAt, plannedEndAt) || other.plannedEndAt == plannedEndAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,inspectionId,preparationVersion,shotList,evidenceTypes,accessConstraints,safetyObservations,permitDocumentReferences,status,submittedAt,reviewedByUserId,reviewedAt,reviewReason,plannedStartAt,plannedEndAt);
}

@override
String toString() {
    return 'InspectionPreparation(id: $id, inspectionId: $inspectionId, preparationVersion: $preparationVersion, shotList: $shotList, evidenceTypes: $evidenceTypes, accessConstraints: $accessConstraints, safetyObservations: $safetyObservations, permitDocumentReferences: $permitDocumentReferences, status: $status, submittedAt: $submittedAt, reviewedByUserId: $reviewedByUserId, reviewedAt: $reviewedAt, reviewReason: $reviewReason, plannedStartAt: $plannedStartAt, plannedEndAt: $plannedEndAt)';
}


}

/// @nodoc
abstract mixin class _$InspectionPreparationCopyWith<$Res> implements $InspectionPreparationCopyWith<$Res> {
  factory _$InspectionPreparationCopyWith(_InspectionPreparation value, $Res Function(_InspectionPreparation) _then) = __$InspectionPreparationCopyWithImpl;
@override @useResult
$Res call({
 String id, String inspectionId, int preparationVersion, String shotList, String? evidenceTypes, String? accessConstraints, String? safetyObservations, String? permitDocumentReferences, String? status, String? submittedAt, String? reviewedByUserId, DateTime? reviewedAt, String? reviewReason, DateTime? plannedStartAt, DateTime? plannedEndAt
});




}
/// @nodoc
class __$InspectionPreparationCopyWithImpl<$Res>
    implements _$InspectionPreparationCopyWith<$Res> {
  __$InspectionPreparationCopyWithImpl(this._self, this._then);

  final _InspectionPreparation _self;
  final $Res Function(_InspectionPreparation) _then;

/// Create a copy of InspectionPreparation
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? inspectionId = null,Object? preparationVersion = null,Object? shotList = null,Object? evidenceTypes = freezed,Object? accessConstraints = freezed,Object? safetyObservations = freezed,Object? permitDocumentReferences = freezed,Object? status = freezed,Object? submittedAt = freezed,Object? reviewedByUserId = freezed,Object? reviewedAt = freezed,Object? reviewReason = freezed,Object? plannedStartAt = freezed,Object? plannedEndAt = freezed,}) {
  return _then(_InspectionPreparation(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,inspectionId: null == inspectionId ? _self.inspectionId : inspectionId // ignore: cast_nullable_to_non_nullable
as String,preparationVersion: null == preparationVersion ? _self.preparationVersion : preparationVersion // ignore: cast_nullable_to_non_nullable
as int,shotList: null == shotList ? _self.shotList : shotList // ignore: cast_nullable_to_non_nullable
as String,evidenceTypes: freezed == evidenceTypes ? _self.evidenceTypes : evidenceTypes // ignore: cast_nullable_to_non_nullable
as String?,accessConstraints: freezed == accessConstraints ? _self.accessConstraints : accessConstraints // ignore: cast_nullable_to_non_nullable
as String?,safetyObservations: freezed == safetyObservations ? _self.safetyObservations : safetyObservations // ignore: cast_nullable_to_non_nullable
as String?,permitDocumentReferences: freezed == permitDocumentReferences ? _self.permitDocumentReferences : permitDocumentReferences // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,submittedAt: freezed == submittedAt ? _self.submittedAt : submittedAt // ignore: cast_nullable_to_non_nullable
as String?,reviewedByUserId: freezed == reviewedByUserId ? _self.reviewedByUserId : reviewedByUserId // ignore: cast_nullable_to_non_nullable
as String?,reviewedAt: freezed == reviewedAt ? _self.reviewedAt : reviewedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,reviewReason: freezed == reviewReason ? _self.reviewReason : reviewReason // ignore: cast_nullable_to_non_nullable
as String?,plannedStartAt: freezed == plannedStartAt ? _self.plannedStartAt : plannedStartAt // ignore: cast_nullable_to_non_nullable
as DateTime?,plannedEndAt: freezed == plannedEndAt ? _self.plannedEndAt : plannedEndAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on

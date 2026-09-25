// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'inspection_checklist_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$InspectionChecklistItem {

 String get itemId; String get itemCode; String? get sectionName; String get prompt; String get responseType; bool get required; int get displayOrder; String? get guidance; String? get validationConfig; Map<String, dynamic>? get responseValue; String? get notes; String? get completedAt;
/// Create a copy of InspectionChecklistItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InspectionChecklistItemCopyWith<InspectionChecklistItem> get copyWith => _$InspectionChecklistItemCopyWithImpl<InspectionChecklistItem>(this as InspectionChecklistItem, _$identity);

  /// Serializes this InspectionChecklistItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as InspectionChecklistItem;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InspectionChecklistItem&&(identical(other.itemId, _this.itemId) || other.itemId == _this.itemId)&&(identical(other.itemCode, _this.itemCode) || other.itemCode == _this.itemCode)&&(identical(other.sectionName, _this.sectionName) || other.sectionName == _this.sectionName)&&(identical(other.prompt, _this.prompt) || other.prompt == _this.prompt)&&(identical(other.responseType, _this.responseType) || other.responseType == _this.responseType)&&(identical(other.required, _this.required) || other.required == _this.required)&&(identical(other.displayOrder, _this.displayOrder) || other.displayOrder == _this.displayOrder)&&(identical(other.guidance, _this.guidance) || other.guidance == _this.guidance)&&(identical(other.validationConfig, _this.validationConfig) || other.validationConfig == _this.validationConfig)&&const DeepCollectionEquality().equals(other.responseValue, _this.responseValue)&&(identical(other.notes, _this.notes) || other.notes == _this.notes)&&(identical(other.completedAt, _this.completedAt) || other.completedAt == _this.completedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as InspectionChecklistItem;
  return Object.hash(runtimeType,_this.itemId,_this.itemCode,_this.sectionName,_this.prompt,_this.responseType,_this.required,_this.displayOrder,_this.guidance,_this.validationConfig,const DeepCollectionEquality().hash(_this.responseValue),_this.notes,_this.completedAt);
}

@override
String toString() {
  final _this = this as InspectionChecklistItem;
  return 'InspectionChecklistItem(itemId: ${_this.itemId}, itemCode: ${_this.itemCode}, sectionName: ${_this.sectionName}, prompt: ${_this.prompt}, responseType: ${_this.responseType}, required: ${_this.required}, displayOrder: ${_this.displayOrder}, guidance: ${_this.guidance}, validationConfig: ${_this.validationConfig}, responseValue: ${_this.responseValue}, notes: ${_this.notes}, completedAt: ${_this.completedAt})';
}


}

/// @nodoc
abstract mixin class $InspectionChecklistItemCopyWith<$Res>  {
  factory $InspectionChecklistItemCopyWith(InspectionChecklistItem value, $Res Function(InspectionChecklistItem) _then) = _$InspectionChecklistItemCopyWithImpl;
@useResult
$Res call({
 String itemId, String itemCode, String? sectionName, String prompt, String responseType, bool required, int displayOrder, String? guidance, String? validationConfig, Map<String, dynamic>? responseValue, String? notes, String? completedAt
});




}
/// @nodoc
class _$InspectionChecklistItemCopyWithImpl<$Res>
    implements $InspectionChecklistItemCopyWith<$Res> {
  _$InspectionChecklistItemCopyWithImpl(this._self, this._then);

  final InspectionChecklistItem _self;
  final $Res Function(InspectionChecklistItem) _then;

/// Create a copy of InspectionChecklistItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? itemId = null,Object? itemCode = null,Object? sectionName = freezed,Object? prompt = null,Object? responseType = null,Object? required = null,Object? displayOrder = null,Object? guidance = freezed,Object? validationConfig = freezed,Object? responseValue = freezed,Object? notes = freezed,Object? completedAt = freezed,}) {
  return _then(InspectionChecklistItem(
itemId: null == itemId ? _self.itemId : itemId // ignore: cast_nullable_to_non_nullable
as String,itemCode: null == itemCode ? _self.itemCode : itemCode // ignore: cast_nullable_to_non_nullable
as String,sectionName: freezed == sectionName ? _self.sectionName : sectionName // ignore: cast_nullable_to_non_nullable
as String?,prompt: null == prompt ? _self.prompt : prompt // ignore: cast_nullable_to_non_nullable
as String,responseType: null == responseType ? _self.responseType : responseType // ignore: cast_nullable_to_non_nullable
as String,required: null == required ? _self.required : required // ignore: cast_nullable_to_non_nullable
as bool,displayOrder: null == displayOrder ? _self.displayOrder : displayOrder // ignore: cast_nullable_to_non_nullable
as int,guidance: freezed == guidance ? _self.guidance : guidance // ignore: cast_nullable_to_non_nullable
as String?,validationConfig: freezed == validationConfig ? _self.validationConfig : validationConfig // ignore: cast_nullable_to_non_nullable
as String?,responseValue: freezed == responseValue ? _self.responseValue : responseValue // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [InspectionChecklistItem].
extension InspectionChecklistItemPatterns on InspectionChecklistItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InspectionChecklistItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InspectionChecklistItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InspectionChecklistItem value)  $default,){
final _that = this;
switch (_that) {
case _InspectionChecklistItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InspectionChecklistItem value)?  $default,){
final _that = this;
switch (_that) {
case _InspectionChecklistItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String itemId,  String itemCode,  String? sectionName,  String prompt,  String responseType,  bool required,  int displayOrder,  String? guidance,  String? validationConfig,  Map<String, dynamic>? responseValue,  String? notes,  String? completedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InspectionChecklistItem() when $default != null:
return $default(_that.itemId,_that.itemCode,_that.sectionName,_that.prompt,_that.responseType,_that.required,_that.displayOrder,_that.guidance,_that.validationConfig,_that.responseValue,_that.notes,_that.completedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String itemId,  String itemCode,  String? sectionName,  String prompt,  String responseType,  bool required,  int displayOrder,  String? guidance,  String? validationConfig,  Map<String, dynamic>? responseValue,  String? notes,  String? completedAt)  $default,) {final _that = this;
switch (_that) {
case _InspectionChecklistItem():
return $default(_that.itemId,_that.itemCode,_that.sectionName,_that.prompt,_that.responseType,_that.required,_that.displayOrder,_that.guidance,_that.validationConfig,_that.responseValue,_that.notes,_that.completedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String itemId,  String itemCode,  String? sectionName,  String prompt,  String responseType,  bool required,  int displayOrder,  String? guidance,  String? validationConfig,  Map<String, dynamic>? responseValue,  String? notes,  String? completedAt)?  $default,) {final _that = this;
switch (_that) {
case _InspectionChecklistItem() when $default != null:
return $default(_that.itemId,_that.itemCode,_that.sectionName,_that.prompt,_that.responseType,_that.required,_that.displayOrder,_that.guidance,_that.validationConfig,_that.responseValue,_that.notes,_that.completedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _InspectionChecklistItem implements InspectionChecklistItem {
  const _InspectionChecklistItem({required this.itemId, required this.itemCode, this.sectionName, required this.prompt, required this.responseType, required this.required, required this.displayOrder, this.guidance, this.validationConfig,  Map<String, dynamic>? responseValue, this.notes, this.completedAt}): _responseValue = responseValue;
  factory _InspectionChecklistItem.fromJson(Map<String, dynamic> json) => _$InspectionChecklistItemFromJson(json);

@override final  String itemId;
@override final  String itemCode;
@override final  String? sectionName;
@override final  String prompt;
@override final  String responseType;
@override final  bool required;
@override final  int displayOrder;
@override final  String? guidance;
@override final  String? validationConfig;
 final  Map<String, dynamic>? _responseValue;
@override Map<String, dynamic>? get responseValue {
  final value = _responseValue;
  if (value == null) return null;
  if (_responseValue is EqualUnmodifiableMapView) return _responseValue;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

@override final  String? notes;
@override final  String? completedAt;

/// Create a copy of InspectionChecklistItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InspectionChecklistItemCopyWith<_InspectionChecklistItem> get copyWith => __$InspectionChecklistItemCopyWithImpl<_InspectionChecklistItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$InspectionChecklistItemToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _InspectionChecklistItem&&(identical(other.itemId, itemId) || other.itemId == itemId)&&(identical(other.itemCode, itemCode) || other.itemCode == itemCode)&&(identical(other.sectionName, sectionName) || other.sectionName == sectionName)&&(identical(other.prompt, prompt) || other.prompt == prompt)&&(identical(other.responseType, responseType) || other.responseType == responseType)&&(identical(other.required, required) || other.required == required)&&(identical(other.displayOrder, displayOrder) || other.displayOrder == displayOrder)&&(identical(other.guidance, guidance) || other.guidance == guidance)&&(identical(other.validationConfig, validationConfig) || other.validationConfig == validationConfig)&&const DeepCollectionEquality().equals(other.responseValue, _responseValue)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,itemId,itemCode,sectionName,prompt,responseType,required,displayOrder,guidance,validationConfig,const DeepCollectionEquality().hash(_responseValue),notes,completedAt);
}

@override
String toString() {
    return 'InspectionChecklistItem(itemId: $itemId, itemCode: $itemCode, sectionName: $sectionName, prompt: $prompt, responseType: $responseType, required: $required, displayOrder: $displayOrder, guidance: $guidance, validationConfig: $validationConfig, responseValue: $responseValue, notes: $notes, completedAt: $completedAt)';
}


}

/// @nodoc
abstract mixin class _$InspectionChecklistItemCopyWith<$Res> implements $InspectionChecklistItemCopyWith<$Res> {
  factory _$InspectionChecklistItemCopyWith(_InspectionChecklistItem value, $Res Function(_InspectionChecklistItem) _then) = __$InspectionChecklistItemCopyWithImpl;
@override @useResult
$Res call({
 String itemId, String itemCode, String? sectionName, String prompt, String responseType, bool required, int displayOrder, String? guidance, String? validationConfig, Map<String, dynamic>? responseValue, String? notes, String? completedAt
});




}
/// @nodoc
class __$InspectionChecklistItemCopyWithImpl<$Res>
    implements _$InspectionChecklistItemCopyWith<$Res> {
  __$InspectionChecklistItemCopyWithImpl(this._self, this._then);

  final _InspectionChecklistItem _self;
  final $Res Function(_InspectionChecklistItem) _then;

/// Create a copy of InspectionChecklistItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? itemId = null,Object? itemCode = null,Object? sectionName = freezed,Object? prompt = null,Object? responseType = null,Object? required = null,Object? displayOrder = null,Object? guidance = freezed,Object? validationConfig = freezed,Object? responseValue = freezed,Object? notes = freezed,Object? completedAt = freezed,}) {
  return _then(_InspectionChecklistItem(
itemId: null == itemId ? _self.itemId : itemId // ignore: cast_nullable_to_non_nullable
as String,itemCode: null == itemCode ? _self.itemCode : itemCode // ignore: cast_nullable_to_non_nullable
as String,sectionName: freezed == sectionName ? _self.sectionName : sectionName // ignore: cast_nullable_to_non_nullable
as String?,prompt: null == prompt ? _self.prompt : prompt // ignore: cast_nullable_to_non_nullable
as String,responseType: null == responseType ? _self.responseType : responseType // ignore: cast_nullable_to_non_nullable
as String,required: null == required ? _self.required : required // ignore: cast_nullable_to_non_nullable
as bool,displayOrder: null == displayOrder ? _self.displayOrder : displayOrder // ignore: cast_nullable_to_non_nullable
as int,guidance: freezed == guidance ? _self.guidance : guidance // ignore: cast_nullable_to_non_nullable
as String?,validationConfig: freezed == validationConfig ? _self.validationConfig : validationConfig // ignore: cast_nullable_to_non_nullable
as String?,responseValue: freezed == responseValue ? _self._responseValue : responseValue // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on

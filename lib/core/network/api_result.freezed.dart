// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'api_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ApiResult<T> {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ApiResult<T>);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'ApiResult<$T>()';
}


}

/// @nodoc
class $ApiResultCopyWith<T,$Res>  {
$ApiResultCopyWith(ApiResult<T> _, $Res Function(ApiResult<T>) __);
}


/// Adds pattern-matching-related methods to [ApiResult].
extension ApiResultPatterns<T> on ApiResult<T> {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( ApiSuccess<T> value)?  success,TResult Function( ApiError<T> value)?  failure,required TResult orElse(),}){
final _that = this;
switch (_that) {
case ApiSuccess() when success != null:
return success(_that);case ApiError() when failure != null:
return failure(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( ApiSuccess<T> value)  success,required TResult Function( ApiError<T> value)  failure,}){
final _that = this;
switch (_that) {
case ApiSuccess():
return success(_that);case ApiError():
return failure(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( ApiSuccess<T> value)?  success,TResult? Function( ApiError<T> value)?  failure,}){
final _that = this;
switch (_that) {
case ApiSuccess() when success != null:
return success(_that);case ApiError() when failure != null:
return failure(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( T data)?  success,TResult Function( ApiFailure failure)?  failure,required TResult orElse(),}) {final _that = this;
switch (_that) {
case ApiSuccess() when success != null:
return success(_that.data);case ApiError() when failure != null:
return failure(_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( T data)  success,required TResult Function( ApiFailure failure)  failure,}) {final _that = this;
switch (_that) {
case ApiSuccess():
return success(_that.data);case ApiError():
return failure(_that.failure);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( T data)?  success,TResult? Function( ApiFailure failure)?  failure,}) {final _that = this;
switch (_that) {
case ApiSuccess() when success != null:
return success(_that.data);case ApiError() when failure != null:
return failure(_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class ApiSuccess<T> implements ApiResult<T> {
  const ApiSuccess(this.data);
  

 final  T data;

/// Create a copy of ApiResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ApiSuccessCopyWith<T, ApiSuccess<T>> get copyWith => _$ApiSuccessCopyWithImpl<T, ApiSuccess<T>>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ApiSuccess<T>&&const DeepCollectionEquality().equals(other.data, data));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(data));
}

@override
String toString() {
    return 'ApiResult<$T>.success(data: $data)';
}


}

/// @nodoc
abstract mixin class $ApiSuccessCopyWith<T,$Res> implements $ApiResultCopyWith<T, $Res> {
  factory $ApiSuccessCopyWith(ApiSuccess<T> value, $Res Function(ApiSuccess<T>) _then) = _$ApiSuccessCopyWithImpl;
@useResult
$Res call({
 T data
});




}
/// @nodoc
class _$ApiSuccessCopyWithImpl<T,$Res>
    implements $ApiSuccessCopyWith<T, $Res> {
  _$ApiSuccessCopyWithImpl(this._self, this._then);

  final ApiSuccess<T> _self;
  final $Res Function(ApiSuccess<T>) _then;

/// Create a copy of ApiResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? data = freezed,}) {
  return _then(ApiSuccess<T>(
freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as T,
  ));
}


}

/// @nodoc


class ApiError<T> implements ApiResult<T> {
  const ApiError(this.failure);
  

 final  ApiFailure failure;

/// Create a copy of ApiResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ApiErrorCopyWith<T, ApiError<T>> get copyWith => _$ApiErrorCopyWithImpl<T, ApiError<T>>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ApiError<T>&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode {
    return Object.hash(runtimeType,failure);
}

@override
String toString() {
    return 'ApiResult<$T>.failure(failure: $failure)';
}


}

/// @nodoc
abstract mixin class $ApiErrorCopyWith<T,$Res> implements $ApiResultCopyWith<T, $Res> {
  factory $ApiErrorCopyWith(ApiError<T> value, $Res Function(ApiError<T>) _then) = _$ApiErrorCopyWithImpl;
@useResult
$Res call({
 ApiFailure failure
});


$ApiFailureCopyWith<$Res> get failure;

}
/// @nodoc
class _$ApiErrorCopyWithImpl<T,$Res>
    implements $ApiErrorCopyWith<T, $Res> {
  _$ApiErrorCopyWithImpl(this._self, this._then);

  final ApiError<T> _self;
  final $Res Function(ApiError<T>) _then;

/// Create a copy of ApiResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? failure = null,}) {
  return _then(ApiError<T>(
null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as ApiFailure,
  ));
}

/// Create a copy of ApiResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiFailureCopyWith<$Res> get failure {
  
  return $ApiFailureCopyWith<$Res>(_self.failure, (value) {
    return _then(_self.copyWith(failure: value));
  });
}
}

// dart format on

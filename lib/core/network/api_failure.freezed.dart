// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'api_failure.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ApiFailure {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ApiFailure);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'ApiFailure()';
}


}

/// @nodoc
class $ApiFailureCopyWith<$Res>  {
$ApiFailureCopyWith(ApiFailure _, $Res Function(ApiFailure) __);
}


/// Adds pattern-matching-related methods to [ApiFailure].
extension ApiFailurePatterns on ApiFailure {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( NetworkFailure value)?  network,TResult Function( ValidationFailure value)?  validation,TResult Function( UnauthorizedFailure value)?  unauthorized,TResult Function( NotFoundFailure value)?  notFound,TResult Function( ServerFailure value)?  server,TResult Function( UnknownFailure value)?  unknown,required TResult orElse(),}){
final _that = this;
switch (_that) {
case NetworkFailure() when network != null:
return network(_that);case ValidationFailure() when validation != null:
return validation(_that);case UnauthorizedFailure() when unauthorized != null:
return unauthorized(_that);case NotFoundFailure() when notFound != null:
return notFound(_that);case ServerFailure() when server != null:
return server(_that);case UnknownFailure() when unknown != null:
return unknown(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( NetworkFailure value)  network,required TResult Function( ValidationFailure value)  validation,required TResult Function( UnauthorizedFailure value)  unauthorized,required TResult Function( NotFoundFailure value)  notFound,required TResult Function( ServerFailure value)  server,required TResult Function( UnknownFailure value)  unknown,}){
final _that = this;
switch (_that) {
case NetworkFailure():
return network(_that);case ValidationFailure():
return validation(_that);case UnauthorizedFailure():
return unauthorized(_that);case NotFoundFailure():
return notFound(_that);case ServerFailure():
return server(_that);case UnknownFailure():
return unknown(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( NetworkFailure value)?  network,TResult? Function( ValidationFailure value)?  validation,TResult? Function( UnauthorizedFailure value)?  unauthorized,TResult? Function( NotFoundFailure value)?  notFound,TResult? Function( ServerFailure value)?  server,TResult? Function( UnknownFailure value)?  unknown,}){
final _that = this;
switch (_that) {
case NetworkFailure() when network != null:
return network(_that);case ValidationFailure() when validation != null:
return validation(_that);case UnauthorizedFailure() when unauthorized != null:
return unauthorized(_that);case NotFoundFailure() when notFound != null:
return notFound(_that);case ServerFailure() when server != null:
return server(_that);case UnknownFailure() when unknown != null:
return unknown(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  network,TResult Function( Map<String, String> errors)?  validation,TResult Function()?  unauthorized,TResult Function()?  notFound,TResult Function( int? status,  String? detail)?  server,TResult Function( String message)?  unknown,required TResult orElse(),}) {final _that = this;
switch (_that) {
case NetworkFailure() when network != null:
return network();case ValidationFailure() when validation != null:
return validation(_that.errors);case UnauthorizedFailure() when unauthorized != null:
return unauthorized();case NotFoundFailure() when notFound != null:
return notFound();case ServerFailure() when server != null:
return server(_that.status,_that.detail);case UnknownFailure() when unknown != null:
return unknown(_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  network,required TResult Function( Map<String, String> errors)  validation,required TResult Function()  unauthorized,required TResult Function()  notFound,required TResult Function( int? status,  String? detail)  server,required TResult Function( String message)  unknown,}) {final _that = this;
switch (_that) {
case NetworkFailure():
return network();case ValidationFailure():
return validation(_that.errors);case UnauthorizedFailure():
return unauthorized();case NotFoundFailure():
return notFound();case ServerFailure():
return server(_that.status,_that.detail);case UnknownFailure():
return unknown(_that.message);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  network,TResult? Function( Map<String, String> errors)?  validation,TResult? Function()?  unauthorized,TResult? Function()?  notFound,TResult? Function( int? status,  String? detail)?  server,TResult? Function( String message)?  unknown,}) {final _that = this;
switch (_that) {
case NetworkFailure() when network != null:
return network();case ValidationFailure() when validation != null:
return validation(_that.errors);case UnauthorizedFailure() when unauthorized != null:
return unauthorized();case NotFoundFailure() when notFound != null:
return notFound();case ServerFailure() when server != null:
return server(_that.status,_that.detail);case UnknownFailure() when unknown != null:
return unknown(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class NetworkFailure implements ApiFailure {
  const NetworkFailure();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is NetworkFailure);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'ApiFailure.network()';
}


}




/// @nodoc


class ValidationFailure implements ApiFailure {
  const ValidationFailure( Map<String, String> errors): _errors = errors;
  

 final  Map<String, String> _errors;
 Map<String, String> get errors {
  if (_errors is EqualUnmodifiableMapView) return _errors;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_errors);
}


/// Create a copy of ApiFailure
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ValidationFailureCopyWith<ValidationFailure> get copyWith => _$ValidationFailureCopyWithImpl<ValidationFailure>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ValidationFailure&&const DeepCollectionEquality().equals(other.errors, _errors));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_errors));
}

@override
String toString() {
    return 'ApiFailure.validation(errors: $errors)';
}


}

/// @nodoc
abstract mixin class $ValidationFailureCopyWith<$Res> implements $ApiFailureCopyWith<$Res> {
  factory $ValidationFailureCopyWith(ValidationFailure value, $Res Function(ValidationFailure) _then) = _$ValidationFailureCopyWithImpl;
@useResult
$Res call({
 Map<String, String> errors
});




}
/// @nodoc
class _$ValidationFailureCopyWithImpl<$Res>
    implements $ValidationFailureCopyWith<$Res> {
  _$ValidationFailureCopyWithImpl(this._self, this._then);

  final ValidationFailure _self;
  final $Res Function(ValidationFailure) _then;

/// Create a copy of ApiFailure
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? errors = null,}) {
  return _then(ValidationFailure(
null == errors ? _self._errors : errors // ignore: cast_nullable_to_non_nullable
as Map<String, String>,
  ));
}


}

/// @nodoc


class UnauthorizedFailure implements ApiFailure {
  const UnauthorizedFailure();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is UnauthorizedFailure);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'ApiFailure.unauthorized()';
}


}




/// @nodoc


class NotFoundFailure implements ApiFailure {
  const NotFoundFailure();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is NotFoundFailure);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'ApiFailure.notFound()';
}


}




/// @nodoc


class ServerFailure implements ApiFailure {
  const ServerFailure(this.status, this.detail);
  

 final  int? status;
 final  String? detail;

/// Create a copy of ApiFailure
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ServerFailureCopyWith<ServerFailure> get copyWith => _$ServerFailureCopyWithImpl<ServerFailure>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ServerFailure&&(identical(other.status, status) || other.status == status)&&(identical(other.detail, detail) || other.detail == detail));
}


@override
int get hashCode {
    return Object.hash(runtimeType,status,detail);
}

@override
String toString() {
    return 'ApiFailure.server(status: $status, detail: $detail)';
}


}

/// @nodoc
abstract mixin class $ServerFailureCopyWith<$Res> implements $ApiFailureCopyWith<$Res> {
  factory $ServerFailureCopyWith(ServerFailure value, $Res Function(ServerFailure) _then) = _$ServerFailureCopyWithImpl;
@useResult
$Res call({
 int? status, String? detail
});




}
/// @nodoc
class _$ServerFailureCopyWithImpl<$Res>
    implements $ServerFailureCopyWith<$Res> {
  _$ServerFailureCopyWithImpl(this._self, this._then);

  final ServerFailure _self;
  final $Res Function(ServerFailure) _then;

/// Create a copy of ApiFailure
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? status = freezed,Object? detail = freezed,}) {
  return _then(ServerFailure(
freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as int?,freezed == detail ? _self.detail : detail // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class UnknownFailure implements ApiFailure {
  const UnknownFailure(this.message);
  

 final  String message;

/// Create a copy of ApiFailure
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UnknownFailureCopyWith<UnknownFailure> get copyWith => _$UnknownFailureCopyWithImpl<UnknownFailure>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is UnknownFailure&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode {
    return Object.hash(runtimeType,message);
}

@override
String toString() {
    return 'ApiFailure.unknown(message: $message)';
}


}

/// @nodoc
abstract mixin class $UnknownFailureCopyWith<$Res> implements $ApiFailureCopyWith<$Res> {
  factory $UnknownFailureCopyWith(UnknownFailure value, $Res Function(UnknownFailure) _then) = _$UnknownFailureCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$UnknownFailureCopyWithImpl<$Res>
    implements $UnknownFailureCopyWith<$Res> {
  _$UnknownFailureCopyWithImpl(this._self, this._then);

  final UnknownFailure _self;
  final $Res Function(UnknownFailure) _then;

/// Create a copy of ApiFailure
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(UnknownFailure(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on

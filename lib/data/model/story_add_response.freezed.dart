// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'story_add_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$StoryAddResponse {

 bool get error; String get message;
/// Create a copy of StoryAddResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StoryAddResponseCopyWith<StoryAddResponse> get copyWith => _$StoryAddResponseCopyWithImpl<StoryAddResponse>(this as StoryAddResponse, _$identity);

  /// Serializes this StoryAddResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StoryAddResponse&&(identical(other.error, error) || other.error == error)&&(identical(other.message, message) || other.message == message));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,error,message);

@override
String toString() {
  return 'StoryAddResponse(error: $error, message: $message)';
}


}

/// @nodoc
abstract mixin class $StoryAddResponseCopyWith<$Res>  {
  factory $StoryAddResponseCopyWith(StoryAddResponse value, $Res Function(StoryAddResponse) _then) = _$StoryAddResponseCopyWithImpl;
@useResult
$Res call({
 bool error, String message
});




}
/// @nodoc
class _$StoryAddResponseCopyWithImpl<$Res>
    implements $StoryAddResponseCopyWith<$Res> {
  _$StoryAddResponseCopyWithImpl(this._self, this._then);

  final StoryAddResponse _self;
  final $Res Function(StoryAddResponse) _then;

/// Create a copy of StoryAddResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? error = null,Object? message = null,}) {
  return _then(_self.copyWith(
error: null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as bool,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _StoryAddResponse implements StoryAddResponse {
  const _StoryAddResponse({required this.error, required this.message});
  factory _StoryAddResponse.fromJson(Map<String, dynamic> json) => _$StoryAddResponseFromJson(json);

@override final  bool error;
@override final  String message;

/// Create a copy of StoryAddResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StoryAddResponseCopyWith<_StoryAddResponse> get copyWith => __$StoryAddResponseCopyWithImpl<_StoryAddResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StoryAddResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StoryAddResponse&&(identical(other.error, error) || other.error == error)&&(identical(other.message, message) || other.message == message));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,error,message);

@override
String toString() {
  return 'StoryAddResponse(error: $error, message: $message)';
}


}

/// @nodoc
abstract mixin class _$StoryAddResponseCopyWith<$Res> implements $StoryAddResponseCopyWith<$Res> {
  factory _$StoryAddResponseCopyWith(_StoryAddResponse value, $Res Function(_StoryAddResponse) _then) = __$StoryAddResponseCopyWithImpl;
@override @useResult
$Res call({
 bool error, String message
});




}
/// @nodoc
class __$StoryAddResponseCopyWithImpl<$Res>
    implements _$StoryAddResponseCopyWith<$Res> {
  __$StoryAddResponseCopyWithImpl(this._self, this._then);

  final _StoryAddResponse _self;
  final $Res Function(_StoryAddResponse) _then;

/// Create a copy of StoryAddResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? error = null,Object? message = null,}) {
  return _then(_StoryAddResponse(
error: null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as bool,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on

// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Settings {

 bool get isDarkModeEnabled;@LocaleConverter() Locale get locale;
/// Create a copy of Settings
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SettingsCopyWith<Settings> get copyWith => _$SettingsCopyWithImpl<Settings>(this as Settings, _$identity);

  /// Serializes this Settings to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Settings&&(identical(other.isDarkModeEnabled, isDarkModeEnabled) || other.isDarkModeEnabled == isDarkModeEnabled)&&(identical(other.locale, locale) || other.locale == locale));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,isDarkModeEnabled,locale);

@override
String toString() {
  return 'Settings(isDarkModeEnabled: $isDarkModeEnabled, locale: $locale)';
}


}

/// @nodoc
abstract mixin class $SettingsCopyWith<$Res>  {
  factory $SettingsCopyWith(Settings value, $Res Function(Settings) _then) = _$SettingsCopyWithImpl;
@useResult
$Res call({
 bool isDarkModeEnabled,@LocaleConverter() Locale locale
});




}
/// @nodoc
class _$SettingsCopyWithImpl<$Res>
    implements $SettingsCopyWith<$Res> {
  _$SettingsCopyWithImpl(this._self, this._then);

  final Settings _self;
  final $Res Function(Settings) _then;

/// Create a copy of Settings
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isDarkModeEnabled = null,Object? locale = null,}) {
  return _then(_self.copyWith(
isDarkModeEnabled: null == isDarkModeEnabled ? _self.isDarkModeEnabled : isDarkModeEnabled // ignore: cast_nullable_to_non_nullable
as bool,locale: null == locale ? _self.locale : locale // ignore: cast_nullable_to_non_nullable
as Locale,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _Settings implements Settings {
  const _Settings({this.isDarkModeEnabled = false, @LocaleConverter() this.locale = const Locale('en')});
  factory _Settings.fromJson(Map<String, dynamic> json) => _$SettingsFromJson(json);

@override@JsonKey() final  bool isDarkModeEnabled;
@override@JsonKey()@LocaleConverter() final  Locale locale;

/// Create a copy of Settings
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SettingsCopyWith<_Settings> get copyWith => __$SettingsCopyWithImpl<_Settings>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SettingsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Settings&&(identical(other.isDarkModeEnabled, isDarkModeEnabled) || other.isDarkModeEnabled == isDarkModeEnabled)&&(identical(other.locale, locale) || other.locale == locale));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,isDarkModeEnabled,locale);

@override
String toString() {
  return 'Settings(isDarkModeEnabled: $isDarkModeEnabled, locale: $locale)';
}


}

/// @nodoc
abstract mixin class _$SettingsCopyWith<$Res> implements $SettingsCopyWith<$Res> {
  factory _$SettingsCopyWith(_Settings value, $Res Function(_Settings) _then) = __$SettingsCopyWithImpl;
@override @useResult
$Res call({
 bool isDarkModeEnabled,@LocaleConverter() Locale locale
});




}
/// @nodoc
class __$SettingsCopyWithImpl<$Res>
    implements _$SettingsCopyWith<$Res> {
  __$SettingsCopyWithImpl(this._self, this._then);

  final _Settings _self;
  final $Res Function(_Settings) _then;

/// Create a copy of Settings
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isDarkModeEnabled = null,Object? locale = null,}) {
  return _then(_Settings(
isDarkModeEnabled: null == isDarkModeEnabled ? _self.isDarkModeEnabled : isDarkModeEnabled // ignore: cast_nullable_to_non_nullable
as bool,locale: null == locale ? _self.locale : locale // ignore: cast_nullable_to_non_nullable
as Locale,
  ));
}


}

// dart format on

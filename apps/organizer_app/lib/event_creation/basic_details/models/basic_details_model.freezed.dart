// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'basic_details_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

BasicDetailsModel _$BasicDetailsModelFromJson(Map<String, dynamic> json) {
  return _BasicDetailsModel.fromJson(json);
}

/// @nodoc
mixin _$BasicDetailsModel {
  String get eventId => throw _privateConstructorUsedError;
  String get eventName => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String get category => throw _privateConstructorUsedError;
  String get venue => throw _privateConstructorUsedError;
  DateTime get startDateTime => throw _privateConstructorUsedError;
  DateTime get endDateTime => throw _privateConstructorUsedError;

  /// Serializes this BasicDetailsModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BasicDetailsModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BasicDetailsModelCopyWith<BasicDetailsModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BasicDetailsModelCopyWith<$Res> {
  factory $BasicDetailsModelCopyWith(
          BasicDetailsModel value, $Res Function(BasicDetailsModel) then) =
      _$BasicDetailsModelCopyWithImpl<$Res, BasicDetailsModel>;
  @useResult
  $Res call(
      {String eventId,
      String eventName,
      String description,
      String category,
      String venue,
      DateTime startDateTime,
      DateTime endDateTime});
}

/// @nodoc
class _$BasicDetailsModelCopyWithImpl<$Res, $Val extends BasicDetailsModel>
    implements $BasicDetailsModelCopyWith<$Res> {
  _$BasicDetailsModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BasicDetailsModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? eventId = null,
    Object? eventName = null,
    Object? description = null,
    Object? category = null,
    Object? venue = null,
    Object? startDateTime = null,
    Object? endDateTime = null,
  }) {
    return _then(_value.copyWith(
      eventId: null == eventId
          ? _value.eventId
          : eventId // ignore: cast_nullable_to_non_nullable
              as String,
      eventName: null == eventName
          ? _value.eventName
          : eventName // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      venue: null == venue
          ? _value.venue
          : venue // ignore: cast_nullable_to_non_nullable
              as String,
      startDateTime: null == startDateTime
          ? _value.startDateTime
          : startDateTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDateTime: null == endDateTime
          ? _value.endDateTime
          : endDateTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BasicDetailsModelImplCopyWith<$Res>
    implements $BasicDetailsModelCopyWith<$Res> {
  factory _$$BasicDetailsModelImplCopyWith(_$BasicDetailsModelImpl value,
          $Res Function(_$BasicDetailsModelImpl) then) =
      __$$BasicDetailsModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String eventId,
      String eventName,
      String description,
      String category,
      String venue,
      DateTime startDateTime,
      DateTime endDateTime});
}

/// @nodoc
class __$$BasicDetailsModelImplCopyWithImpl<$Res>
    extends _$BasicDetailsModelCopyWithImpl<$Res, _$BasicDetailsModelImpl>
    implements _$$BasicDetailsModelImplCopyWith<$Res> {
  __$$BasicDetailsModelImplCopyWithImpl(_$BasicDetailsModelImpl _value,
      $Res Function(_$BasicDetailsModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of BasicDetailsModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? eventId = null,
    Object? eventName = null,
    Object? description = null,
    Object? category = null,
    Object? venue = null,
    Object? startDateTime = null,
    Object? endDateTime = null,
  }) {
    return _then(_$BasicDetailsModelImpl(
      eventId: null == eventId
          ? _value.eventId
          : eventId // ignore: cast_nullable_to_non_nullable
              as String,
      eventName: null == eventName
          ? _value.eventName
          : eventName // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      venue: null == venue
          ? _value.venue
          : venue // ignore: cast_nullable_to_non_nullable
              as String,
      startDateTime: null == startDateTime
          ? _value.startDateTime
          : startDateTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDateTime: null == endDateTime
          ? _value.endDateTime
          : endDateTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BasicDetailsModelImpl implements _BasicDetailsModel {
  const _$BasicDetailsModelImpl(
      {required this.eventId,
      required this.eventName,
      required this.description,
      required this.category,
      required this.venue,
      required this.startDateTime,
      required this.endDateTime});

  factory _$BasicDetailsModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$BasicDetailsModelImplFromJson(json);

  @override
  final String eventId;
  @override
  final String eventName;
  @override
  final String description;
  @override
  final String category;
  @override
  final String venue;
  @override
  final DateTime startDateTime;
  @override
  final DateTime endDateTime;

  @override
  String toString() {
    return 'BasicDetailsModel(eventId: $eventId, eventName: $eventName, description: $description, category: $category, venue: $venue, startDateTime: $startDateTime, endDateTime: $endDateTime)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BasicDetailsModelImpl &&
            (identical(other.eventId, eventId) || other.eventId == eventId) &&
            (identical(other.eventName, eventName) ||
                other.eventName == eventName) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.venue, venue) || other.venue == venue) &&
            (identical(other.startDateTime, startDateTime) ||
                other.startDateTime == startDateTime) &&
            (identical(other.endDateTime, endDateTime) ||
                other.endDateTime == endDateTime));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, eventId, eventName, description,
      category, venue, startDateTime, endDateTime);

  /// Create a copy of BasicDetailsModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BasicDetailsModelImplCopyWith<_$BasicDetailsModelImpl> get copyWith =>
      __$$BasicDetailsModelImplCopyWithImpl<_$BasicDetailsModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BasicDetailsModelImplToJson(
      this,
    );
  }
}

abstract class _BasicDetailsModel implements BasicDetailsModel {
  const factory _BasicDetailsModel(
      {required final String eventId,
      required final String eventName,
      required final String description,
      required final String category,
      required final String venue,
      required final DateTime startDateTime,
      required final DateTime endDateTime}) = _$BasicDetailsModelImpl;

  factory _BasicDetailsModel.fromJson(Map<String, dynamic> json) =
      _$BasicDetailsModelImpl.fromJson;

  @override
  String get eventId;
  @override
  String get eventName;
  @override
  String get description;
  @override
  String get category;
  @override
  String get venue;
  @override
  DateTime get startDateTime;
  @override
  DateTime get endDateTime;

  /// Create a copy of BasicDetailsModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BasicDetailsModelImplCopyWith<_$BasicDetailsModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

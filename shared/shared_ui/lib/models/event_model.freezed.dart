// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'event_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Event _$EventFromJson(Map<String, dynamic> json) {
  return _Event.fromJson(json);
}

/// @nodoc
mixin _$Event {
  String get eventId => throw _privateConstructorUsedError;
  String? get brandId => throw _privateConstructorUsedError;
  String get createdByUserId => throw _privateConstructorUsedError;
  String get eventName => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String get category => throw _privateConstructorUsedError;
  DateTime get startDateTime => throw _privateConstructorUsedError;
  DateTime get endDateTime => throw _privateConstructorUsedError;
  String get venue => throw _privateConstructorUsedError;
  String? get eventCoverImageFullUrl => throw _privateConstructorUsedError;
  String? get eventCoverImageCroppedUrl => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  DateTime? get saleStartDate => throw _privateConstructorUsedError;
  DateTime? get saleEndDate => throw _privateConstructorUsedError;

  /// Serializes this Event to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Event
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $EventCopyWith<Event> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EventCopyWith<$Res> {
  factory $EventCopyWith(Event value, $Res Function(Event) then) =
      _$EventCopyWithImpl<$Res, Event>;
  @useResult
  $Res call(
      {String eventId,
      String? brandId,
      String createdByUserId,
      String eventName,
      String description,
      String category,
      DateTime startDateTime,
      DateTime endDateTime,
      String venue,
      String? eventCoverImageFullUrl,
      String? eventCoverImageCroppedUrl,
      String status,
      DateTime createdAt,
      DateTime? updatedAt,
      DateTime? saleStartDate,
      DateTime? saleEndDate});
}

/// @nodoc
class _$EventCopyWithImpl<$Res, $Val extends Event>
    implements $EventCopyWith<$Res> {
  _$EventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Event
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? eventId = null,
    Object? brandId = freezed,
    Object? createdByUserId = null,
    Object? eventName = null,
    Object? description = null,
    Object? category = null,
    Object? startDateTime = null,
    Object? endDateTime = null,
    Object? venue = null,
    Object? eventCoverImageFullUrl = freezed,
    Object? eventCoverImageCroppedUrl = freezed,
    Object? status = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
    Object? saleStartDate = freezed,
    Object? saleEndDate = freezed,
  }) {
    return _then(_value.copyWith(
      eventId: null == eventId
          ? _value.eventId
          : eventId // ignore: cast_nullable_to_non_nullable
              as String,
      brandId: freezed == brandId
          ? _value.brandId
          : brandId // ignore: cast_nullable_to_non_nullable
              as String?,
      createdByUserId: null == createdByUserId
          ? _value.createdByUserId
          : createdByUserId // ignore: cast_nullable_to_non_nullable
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
      startDateTime: null == startDateTime
          ? _value.startDateTime
          : startDateTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDateTime: null == endDateTime
          ? _value.endDateTime
          : endDateTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      venue: null == venue
          ? _value.venue
          : venue // ignore: cast_nullable_to_non_nullable
              as String,
      eventCoverImageFullUrl: freezed == eventCoverImageFullUrl
          ? _value.eventCoverImageFullUrl
          : eventCoverImageFullUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      eventCoverImageCroppedUrl: freezed == eventCoverImageCroppedUrl
          ? _value.eventCoverImageCroppedUrl
          : eventCoverImageCroppedUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      saleStartDate: freezed == saleStartDate
          ? _value.saleStartDate
          : saleStartDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      saleEndDate: freezed == saleEndDate
          ? _value.saleEndDate
          : saleEndDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$EventImplCopyWith<$Res> implements $EventCopyWith<$Res> {
  factory _$$EventImplCopyWith(
          _$EventImpl value, $Res Function(_$EventImpl) then) =
      __$$EventImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String eventId,
      String? brandId,
      String createdByUserId,
      String eventName,
      String description,
      String category,
      DateTime startDateTime,
      DateTime endDateTime,
      String venue,
      String? eventCoverImageFullUrl,
      String? eventCoverImageCroppedUrl,
      String status,
      DateTime createdAt,
      DateTime? updatedAt,
      DateTime? saleStartDate,
      DateTime? saleEndDate});
}

/// @nodoc
class __$$EventImplCopyWithImpl<$Res>
    extends _$EventCopyWithImpl<$Res, _$EventImpl>
    implements _$$EventImplCopyWith<$Res> {
  __$$EventImplCopyWithImpl(
      _$EventImpl _value, $Res Function(_$EventImpl) _then)
      : super(_value, _then);

  /// Create a copy of Event
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? eventId = null,
    Object? brandId = freezed,
    Object? createdByUserId = null,
    Object? eventName = null,
    Object? description = null,
    Object? category = null,
    Object? startDateTime = null,
    Object? endDateTime = null,
    Object? venue = null,
    Object? eventCoverImageFullUrl = freezed,
    Object? eventCoverImageCroppedUrl = freezed,
    Object? status = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
    Object? saleStartDate = freezed,
    Object? saleEndDate = freezed,
  }) {
    return _then(_$EventImpl(
      eventId: null == eventId
          ? _value.eventId
          : eventId // ignore: cast_nullable_to_non_nullable
              as String,
      brandId: freezed == brandId
          ? _value.brandId
          : brandId // ignore: cast_nullable_to_non_nullable
              as String?,
      createdByUserId: null == createdByUserId
          ? _value.createdByUserId
          : createdByUserId // ignore: cast_nullable_to_non_nullable
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
      startDateTime: null == startDateTime
          ? _value.startDateTime
          : startDateTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDateTime: null == endDateTime
          ? _value.endDateTime
          : endDateTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      venue: null == venue
          ? _value.venue
          : venue // ignore: cast_nullable_to_non_nullable
              as String,
      eventCoverImageFullUrl: freezed == eventCoverImageFullUrl
          ? _value.eventCoverImageFullUrl
          : eventCoverImageFullUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      eventCoverImageCroppedUrl: freezed == eventCoverImageCroppedUrl
          ? _value.eventCoverImageCroppedUrl
          : eventCoverImageCroppedUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      saleStartDate: freezed == saleStartDate
          ? _value.saleStartDate
          : saleStartDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      saleEndDate: freezed == saleEndDate
          ? _value.saleEndDate
          : saleEndDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$EventImpl implements _Event {
  const _$EventImpl(
      {required this.eventId,
      this.brandId,
      required this.createdByUserId,
      required this.eventName,
      required this.description,
      required this.category,
      required this.startDateTime,
      required this.endDateTime,
      required this.venue,
      this.eventCoverImageFullUrl,
      this.eventCoverImageCroppedUrl,
      required this.status,
      required this.createdAt,
      this.updatedAt,
      this.saleStartDate,
      this.saleEndDate});

  factory _$EventImpl.fromJson(Map<String, dynamic> json) =>
      _$$EventImplFromJson(json);

  @override
  final String eventId;
  @override
  final String? brandId;
  @override
  final String createdByUserId;
  @override
  final String eventName;
  @override
  final String description;
  @override
  final String category;
  @override
  final DateTime startDateTime;
  @override
  final DateTime endDateTime;
  @override
  final String venue;
  @override
  final String? eventCoverImageFullUrl;
  @override
  final String? eventCoverImageCroppedUrl;
  @override
  final String status;
  @override
  final DateTime createdAt;
  @override
  final DateTime? updatedAt;
  @override
  final DateTime? saleStartDate;
  @override
  final DateTime? saleEndDate;

  @override
  String toString() {
    return 'Event(eventId: $eventId, brandId: $brandId, createdByUserId: $createdByUserId, eventName: $eventName, description: $description, category: $category, startDateTime: $startDateTime, endDateTime: $endDateTime, venue: $venue, eventCoverImageFullUrl: $eventCoverImageFullUrl, eventCoverImageCroppedUrl: $eventCoverImageCroppedUrl, status: $status, createdAt: $createdAt, updatedAt: $updatedAt, saleStartDate: $saleStartDate, saleEndDate: $saleEndDate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EventImpl &&
            (identical(other.eventId, eventId) || other.eventId == eventId) &&
            (identical(other.brandId, brandId) || other.brandId == brandId) &&
            (identical(other.createdByUserId, createdByUserId) ||
                other.createdByUserId == createdByUserId) &&
            (identical(other.eventName, eventName) ||
                other.eventName == eventName) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.startDateTime, startDateTime) ||
                other.startDateTime == startDateTime) &&
            (identical(other.endDateTime, endDateTime) ||
                other.endDateTime == endDateTime) &&
            (identical(other.venue, venue) || other.venue == venue) &&
            (identical(other.eventCoverImageFullUrl, eventCoverImageFullUrl) ||
                other.eventCoverImageFullUrl == eventCoverImageFullUrl) &&
            (identical(other.eventCoverImageCroppedUrl,
                    eventCoverImageCroppedUrl) ||
                other.eventCoverImageCroppedUrl == eventCoverImageCroppedUrl) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.saleStartDate, saleStartDate) ||
                other.saleStartDate == saleStartDate) &&
            (identical(other.saleEndDate, saleEndDate) ||
                other.saleEndDate == saleEndDate));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      eventId,
      brandId,
      createdByUserId,
      eventName,
      description,
      category,
      startDateTime,
      endDateTime,
      venue,
      eventCoverImageFullUrl,
      eventCoverImageCroppedUrl,
      status,
      createdAt,
      updatedAt,
      saleStartDate,
      saleEndDate);

  /// Create a copy of Event
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EventImplCopyWith<_$EventImpl> get copyWith =>
      __$$EventImplCopyWithImpl<_$EventImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EventImplToJson(
      this,
    );
  }
}

abstract class _Event implements Event {
  const factory _Event(
      {required final String eventId,
      final String? brandId,
      required final String createdByUserId,
      required final String eventName,
      required final String description,
      required final String category,
      required final DateTime startDateTime,
      required final DateTime endDateTime,
      required final String venue,
      final String? eventCoverImageFullUrl,
      final String? eventCoverImageCroppedUrl,
      required final String status,
      required final DateTime createdAt,
      final DateTime? updatedAt,
      final DateTime? saleStartDate,
      final DateTime? saleEndDate}) = _$EventImpl;

  factory _Event.fromJson(Map<String, dynamic> json) = _$EventImpl.fromJson;

  @override
  String get eventId;
  @override
  String? get brandId;
  @override
  String get createdByUserId;
  @override
  String get eventName;
  @override
  String get description;
  @override
  String get category;
  @override
  DateTime get startDateTime;
  @override
  DateTime get endDateTime;
  @override
  String get venue;
  @override
  String? get eventCoverImageFullUrl;
  @override
  String? get eventCoverImageCroppedUrl;
  @override
  String get status;
  @override
  DateTime get createdAt;
  @override
  DateTime? get updatedAt;
  @override
  DateTime? get saleStartDate;
  @override
  DateTime? get saleEndDate;

  /// Create a copy of Event
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EventImplCopyWith<_$EventImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

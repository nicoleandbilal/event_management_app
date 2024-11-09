// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ticket_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Ticket _$TicketFromJson(Map<String, dynamic> json) {
  return _Ticket.fromJson(json);
}

/// @nodoc
mixin _$Ticket {
  String get ticketId => throw _privateConstructorUsedError;
  String get eventId => throw _privateConstructorUsedError;
  String get ticketName => throw _privateConstructorUsedError;
  double get ticketPrice => throw _privateConstructorUsedError;
  int get availableQuantity => throw _privateConstructorUsedError;
  int get soldQuantity => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get stripePriceId => throw _privateConstructorUsedError;
  bool get isRefundable => throw _privateConstructorUsedError;
  DateTime? get saleStartDate => throw _privateConstructorUsedError;
  DateTime? get saleEndDate => throw _privateConstructorUsedError;
  bool get isSoldOut => throw _privateConstructorUsedError;

  /// Serializes this Ticket to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Ticket
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TicketCopyWith<Ticket> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TicketCopyWith<$Res> {
  factory $TicketCopyWith(Ticket value, $Res Function(Ticket) then) =
      _$TicketCopyWithImpl<$Res, Ticket>;
  @useResult
  $Res call(
      {String ticketId,
      String eventId,
      String ticketName,
      double ticketPrice,
      int availableQuantity,
      int soldQuantity,
      String? description,
      String? stripePriceId,
      bool isRefundable,
      DateTime? saleStartDate,
      DateTime? saleEndDate,
      bool isSoldOut});
}

/// @nodoc
class _$TicketCopyWithImpl<$Res, $Val extends Ticket>
    implements $TicketCopyWith<$Res> {
  _$TicketCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Ticket
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? ticketId = null,
    Object? eventId = null,
    Object? ticketName = null,
    Object? ticketPrice = null,
    Object? availableQuantity = null,
    Object? soldQuantity = null,
    Object? description = freezed,
    Object? stripePriceId = freezed,
    Object? isRefundable = null,
    Object? saleStartDate = freezed,
    Object? saleEndDate = freezed,
    Object? isSoldOut = null,
  }) {
    return _then(_value.copyWith(
      ticketId: null == ticketId
          ? _value.ticketId
          : ticketId // ignore: cast_nullable_to_non_nullable
              as String,
      eventId: null == eventId
          ? _value.eventId
          : eventId // ignore: cast_nullable_to_non_nullable
              as String,
      ticketName: null == ticketName
          ? _value.ticketName
          : ticketName // ignore: cast_nullable_to_non_nullable
              as String,
      ticketPrice: null == ticketPrice
          ? _value.ticketPrice
          : ticketPrice // ignore: cast_nullable_to_non_nullable
              as double,
      availableQuantity: null == availableQuantity
          ? _value.availableQuantity
          : availableQuantity // ignore: cast_nullable_to_non_nullable
              as int,
      soldQuantity: null == soldQuantity
          ? _value.soldQuantity
          : soldQuantity // ignore: cast_nullable_to_non_nullable
              as int,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      stripePriceId: freezed == stripePriceId
          ? _value.stripePriceId
          : stripePriceId // ignore: cast_nullable_to_non_nullable
              as String?,
      isRefundable: null == isRefundable
          ? _value.isRefundable
          : isRefundable // ignore: cast_nullable_to_non_nullable
              as bool,
      saleStartDate: freezed == saleStartDate
          ? _value.saleStartDate
          : saleStartDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      saleEndDate: freezed == saleEndDate
          ? _value.saleEndDate
          : saleEndDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isSoldOut: null == isSoldOut
          ? _value.isSoldOut
          : isSoldOut // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TicketImplCopyWith<$Res> implements $TicketCopyWith<$Res> {
  factory _$$TicketImplCopyWith(
          _$TicketImpl value, $Res Function(_$TicketImpl) then) =
      __$$TicketImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String ticketId,
      String eventId,
      String ticketName,
      double ticketPrice,
      int availableQuantity,
      int soldQuantity,
      String? description,
      String? stripePriceId,
      bool isRefundable,
      DateTime? saleStartDate,
      DateTime? saleEndDate,
      bool isSoldOut});
}

/// @nodoc
class __$$TicketImplCopyWithImpl<$Res>
    extends _$TicketCopyWithImpl<$Res, _$TicketImpl>
    implements _$$TicketImplCopyWith<$Res> {
  __$$TicketImplCopyWithImpl(
      _$TicketImpl _value, $Res Function(_$TicketImpl) _then)
      : super(_value, _then);

  /// Create a copy of Ticket
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? ticketId = null,
    Object? eventId = null,
    Object? ticketName = null,
    Object? ticketPrice = null,
    Object? availableQuantity = null,
    Object? soldQuantity = null,
    Object? description = freezed,
    Object? stripePriceId = freezed,
    Object? isRefundable = null,
    Object? saleStartDate = freezed,
    Object? saleEndDate = freezed,
    Object? isSoldOut = null,
  }) {
    return _then(_$TicketImpl(
      ticketId: null == ticketId
          ? _value.ticketId
          : ticketId // ignore: cast_nullable_to_non_nullable
              as String,
      eventId: null == eventId
          ? _value.eventId
          : eventId // ignore: cast_nullable_to_non_nullable
              as String,
      ticketName: null == ticketName
          ? _value.ticketName
          : ticketName // ignore: cast_nullable_to_non_nullable
              as String,
      ticketPrice: null == ticketPrice
          ? _value.ticketPrice
          : ticketPrice // ignore: cast_nullable_to_non_nullable
              as double,
      availableQuantity: null == availableQuantity
          ? _value.availableQuantity
          : availableQuantity // ignore: cast_nullable_to_non_nullable
              as int,
      soldQuantity: null == soldQuantity
          ? _value.soldQuantity
          : soldQuantity // ignore: cast_nullable_to_non_nullable
              as int,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      stripePriceId: freezed == stripePriceId
          ? _value.stripePriceId
          : stripePriceId // ignore: cast_nullable_to_non_nullable
              as String?,
      isRefundable: null == isRefundable
          ? _value.isRefundable
          : isRefundable // ignore: cast_nullable_to_non_nullable
              as bool,
      saleStartDate: freezed == saleStartDate
          ? _value.saleStartDate
          : saleStartDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      saleEndDate: freezed == saleEndDate
          ? _value.saleEndDate
          : saleEndDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isSoldOut: null == isSoldOut
          ? _value.isSoldOut
          : isSoldOut // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TicketImpl implements _Ticket {
  const _$TicketImpl(
      {required this.ticketId,
      required this.eventId,
      required this.ticketName,
      required this.ticketPrice,
      required this.availableQuantity,
      required this.soldQuantity,
      this.description,
      this.stripePriceId,
      this.isRefundable = true,
      this.saleStartDate,
      this.saleEndDate,
      this.isSoldOut = false});

  factory _$TicketImpl.fromJson(Map<String, dynamic> json) =>
      _$$TicketImplFromJson(json);

  @override
  final String ticketId;
  @override
  final String eventId;
  @override
  final String ticketName;
  @override
  final double ticketPrice;
  @override
  final int availableQuantity;
  @override
  final int soldQuantity;
  @override
  final String? description;
  @override
  final String? stripePriceId;
  @override
  @JsonKey()
  final bool isRefundable;
  @override
  final DateTime? saleStartDate;
  @override
  final DateTime? saleEndDate;
  @override
  @JsonKey()
  final bool isSoldOut;

  @override
  String toString() {
    return 'Ticket(ticketId: $ticketId, eventId: $eventId, ticketName: $ticketName, ticketPrice: $ticketPrice, availableQuantity: $availableQuantity, soldQuantity: $soldQuantity, description: $description, stripePriceId: $stripePriceId, isRefundable: $isRefundable, saleStartDate: $saleStartDate, saleEndDate: $saleEndDate, isSoldOut: $isSoldOut)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TicketImpl &&
            (identical(other.ticketId, ticketId) ||
                other.ticketId == ticketId) &&
            (identical(other.eventId, eventId) || other.eventId == eventId) &&
            (identical(other.ticketName, ticketName) ||
                other.ticketName == ticketName) &&
            (identical(other.ticketPrice, ticketPrice) ||
                other.ticketPrice == ticketPrice) &&
            (identical(other.availableQuantity, availableQuantity) ||
                other.availableQuantity == availableQuantity) &&
            (identical(other.soldQuantity, soldQuantity) ||
                other.soldQuantity == soldQuantity) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.stripePriceId, stripePriceId) ||
                other.stripePriceId == stripePriceId) &&
            (identical(other.isRefundable, isRefundable) ||
                other.isRefundable == isRefundable) &&
            (identical(other.saleStartDate, saleStartDate) ||
                other.saleStartDate == saleStartDate) &&
            (identical(other.saleEndDate, saleEndDate) ||
                other.saleEndDate == saleEndDate) &&
            (identical(other.isSoldOut, isSoldOut) ||
                other.isSoldOut == isSoldOut));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      ticketId,
      eventId,
      ticketName,
      ticketPrice,
      availableQuantity,
      soldQuantity,
      description,
      stripePriceId,
      isRefundable,
      saleStartDate,
      saleEndDate,
      isSoldOut);

  /// Create a copy of Ticket
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TicketImplCopyWith<_$TicketImpl> get copyWith =>
      __$$TicketImplCopyWithImpl<_$TicketImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TicketImplToJson(
      this,
    );
  }
}

abstract class _Ticket implements Ticket {
  const factory _Ticket(
      {required final String ticketId,
      required final String eventId,
      required final String ticketName,
      required final double ticketPrice,
      required final int availableQuantity,
      required final int soldQuantity,
      final String? description,
      final String? stripePriceId,
      final bool isRefundable,
      final DateTime? saleStartDate,
      final DateTime? saleEndDate,
      final bool isSoldOut}) = _$TicketImpl;

  factory _Ticket.fromJson(Map<String, dynamic> json) = _$TicketImpl.fromJson;

  @override
  String get ticketId;
  @override
  String get eventId;
  @override
  String get ticketName;
  @override
  double get ticketPrice;
  @override
  int get availableQuantity;
  @override
  int get soldQuantity;
  @override
  String? get description;
  @override
  String? get stripePriceId;
  @override
  bool get isRefundable;
  @override
  DateTime? get saleStartDate;
  @override
  DateTime? get saleEndDate;
  @override
  bool get isSoldOut;

  /// Create a copy of Ticket
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TicketImplCopyWith<_$TicketImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

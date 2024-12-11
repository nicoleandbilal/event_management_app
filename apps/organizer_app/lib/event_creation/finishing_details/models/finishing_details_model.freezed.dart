// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'finishing_details_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

FinishingDetailsModel _$FinishingDetailsModelFromJson(
    Map<String, dynamic> json) {
  return _FinishingDetailsModel.fromJson(json);
}

/// @nodoc
mixin _$FinishingDetailsModel {
  String get eventId => throw _privateConstructorUsedError;
  DateTime? get salesStartDate => throw _privateConstructorUsedError;
  DateTime? get salesEndDate => throw _privateConstructorUsedError;
  bool get privacyPolicyAgreed => throw _privateConstructorUsedError;
  String? get remarks => throw _privateConstructorUsedError;

  /// Serializes this FinishingDetailsModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FinishingDetailsModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FinishingDetailsModelCopyWith<FinishingDetailsModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FinishingDetailsModelCopyWith<$Res> {
  factory $FinishingDetailsModelCopyWith(FinishingDetailsModel value,
          $Res Function(FinishingDetailsModel) then) =
      _$FinishingDetailsModelCopyWithImpl<$Res, FinishingDetailsModel>;
  @useResult
  $Res call(
      {String eventId,
      DateTime? salesStartDate,
      DateTime? salesEndDate,
      bool privacyPolicyAgreed,
      String? remarks});
}

/// @nodoc
class _$FinishingDetailsModelCopyWithImpl<$Res,
        $Val extends FinishingDetailsModel>
    implements $FinishingDetailsModelCopyWith<$Res> {
  _$FinishingDetailsModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FinishingDetailsModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? eventId = null,
    Object? salesStartDate = freezed,
    Object? salesEndDate = freezed,
    Object? privacyPolicyAgreed = null,
    Object? remarks = freezed,
  }) {
    return _then(_value.copyWith(
      eventId: null == eventId
          ? _value.eventId
          : eventId // ignore: cast_nullable_to_non_nullable
              as String,
      salesStartDate: freezed == salesStartDate
          ? _value.salesStartDate
          : salesStartDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      salesEndDate: freezed == salesEndDate
          ? _value.salesEndDate
          : salesEndDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      privacyPolicyAgreed: null == privacyPolicyAgreed
          ? _value.privacyPolicyAgreed
          : privacyPolicyAgreed // ignore: cast_nullable_to_non_nullable
              as bool,
      remarks: freezed == remarks
          ? _value.remarks
          : remarks // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FinishingDetailsModelImplCopyWith<$Res>
    implements $FinishingDetailsModelCopyWith<$Res> {
  factory _$$FinishingDetailsModelImplCopyWith(
          _$FinishingDetailsModelImpl value,
          $Res Function(_$FinishingDetailsModelImpl) then) =
      __$$FinishingDetailsModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String eventId,
      DateTime? salesStartDate,
      DateTime? salesEndDate,
      bool privacyPolicyAgreed,
      String? remarks});
}

/// @nodoc
class __$$FinishingDetailsModelImplCopyWithImpl<$Res>
    extends _$FinishingDetailsModelCopyWithImpl<$Res,
        _$FinishingDetailsModelImpl>
    implements _$$FinishingDetailsModelImplCopyWith<$Res> {
  __$$FinishingDetailsModelImplCopyWithImpl(_$FinishingDetailsModelImpl _value,
      $Res Function(_$FinishingDetailsModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of FinishingDetailsModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? eventId = null,
    Object? salesStartDate = freezed,
    Object? salesEndDate = freezed,
    Object? privacyPolicyAgreed = null,
    Object? remarks = freezed,
  }) {
    return _then(_$FinishingDetailsModelImpl(
      eventId: null == eventId
          ? _value.eventId
          : eventId // ignore: cast_nullable_to_non_nullable
              as String,
      salesStartDate: freezed == salesStartDate
          ? _value.salesStartDate
          : salesStartDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      salesEndDate: freezed == salesEndDate
          ? _value.salesEndDate
          : salesEndDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      privacyPolicyAgreed: null == privacyPolicyAgreed
          ? _value.privacyPolicyAgreed
          : privacyPolicyAgreed // ignore: cast_nullable_to_non_nullable
              as bool,
      remarks: freezed == remarks
          ? _value.remarks
          : remarks // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FinishingDetailsModelImpl implements _FinishingDetailsModel {
  const _$FinishingDetailsModelImpl(
      {required this.eventId,
      this.salesStartDate,
      this.salesEndDate,
      required this.privacyPolicyAgreed,
      this.remarks});

  factory _$FinishingDetailsModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$FinishingDetailsModelImplFromJson(json);

  @override
  final String eventId;
  @override
  final DateTime? salesStartDate;
  @override
  final DateTime? salesEndDate;
  @override
  final bool privacyPolicyAgreed;
  @override
  final String? remarks;

  @override
  String toString() {
    return 'FinishingDetailsModel(eventId: $eventId, salesStartDate: $salesStartDate, salesEndDate: $salesEndDate, privacyPolicyAgreed: $privacyPolicyAgreed, remarks: $remarks)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FinishingDetailsModelImpl &&
            (identical(other.eventId, eventId) || other.eventId == eventId) &&
            (identical(other.salesStartDate, salesStartDate) ||
                other.salesStartDate == salesStartDate) &&
            (identical(other.salesEndDate, salesEndDate) ||
                other.salesEndDate == salesEndDate) &&
            (identical(other.privacyPolicyAgreed, privacyPolicyAgreed) ||
                other.privacyPolicyAgreed == privacyPolicyAgreed) &&
            (identical(other.remarks, remarks) || other.remarks == remarks));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, eventId, salesStartDate,
      salesEndDate, privacyPolicyAgreed, remarks);

  /// Create a copy of FinishingDetailsModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FinishingDetailsModelImplCopyWith<_$FinishingDetailsModelImpl>
      get copyWith => __$$FinishingDetailsModelImplCopyWithImpl<
          _$FinishingDetailsModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FinishingDetailsModelImplToJson(
      this,
    );
  }
}

abstract class _FinishingDetailsModel implements FinishingDetailsModel {
  const factory _FinishingDetailsModel(
      {required final String eventId,
      final DateTime? salesStartDate,
      final DateTime? salesEndDate,
      required final bool privacyPolicyAgreed,
      final String? remarks}) = _$FinishingDetailsModelImpl;

  factory _FinishingDetailsModel.fromJson(Map<String, dynamic> json) =
      _$FinishingDetailsModelImpl.fromJson;

  @override
  String get eventId;
  @override
  DateTime? get salesStartDate;
  @override
  DateTime? get salesEndDate;
  @override
  bool get privacyPolicyAgreed;
  @override
  String? get remarks;

  /// Create a copy of FinishingDetailsModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FinishingDetailsModelImplCopyWith<_$FinishingDetailsModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}

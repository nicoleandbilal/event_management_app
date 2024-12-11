// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'finishing_details_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FinishingDetailsModelImpl _$$FinishingDetailsModelImplFromJson(
        Map<String, dynamic> json) =>
    _$FinishingDetailsModelImpl(
      eventId: json['eventId'] as String,
      salesStartDate: json['salesStartDate'] == null
          ? null
          : DateTime.parse(json['salesStartDate'] as String),
      salesEndDate: json['salesEndDate'] == null
          ? null
          : DateTime.parse(json['salesEndDate'] as String),
      privacyPolicyAgreed: json['privacyPolicyAgreed'] as bool,
      remarks: json['remarks'] as String?,
    );

Map<String, dynamic> _$$FinishingDetailsModelImplToJson(
        _$FinishingDetailsModelImpl instance) =>
    <String, dynamic>{
      'eventId': instance.eventId,
      'salesStartDate': instance.salesStartDate?.toIso8601String(),
      'salesEndDate': instance.salesEndDate?.toIso8601String(),
      'privacyPolicyAgreed': instance.privacyPolicyAgreed,
      'remarks': instance.remarks,
    };

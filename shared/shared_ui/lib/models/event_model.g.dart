// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$EventImpl _$$EventImplFromJson(Map<String, dynamic> json) => _$EventImpl(
      eventId: json['eventId'] as String,
      brandId: json['brandId'] as String?,
      createdByUserId: json['createdByUserId'] as String,
      eventName: json['eventName'] as String,
      description: json['description'] as String,
      category: json['category'] as String,
      startDateTime: DateTime.parse(json['startDateTime'] as String),
      endDateTime: DateTime.parse(json['endDateTime'] as String),
      venue: json['venue'] as String,
      eventCoverImageFullUrl: json['eventCoverImageFullUrl'] as String?,
      eventCoverImageCroppedUrl: json['eventCoverImageCroppedUrl'] as String?,
      status: json['status'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      saleStartDate: json['saleStartDate'] == null
          ? null
          : DateTime.parse(json['saleStartDate'] as String),
      saleEndDate: json['saleEndDate'] == null
          ? null
          : DateTime.parse(json['saleEndDate'] as String),
    );

Map<String, dynamic> _$$EventImplToJson(_$EventImpl instance) =>
    <String, dynamic>{
      'eventId': instance.eventId,
      'brandId': instance.brandId,
      'createdByUserId': instance.createdByUserId,
      'eventName': instance.eventName,
      'description': instance.description,
      'category': instance.category,
      'startDateTime': instance.startDateTime.toIso8601String(),
      'endDateTime': instance.endDateTime.toIso8601String(),
      'venue': instance.venue,
      'eventCoverImageFullUrl': instance.eventCoverImageFullUrl,
      'eventCoverImageCroppedUrl': instance.eventCoverImageCroppedUrl,
      'status': instance.status,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'saleStartDate': instance.saleStartDate?.toIso8601String(),
      'saleEndDate': instance.saleEndDate?.toIso8601String(),
    };

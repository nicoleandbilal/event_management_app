// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'basic_details_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BasicDetailsModelImpl _$$BasicDetailsModelImplFromJson(
        Map<String, dynamic> json) =>
    _$BasicDetailsModelImpl(
      eventId: json['eventId'] as String,
      eventName: json['eventName'] as String,
      description: json['description'] as String,
      category: json['category'] as String,
      venue: json['venue'] as String,
      startDateTime: DateTime.parse(json['startDateTime'] as String),
      endDateTime: DateTime.parse(json['endDateTime'] as String),
    );

Map<String, dynamic> _$$BasicDetailsModelImplToJson(
        _$BasicDetailsModelImpl instance) =>
    <String, dynamic>{
      'eventId': instance.eventId,
      'eventName': instance.eventName,
      'description': instance.description,
      'category': instance.category,
      'venue': instance.venue,
      'startDateTime': instance.startDateTime.toIso8601String(),
      'endDateTime': instance.endDateTime.toIso8601String(),
    };

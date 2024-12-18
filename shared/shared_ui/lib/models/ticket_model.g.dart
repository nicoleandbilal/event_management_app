// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ticket_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TicketImpl _$$TicketImplFromJson(Map<String, dynamic> json) => _$TicketImpl(
      ticketId: json['ticketId'] as String,
      eventId: json['eventId'] as String,
      ticketType: json['ticketType'] as String,
      ticketName: json['ticketName'] as String,
      ticketPrice: (json['ticketPrice'] as num).toDouble(),
      availableQuantity: (json['availableQuantity'] as num).toInt(),
      soldQuantity: (json['soldQuantity'] as num).toInt(),
      description: json['description'] as String?,
      stripePriceId: json['stripePriceId'] as String?,
      isRefundable: json['isRefundable'] as bool? ?? true,
      ticketSaleStartDateTime: json['ticketSaleStartDateTime'] == null
          ? null
          : DateTime.parse(json['ticketSaleStartDateTime'] as String),
      ticketSaleEndDateTime: json['ticketSaleEndDateTime'] == null
          ? null
          : DateTime.parse(json['ticketSaleEndDateTime'] as String),
      isSoldOut: json['isSoldOut'] as bool? ?? false,
    );

Map<String, dynamic> _$$TicketImplToJson(_$TicketImpl instance) =>
    <String, dynamic>{
      'ticketId': instance.ticketId,
      'eventId': instance.eventId,
      'ticketType': instance.ticketType,
      'ticketName': instance.ticketName,
      'ticketPrice': instance.ticketPrice,
      'availableQuantity': instance.availableQuantity,
      'soldQuantity': instance.soldQuantity,
      'description': instance.description,
      'stripePriceId': instance.stripePriceId,
      'isRefundable': instance.isRefundable,
      'ticketSaleStartDateTime':
          instance.ticketSaleStartDateTime?.toIso8601String(),
      'ticketSaleEndDateTime':
          instance.ticketSaleEndDateTime?.toIso8601String(),
      'isSoldOut': instance.isSoldOut,
    };

import 'package:freezed_annotation/freezed_annotation.dart';

part 'basic_details_model.freezed.dart';
part 'basic_details_model.g.dart';

@freezed
class BasicDetailsModel with _$BasicDetailsModel {
  const factory BasicDetailsModel({
    required String eventId,
    required String eventName,
    required String description,
    required String category,
    required String venue,
    required DateTime startDateTime,
    required DateTime endDateTime,
  }) = _BasicDetailsModel;

  factory BasicDetailsModel.fromJson(Map<String, dynamic> json) =>
      _$BasicDetailsModelFromJson(json);
}
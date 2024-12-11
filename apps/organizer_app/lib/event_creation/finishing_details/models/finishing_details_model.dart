import 'package:freezed_annotation/freezed_annotation.dart';

part 'finishing_details_model.freezed.dart';
part 'finishing_details_model.g.dart';

@freezed
class FinishingDetailsModel with _$FinishingDetailsModel {
  const factory FinishingDetailsModel({
    required String eventId,
    DateTime? salesStartDate,
    DateTime? salesEndDate,
    required bool privacyPolicyAgreed,
    String? remarks,
  }) = _FinishingDetailsModel;

  factory FinishingDetailsModel.fromJson(Map<String, dynamic> json) =>
      _$FinishingDetailsModelFromJson(json);
}

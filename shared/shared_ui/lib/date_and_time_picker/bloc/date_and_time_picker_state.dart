// date_and_time_picker_state.dart
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class DateAndTimePickerState extends Equatable {
  final DateTime? startDate;
  final DateTime? endDate;
  final TimeOfDay? startTime;
  final TimeOfDay? endTime;

  const DateAndTimePickerState({
    this.startDate,
    this.endDate,
    this.startTime,
    this.endTime,
  });

  DateAndTimePickerState copyWith({
    DateTime? startDate,
    DateTime? endDate,
    TimeOfDay? startTime,
    TimeOfDay? endTime,
  }) {
    return DateAndTimePickerState(
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
    );
  }

  @override
  List<Object?> get props => [startDate, endDate, startTime, endTime];
}

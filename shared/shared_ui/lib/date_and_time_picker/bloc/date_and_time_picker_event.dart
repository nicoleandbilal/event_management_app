// date_and_time_picker_event.dart
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class DateAndTimePickerEvent extends Equatable {
  const DateAndTimePickerEvent();

  @override
  List<Object> get props => [];
}

class StartDatePicked extends DateAndTimePickerEvent {
  final DateTime date;
  const StartDatePicked(this.date);

  @override
  List<Object> get props => [date];
}

class EndDatePicked extends DateAndTimePickerEvent {
  final DateTime date;
  const EndDatePicked(this.date);

  @override
  List<Object> get props => [date];
}

class StartTimePicked extends DateAndTimePickerEvent {
  final TimeOfDay time;
  const StartTimePicked(this.time);

  @override
  List<Object> get props => [time];
}

class EndTimePicked extends DateAndTimePickerEvent {
  final TimeOfDay time;
  const EndTimePicked(this.time);

  @override
  List<Object> get props => [time];
}

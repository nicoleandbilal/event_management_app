// date_and_time_picker_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'date_and_time_picker_event.dart';
import 'date_and_time_picker_state.dart';

class DateAndTimePickerBloc extends Bloc<DateAndTimePickerEvent, DateAndTimePickerState> {
  DateAndTimePickerBloc() : super(const DateAndTimePickerState());

  @override
  Stream<DateAndTimePickerState> mapEventToState(DateAndTimePickerEvent event) async* {
    if (event is StartDatePicked) {
      yield state.copyWith(startDate: event.date);
    } else if (event is EndDatePicked) {
      yield state.copyWith(endDate: event.date);
    } else if (event is StartTimePicked) {
      yield state.copyWith(startTime: event.time);
    } else if (event is EndTimePicked) {
      yield state.copyWith(endTime: event.time);
    }
  }
}

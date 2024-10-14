// lib/blocs/email_checker/email_checker_bloc.dart

/*

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared/repositories/auth_repository.dart';
import 'email_checker_event.dart';
import 'package:shared/blocs/all_auth/email_checker/email_checker_state.dart';

class EmailCheckerBloc extends Bloc<EmailCheckerEvent, EmailCheckerState> {
  final AuthRepository authRepository;

  EmailCheckerBloc({required this.authRepository}) : super(EmailCheckerInitial()) {
    on<CheckEmailEvent>(_onCheckEmail);
  }

  Future<void> _onCheckEmail(
      CheckEmailEvent event, Emitter<EmailCheckerState> emit) async {
    emit(EmailCheckerLoading());
    try {
      final exists = await authRepository.checkEmailExists(event.email);
      if (exists) {
        emit(EmailExistsState());
      } else {
        emit(EmailDoesNotExistState());
      }
    } catch (e) {
      emit(const EmailCheckerError("Failed to check email. Please try again."));
    }
  }
}

*/
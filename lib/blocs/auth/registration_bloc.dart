import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:event_management_app/repositories/auth_repository.dart';

// Events for RegistrationBloc
abstract class RegistrationEvent extends Equatable {
  const RegistrationEvent();
  @override
  List<Object> get props => [];
}

class RegistrationEmailChanged extends RegistrationEvent {
  final String email;
  const RegistrationEmailChanged(this.email);

  @override
  List<Object> get props => [email];
}

class RegistrationPasswordChanged extends RegistrationEvent {
  final String password;
  const RegistrationPasswordChanged(this.password);

  @override
  List<Object> get props => [password];
}

class RegistrationSubmitted extends RegistrationEvent {
  final String email;
  final String password;
  const RegistrationSubmitted(this.email, this.password);

  @override
  List<Object> get props => [email, password];
}

// States for RegistrationBloc
abstract class RegistrationState extends Equatable {
  const RegistrationState();

  @override
  List<Object> get props => [];
}

class RegistrationInitial extends RegistrationState {}

class RegistrationLoading extends RegistrationState {}

class RegistrationSuccess extends RegistrationState {
  final User user;
  const RegistrationSuccess({required this.user});

  @override
  List<Object> get props => [user];
}

class RegistrationFailure extends RegistrationState {
  final String error;
  const RegistrationFailure({required this.error});

  @override
  List<Object> get props => [error];
}

// Bloc Implementation
class RegistrationBloc extends Bloc<RegistrationEvent, RegistrationState> {
  final AuthRepository _authRepository;

  RegistrationBloc({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(RegistrationInitial()) {
    // Register event handlers
    on<RegistrationEmailChanged>((event, emit) {
      // Handle email changed event if needed
    });

    on<RegistrationPasswordChanged>((event, emit) {
      // Handle password changed event if needed
    });

    on<RegistrationSubmitted>((event, emit) async {
      emit(RegistrationLoading());
      try {
        final user = await _authRepository.registerWithEmail(event.email, event.password);
        if (user != null) {
          emit(RegistrationSuccess(user: user));
        } else {
          emit(const RegistrationFailure(error: 'Registration failed. Please try again.'));
        }
      } catch (error) {
        emit(RegistrationFailure(error: error.toString()));
      }
    });
  }
}

// lib/blocs/auth/login_bloc.dart

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../repositories/auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared/blocs/auth/auth_bloc.dart';  // Import AuthBloc to dispatch LoggedIn event

// Events for LoginBloc
abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

class LoginEmailChanged extends LoginEvent {
  final String email;
  const LoginEmailChanged(this.email);

  @override
  List<Object> get props => [email];
}

class LoginPasswordChanged extends LoginEvent {
  final String password;
  const LoginPasswordChanged(this.password);

  @override
  List<Object> get props => [password];
}

class LoginSubmitted extends LoginEvent {
  final String email;
  final String password;
  const LoginSubmitted(this.email, this.password);

  @override
  List<Object> get props => [email, password];
}

// States for LoginBloc
abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props => [];
}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final User user;
  const LoginSuccess({required this.user});

  @override
  List<Object> get props => [user];
}

class LoginFailure extends LoginState {
  final String error;
  const LoginFailure({required this.error});

  @override
  List<Object> get props => [error];
}

// Bloc Implementation
class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository _authRepository;
  final AuthBloc _authBloc;  // Inject AuthBloc to dispatch authentication events

  LoginBloc({required AuthRepository authRepository, required AuthBloc authBloc})
      : _authRepository = authRepository,
        _authBloc = authBloc,  // Set AuthBloc to be used inside the Bloc
        super(LoginInitial()) {
    // Register event handlers
    on<LoginEmailChanged>(_onLoginEmailChanged);
    on<LoginPasswordChanged>(_onLoginPasswordChanged);
    on<LoginSubmitted>(_onLoginSubmitted);
  }

  void _onLoginEmailChanged(LoginEmailChanged event, Emitter<LoginState> emit) {
    // Optionally handle email changes for validation
    // For example, you could emit states that reflect validation status
    // Future validation logic can be implemented here
  }

  void _onLoginPasswordChanged(LoginPasswordChanged event, Emitter<LoginState> emit) {
    // Optionally handle password changes for validation
    // For example, you could emit states that reflect validation status
    // Future validation logic can be implemented here
  }

  void _onLoginSubmitted(LoginSubmitted event, Emitter<LoginState> emit) async {
    emit(LoginLoading());  // Emit loading state while attempting login
    try {
      final user = await _authRepository.signInWithEmail(event.email, event.password);
      if (user != null) {
        emit(LoginSuccess(user: user));

        // Dispatch LoggedIn event to AuthBloc after successful login
        _authBloc.add(LoggedIn());
      } else {
        emit(const LoginFailure(error: 'Login failed. Please try again.'));
      }
    } catch (error) {
      emit(LoginFailure(error: _mapErrorToMessage(error)));
    }
  }

  String _mapErrorToMessage(dynamic error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'invalid-email':
          return 'The email address is not valid.';
        case 'user-disabled':
          return 'This user has been disabled.';
        case 'user-not-found':
          return 'No user found for that email.';
        case 'wrong-password':
          return 'Wrong password provided.';
        default:
          return 'Authentication failed. Please try again.';
      }
    } else {
      return 'An unknown error occurred.';
    }
  }
}

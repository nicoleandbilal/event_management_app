// lib/blocs/auth/auth_bloc.dart

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:event_management_app/repositories/auth_repository.dart';

// Events for AuthBloc
abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AppStarted extends AuthEvent {}

class LoggedIn extends AuthEvent {}

class LoggedOut extends AuthEvent {}

// States for AuthBloc
abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class Authenticated extends AuthState {
  final User user;
  const Authenticated({required this.user});

  @override
  List<Object> get props => [user];
}

class Unauthenticated extends AuthState {}

// Bloc Implementation
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;

  AuthBloc({AuthRepository? authRepository})
      : _authRepository = authRepository ?? AuthRepository(),
        super(AuthInitial()) {
    // Register event handlers
    on<AppStarted>(_onAppStarted);
    on<LoggedIn>(_onLoggedIn);
    on<LoggedOut>(_onLoggedOut);

    // Listen to Firebase Auth State Changes
    _authRepository.authStateChanges.listen((user) {
      if (user != null) {
        add(LoggedIn());
      } else {
        add(LoggedOut());
      }
    });
  }

  void _onAppStarted(AppStarted event, Emitter<AuthState> emit) async {
    final currentUser = _authRepository.getCurrentUser();
    if (currentUser != null) {
      emit(Authenticated(user: currentUser));
    } else {
      emit(Unauthenticated());
    }
  }

  void _onLoggedIn(LoggedIn event, Emitter<AuthState> emit) {
    final user = _authRepository.getCurrentUser();
    if (user != null) {
      emit(Authenticated(user: user));
    } else {
      emit(Unauthenticated());
    }
  }

  void _onLoggedOut(LoggedOut event, Emitter<AuthState> emit) {
    emit(Unauthenticated());
  }
}

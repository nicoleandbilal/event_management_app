import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../repositories/auth_repository.dart';
import 'package:logger/logger.dart';

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
  late final StreamSubscription<User?> _authSubscription;
  final Logger _logger = Logger();

  AuthBloc({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(AuthInitial()) {

    // Register event handlers
    on<AppStarted>(_onAppStarted);
    on<LoggedIn>(_onLoggedIn);
    on<LoggedOut>(_onLoggedOut);

    // Listen to Firebase Auth State Changes and emit states directly
    _authSubscription = _authRepository.authStateChanges.listen((user) {
      if (user != null) {
        emit(Authenticated(user: user));
        _logger.i('AuthBloc: User authenticated: ${user.email}');
      } else {
        emit(Unauthenticated());
        _logger.i('AuthBloc: User unauthenticated.');
      }
    });

    _logger.d('AuthBloc initialized and listening to auth state changes.');
  }

  // Event Handler for AppStarted
  void _onAppStarted(AppStarted event, Emitter<AuthState> emit) async {
    _logger.i('AuthBloc: AppStarted event received.');
    final currentUser = _authRepository.getCurrentUser();
    if (currentUser != null) {
      emit(Authenticated(user: currentUser));
      _logger.i('AuthBloc: Emitting Authenticated state.');
    } else {
      emit(Unauthenticated());
      _logger.i('AuthBloc: Emitting Unauthenticated state.');
    }
  }

  // Event Handler for LoggedIn (after login or registration)
  void _onLoggedIn(LoggedIn event, Emitter<AuthState> emit) async {
    final currentUser = _authRepository.getCurrentUser();
    if (currentUser != null) {
      emit(Authenticated(user: currentUser));
      _logger.i('AuthBloc: User logged in. Emitting Authenticated state.');
    }
  }

  // Event Handler for LoggedOut
  void _onLoggedOut(LoggedOut event, Emitter<AuthState> emit) async {
    await _authRepository.signOut();
    emit(Unauthenticated());
    _logger.i('AuthBloc: User logged out. Emitting Unauthenticated state.');
  }

  @override
  Future<void> close() {
    _authSubscription.cancel(); // Correctly cancel the subscription
    _logger.d('AuthBloc: Stream subscription canceled.');
    return super.close();
  }
}
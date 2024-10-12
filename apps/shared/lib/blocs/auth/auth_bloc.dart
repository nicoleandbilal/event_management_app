import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../repositories/auth_repository.dart';
import 'package:logger/logger.dart';

// --- EVENTS ---
abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AppStarted extends AuthEvent {}

class LoggedIn extends AuthEvent {}

class LoggedOut extends AuthEvent {}

// --- STATES ---
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

// --- BLOC IMPLEMENTATION ---
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  late final StreamSubscription<User?> _authSubscription;
  final Logger _logger = Logger();

  AuthBloc({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(AuthInitial()) {
    
    // Registering event handlers for the three events
    on<AppStarted>(_onAppStarted);
    on<LoggedIn>(_onLoggedIn);
    on<LoggedOut>(_onLoggedOut);

    // Listen to Firebase Auth State Changes and emit states directly
    _authSubscription = _authRepository.authStateChanges.listen((user) {
      if (user != null) {
        add(LoggedIn()); // Emit LoggedIn event when authenticated
        _logger.i('AuthBloc: User authenticated: ${user.email}');
      } else {
        add(LoggedOut()); // Emit LoggedOut event when not authenticated
        _logger.i('AuthBloc: User unauthenticated.');
      }
    });

    _logger.d('AuthBloc initialized and listening to auth state changes.');
  }

  // --- EVENT HANDLERS ---

  // Handler for AppStarted event (fired when the app starts)
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

  // Handler for LoggedIn event (fired after successful login)
  void _onLoggedIn(LoggedIn event, Emitter<AuthState> emit) async {
    final currentUser = _authRepository.getCurrentUser();
    if (currentUser != null) {
      emit(Authenticated(user: currentUser));
      _logger.i('AuthBloc: User logged in. Emitting Authenticated state.');
    }
  }

  // Handler for LoggedOut event (fired when the user logs out)
  void _onLoggedOut(LoggedOut event, Emitter<AuthState> emit) async {
    await _authRepository.signOut();
    emit(Unauthenticated());
    _logger.i('AuthBloc: User logged out. Emitting Unauthenticated state.');
  }

  @override
  Future<void> close() {
    _authSubscription.cancel(); // Cancel the subscription to avoid memory leaks
    _logger.d('AuthBloc: Stream subscription canceled.');
    return super.close();
  }
}

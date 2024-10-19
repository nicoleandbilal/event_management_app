import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../repositories/auth_repository.dart';
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

class EmailRecognized extends AuthEvent {
  final String email;

  const EmailRecognized({required this.email});

  @override
  List<Object> get props => [email];
}

class PasswordSubmitted extends AuthEvent {
  final String email;
  final String password;

  const PasswordSubmitted({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}

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

class AuthEmailRecognized extends AuthState {
  final String email;

  const AuthEmailRecognized({required this.email});

  @override
  List<Object> get props => [email];
}

class AuthLogin extends AuthState {
  final String email;

  const AuthLogin({required this.email});

  @override
  List<Object> get props => [email];
}

class AuthRegistration extends AuthState {
  final String email;

  const AuthRegistration({required this.email});

  @override
  List<Object> get props => [email];
}

class AuthFailure extends AuthState {
  final String error;

  const AuthFailure({required this.error});

  @override
  List<Object> get props => [error];
}

// --- BLOC IMPLEMENTATION ---
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
    on<EmailRecognized>(_onEmailRecognized);
    on<PasswordSubmitted>(_onPasswordSubmitted);

    // Listen to Firebase Auth state changes and handle login/logout events
    _authSubscription = _authRepository.authStateChanges.listen((user) {
      if (user != null) {
        add(LoggedIn());
        _logger.i('AuthBloc: User authenticated: ${user.email}');
      } else {
        add(LoggedOut());
        _logger.i('AuthBloc: User unauthenticated.');
      }
    });

    _logger.d('AuthBloc initialized and listening to auth state changes.');
  }

  // --- EVENT HANDLERS ---
  
  // Handle the AppStarted event, determining if the user is authenticated
  Future<void> _onAppStarted(AppStarted event, Emitter<AuthState> emit) async {
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

  // Handle the LoggedIn event, emitting Authenticated state
  Future<void> _onLoggedIn(LoggedIn event, Emitter<AuthState> emit) async {
    final currentUser = _authRepository.getCurrentUser();
    if (currentUser != null) {
      emit(Authenticated(user: currentUser));
      _logger.i('AuthBloc: User logged in. Emitting Authenticated state.');
    }
  }

  // Handle the LoggedOut event, signing the user out and emitting Unauthenticated state
  Future<void> _onLoggedOut(LoggedOut event, Emitter<AuthState> emit) async {
    await _authRepository.signOut();
    emit(Unauthenticated());
    _logger.i('AuthBloc: User logged out. Emitting Unauthenticated state.');
  }

  // Handle the EmailRecognized event, moving to either login or registration based on email status
  Future<void> _onEmailRecognized(EmailRecognized event, Emitter<AuthState> emit) async {
    _logger.i('AuthBloc: Email recognized: ${event.email}');
    // Move to the login state, awaiting password input
    emit(AuthEmailRecognized(email: event.email));
  }

  // Handle Password submission
  Future<void> _onPasswordSubmitted(PasswordSubmitted event, Emitter<AuthState> emit) async {
    _logger.i('AuthBloc: Password submitted for email: ${event.email}');
    try {
      // Try to log the user in
      final user = await _authRepository.signInWithEmail(event.email, event.password);
      if (user != null) {
        emit(Authenticated(user: user));
        _logger.i('AuthBloc: User successfully authenticated.');
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        // If user not found, suggest registration
        emit(AuthRegistration(email: event.email));
        _logger.i('AuthBloc: User not found. Suggesting registration.');
      } else if (e.code == 'wrong-password') {
        emit(const AuthFailure(error: 'Incorrect password. Please try again.'));
        _logger.w('AuthBloc: Incorrect password.');
      } else {
        emit(AuthFailure(error: e.message ?? 'Authentication failed.'));
        _logger.e('AuthBloc: Error: ${e.message}');
      }
    } catch (error) {
      emit(const AuthFailure(error: 'Login failed. Please try again.'));
      _logger.e('AuthBloc: Unknown error during login: $error');
    }
  }

  @override
  Future<void> close() {
    _authSubscription.cancel();
    _logger.d('AuthBloc: Stream subscription canceled.');
    return super.close();
  }
}

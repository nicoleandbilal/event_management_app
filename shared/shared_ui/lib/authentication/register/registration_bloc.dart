import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../repositories/auth_repository.dart';
import '../../../repositories/user_repository.dart'; // Add user repository import
import 'package:logger/logger.dart';

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
  final String firstName;
  final String lastName; // New fields for first and last name
  const RegistrationSubmitted({
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
  });

  @override
  List<Object> get props => [email, password, firstName, lastName];
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
  final UserRepository _userRepository; // Add user repository dependency
  final Logger _logger = Logger(); // Initialize logger

  RegistrationBloc({
    required AuthRepository authRepository,
    required UserRepository userRepository,
  })  : _authRepository = authRepository,
        _userRepository = userRepository,
        super(RegistrationInitial()) {
    // Register event handlers
    on<RegistrationEmailChanged>(_onRegistrationEmailChanged);
    on<RegistrationPasswordChanged>(_onRegistrationPasswordChanged);
    on<RegistrationSubmitted>(_onRegistrationSubmitted);
  }

  void _onRegistrationEmailChanged(
      RegistrationEmailChanged event, Emitter<RegistrationState> emit) {
    _logger.d('RegistrationBloc: Email changed to ${event.email}');
  }

  void _onRegistrationPasswordChanged(
      RegistrationPasswordChanged event, Emitter<RegistrationState> emit) {
    _logger.d('RegistrationBloc: Password changed');
  }

  void _onRegistrationSubmitted(
      RegistrationSubmitted event, Emitter<RegistrationState> emit) async {
    emit(RegistrationLoading());
    _logger.i(
        'RegistrationBloc: RegistrationSubmitted with email: ${event.email}');
    try {
      // Register the user in Firebase Auth
      final user = await _authRepository.registerWithEmail(
          event.email, event.password);
      if (user != null) {
        // Create the user profile in Firestore
        await _userRepository.createUser(
          userId: user.uid,
          email: event.email,
          firstName: event.firstName,
          lastName: event.lastName,
        );

        emit(RegistrationSuccess(user: user));
        _logger.i(
            'RegistrationBloc: RegistrationSuccess emitted for user: ${user.email}');
      } else {
        emit(const RegistrationFailure(
            error: 'Registration failed. Please try again.'));
        _logger.e('RegistrationBloc: Registration failed without exception.');
      }
    } catch (error) {
      String errorMessage = _mapErrorToMessage(error);
      emit(RegistrationFailure(error: errorMessage));
      _logger.e(
          'RegistrationBloc: RegistrationFailure emitted with error: $errorMessage');
    }
  }

  String _mapErrorToMessage(dynamic error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'invalid-email':
          return 'The email address is not valid.';
        case 'email-already-in-use':
          return 'The email address is already in use.';
        case 'weak-password':
          return 'The password is too weak.';
        default:
          return 'Registration failed. Please try again.';
      }
    } else {
      return 'An unknown error occurred.';
    }
  }
}

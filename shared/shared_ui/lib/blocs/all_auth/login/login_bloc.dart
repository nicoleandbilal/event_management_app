import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../repositories/auth_repository.dart';
import 'package:shared/authentication/auth/auth_bloc.dart';

// --- EVENTS ---
abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

class LoginSubmitted extends LoginEvent {
  final String email;
  final String password;
  const LoginSubmitted(this.email, this.password);

  @override
  List<Object> get props => [email, password];
}

// --- STATES ---
abstract class LoginState extends Equatable {
  const LoginState();
  @override
  List<Object> get props => [];
}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final String email;
  const LoginSuccess(this.email);

  @override
  List<Object> get props => [email];
}

class LoginFailure extends LoginState {
  final String error;
  const LoginFailure({required this.error});

  @override
  List<Object> get props => [error];
}

// --- BLOC IMPLEMENTATION ---
class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository _authRepository;
  final AuthBloc _authBloc;

  LoginBloc({required AuthRepository authRepository, required AuthBloc authBloc})
      : _authRepository = authRepository,
        _authBloc = authBloc,
        super(LoginInitial()) {
    on<LoginSubmitted>(_onLoginSubmitted);
  }

  // Handle login submission
  Future<void> _onLoginSubmitted(
      LoginSubmitted event, Emitter<LoginState> emit) async {
    emit(LoginLoading());

    try {
      // Authenticate user with email and password
      final user = await _authRepository.signInWithEmail(
        event.email,
        event.password,
      );

      if (user != null) {
        emit(LoginSuccess(user.email!));
        _authBloc.add(LoggedIn());  // Notify AuthBloc about successful login
      } else {
        emit(const LoginFailure(error: 'Invalid login credentials'));
      }
    } catch (error) {
      emit(LoginFailure(error: 'Login failed: ${error.toString()}'));
    }
  }
}

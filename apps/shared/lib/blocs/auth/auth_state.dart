// lib/blocs/auth/auth_state.dart

import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

// lib/config/auth_guard.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared/blocs/all_auth/auth/auth_bloc.dart';

/// This class helps to protect specific routes based on authentication state.
class AuthGuard {
  static Future<String?> redirectLogic(BuildContext context, GoRouterState state) async {
    final authState = BlocProvider.of<AuthBloc>(context).state;
    final isAuthenticated = authState is Authenticated;

    if (!isAuthenticated && state.uri.toString() != '/login') {
      return '/login';
    }
    if (isAuthenticated && state.uri.toString() == '/login') {
      return '/home';
    }
    return null;
  }
}

// lib/routes/auth_routes.dart

import 'package:go_router/go_router.dart';
import 'package:shared/authentication/screens/registration_screen.dart';
import 'package:shared/authentication/screens/login_screen.dart';
import 'package:shared/authentication/screens/forgot_password_screen.dart';


List<GoRoute> authRoutes = [
  GoRoute(
    path: '/login',
    builder: (context, state) => const LoginScreen(),
  ),
  GoRoute(
    path: '/register',
    builder: (context, state) => const RegistrationScreen(),
  ),
  GoRoute(
    path: '/forgot_password',
    builder: (context, state) => const ForgotPasswordScreen(),
  ),
];
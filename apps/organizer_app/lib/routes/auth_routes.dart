// lib/routes/auth_routes.dart
import 'package:go_router/go_router.dart';
import 'package:organizer_app/screens/auth/login_screen.dart';
import 'package:organizer_app/screens/auth/registration_screen.dart';
import 'package:organizer_app/screens/auth/forgot_password_screen.dart';

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

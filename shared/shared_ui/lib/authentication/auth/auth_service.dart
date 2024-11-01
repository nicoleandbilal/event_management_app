// auth_service.dart

import 'package:shared/repositories/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final AuthRepository _authRepository;

  AuthService(this._authRepository);

  // Get current user's ID if authenticated, or null if not
  String? getCurrentUserId() {
    final user = _authRepository.getCurrentUser();
    return user?.uid;
  }

  // Handle user sign-in and additional actions (e.g., logging, loading profile)
  Future<User?> signIn(String email, String password) async {
    return await _authRepository.signInWithEmail(email, password);
  }

  // Sign out the user and perform any additional cleanup if needed
  Future<void> signOut() async {
    await _authRepository.signOut();
  }
}

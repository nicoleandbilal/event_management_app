// auth_service.dart

import 'package:shared/repositories/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final AuthRepository _authRepository;

  AuthService(this._authRepository);

  /// Retrieves the current authenticated user's ID, or null if not authenticated
  String? getCurrentUserId() {
    final user = _authRepository.getCurrentUser();
    final userId = user?.uid;
    print('Current user ID: $userId');
    return userId;
  }

  /// Signs in the user with email and password, returning the User object if successful
  Future<User?> signIn(String email, String password) async {
    try {
      return await _authRepository.signInWithEmail(email, password);
    } catch (e) {
      print("Error signing in: $e");
      return null; // Return null if sign-in fails
    }
  }

  /// Signs out the user and performs any additional cleanup if needed
  Future<void> signOut() async {
    try {
      await _authRepository.signOut();
    } catch (e) {
      print("Error signing out: $e");
    }
  }
}

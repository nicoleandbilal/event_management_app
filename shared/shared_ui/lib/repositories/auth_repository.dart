import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final Logger _logger = Logger();

  AuthRepository({FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  // Sign in using Email and Password
  Future<User?> signInWithEmail(String email, String password) async {
    try {
      _logger.i('AuthRepository: Attempting to sign in with email: $email');
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      _logger.i('AuthRepository: Sign in successful: ${userCredential.user?.email}');
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      _logger.e('AuthRepository: FirebaseAuthException: ${e.code} - ${e.message}');
      switch (e.code) {
        case 'invalid-email':
          throw Exception('The email address is not valid.');
        case 'user-disabled':
          throw Exception('This user account has been disabled.');
        case 'user-not-found':
          throw Exception('No user found for that email.');
        case 'wrong-password':
          throw Exception('Incorrect password provided.');
        default:
          throw Exception('Authentication failed. Please try again.');
      }
    } catch (e) {
      _logger.e('AuthRepository: Unknown error during sign-in: $e');
      throw Exception('Login failed. Please try again.');
    }
  }

  // Register using Email and Password
  Future<User?> registerWithEmail(String email, String password) async {
    try {
      _logger.i('AuthRepository: Attempting to register with email: $email');
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      _logger.i('AuthRepository: Registration successful: ${userCredential.user?.email}');
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      _logger.e('AuthRepository: FirebaseAuthException: ${e.code} - ${e.message}');
      switch (e.code) {
        case 'email-already-in-use':
          throw Exception('The email is already in use. Please log in instead.');
        case 'invalid-email':
          throw Exception('The email address is not valid.');
        case 'operation-not-allowed':
          throw Exception('This operation is not allowed.');
        case 'weak-password':
          throw Exception('The password provided is too weak.');
        default:
          throw Exception('Registration failed. Please try again.');
      }
    } catch (e) {
      _logger.e('AuthRepository: Unknown error during registration: $e');
      throw Exception('Registration failed. Please try again.');
    }
  }

  // Sign out the user
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    _logger.i('AuthRepository: Sign out successful.');
  }

  // Get the current authenticated user
  User? getCurrentUser() {
    return _firebaseAuth.currentUser;
  }

  // Stream of authentication state changes
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  // Centralized error handling (for reusable handling)
  void _handleFirebaseAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        throw Exception('The email address is not valid.');
      case 'user-disabled':
        throw Exception('This user account has been disabled.');
      case 'user-not-found':
        throw Exception('No user found for that email.');
      case 'wrong-password':
        throw Exception('Incorrect password.');
      default:
        throw Exception('Authentication failed.');
    }
  }
}

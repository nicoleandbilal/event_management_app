import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final Logger _logger = Logger();

  AuthRepository({FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  // Sign In using Email and Password
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
          throw Exception('This user has been disabled.');
        case 'user-not-found':
          throw Exception('No user found for that email.');
        case 'wrong-password':
          throw Exception('Wrong password provided.');
        default:
          throw Exception('Authentication failed. Please try again.');
      }
    } catch (e) {
      _logger.e('AuthRepository: Unknown error: $e');
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
          throw Exception('The email is already in use.');
        case 'invalid-email':
          throw Exception('The email address is not valid.');
        case 'operation-not-allowed':
          throw Exception('Operation not allowed.');
        case 'weak-password':
          throw Exception('The password is too weak.');
        default:
          throw Exception('Registration failed. Please try again.');
      }
    } catch (e) {
      _logger.e('AuthRepository: Unknown error: $e');
      throw Exception('Registration failed. Please try again.');
    }
  }

  // Sign Out
  Future<void> signOut() async {
    try {
      _logger.i('AuthRepository: Signing out user.');
      await _firebaseAuth.signOut();
      _logger.i('AuthRepository: Sign out successful.');
    } catch (e) {
      _logger.e('AuthRepository: Error signing out: $e');
      throw Exception('Sign out failed. Please try again.');
    }
  }

  // Get Current User
  User? getCurrentUser() {
    return _firebaseAuth.currentUser;
  }

  // Stream of Auth State Changes
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();
}

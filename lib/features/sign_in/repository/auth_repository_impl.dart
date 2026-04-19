import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import 'auth_repository.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Future<void> signInWithMagicLink(String email) async {
    // TODO: Implement real Magic Link logic
    await Future.delayed(const Duration(seconds: 2));
    if (email.isEmpty) {
      throw Exception('Email cannot be empty.');
    }
  }

  @override
  Future<void> signInWithPhone(String phone) async {
    // TODO: Implement real Phone Auth logic
    await Future.delayed(const Duration(seconds: 2));
    if (phone.isEmpty) {
      throw Exception('Phone cannot be empty.');
    }
  }

  @override
  Future<void> signInWithPasskey() async {
    await Future.delayed(const Duration(seconds: 2));
  }

  @override
  Future<void> signInWithGoogle() async {
    await Future.delayed(const Duration(seconds: 2));
  }

  @override
  Future<void> signInWithApple() async {
    await Future.delayed(const Duration(seconds: 2));
  }

  @override
  Future<void> signInAsGuest() async {
    try {
      await _firebaseAuth.signInAnonymously();
    } catch (e) {
      throw Exception('Failed to sign in anonymously: ${e.toString()}');
    }
  }
}

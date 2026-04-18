import 'package:injectable/injectable.dart';
import 'auth_repository.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  @override
  Future<void> signInWithMagicLink(String email) async {
    await Future.delayed(const Duration(seconds: 2));
    if (email.isEmpty) {
      throw Exception('Email cannot be empty.');
    }
  }

  @override
  Future<void> signInWithPhone(String phone) async {
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
    await Future.delayed(const Duration(seconds: 1));
  }
}

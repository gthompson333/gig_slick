import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthRepository {
  Future<void> signInWithMagicLink(String email);
  Future<void> verifyPhoneNumber(
    String phoneNumber, {
    required void Function(String verificationId) onCodeSent,
    required void Function(String error) onError,
  });
  Future<UserCredential> signInWithOtp(String verificationId, String smsCode);
  Future<UserCredential> linkWithOtp(String verificationId, String smsCode);
  Future<void> signInAsGuest();
  Future<void> signOut();
}

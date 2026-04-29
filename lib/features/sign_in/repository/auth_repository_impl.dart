import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'auth_repository.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Future<void> verifyPhoneNumber(
    String phoneNumber, {
    required void Function(String verificationId) onCodeSent,
    required void Function(String error) onError,
    required void Function() onVerificationCompleted,
  }) async {
    debugPrint('AuthRepository: Starting phone verification for $phoneNumber');
    
    // Tweak: For iOS, silent auth relies on APNs token. 
    // Sometimes it takes a moment to be registered.
    try {
      final apnsToken = await FirebaseMessaging.instance.getAPNSToken();
      if (apnsToken != null) {
        debugPrint('AuthRepository: APNs token is present: ${apnsToken.substring(0, 8)}...');
      } else {
        debugPrint('AuthRepository: WARNING - APNs token is NULL. Silent auth might fail/flicker.');
        // Briefly wait to see if it arrives? 
        // Some developers report that a small delay helps if the app just started.
        await Future.delayed(const Duration(milliseconds: 500));
        final retryToken = await FirebaseMessaging.instance.getAPNSToken();
        if (retryToken != null) {
          debugPrint('AuthRepository: APNs token arrived after delay.');
        }
      }
    } catch (e) {
      debugPrint('AuthRepository: Error checking APNs token: $e');
    }

    try {
      await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: const Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential credential) async {
          debugPrint('AuthRepository: Verification completed automatically (Silent Flow Success)');
          try {
            await _firebaseAuth.signInWithCredential(credential);
            onVerificationCompleted();
          } catch (e) {
            debugPrint('AuthRepository: Error during auto-sign-in: $e');
            onError(e.toString());
          }
        },
        verificationFailed: (FirebaseAuthException e) {
          debugPrint('AuthRepository: Verification failed: [${e.code}] ${e.message}');
          if (e.code == 'too-many-requests') {
            onError('Too many requests. Please try again later.');
          } else {
            onError(e.message ?? 'Verification failed');
          }
        },
        codeSent: (String verificationId, int? resendToken) {
          debugPrint('AuthRepository: Code sent. VerificationId: $verificationId');
          onCodeSent(verificationId);
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          debugPrint('AuthRepository: Code auto-retrieval timed out for $verificationId');
        },
      );
    } catch (e) {
      debugPrint('AuthRepository: Unexpected error during verifyPhoneNumber: $e');
      onError(e.toString());
    }
  }

  @override
  Future<UserCredential> signInWithOtp(
    String verificationId,
    String smsCode,
  ) async {
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );
      return await _firebaseAuth.signInWithCredential(credential);
    } on FirebaseAuthException {
      rethrow;
    } catch (e) {
      throw Exception('Failed to sign in with OTP: ${e.toString()}');
    }
  }

  @override
  Future<UserCredential> linkWithOtp(
    String verificationId,
    String smsCode,
  ) async {
    final user = _firebaseAuth.currentUser;
    if (user == null) {
      throw Exception('No user currently signed in to link.');
    }

    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );
      return await user.linkWithCredential(credential);
    } on FirebaseAuthException {
      rethrow;
    } catch (e) {
      throw Exception('Failed to link phone number: ${e.toString()}');
    }
  }

  @override
  Future<void> signInAsGuest() async {
    try {
      await _firebaseAuth.signInAnonymously();
    } on FirebaseAuthException {
      rethrow;
    } catch (e) {
      throw Exception('Failed to sign in anonymously: ${e.toString()}');
    }
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  // Placeholders for other interface methods if needed, or remove from interface if unused
  @override
  Future<void> signInWithMagicLink(String email) async {
    try {
      await _firebaseAuth.sendSignInLinkToEmail(
        email: email,
        actionCodeSettings: ActionCodeSettings(
          url: 'https://gig-slick-2026-auth.firebaseapp.com',
          handleCodeInApp: true,
          androidPackageName: 'com.example.gig_slick',
          androidInstallApp: true,
          androidMinimumVersion: '1',
          iOSBundleId: 'com.tommysoftware.gigslick',
        ),
      );
    } on FirebaseAuthException {
      rethrow;
    } catch (e) {
      throw Exception('Failed to send magic link: ${e.toString()}');
    }
  }
}

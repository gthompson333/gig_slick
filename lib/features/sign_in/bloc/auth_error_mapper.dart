import 'package:firebase_auth/firebase_auth.dart';

class AuthErrorMapper {
  static String mapMessage(dynamic error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'invalid-phone-number':
          return 'The phone number entered is invalid. Please check the number and try again.';
        case 'too-many-requests':
          return 'We have blocked all requests from this device due to unusual activity. Please try again later.';
        case 'invalid-verification-code':
          return 'The SMS code entered is incorrect. Please try again.';
        case 'expired-verification-code':
          return 'The SMS code has expired. Please request a new one.';
        case 'quota-exceeded':
          return 'We have reached our SMS limit for now. Please try again later.';
        case 'captcha-check-failed':
          return 'Verification failed. Please try again.';
        case 'user-disabled':
          return 'This account has been disabled. Please contact support.';
        case 'operation-not-allowed':
          return 'Phone authentication is not enabled. Please contact support.';
        case 'network-request-failed':
          return 'Network error. Please check your internet connection.';
        default:
          return error.message ??
              'An unexpected authentication error occurred.';
      }
    }

    final errorString = error.toString();
    if (errorString.contains('invalid-phone-number')) {
      return 'The phone number entered is invalid. Please check the number and try again.';
    }

    return 'Something went wrong. Please try again.';
  }
}

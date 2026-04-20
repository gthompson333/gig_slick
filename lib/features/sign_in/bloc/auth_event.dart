import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object> get props => [];
}

class PhoneLoginRequested extends AuthEvent {
  final String phoneNumber;
  const PhoneLoginRequested(this.phoneNumber);
  @override
  List<Object> get props => [phoneNumber];
}

class OtpSubmitted extends AuthEvent {
  final String verificationId;
  final String smsCode;
  const OtpSubmitted(this.verificationId, this.smsCode);
  @override
  List<Object> get props => [verificationId, smsCode];
}

class SignInAsGuestRequested extends AuthEvent {}

class LinkPhoneRequested extends AuthEvent {
  final String phoneNumber;
  const LinkPhoneRequested(this.phoneNumber);
  @override
  List<Object> get props => [phoneNumber];
}

class LinkOtpSubmitted extends AuthEvent {
  final String verificationId;
  final String smsCode;
  const LinkOtpSubmitted(this.verificationId, this.smsCode);
  @override
  List<Object> get props => [verificationId, smsCode];
}

class AuthErrorOccurred extends AuthEvent {
  final String message;
  const AuthErrorOccurred(this.message);
  @override
  List<Object> get props => [message];
}

class AuthVerificationCompleted extends AuthEvent {}

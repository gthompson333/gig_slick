import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object> get props => [];
}

class SubmitEmailOrPhoneRequested extends AuthEvent {
  final String input;
  const SubmitEmailOrPhoneRequested(this.input);
  @override
  List<Object> get props => [input];
}

class SignInWithPasskeyRequested extends AuthEvent {}

class SignInWithGoogleRequested extends AuthEvent {}
class SignInWithAppleRequested extends AuthEvent {}
class SignInAsGuestRequested extends AuthEvent {}

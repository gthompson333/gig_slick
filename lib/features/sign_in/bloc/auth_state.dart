import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {
  const AuthState();
  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}
class AuthLoading extends AuthState {}
class AuthAuthenticated extends AuthState {
  final String method;
  final bool hasVenue;

  const AuthAuthenticated(this.method, {this.hasVenue = false});

  @override
  List<Object> get props => [method, hasVenue];
}
class AuthOtpSent extends AuthState {
  final String verificationId;
  final String phoneNumber;

  const AuthOtpSent(this.verificationId, this.phoneNumber);

  @override
  List<Object> get props => [verificationId, phoneNumber];
}

class AuthLinkOtpSent extends AuthState {
  final String verificationId;
  final String phoneNumber;

  const AuthLinkOtpSent(this.verificationId, this.phoneNumber);

  @override
  List<Object> get props => [verificationId, phoneNumber];
}
class AuthUnauthenticated extends AuthState {}
class AuthError extends AuthState {
  final String message;
  const AuthError(this.message);
  @override
  List<Object> get props => [message];
}

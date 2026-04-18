import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'auth_event.dart';
import 'auth_state.dart';
import '../repository/auth_repository.dart';

@injectable
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;

  AuthBloc(this._authRepository) : super(AuthInitial()) {
    on<SubmitEmailOrPhoneRequested>(_onSubmitEmailOrPhone);
    on<SignInWithPasskeyRequested>(_onSignInWithPasskey);
    on<SignInWithGoogleRequested>(_onSignInWithGoogle);
    on<SignInWithAppleRequested>(_onSignInWithApple);
    on<SignInAsGuestRequested>(_onSignInAsGuest);
  }

  Future<void> _onSubmitEmailOrPhone(
      SubmitEmailOrPhoneRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final input = event.input.trim();
      final isEmail = RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(input);
      if (isEmail) {
        await _authRepository.signInWithMagicLink(input);
        emit(const AuthAuthenticated('magic_link'));
      } else {
        await _authRepository.signInWithPhone(input);
        emit(const AuthAuthenticated('phone'));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
      emit(AuthUnauthenticated());
    }
  }

  Future<void> _onSignInWithPasskey(
      SignInWithPasskeyRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await _authRepository.signInWithPasskey();
      emit(const AuthAuthenticated('passkey'));
    } catch (e) {
      emit(AuthError(e.toString()));
      emit(AuthUnauthenticated());
    }
  }

  Future<void> _onSignInWithGoogle(
      SignInWithGoogleRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await _authRepository.signInWithGoogle();
      emit(const AuthAuthenticated('google'));
    } catch (e) {
      emit(AuthError(e.toString()));
      emit(AuthUnauthenticated());
    }
  }

  Future<void> _onSignInWithApple(
      SignInWithAppleRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await _authRepository.signInWithApple();
      emit(const AuthAuthenticated('apple'));
    } catch (e) {
      emit(AuthError(e.toString()));
      emit(AuthUnauthenticated());
    }
  }

  Future<void> _onSignInAsGuest(
      SignInAsGuestRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await _authRepository.signInAsGuest();
      emit(const AuthAuthenticated('guest'));
    } catch (e) {
      emit(AuthError(e.toString()));
      emit(AuthUnauthenticated());
    }
  }
}

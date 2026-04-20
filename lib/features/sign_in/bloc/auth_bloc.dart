import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'auth_event.dart';
import 'auth_state.dart';
import '../repository/auth_repository.dart';
import '../../dashboard/data/repositories/dashboard_repository.dart';

@injectable
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  final DashboardRepository _dashboardRepository;

  AuthBloc(this._authRepository, this._dashboardRepository) : super(AuthInitial()) {
    on<PhoneLoginRequested>(_onPhoneLoginRequested);
    on<OtpSubmitted>(_onOtpSubmitted);
    on<SignInAsGuestRequested>(_onSignInAsGuest);
    on<LinkPhoneRequested>(_onLinkPhoneRequested);
    on<LinkOtpSubmitted>(_onLinkOtpSubmitted);
    on<AuthErrorOccurred>(_onAuthErrorOccurred);
    on<AuthVerificationCompleted>(_onAuthVerificationCompleted);
    on<_AuthOtpSentInternal>(_onOtpSentInternal);
  }

  Future<void> _onPhoneLoginRequested(
    PhoneLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await _authRepository.verifyPhoneNumber(
        event.phoneNumber,
        onCodeSent: (verificationId) {
          add(_AuthOtpSentInternal(
            verificationId: verificationId,
            phoneNumber: event.phoneNumber,
            isLinking: false,
          ));
        },
        onError: (error) {
          add(AuthErrorOccurred(error));
        },
      );
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onLinkPhoneRequested(
    LinkPhoneRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await _authRepository.verifyPhoneNumber(
        event.phoneNumber,
        onCodeSent: (verificationId) {
          add(_AuthOtpSentInternal(
            verificationId: verificationId,
            phoneNumber: event.phoneNumber,
            isLinking: true,
          ));
        },
        onError: (message) {
          add(AuthErrorOccurred(message));
        },
      );
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onLinkOtpSubmitted(
    LinkOtpSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await _authRepository.linkWithOtp(event.verificationId, event.smsCode);
      // After linking, we definitely have a venue because that's the only way to get to the secure page
      emit(const AuthAuthenticated('phone_link', hasVenue: true));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  void _onOtpSentInternal(
    _AuthOtpSentInternal event,
    Emitter<AuthState> emit,
  ) {
    if (event.isLinking) {
      emit(AuthLinkOtpSent(event.verificationId, event.phoneNumber));
    } else {
      emit(AuthOtpSent(event.verificationId, event.phoneNumber));
    }
  }

  Future<void> _onOtpSubmitted(
    OtpSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await _authRepository.signInWithOtp(event.verificationId, event.smsCode);
      final venue = await _dashboardRepository.getVenueForUser();
      emit(AuthAuthenticated('phone', hasVenue: venue != null));
    } catch (e) {
      emit(AuthError(e.toString()));
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
    }
  }

  void _onAuthErrorOccurred(AuthErrorOccurred event, Emitter<AuthState> emit) {
    emit(AuthError(event.message));
  }

  Future<void> _onAuthVerificationCompleted(
      AuthVerificationCompleted event, Emitter<AuthState> emit) async {
    final venue = await _dashboardRepository.getVenueForUser();
    emit(AuthAuthenticated('phone_auto', hasVenue: venue != null));
  }
}

// Internal event for state transition
class _AuthOtpSentInternal extends AuthEvent {
  final String verificationId;
  final String phoneNumber;
  final bool isLinking;

  const _AuthOtpSentInternal({
    required this.verificationId,
    required this.phoneNumber,
    required this.isLinking,
  });

  @override
  List<Object> get props => [verificationId, phoneNumber, isLinking];
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpt_ojt/features/auth/presentation/blocs/forgot_password/forgot_password_event.dart';
import 'package:fpt_ojt/features/auth/presentation/blocs/forgot_password/forgot_password_state.dart';

class ForgotPasswordBloc extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {

  ForgotPasswordBloc() : super(ForgotPasswordInitial()) {
    on<SendResetCodeRequested>(_onSendResetCodeRequested);
    on<VerifyOtpRequested>(_onVerifyOtpRequested);
    on<ResetPasswordRequested>(_onResetPasswordRequested);
    on<ResetForgotPasswordFlow>(_onResetForgotPasswordFlow);
  }
  String? _email;
  String? _otp;

  Future<void> _onSendResetCodeRequested(
    SendResetCodeRequested event,
    Emitter<ForgotPasswordState> emit,
  ) async {
    emit(SendingResetCode());

    try {
      // TODO: Call your API to send reset code
      // await authRepository.sendResetCode(event.email);
      
      // Simulate API call
      await Future<void>.delayed(const Duration(seconds: 2));

      _email = event.email;
      emit(ResetCodeSent(email: event.email));
    } catch (e) {
      emit(SendResetCodeFailure(message: e.toString()));
    }
  }

  Future<void> _onVerifyOtpRequested(
    VerifyOtpRequested event,
    Emitter<ForgotPasswordState> emit,
  ) async {
    if (_email == null) {
      emit(SendResetCodeFailure(message: 'Email not found'));
      return;
    }

    emit(VerifyingOtp(email: _email!));

    try {
      // TODO: Call your API to verify OTP
      // await authRepository.verifyOtp(_email!, event.otp);
      
      // Simulate API call
      await Future<void>.delayed(const Duration(seconds: 2));

      _otp = event.otp;
      emit(OtpVerified(email: _email!, otp: event.otp));
    } catch (e) {
      emit(OtpVerificationFailure(email: _email!, message: e.toString()));
    }
  }

  Future<void> _onResetPasswordRequested(
    ResetPasswordRequested event,
    Emitter<ForgotPasswordState> emit,
  ) async {
    if (_email == null || _otp == null) {
      emit(PasswordResetFailure(message: 'Missing email or OTP'));
      return;
    }

    emit(ResettingPassword());

    try {
      // TODO: Call your API to reset password
      // await authRepository.resetPassword(_email!, _otp!, event.newPassword);
      
      // Simulate API call
      await Future<void>.delayed(const Duration(seconds: 2));

      emit(PasswordResetSuccess());
      
      // Reset internal state
      _email = null;
      _otp = null;
    } catch (e) {
      emit(PasswordResetFailure(message: e.toString()));
    }
  }

  Future<void> _onResetForgotPasswordFlow(
    ResetForgotPasswordFlow event,
    Emitter<ForgotPasswordState> emit,
  ) async {
    _email = null;
    _otp = null;
    emit(ForgotPasswordInitial());
  }
}

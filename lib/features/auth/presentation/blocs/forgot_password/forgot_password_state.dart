import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

@immutable
sealed class ForgotPasswordState extends Equatable {
  const ForgotPasswordState();
  @override
  List<Object?> get props => [];
}

@immutable
class ForgotPasswordInitial extends ForgotPasswordState {
  const ForgotPasswordInitial();
  @override
  List<Object?> get props => [];
}

// Email Step States
@immutable
class SendingResetCode extends ForgotPasswordState {
  const SendingResetCode();
  @override
  List<Object?> get props => [];
}

@immutable
class ResetCodeSent extends ForgotPasswordState {
  const ResetCodeSent({required this.email});
  final String email;
  @override
  List<Object?> get props => [email];
}

@immutable
class SendResetCodeFailure extends ForgotPasswordState {
  const SendResetCodeFailure({required this.message});
  final String message;
  @override
  List<Object?> get props => [message];
}

// OTP Verification States
@immutable
class VerifyingOtp extends ForgotPasswordState {
  const VerifyingOtp({required this.email});
  final String email;
  @override
  List<Object?> get props => [email];
}

@immutable
class OtpVerified extends ForgotPasswordState {
  const OtpVerified({required this.email, required this.otp});
  final String email;
  final String otp;
  @override
  List<Object?> get props => [email, otp];
}

@immutable
class OtpVerificationFailure extends ForgotPasswordState {
  const OtpVerificationFailure({required this.email, required this.message});
  final String email;
  final String message;
  @override
  List<Object?> get props => [email, message];
}

// Reset Password States
@immutable
class ResettingPassword extends ForgotPasswordState {
  const ResettingPassword();
  @override
  List<Object?> get props => [];
}

@immutable
class PasswordResetSuccess extends ForgotPasswordState {
  const PasswordResetSuccess();
  @override
  List<Object?> get props => [];
}

@immutable
class PasswordResetFailure extends ForgotPasswordState {
  const PasswordResetFailure({required this.message});
  final String message;
  @override
  List<Object?> get props => [message];
}

sealed class ForgotPasswordEvent {}

class SendResetCodeRequested extends ForgotPasswordEvent {
  SendResetCodeRequested({required this.email});
  final String email;
}

class VerifyOtpRequested extends ForgotPasswordEvent {
  VerifyOtpRequested({required this.otp});
  final String otp;
}

class ResetPasswordRequested extends ForgotPasswordEvent {
  ResetPasswordRequested({required this.newPassword});
  final String newPassword;
}

class ResetForgotPasswordFlow extends ForgotPasswordEvent {}

sealed class ForgotPasswordState {}

class ForgotPasswordInitial extends ForgotPasswordState {}

// Email Step States
class SendingResetCode extends ForgotPasswordState {}

class ResetCodeSent extends ForgotPasswordState {

  ResetCodeSent({required this.email});
  final String email;
}

class SendResetCodeFailure extends ForgotPasswordState {

  SendResetCodeFailure({required this.message});
  final String message;
}

// OTP Verification States
class VerifyingOtp extends ForgotPasswordState {

  VerifyingOtp({required this.email});
  final String email;
}

class OtpVerified extends ForgotPasswordState {

  OtpVerified({required this.email, required this.otp});
  final String email;
  final String otp;
}

class OtpVerificationFailure extends ForgotPasswordState {

  OtpVerificationFailure({required this.email, required this.message});
  final String email;
  final String message;
}

// Reset Password States
class ResettingPassword extends ForgotPasswordState {}

class PasswordResetSuccess extends ForgotPasswordState {}

class PasswordResetFailure extends ForgotPasswordState {

  PasswordResetFailure({required this.message});
  final String message;
}

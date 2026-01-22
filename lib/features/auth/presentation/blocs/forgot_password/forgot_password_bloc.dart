import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpt_ojt/features/auth/domain/usecases/forgot_password.dart';
import 'package:fpt_ojt/features/auth/domain/usecases/reset_password.dart';
import 'package:fpt_ojt/features/auth/presentation/blocs/forgot_password/forgot_password_event.dart';
import 'package:fpt_ojt/features/auth/presentation/blocs/forgot_password/forgot_password_state.dart';

class ForgotPasswordBloc
    extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  ForgotPasswordBloc({
    required ForgotPasswordUseCase forgotPasswordUseCase,
    required ResetPasswordUseCase resetPasswordUseCase,
  }) : _forgotPasswordUseCase = forgotPasswordUseCase,
       _resetPasswordUseCase = resetPasswordUseCase,
       super(ForgotPasswordInitial()) {
    on<SendResetCodeRequested>(_onSendResetCodeRequested);
    on<VerifyOtpRequested>(_onVerifyOtpRequested);
    on<ResetPasswordRequested>(_onResetPasswordRequested);
    on<ResetForgotPasswordFlow>(_onResetForgotPasswordFlow);
  }
  final ForgotPasswordUseCase _forgotPasswordUseCase;
  final ResetPasswordUseCase _resetPasswordUseCase;
  String? _email;
  String? _otp;

  Future<void> _onSendResetCodeRequested(
    SendResetCodeRequested event,
    Emitter<ForgotPasswordState> emit,
  ) async {
    emit(SendingResetCode());

    final result = await _forgotPasswordUseCase.call(
      ForgotPasswordParams(email: event.email),
    );
    result.fold(
      (failure) => emit(SendResetCodeFailure(message: failure.message)),
      (user) {
        emit(ResetCodeSent(email: event.email));
        _email = event.email;
      },
    );
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
      await Future<void>.delayed(const Duration(seconds: 1));

      _otp = event.otp;
      emit(OtpVerified(email: _email!, otp: event.otp));
    } on Exception catch (e) {
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

    final result = await _resetPasswordUseCase.call(
      ResetPasswordParams(
        email: _email!,
        otp: _otp!,
        newPassword: event.newPassword,
      ),
    );
    result.fold(
      (failure) => emit(PasswordResetFailure(message: failure.message)),
      (user) {
        emit(PasswordResetSuccess());
        _email = null;
        _otp = null;
      },
    );
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

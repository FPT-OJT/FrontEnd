import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpt_ojt/core/theme/app_colors.dart';
import 'package:fpt_ojt/core/theme/ui_gaps.dart';
import 'package:fpt_ojt/features/auth/presentation/blocs/forgot_password/forgot_password_bloc.dart';
import 'package:fpt_ojt/features/auth/presentation/blocs/forgot_password/forgot_password_event.dart';
import 'package:fpt_ojt/features/auth/presentation/blocs/forgot_password/forgot_password_state.dart';
import 'package:fpt_ojt/features/auth/presentation/constants/forgot_password.dart';
import 'package:fpt_ojt/features/auth/presentation/widgets/forgot_password/forgot_password_email_step.dart';
import 'package:fpt_ojt/features/auth/presentation/widgets/forgot_password/forgot_password_header.dart';
import 'package:fpt_ojt/features/auth/presentation/widgets/forgot_password/forgot_password_otp_step.dart';
import 'package:fpt_ojt/features/auth/presentation/widgets/forgot_password/forgot_password_reset_step.dart';
import 'package:fpt_ojt/features/shared/utils/snackbar_utils.dart';

class ForgotPasswordBottomSheet extends StatefulWidget {
  const ForgotPasswordBottomSheet({super.key});

  @override
  State<ForgotPasswordBottomSheet> createState() =>
      _ForgotPasswordBottomSheetState();
}

class _ForgotPasswordBottomSheetState extends State<ForgotPasswordBottomSheet> {
  final _emailFormKey = GlobalKey<FormState>();
  final _otpFormKey = GlobalKey<FormState>();
  final _passwordFormKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _otpController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _otpController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocConsumer<ForgotPasswordBloc, ForgotPasswordState>(
      listener: (context, state) {
        if (state is SendResetCodeFailure) {
          SnackBarUtils.showError(context, state.message);
        } else if (state is OtpVerificationFailure) {
          SnackBarUtils.showError(context, state.message);
        } else if (state is PasswordResetFailure) {
          SnackBarUtils.showError(context, state.message);
        } else if (state is PasswordResetSuccess) {
          SnackBarUtils.showSuccess(
            context,
            ForgotPasswordConstants.passwordResetSuccessMessage,
          );
          Navigator.of(context).pop();
        }
      },
      builder: (context, state) => DecoratedBox(
        decoration: const BoxDecoration(
          color: AppColors.neutralEggShell20,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
              left: 24,
              right: 24,
              top: 24,
              bottom: MediaQuery.of(context).viewInsets.bottom + 24,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildHeader(theme),
                  UIGaps.h24,
                  _buildContent(state, theme),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) => const ForgotPasswordHeader();

  Widget _buildContent(ForgotPasswordState state, ThemeData theme) {
    if (state is ResetCodeSent ||
        state is VerifyingOtp ||
        state is OtpVerificationFailure) {
      return _buildOtpStep(state, theme);
    } else if (state is OtpVerified || state is ResettingPassword) {
      return _buildResetPasswordStep(state, theme);
    } else {
      return _buildEmailStep(state, theme);
    }
  }

  Widget _buildEmailStep(ForgotPasswordState state, ThemeData theme) {
    final isLoading = state is SendingResetCode;

    return ForgotPasswordEmailStep(
      formKey: _emailFormKey,
      emailController: _emailController,
      isLoading: isLoading,
      onSendCode: _handleSendResetCode,
    );
  }

  Widget _buildOtpStep(ForgotPasswordState state, ThemeData theme) {
    final isLoading = state is VerifyingOtp;
    final email = state is ResetCodeSent
        ? state.email
        : state is VerifyingOtp
        ? state.email
        : state is OtpVerificationFailure
        ? state.email
        : '';

    return ForgotPasswordOtpStep(
      formKey: _otpFormKey,
      otpController: _otpController,
      email: email,
      isLoading: isLoading,
      onVerifyOtp: _handleVerifyOtp,
    );
  }

  Widget _buildResetPasswordStep(ForgotPasswordState state, ThemeData theme) {
    final isLoading = state is ResettingPassword;

    return ForgotPasswordResetStep(
      formKey: _passwordFormKey,
      newPasswordController: _newPasswordController,
      confirmPasswordController: _confirmPasswordController,
      isLoading: isLoading,
      onResetPassword: _handleResetPassword,
    );
  }

  void _handleSendResetCode() {
    if (_emailFormKey.currentState?.validate() ?? false) {
      context.read<ForgotPasswordBloc>().add(
        SendResetCodeRequested(email: _emailController.text.trim()),
      );
    }
  }

  void _handleVerifyOtp() {
    if (_otpFormKey.currentState?.validate() ?? false) {
      context.read<ForgotPasswordBloc>().add(
        VerifyOtpRequested(otp: _otpController.text),
      );
    }
  }

  void _handleResetPassword() {
    if (_passwordFormKey.currentState?.validate() ?? false) {
      context.read<ForgotPasswordBloc>().add(
        ResetPasswordRequested(newPassword: _newPasswordController.text),
      );
    }
  }
}

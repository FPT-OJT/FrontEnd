import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpt_ojt/core/theme/app_colors.dart';
import 'package:fpt_ojt/core/theme/app_text_styles.dart';
import 'package:fpt_ojt/features/auth/presentation/blocs/forgot_password/forgot_password_bloc.dart';
import 'package:fpt_ojt/features/auth/presentation/blocs/forgot_password/forgot_password_event.dart';
import 'package:fpt_ojt/features/auth/presentation/blocs/forgot_password/forgot_password_state.dart';
import 'package:fpt_ojt/features/auth/presentation/widgets/custom_text_field.dart';
import 'package:fpt_ojt/features/auth/presentation/widgets/password_text_field.dart';
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
            'Password reset successfully! Please login with your new password.',
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
                  const SizedBox(height: 24),
                  _buildContent(state, theme),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Container(
        width: 80,
        height: 3,
        decoration: BoxDecoration(
          color: const Color(0xFFC2C5CD),
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    ],
  );

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

    return Form(
      key: _emailFormKey,
      child: Column(
        spacing: 16,
        children: [
          Text('Don’t remember your password?', style: AppTextStyles.h3),
          Text(
            'Please provide your e-mail address, if we have it in our system we will send you the link to reset your password. ',
            style: AppTextStyles.bodySmall,
          ),
          CustomTextField(
            label: 'Email',
            controller: _emailController,
            validator: _validateEmail,
            keyboardType: TextInputType.emailAddress,
            enabled: !isLoading,
          ),
          SizedBox(
            height: 48,
            width: double.infinity,
            child: ElevatedButton(
              onPressed: isLoading ? null : _handleSendResetCode,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.secondaryCoral,
                foregroundColor: AppColors.neutralEggShell20,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
                disabledBackgroundColor: AppColors.secondaryCoral.withAlpha(
                  135,
                ),
              ),
              child: isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.neutralWhite,
                        ),
                      ),
                    )
                  : Text(
                      'Send Reset Code',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: AppColors.neutralWhite,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
            ),
          ),
        ],
      ),
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

    return Form(
      key: _otpFormKey,
      child: Column(
        spacing: 16,
        children: [
          Text('Please check your email', style: AppTextStyles.h3),
          Column(
            children: [
              Text(
                'We sent you a reset code to the following address:',
                style: AppTextStyles.bodySmall,
                textAlign: TextAlign.center,
              ),
              Text(
                email,
                style: AppTextStyles.bodySmall.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),

          TextFormField(
            controller: _otpController,
            validator: _validateOtp,
            keyboardType: TextInputType.number,
            enabled: !isLoading,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(6),
            ],
            maxLength: 6,
            textAlign: TextAlign.center,
            style: theme.textTheme.headlineSmall?.copyWith(
              letterSpacing: 8,
              fontWeight: FontWeight.bold,
            ),
            decoration: InputDecoration(
              labelText: 'Enter 6-digit OTP',
              counterText: '',
              filled: true,
              fillColor: Colors.transparent,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.neutralGrey),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.neutralGrey),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: AppColors.secondaryCoral,
                  width: 2,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.notifyError),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: AppColors.notifyError,
                  width: 2,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 48,
            width: double.infinity,
            child: ElevatedButton(
              onPressed: isLoading ? null : _handleVerifyOtp,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.secondaryCoral,
                foregroundColor: AppColors.neutralWhite,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
                disabledBackgroundColor: AppColors.secondaryCoral.withAlpha(
                  135,
                ),
              ),
              child: isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.neutralWhite,
                        ),
                      ),
                    )
                  : Text(
                      'Verify OTP',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: AppColors.neutralWhite,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResetPasswordStep(ForgotPasswordState state, ThemeData theme) {
    final isLoading = state is ResettingPassword;

    return Form(
      key: _passwordFormKey,
      child: Column(
        spacing: 16,
        children: [
          Text('Please enter your new password', style: AppTextStyles.h3),
          PasswordTextField(
            label: 'New Password',
            controller: _newPasswordController,
            validator: _validateNewPassword,
            enabled: !isLoading,
          ),
          PasswordTextField(
            label: 'Confirm Password',
            controller: _confirmPasswordController,
            validator: _validateConfirmPassword,
            enabled: !isLoading,
          ),
          SizedBox(
            height: 48,
            width: double.infinity,
            child: ElevatedButton(
              onPressed: isLoading ? null : _handleResetPassword,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.secondaryCoral,
                foregroundColor: AppColors.neutralWhite,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
                disabledBackgroundColor: AppColors.secondaryCoral.withAlpha(
                  135,
                ),
              ),
              child: isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.neutralWhite,
                        ),
                      ),
                    )
                  : Text(
                      'Reset Password',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: AppColors.neutralWhite,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
            ),
          ),
        ],
      ),
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

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? _validateOtp(String? value) {
    if (value == null || value.isEmpty) {
      return 'OTP is required';
    }
    if (value.length != 6) {
      return 'OTP must be 6 digits';
    }
    return null;
  }

  String? _validateNewPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != _newPasswordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }
}

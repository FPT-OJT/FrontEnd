import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpt_ojt/core/theme/app_colors.dart';
import 'package:fpt_ojt/core/theme/app_text_styles.dart';
import 'package:fpt_ojt/core/theme/rounded.dart';
import 'package:fpt_ojt/core/theme/ui_gaps.dart';
import 'package:fpt_ojt/core/utils/validators.dart';
import 'package:fpt_ojt/features/auth/presentation/blocs/forgot_password/forgot_password_bloc.dart';
import 'package:fpt_ojt/features/auth/presentation/blocs/forgot_password/forgot_password_event.dart';
import 'package:fpt_ojt/features/auth/presentation/blocs/forgot_password/forgot_password_state.dart';
import 'package:fpt_ojt/features/auth/presentation/constants/forgot_password.dart';
import 'package:fpt_ojt/features/auth/presentation/constants/validations.dart';
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
          Text(
            ForgotPasswordConstants.dontRememberPasswordText,
            style: AppTextStyles.h3,
          ),
          Text(
            ForgotPasswordConstants.pleaseProvideEmailText,
            style: AppTextStyles.bodySmall,
          ),
          CustomTextField(
            label: ForgotPasswordConstants.emailLabel,
            controller: _emailController,
            validator: Validators.compose([
              Validators.required(
                message: ValidationsConstants.emailRequiredError,
              ),
              Validators.email(message: ValidationsConstants.emailInvalidError),
            ]),
            keyboardType: TextInputType.emailAddress,
            enabled: !isLoading,
          ),
          SizedBox(
            height: UIGaps.gap48,
            width: double.infinity,
            child: ElevatedButton(
              onPressed: isLoading ? null : _handleSendResetCode,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.secondaryCoral,
                foregroundColor: AppColors.neutralEggShell20,
                shape: RoundedRectangleBorder(borderRadius: Rounded.md),
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
                      ForgotPasswordConstants.sendResetCodeText,
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
          Text(
            ForgotPasswordConstants.pleaseCheckYourEmailText,
            style: AppTextStyles.h3,
          ),
          Column(
            children: [
              Text(
                ForgotPasswordConstants
                    .weSentYouAResetCodeToTheFollowingAddressText,
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
            validator: Validators.compose([
              Validators.required(
                message: ValidationsConstants.otpRequiredError,
              ),
              Validators.minLen(
                ValidationsConstants.otpMinLength,
                message: ValidationsConstants.otpInvalidError,
              ),
              Validators.maxLen(
                ValidationsConstants.otpMaxLength,
                message: ValidationsConstants.otpInvalidError,
              ),
            ]),
            keyboardType: TextInputType.number,
            enabled: !isLoading,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(
                ValidationsConstants.otpMaxLength,
              ),
            ],
            maxLength: ValidationsConstants.otpMaxLength,
            textAlign: TextAlign.center,
            style: theme.textTheme.headlineSmall?.copyWith(
              letterSpacing: 8,
              fontWeight: FontWeight.bold,
            ),
            decoration: InputDecoration(
              labelText: ForgotPasswordConstants.enter6DigitOTPText,
              counterText: '',
              filled: true,
              fillColor: Colors.transparent,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              border: OutlineInputBorder(
                borderRadius: Rounded.md,
                borderSide: const BorderSide(color: AppColors.neutralGrey),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: Rounded.md,
                borderSide: const BorderSide(color: AppColors.neutralGrey),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: Rounded.md,
                borderSide: const BorderSide(
                  color: AppColors.secondaryCoral,
                  width: 2,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: Rounded.md,
                borderSide: const BorderSide(color: AppColors.notifyError),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: Rounded.md,
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
                shape: RoundedRectangleBorder(borderRadius: Rounded.md),
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
                      ForgotPasswordConstants.verifyOTPText,
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
          Text(
            ForgotPasswordConstants.pleaseEnterYourNewPasswordText,
            style: AppTextStyles.h3,
          ),
          PasswordTextField(
            label: ForgotPasswordConstants.newPasswordLabel,
            controller: _newPasswordController,
            validator: Validators.compose([
              Validators.required(
                message: ValidationsConstants.passwordRequiredError,
              ),
              Validators.minLen(
                ValidationsConstants.passwordMinLength,
                message: ValidationsConstants.passwordInvalidError,
              ),
              Validators.maxLen(
                ValidationsConstants.passwordMaxLength,
                message: ValidationsConstants.passwordInvalidError,
              ),
            ]),
            enabled: !isLoading,
          ),
          PasswordTextField(
            label: ForgotPasswordConstants.confirmPasswordLabel,
            controller: _confirmPasswordController,
            validator: Validators.compose([
              Validators.required(
                message: ValidationsConstants.passwordConfirmationRequiredError,
              ),
              Validators.minLen(
                ValidationsConstants.passwordConfirmationMinLength,
                message: ValidationsConstants.passwordConfirmationInvalidError,
              ),
              Validators.maxLen(
                ValidationsConstants.passwordConfirmationMaxLength,
                message: ValidationsConstants.passwordConfirmationInvalidError,
              ),
              Validators.sameAs(
                () => _newPasswordController.text,
                message: ValidationsConstants.passwordConfirmationMatchError,
              ),
            ]),
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
                shape: RoundedRectangleBorder(borderRadius: Rounded.md),
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
                      ForgotPasswordConstants.resetPasswordText,
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
}

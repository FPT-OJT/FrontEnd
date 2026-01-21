import 'package:flutter/material.dart';
import 'package:fpt_ojt/core/theme/app_colors.dart';
import 'package:fpt_ojt/core/theme/app_text_styles.dart';
import 'package:fpt_ojt/core/theme/rounded.dart';
import 'package:fpt_ojt/core/utils/validators.dart';
import 'package:fpt_ojt/features/auth/presentation/constants/forgot_password.dart';
import 'package:fpt_ojt/features/auth/presentation/constants/validations.dart';
import 'package:fpt_ojt/features/auth/presentation/widgets/password_text_field.dart';

class ForgotPasswordResetStep extends StatelessWidget {
  const ForgotPasswordResetStep({
    required this.formKey,
    required this.newPasswordController,
    required this.confirmPasswordController,
    required this.isLoading,
    required this.onResetPassword,
    super.key,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController newPasswordController;
  final TextEditingController confirmPasswordController;
  final bool isLoading;
  final VoidCallback onResetPassword;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Form(
      key: formKey,
      child: Column(
        spacing: 16,
        children: [
          Text(
            ForgotPasswordConstants.pleaseEnterYourNewPasswordText,
            style: AppTextStyles.h3,
          ),
          PasswordTextField(
            label: ForgotPasswordConstants.newPasswordLabel,
            controller: newPasswordController,
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
            controller: confirmPasswordController,
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
                () => newPasswordController.text,
                message: ValidationsConstants.passwordConfirmationMatchError,
              ),
            ]),
            enabled: !isLoading,
          ),
          SizedBox(
            height: 48,
            width: double.infinity,
            child: ElevatedButton(
              onPressed: isLoading ? null : onResetPassword,
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
}

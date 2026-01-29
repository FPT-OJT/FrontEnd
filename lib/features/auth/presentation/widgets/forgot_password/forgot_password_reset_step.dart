import 'package:flutter/material.dart';
import 'package:fpt_ojt/core/theme/app_colors.dart';
import 'package:fpt_ojt/core/theme/app_text_styles.dart';
import 'package:fpt_ojt/core/theme/borders.dart';
import 'package:fpt_ojt/core/theme/rounded.dart';
import 'package:fpt_ojt/core/theme/shadows.dart';
import 'package:fpt_ojt/core/theme/ui_gaps.dart';
import 'package:fpt_ojt/core/utils/validators.dart';
import 'package:fpt_ojt/features/auth/presentation/constants/validations.dart';
import 'package:fpt_ojt/features/auth/presentation/widgets/password_text_field.dart';
import 'package:fpt_ojt/l10n/app_localizations.dart';

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
  Widget build(BuildContext context) => Form(
    key: formKey,
    child: Column(
      spacing: UIGaps.size16,
      children: [
        Text(
          AppLocalizations.of(context)!.forgot_password_instruction,
          style: AppTextStyles.h3,
        ),
        PasswordTextField(
          label: AppLocalizations.of(
            context,
          )!.forgot_password_new_password_label,
          controller: newPasswordController,
          validator: Validators.compose([
            Validators.required(
              message: AppLocalizations.of(context)!.password_required_error,
            ),
            Validators.minLen(
              ValidationsConstants.passwordMinLength,
              message: AppLocalizations.of(context)!.password_min_length_error(
                ValidationsConstants.passwordMinLength,
              ),
            ),
            Validators.maxLen(
              ValidationsConstants.passwordMaxLength,
              message: AppLocalizations.of(context)!.password_max_length_error(
                ValidationsConstants.passwordMaxLength,
              ),
            ),
          ]),
          enabled: !isLoading,
        ),
        PasswordTextField(
          label: AppLocalizations.of(
            context,
          )!.forgot_password_confirm_password_label,
          controller: confirmPasswordController,
          validator: Validators.compose([
            Validators.required(
              message: AppLocalizations.of(
                context,
              )!.password_confirmation_required_error,
            ),
            Validators.minLen(
              ValidationsConstants.passwordConfirmationMinLength,
              message: AppLocalizations.of(context)!
                  .password_confirmation_min_length_error(
                    ValidationsConstants.passwordConfirmationMinLength,
                  ),
            ),
            Validators.maxLen(
              ValidationsConstants.passwordConfirmationMaxLength,
              message: AppLocalizations.of(context)!
                  .password_confirmation_max_length_error(
                    ValidationsConstants.passwordConfirmationMaxLength,
                  ),
            ),
            Validators.sameAs(
              () => newPasswordController.text,
              message: AppLocalizations.of(
                context,
              )!.password_confirmation_match_error,
            ),
          ]),
          enabled: !isLoading,
        ),
        SizedBox(
          height: UIGaps.size48,
          width: double.infinity,
          child: ElevatedButton(
            onPressed: isLoading ? null : onResetPassword,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.secondaryCoral,
              foregroundColor: AppColors.neutralWhite,
              shape: RoundedRectangleBorder(borderRadius: Rounded.md),
              elevation: Shadows.none,
              disabledBackgroundColor: AppColors.secondaryCoralDisabled,
            ),
            child: isLoading
                ? const SizedBox(
                    height: UIGaps.size20,
                    width: UIGaps.size20,
                    child: CircularProgressIndicator(
                      strokeWidth: Borders.xs,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.neutralWhite,
                      ),
                    ),
                  )
                : Text(
                    AppLocalizations.of(
                      context,
                    )!.forgot_password_reset_password,
                    style: AppTextStyles.btn.copyWith(
                      color: AppColors.neutralWhite,
                    ),
                  ),
          ),
        ),
      ],
    ),
  );
}

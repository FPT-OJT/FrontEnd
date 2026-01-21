import 'package:flutter/material.dart';
import 'package:fpt_ojt/core/theme/app_colors.dart';
import 'package:fpt_ojt/core/theme/app_text_styles.dart';
import 'package:fpt_ojt/core/theme/rounded.dart';
import 'package:fpt_ojt/core/theme/ui_gaps.dart';
import 'package:fpt_ojt/core/utils/validators.dart';
import 'package:fpt_ojt/features/auth/presentation/constants/forgot_password.dart';
import 'package:fpt_ojt/features/auth/presentation/constants/validations.dart';
import 'package:fpt_ojt/features/auth/presentation/widgets/custom_text_field.dart';

class ForgotPasswordEmailStep extends StatelessWidget {
  const ForgotPasswordEmailStep({
    required this.formKey,
    required this.emailController,
    required this.isLoading,
    required this.onSendCode,
    super.key,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final bool isLoading;
  final VoidCallback onSendCode;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Form(
      key: formKey,
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
            controller: emailController,
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
              onPressed: isLoading ? null : onSendCode,
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
}

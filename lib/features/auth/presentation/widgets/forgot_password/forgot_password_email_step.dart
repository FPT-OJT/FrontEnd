import 'package:flutter/material.dart';
import 'package:fpt_ojt/core/theme/app_colors.dart';
import 'package:fpt_ojt/core/theme/app_text_styles.dart';
import 'package:fpt_ojt/core/theme/borders.dart';
import 'package:fpt_ojt/core/theme/rounded.dart';
import 'package:fpt_ojt/core/theme/shadows.dart';
import 'package:fpt_ojt/core/theme/ui_gaps.dart';
import 'package:fpt_ojt/core/utils/validators.dart';
import 'package:fpt_ojt/features/auth/presentation/widgets/custom_text_field.dart';
import 'package:fpt_ojt/l10n/app_localizations.dart';

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
  Widget build(BuildContext context) => Form(
    key: formKey,
    child: Column(
      spacing: UIGaps.size16,
      children: [
        Text(
          AppLocalizations.of(context)!.forgot_password_title,
          style: AppTextStyles.h3,
        ),
        Text(
          AppLocalizations.of(context)!.forgot_password_email_instruction,
          style: AppTextStyles.bodySmall,
        ),
        CustomTextField(
          label: AppLocalizations.of(context)!.forgot_password_email_label,
          controller: emailController,
          validator: Validators.compose([
            Validators.required(
              message: AppLocalizations.of(context)!.email_required_error,
            ),
            Validators.email(
              message: AppLocalizations.of(context)!.email_invalid_error,
            ),
          ]),
          keyboardType: TextInputType.emailAddress,
          enabled: !isLoading,
        ),
        SizedBox(
          height: UIGaps.size48,
          width: double.infinity,
          child: ElevatedButton(
            onPressed: isLoading ? null : onSendCode,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.secondaryCoral,
              foregroundColor: AppColors.neutralEggShell20,
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
                    )!.forgot_password_send_reset_code,
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

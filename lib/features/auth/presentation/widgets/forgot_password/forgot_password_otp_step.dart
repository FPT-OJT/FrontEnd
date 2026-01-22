import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fpt_ojt/core/theme/app_colors.dart';
import 'package:fpt_ojt/core/theme/app_text_styles.dart';
import 'package:fpt_ojt/core/theme/borders.dart';
import 'package:fpt_ojt/core/theme/rounded.dart';
import 'package:fpt_ojt/core/theme/shadows.dart';
import 'package:fpt_ojt/core/theme/ui_gaps.dart';
import 'package:fpt_ojt/core/utils/validators.dart';
import 'package:fpt_ojt/features/auth/presentation/constants/forgot_password.dart';
import 'package:fpt_ojt/features/auth/presentation/constants/validations.dart';

class ForgotPasswordOtpStep extends StatelessWidget {
  const ForgotPasswordOtpStep({
    required this.formKey,
    required this.otpController,
    required this.email,
    required this.isLoading,
    required this.onVerifyOtp,
    super.key,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController otpController;
  final String email;
  final bool isLoading;
  final VoidCallback onVerifyOtp;

  @override
  Widget build(BuildContext context) => Form(
    key: formKey,
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
          controller: otpController,
          validator: Validators.compose([
            Validators.required(message: ValidationsConstants.otpRequiredError),
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
            LengthLimitingTextInputFormatter(ValidationsConstants.otpMaxLength),
          ],
          maxLength: ValidationsConstants.otpMaxLength,
          textAlign: TextAlign.center,
          style: AppTextStyles.h3.copyWith(letterSpacing: 8),
          decoration: InputDecoration(
            labelText: ForgotPasswordConstants.enter6DigitOTPText,
            counterText: '',
            filled: true,
            fillColor: Colors.transparent,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: UIGaps.size16,
              vertical: UIGaps.size16,
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
              borderSide: const BorderSide(color: AppColors.secondaryCoral),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: Rounded.md,
              borderSide: const BorderSide(color: AppColors.notifyError),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: Rounded.md,
              borderSide: const BorderSide(color: AppColors.notifyError),
            ),
          ),
        ),
        SizedBox(
          height: UIGaps.size48,
          width: double.infinity,
          child: ElevatedButton(
            onPressed: isLoading ? null : onVerifyOtp,
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
                    ForgotPasswordConstants.verifyOTPText,
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

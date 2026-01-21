import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fpt_ojt/core/theme/app_colors.dart';
import 'package:fpt_ojt/core/theme/app_text_styles.dart';
import 'package:fpt_ojt/core/theme/rounded.dart';
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
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Form(
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
              onPressed: isLoading ? null : onVerifyOtp,
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
}

import 'package:flutter/material.dart';
import 'package:fpt_ojt/core/theme/app_colors.dart';
import 'package:fpt_ojt/core/theme/app_text_styles.dart';
import 'package:fpt_ojt/core/theme/rounded.dart';

const double inputPadding = 16;

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    required this.label,
    required this.controller,
    super.key,
    this.hintText,
    this.validator,
    this.keyboardType,
    this.enabled = true,
    this.maxLines = 1,
  });
  final String label;
  final String? hintText;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final bool enabled;
  final int? maxLines;

  @override
  Widget build(BuildContext context) => TextFormField(
    controller: controller,
    validator: validator,
    keyboardType: keyboardType,
    enabled: enabled,
    maxLines: maxLines,
    cursorColor: AppColors.secondaryCoral,
    style: AppTextStyles.bodyLarge,
    decoration: InputDecoration(
      labelText: label,
      hintText: hintText,
      filled: true,
      fillColor: Colors.transparent,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: inputPadding,
        vertical: inputPadding,
      ),
      labelStyle: AppTextStyles.bodyLarge.copyWith(
        color: AppColors.neutralGrey,
      ),
      floatingLabelStyle: AppTextStyles.bodyLarge.copyWith(
        color: AppColors.secondaryCoral,
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
        borderSide: const BorderSide(color: AppColors.secondaryCoral, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: Rounded.md,
        borderSide: const BorderSide(color: AppColors.notifyError),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: Rounded.md,
        borderSide: const BorderSide(color: AppColors.notifyError, width: 2),
      ),
    ),
  );
}

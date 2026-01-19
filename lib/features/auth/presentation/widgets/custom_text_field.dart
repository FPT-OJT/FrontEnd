import 'package:flutter/material.dart';
import 'package:fpt_ojt/core/theme/app_colors.dart';

class CustomTextField extends StatelessWidget {

  const CustomTextField({
    required this.label, required this.controller, super.key,
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
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      enabled: enabled,
      maxLines: maxLines,
      style: theme.textTheme.bodyLarge?.copyWith(
        color: AppColors.secondaryNavy,
      ),
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        filled: true,
        fillColor: Colors.transparent,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        labelStyle: theme.textTheme.bodyMedium?.copyWith(
          color: AppColors.secondaryNavy.withOpacity(0.6),
          fontSize: 16,
        ),
        floatingLabelStyle: theme.textTheme.bodyMedium?.copyWith(
          color: AppColors.secondaryNavy,
          fontSize: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppColors.neutralGrey,
            width: 1.5,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppColors.neutralGrey,
            width: 1.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primaryMint, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppColors.notifyError,
            width: 1.5,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.notifyError, width: 2),
        ),
      ),
    );
  }
}

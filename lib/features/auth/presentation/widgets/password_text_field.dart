import 'package:flutter/material.dart';
import 'package:fpt_ojt/core/theme/app_colors.dart';

class PasswordTextField extends StatefulWidget {

  const PasswordTextField({
    required this.label, required this.controller, super.key,
    this.hintText,
    this.validator,
  });
  final String label;
  final String? hintText;
  final TextEditingController controller;
  final String? Function(String?)? validator;

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool _obscureText = true;

  void _toggleVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TextFormField(
      controller: widget.controller,
      validator: widget.validator,
      obscureText: _obscureText,
      style: theme.textTheme.bodyLarge?.copyWith(
        color: AppColors.secondaryNavy,
      ),
      decoration: InputDecoration(
        labelText: widget.label,
        hintText: widget.hintText,
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
        suffixIcon: IconButton(
          icon: Icon(
            _obscureText ? Icons.visibility_off : Icons.visibility,
            color: AppColors.secondaryNavy.withOpacity(0.6),
            size: 20,
          ),
          onPressed: _toggleVisibility,
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

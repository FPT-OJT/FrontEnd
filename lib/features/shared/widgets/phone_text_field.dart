import 'package:flutter/material.dart';
import 'package:fpt_ojt/core/theme/app_colors.dart';
import 'package:fpt_ojt/core/theme/app_text_styles.dart';
import 'package:fpt_ojt/core/theme/rounded.dart';
import 'package:fpt_ojt/core/theme/ui_gaps.dart';

const double inputPadding = UIGaps.size16;

class CountryPhoneCode {
  const CountryPhoneCode({required this.code, required this.name});
  final String code;
  final String name;
}

class PhoneTextField extends StatefulWidget {
  const PhoneTextField({
    required this.label,
    required this.phoneController,
    this.countryCodes = const [],
    super.key,
    this.hintText,
    this.validator,
    this.enabled = true,
    this.initialCountryCode = '+61',
    this.onCountryCodeChanged,
  });

  final String label;
  final String? hintText;
  final TextEditingController phoneController;
  final String? Function(String?)? validator;
  final bool enabled;
  final String initialCountryCode;
  final void Function(String)? onCountryCodeChanged;
  final List<CountryPhoneCode> countryCodes;

  @override
  State<PhoneTextField> createState() => _PhoneTextFieldState();
}

class _PhoneTextFieldState extends State<PhoneTextField> {
  late String _selectedCountryCode;

  @override
  void initState() {
    super.initState();
    _selectedCountryCode = widget.initialCountryCode;
  }

  @override
  Widget build(BuildContext context) => TextFormField(
    controller: widget.phoneController,
    keyboardType: TextInputType.phone,
    enabled: widget.enabled,
    cursorColor: AppColors.secondaryCoral,
    style: AppTextStyles.bodyLarge,
    validator: widget.validator,
    decoration: InputDecoration(
      labelText: widget.label,
      hintText: widget.hintText,
      filled: true,
      fillColor: Colors.transparent,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: inputPadding,
        vertical: inputPadding,
      ),
      hintStyle: AppTextStyles.bodyLarge.copyWith(color: AppColors.neutralGrey),
      labelStyle: AppTextStyles.bodyExtraSmall.copyWith(
        color: AppColors.secondaryCoral,
      ),
      floatingLabelStyle: AppTextStyles.bodyLarge.copyWith(
        color: AppColors.secondaryCoral,
      ),
      errorStyle: AppTextStyles.bodySmall.copyWith(
        color: AppColors.notifyError,
      ),
      border: OutlineInputBorder(
        borderRadius: Rounded.md,
        borderSide: const BorderSide(
          color: AppColors.neutralGrey,
          width: 1,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: Rounded.md,
        borderSide: const BorderSide(
          color: AppColors.neutralGrey,
          width: 1,
        ),
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
        borderSide: const BorderSide(
          color: AppColors.notifyError,
          width: 1,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: Rounded.md,
        borderSide: const BorderSide(
          color: AppColors.notifyError,
          width: 2,
        ),
      ),
      prefixIcon: _buildCountryCodeDropdown(),
    ),
  );

  Widget _buildCountryCodeDropdown() => Container(
    padding: const EdgeInsets.only(left: UIGaps.size8, right: UIGaps.size4),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        PopupMenuButton<String>(
          initialValue: _selectedCountryCode,
          enabled: widget.enabled,
          offset: const Offset(0, 8),
          shape: RoundedRectangleBorder(borderRadius: Rounded.md),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _selectedCountryCode,
                style: AppTextStyles.bodyLarge,
              ),
              UIGaps.w4,
              const Icon(
                Icons.keyboard_arrow_down,
                color: AppColors.neutralEggShell80,
                size: 20,
              ),
            ],
          ),
          onSelected: (newValue) {
            setState(() {
              _selectedCountryCode = newValue;
            });
            widget.onCountryCodeChanged?.call(newValue);
          },
          itemBuilder: (context) => widget.countryCodes
              .map(
                (countryData) => PopupMenuItem<String>(
                  value: countryData.code,
                  child: Row(
                    children: [
                      Text(countryData.code, style: AppTextStyles.bodyLarge),
                      UIGaps.w8,
                      Text(
                        countryData.name,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.neutralBlack,
                        ),
                      ),
                    ],
                  ),
                ),
              )
              .toList(),
        ),
        Container(
          width: 1,
          height: UIGaps.size24,
          color: AppColors.neutralGrey,
          margin: const EdgeInsets.only(left: UIGaps.size4),
        ),
      ],
    ),
  );
}

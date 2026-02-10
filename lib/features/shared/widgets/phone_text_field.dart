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
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;
  String? _errorText;
  bool _hasContent = false;

  @override
  void initState() {
    super.initState();
    _selectedCountryCode = widget.initialCountryCode;
    _focusNode.addListener(_onFocusChange);
    widget.phoneController.addListener(_onTextChange);
    _hasContent = widget.phoneController.text.isNotEmpty;
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    widget.phoneController.removeListener(_onTextChange);
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  void _onTextChange() {
    setState(() {
      _hasContent = widget.phoneController.text.isNotEmpty;
    });
  }

  bool get _shouldShowLabel => _isFocused || _hasContent;

  void _validateField() {
    if (widget.validator != null) {
      setState(() {
        _errorText = widget.validator!(widget.phoneController.text);
      });
    }
  }

  Color _getBorderColor() {
    if (_errorText != null) {
      return AppColors.notifyError;
    }
    if (_isFocused) {
      return AppColors.secondaryCoral;
    }
    return AppColors.neutralGrey;
  }

  double _getBorderWidth() {
    if (_isFocused) {
      return 2;
    }
    return 1;
  }

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _buildCombinedField(),
      if (_errorText != null) ...[
        UIGaps.h8,
        Text(
          _errorText!,
          style: AppTextStyles.bodySmall.copyWith(color: AppColors.notifyError),
        ),
      ],
    ],
  );

  Widget _buildCombinedField() => Stack(
    clipBehavior: Clip.none,
    children: [
      Container(
        height: UIGaps.size56,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: Rounded.md,
          border: Border.all(
            color: _getBorderColor(),
            width: _getBorderWidth(),
          ),
        ),
        child: Row(
          children: [
            _buildCountryCodeButton(),
            Container(
              width: 1,
              height: UIGaps.size24,
              color: AppColors.neutralGrey,
              margin: const EdgeInsets.symmetric(horizontal: UIGaps.size8),
            ),
            Expanded(child: _buildPhoneNumberField()),
          ],
        ),
      ),
      if (_shouldShowLabel)
        Positioned(
          top: -10,
          left: 12,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            color: AppColors.neutralEggShell20,
            child: Text(
              widget.label,
              style: AppTextStyles.bodyExtraSmall.copyWith(
                color: _isFocused
                    ? AppColors.secondaryCoral
                    : _errorText != null
                    ? AppColors.notifyError
                    : AppColors.secondaryCoral,
              ),
            ),
          ),
        ),
    ],
  );

  Widget _buildCountryCodeButton() => PopupMenuButton<String>(
    initialValue: _selectedCountryCode,
    enabled: widget.enabled,
    offset: const Offset(0, 8),
    shape: RoundedRectangleBorder(borderRadius: Rounded.md),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: UIGaps.size12),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(_selectedCountryCode, style: AppTextStyles.bodyLarge),
          UIGaps.w4,
          const Icon(
            Icons.keyboard_arrow_down,
            color: AppColors.neutralEggShell80,
            size: 20,
          ),
        ],
      ),
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
  );

  Widget _buildPhoneNumberField() => TextFormField(
    controller: widget.phoneController,
    focusNode: _focusNode,
    keyboardType: TextInputType.phone,
    enabled: widget.enabled,
    cursorColor: AppColors.secondaryCoral,
    style: AppTextStyles.bodyLarge,
    onChanged: (_) => _validateField(),
    validator: (value) {
      // Capture error from validator and sync with custom error display
      final error = widget.validator?.call(value);

      // Use post frame callback to update state after build
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _errorText != error) {
          setState(() {
            _errorText = error;
          });
        }
      });

      // Return error for Form system (but we hide it with errorStyle)
      return error;
    },
    decoration: InputDecoration(
      hintText: _shouldShowLabel ? widget.hintText : widget.label,
      filled: true,
      fillColor: Colors.transparent,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: inputPadding,
        vertical: inputPadding,
      ),
      hintStyle: AppTextStyles.bodyLarge.copyWith(color: AppColors.neutralGrey),
      border: InputBorder.none,
      enabledBorder: InputBorder.none,
      focusedBorder: InputBorder.none,
      errorBorder: InputBorder.none,
      focusedErrorBorder: InputBorder.none,
      errorStyle: const TextStyle(height: 0),
    ),
  );
}

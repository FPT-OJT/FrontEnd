import 'package:flutter/material.dart';
import 'package:fpt_ojt/core/theme/app_colors.dart';

class SwitchItem extends StatefulWidget {

  const SwitchItem({
    required this.label, super.key,
    this.initialValue = false,
    this.onChanged,
    this.onInfoTap,
  });
  final String label;
  final bool initialValue;
  final ValueChanged<bool>? onChanged;
  final VoidCallback? onInfoTap;

  @override
  State<SwitchItem> createState() => _SwitchItemState();
}

class _SwitchItemState extends State<SwitchItem> {
  // Layout constants
  static const double _containerBorderRadius = 5;
  static const double _containerPaddingHorizontal = 16;
  static const double _containerPaddingVertical = 14;
  
  // Shadow constants
  static const double _shadowBlurRadius = 8;
  static const double _shadowOffsetX = 0;
  static const double _shadowOffsetY = 2;
  
  // Switch constants
  static const double _switchScale = 0.8;
  static const double _switchSpacing = 8;
  
  // Text constants
  static const double _labelFontSize = 14;
  static const double _labelLineHeight = 1.5;
  
  // Icon constants
  static const double _iconBorderRadius = 12;
  static const double _iconSize = 24;
  
  late bool _isChecked;

  @override
  void initState() {
    super.initState();
    _isChecked = widget.initialValue;
  }

  void _handleCheckboxChange(bool value) {
    setState(() {
      _isChecked = value;
    });
    widget.onChanged?.call(value);
  }

  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      color: AppColors.neutralWhite,
      borderRadius: BorderRadius.circular(_containerBorderRadius),
      boxShadow: const [
        BoxShadow(
          color: AppColors.shadowNavyA10,
          blurRadius: _shadowBlurRadius,
          offset: Offset(_shadowOffsetX, _shadowOffsetY),
        ),
      ],
    ),
    padding: const EdgeInsets.symmetric(
      horizontal: _containerPaddingHorizontal,
      vertical: _containerPaddingVertical,
    ),
    child: Row(
      children: [
        // Switch
        Transform.scale(
          scale: _switchScale,
          child: Switch(
            value: _isChecked,
            onChanged: _handleCheckboxChange,
            activeThumbColor: AppColors.neutralEggShell20,
            activeTrackColor: AppColors.primaryMint,
            inactiveThumbColor: AppColors.neutralWhite,
            inactiveTrackColor: AppColors.neutralGrey,
          ),
        ),
        const SizedBox(width: _switchSpacing),
        // Label
        Expanded(
          child: Text(
            widget.label,
            style: const TextStyle(
              color: AppColors.primaryForest,
              fontSize: _labelFontSize,
              fontWeight: FontWeight.w400,
              height: _labelLineHeight,
            ),
          ),
        ),
        // Info icon
        InkWell(
          onTap: widget.onInfoTap,
          borderRadius: BorderRadius.circular(_iconBorderRadius),
          child: const Icon(
            Icons.info_outline,
            color: AppColors.primaryForest,
            size: _iconSize,
          ),
        ),
      ],
    ),
  );
}

import 'package:flutter/material.dart';
import 'package:fpt_ojt/core/theme/app_colors.dart';
import 'package:fpt_ojt/core/theme/app_text_styles.dart';

class SettingItemDate extends StatefulWidget {
  const SettingItemDate({
    required this.datePickerTitle,
    required this.description,
    required this.title,
    this.expiryDate,
    this.onChanged,
    super.key,
  });

  final String title;
  final String description;
  final String datePickerTitle;
  final DateTime? expiryDate;
  final void Function(DateTime?)? onChanged;

  @override
  State<SettingItemDate> createState() => _SettingItemDateState();
}

class _SettingItemDateState extends State<SettingItemDate> {
  bool _isExpanded = false;
  DateTime? _selectedDate;

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? widget.expiryDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
      widget.onChanged?.call(picked);
    }
  }

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: const BoxDecoration(color: AppColors.neutralWhite),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          leading: const Icon(
            Icons.settings,
            color: AppColors.primaryForest,
            size: 24,
          ),
          title: Row(
            children: [
              Expanded(
                child: Text(
                  widget.title,
                  style: AppTextStyles.bodyExtraSmall.copyWith(
                    color: AppColors.primaryForest,
                  ),
                ),
              ),
              if (widget.expiryDate == null) ...[
                const SizedBox(width: 10),
                Container(
                  width: 10,
                  height: 10,
                  decoration: const BoxDecoration(
                    color: AppColors.secondaryCoral,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ],
          ),
          trailing: Icon(
            _isExpanded ? Icons.keyboard_arrow_up : Icons.arrow_forward_ios,
            size: 16,
            color: AppColors.primaryForest,
          ),
          onTap: _toggleExpanded,
        ),
        if (_isExpanded) ...[
          const SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(height: 1, color: AppColors.neutralGrey),
                const SizedBox(height: 5),
                Text(
                  widget.description,
                  style: AppTextStyles.bodyExtraSmall.copyWith(
                    color: AppColors.neutralGrey,
                  ),
                ),
                const SizedBox(height: 5),
                InkWell(
                  onTap: () => _selectDate(context),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.datePickerTitle,
                        style: AppTextStyles.bodyLarge.copyWith(
                          color: AppColors.primaryForest,
                        ),
                      ),
                      Text(
                        _selectedDate != null
                            ? '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
                            : widget.expiryDate != null
                            ? '${widget.expiryDate!.day}/${widget.expiryDate!.month}/${widget.expiryDate!.year}'
                            : 'Select date',
                        style: AppTextStyles.bodyLarge.copyWith(
                          color: AppColors.neutralGrey,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
              ],
            ),
          ),
        ],
      ],
    ),
  );
}

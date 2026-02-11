import 'package:flutter/material.dart';
import 'package:fpt_ojt/core/theme/app_colors.dart';
import 'package:fpt_ojt/core/theme/app_text_styles.dart';

class SettingItem extends StatefulWidget {
  const SettingItem({
    required this.datePickerTitle,
    required this.description,
    required this.hasData,
    required this.title,
    super.key,
  });

  final String title;
  final String description;
  final String datePickerTitle;
  final bool hasData;

  @override
  State<SettingItem> createState() => _SettingItemState();
}

class _SettingItemState extends State<SettingItem> {
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
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
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
              if (!widget.hasData) ...[
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

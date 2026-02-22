import 'package:flutter/material.dart';
import 'package:fpt_ojt/core/theme/app_colors.dart';
import 'package:fpt_ojt/core/theme/app_text_styles.dart';
import 'package:intl/intl.dart';

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
      builder: (context, child) => Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primaryForest,
              onSurface: AppColors.primaryForest,
            ),
          ),
          child: child!,
        ),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
      widget.onChanged?.call(picked);
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    return DateFormat('dd-MM-yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: const BoxDecoration(color: AppColors.neutralWhite),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          clipBehavior: Clip.none,
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
              title: Text(
                widget.title,
                style: AppTextStyles.bodyExtraSmall.copyWith(
                  color: AppColors.primaryForest,
                ),
              ),
              trailing: Icon(
                _isExpanded ? Icons.keyboard_arrow_up : Icons.arrow_forward_ios,
                size: 16,
                color: AppColors.primaryForest,
              ),
              onTap: _toggleExpanded,
            ),
            if (widget.expiryDate == null)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: const BoxDecoration(
                    color: AppColors.secondaryCoral,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
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
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.neutralWhite,
                      border: Border.all(
                        color: AppColors.neutralGrey,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            () {
                              final displayDate =
                                  _selectedDate ?? widget.expiryDate;
                              final formattedDate = _formatDate(displayDate);
                              return formattedDate.isEmpty
                                  ? widget.datePickerTitle
                                  : formattedDate;
                            }(),
                            style: AppTextStyles.bodySmall.copyWith(
                              color:
                                  (_selectedDate ?? widget.expiryDate) == null
                                  ? AppColors.neutralGrey
                                  : AppColors.primaryForest,
                            ),
                          ),
                        ),
                        const Icon(
                          Icons.calendar_today,
                          color: AppColors.primaryForest,
                          size: 20,
                        ),
                      ],
                    ),
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

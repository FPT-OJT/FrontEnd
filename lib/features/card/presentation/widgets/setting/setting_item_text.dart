import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fpt_ojt/core/theme/app_colors.dart';
import 'package:fpt_ojt/core/theme/app_text_styles.dart';

class SettingItemText extends StatefulWidget {
  const SettingItemText({
    required this.datePickerTitle,
    required this.description,
    required this.title,
    this.reminderDate,
    this.onChanged,
    super.key,
  });

  final String title;
  final String description;
  final String datePickerTitle;
  final int? reminderDate;
  final void Function(int?)? onChanged;

  @override
  State<SettingItemText> createState() => _SettingItemTextState();
}

class _SettingItemTextState extends State<SettingItemText> {
  bool _isExpanded = false;
  late TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(
      text: widget.reminderDate?.toString() ?? '',
    );
    _textController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _textController.removeListener(_onTextChanged);
    _textController.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    final text = _textController.text;
    final value = text.isEmpty ? null : int.tryParse(text);
    widget.onChanged?.call(value);
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
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
            if (widget.reminderDate == null || widget.reminderDate == 0)
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
                TextField(
                  controller: _textController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.primaryForest,
                  ),
                  decoration: InputDecoration(
                    hintText: widget.datePickerTitle,
                    hintStyle: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.neutralGrey,
                    ),
                    filled: true,
                    fillColor: AppColors.neutralWhite,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        color: AppColors.neutralGrey,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        color: AppColors.neutralGrey,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        color: AppColors.primaryForest,
                        width: 2,
                      ),
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

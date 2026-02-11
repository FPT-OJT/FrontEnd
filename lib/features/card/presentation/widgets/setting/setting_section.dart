import 'package:flutter/material.dart';
import 'package:fpt_ojt/core/theme/app_colors.dart';
import 'package:fpt_ojt/core/theme/app_text_styles.dart';
import 'package:fpt_ojt/features/card/presentation/constants/card_text.dart';
import 'package:fpt_ojt/features/card/presentation/widgets/setting/setting_item.dart';
import 'package:fpt_ojt/features/card/presentation/widgets/setting/setting_warning_item.dart';

class SettingSection extends StatefulWidget {
  const SettingSection({required this.cardId, super.key});
  final String cardId;

  @override
  State<SettingSection> createState() => _SettingSectionState();
}

class _SettingSectionState extends State<SettingSection> {
  bool _showWarning = true;

  @override
  Widget build(BuildContext context) => Column(
    spacing: 16,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // Warning item
      if (_showWarning) ...[
        SettingWarningItem(
          warningText: CardText.expiredSoon,
          onClose: () {
            setState(() {
              _showWarning = false;
            });
          },
        ),
        const SizedBox(height: 8),
      ],
      // Section title
      Text(
        'Card Settings',
        style: AppTextStyles.h3.copyWith(color: AppColors.primaryForest),
      ),
      // Setting items
      const SettingItem(
        title: CardText.reminderSetting,
        description: CardText.reminderSettingDesc,
        datePickerTitle: 'Select reminder date',
        hasData: false,
      ),
      const SettingItem(
        title: CardText.expirySetting,
        description: CardText.expirySettingDesc,
        datePickerTitle: 'Select card expiry date',
        hasData: true,
      ),
    ],
  );
}

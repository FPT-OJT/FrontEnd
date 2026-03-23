import 'package:flutter/material.dart';
import 'package:fpt_ojt/core/theme/app_colors.dart';
import 'package:fpt_ojt/core/theme/app_text_styles.dart';
import 'package:fpt_ojt/core/theme/ui_gaps.dart';
import 'package:fpt_ojt/features/merchants/presentation/constants/merchant_text.dart';

class MerchantListSection extends StatelessWidget {
  const MerchantListSection({super.key});

  @override
  Widget build(BuildContext context) => Column(
    spacing: UIGaps.size20,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        MerchantText.merchantListTitleNoSearch,
        style: AppTextStyles.h3.copyWith(color: AppColors.primaryForest),
      ),
    ],
  );
}

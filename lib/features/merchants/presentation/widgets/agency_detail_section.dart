import 'package:flutter/material.dart';
import 'package:fpt_ojt/core/theme/app_colors.dart';
import 'package:fpt_ojt/core/theme/app_text_styles.dart';
import 'package:fpt_ojt/core/theme/ui_gaps.dart';
import 'package:fpt_ojt/features/merchants/presentation/constants/merchant_detail.dart';
import 'package:fpt_ojt/features/shared/widgets/icon_button.dart';
import 'package:go_router/go_router.dart';

class AgencyDetailSection extends StatelessWidget {
  const AgencyDetailSection({this.isFavorite, this.name, super.key});
  final String? name;
  final bool? isFavorite;

  // UI Constants
  static const double containerHeight = 120;
  static const int nameMaxLines = 2;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: UIGaps.size12),
    height: AgencyDetailSection.containerHeight,
    width: double.infinity,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppIconButton(
              icon: Icons.arrow_back_ios_new,
              onPressed: () => context.pop(),
            ),
            Row(
              spacing: UIGaps.size4,
              children: [
                AppIconButton(
                  icon: isFavorite ?? false
                      ? Icons.favorite
                      : Icons.favorite_border,
                  onPressed: () {}, // Todo: Handle favorite action
                ),
                AppIconButton(
                  icon: Icons.notification_add_outlined,
                  onPressed: () {},
                ),
              ],
            ),
          ],
        ),
        Text(
          name ?? MerchantDetailText.emptyString,
          style: AppTextStyles.h2.copyWith(color: AppColors.neutralWhite),
          maxLines: AgencyDetailSection.nameMaxLines,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    ),
  );
}

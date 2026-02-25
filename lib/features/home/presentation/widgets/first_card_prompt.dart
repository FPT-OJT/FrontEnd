import 'package:flutter/material.dart';
import 'package:fpt_ojt/app/router/route_names.dart';
import 'package:fpt_ojt/core/theme/app_colors.dart';
import 'package:fpt_ojt/core/theme/app_text_styles.dart';
import 'package:fpt_ojt/core/theme/rounded.dart';
import 'package:fpt_ojt/core/theme/ui_gaps.dart';
import 'package:fpt_ojt/features/home/presentation/constants/text.dart';
import 'package:go_router/go_router.dart';

class FirstCardPrompt extends StatelessWidget {
  const FirstCardPrompt({super.key, this.hasCard = false});
  final bool hasCard;
  static const firstCardImage = 'assets/images/home/home_first_cart.png';
  static const hasCardImage = 'assets/images/home/home_has_card.png';
  @override
  Widget build(BuildContext context) => Material(
    color: hasCard ? AppColors.secondaryGreen : AppColors.secondaryCoral,
    borderRadius: Rounded.lg,
    child: InkWell(
      borderRadius: Rounded.lg,
      onTap: () {
        context.push(RouteNames.aiSuggestion);
      },
      child: Padding(
        padding: const EdgeInsets.all(UIGaps.size10),
        child: Row(
          spacing: UIGaps.size20,
          children: [
            Image.asset(
              hasCard ? hasCardImage : firstCardImage,
              height: 70,
              width: 70,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: UIGaps.size4,
                children: [
                  Text(
                    hasCard
                        ? HomeText.hasCardPromptTitle
                        : HomeText.firstCardPromptTitle,
                    style: AppTextStyles.h3.copyWith(
                      color: AppColors.neutralWhite,
                    ),
                  ),
                  Text(
                    hasCard
                        ? HomeText.hasCardPromptDescription
                        : HomeText.firstCardPromptDescription,
                    style: AppTextStyles.bodyExtraSmall.copyWith(
                      color: AppColors.neutralWhite,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

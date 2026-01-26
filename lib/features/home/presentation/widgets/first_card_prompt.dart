import 'package:flutter/material.dart';
import 'package:fpt_ojt/core/theme/app_colors.dart';
import 'package:fpt_ojt/core/theme/app_text_styles.dart';
import 'package:fpt_ojt/core/theme/rounded.dart';
import 'package:fpt_ojt/core/theme/ui_gaps.dart';
class FirstCardPrompt extends StatelessWidget {
  const FirstCardPrompt({super.key});

  @override
  Widget build(BuildContext context) => Material(
      color: AppColors.secondaryCoral,
      borderRadius: Rounded.lg,
      child: InkWell(
        borderRadius: Rounded.lg,
        onTap: () {
          // TODO: Implement add card navigation
        },
        child: Padding(
          padding: const EdgeInsets.all(UIGaps.size10),
          child: Row(
            spacing: UIGaps.size20,
            children: [
              Image.asset(
                'assets/images/home/home_first_cart.png',
                height: 70,
                width: 70,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: UIGaps.size4,
                  children: [
                    Text(
                      'Add your first card now!',
                      style: AppTextStyles.h3.copyWith(
                        color: AppColors.neutralWhite,
                      ),
                    ),
                    Text(
                      'Start your journey today!',
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
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpt_ojt/core/theme/app_colors.dart';
import 'package:fpt_ojt/core/theme/app_text_styles.dart';
import 'package:fpt_ojt/core/theme/ui_gaps.dart';
import 'package:fpt_ojt/features/merchants/presentation/blocs/merchant_detail/merchant_detail_bloc.dart';
import 'package:fpt_ojt/features/merchants/presentation/blocs/merchant_detail/merchant_detail_state.dart';
import 'package:fpt_ojt/features/merchants/presentation/constants/merchant_detail.dart';
import 'package:fpt_ojt/features/shared/widgets/primary_button.dart';

class BottomSelectedCardSection extends StatelessWidget {
  const BottomSelectedCardSection({super.key, this.onContinue});
  final VoidCallback? onContinue;

  // UI Constants
  static const double containerHeight = 140;
  static const double cardImageHeight = 60;
  static const double borderRadiusTopLeft = 20;
  static const double borderRadiusTopRight = 20;
  static const double shadowBlurRadius = 10;
  static const double shadowSpreadRadius = 0;
  static const double shadowOpacity = 0.1;
  static const double buttonHeight = 48;
  static const double buttonBorderRadius = 8;
  static const int cardNameMaxLines = 1;
  static const int dealNameMaxLines = 1;

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<MerchantDetailBloc, MerchantDetailState>(
        builder: (context, state) {
          if (state is! MerchantDetailLoaded || state.selectedCard == null) {
            return const SizedBox.shrink();
          }

          final selectedCard = state.selectedCard;

          return Container(
            height: BottomSelectedCardSection.containerHeight,
            decoration: BoxDecoration(
              color: AppColors.neutralWhite,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(
                  BottomSelectedCardSection.borderRadiusTopLeft,
                ),
                topRight: Radius.circular(
                  BottomSelectedCardSection.borderRadiusTopRight,
                ),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryForest.withValues(
                    alpha: BottomSelectedCardSection.shadowOpacity,
                  ),
                  blurRadius: BottomSelectedCardSection.shadowBlurRadius,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: UIGaps.size20,
              vertical: UIGaps.size16,
            ),
            child: Column(
              spacing: UIGaps.size20,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      MerchantDetailText.maxReduceRateTitle,
                      style: AppTextStyles.h3.copyWith(
                        color: AppColors.primaryForest,
                      ),
                    ),
                    Text(
                      '${selectedCard?.maxReduceRate ?? 0}%',
                      style: AppTextStyles.h3.copyWith(
                        color: AppColors.primaryForest,
                      ),
                    ),
                  ],
                ),
                // Continue Button
                PrimaryButton(
                  onPressed: onContinue ?? () {},
                  text: MerchantDetailText.continueButton,
                ),
              ],
            ),
          );
        },
      );
}

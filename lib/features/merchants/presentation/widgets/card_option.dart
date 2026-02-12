import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpt_ojt/core/theme/app_colors.dart';
import 'package:fpt_ojt/core/theme/app_text_styles.dart';
import 'package:fpt_ojt/core/theme/ui_gaps.dart';
import 'package:fpt_ojt/features/merchants/domain/entities/card.dart'
    as card_entity;
import 'package:fpt_ojt/features/merchants/presentation/blocs/merchant_detail/merchant_detail_bloc.dart';
import 'package:fpt_ojt/features/merchants/presentation/blocs/merchant_detail/merchant_detail_event.dart';
import 'package:fpt_ojt/features/merchants/presentation/constants/merchant_detail.dart';

class CardOption extends StatefulWidget {
  const CardOption({required this.card, required this.selectOptionTap, this.isSelected = false, super.key});
  final card_entity.Card card;
  final bool isSelected;
  final VoidCallback selectOptionTap;

  // UI Constants
  static const double iconSize = 20;
  static const double pageViewHeight = 120;
  static const double cardImageHeight = 80;
  static const double infoIconSize = 16;
  static const double dotMarginHorizontal = 4;
  static const double dotSize = 6;
  static const double textOpacity = 0.5;
  static const double inactiveDotOpacity = 0.3;
  static const int cardNameMaxLines = 1;

  @override
  State<CardOption> createState() => _CardOptionState();
}

class _CardOptionState extends State<CardOption> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final deals = widget.card.deals;
    final hasDeals = deals.isNotEmpty;

    return GestureDetector(
      onTap: widget.selectOptionTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: UIGaps.size8),
        child: Column(
          spacing: UIGaps.size4,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: UIGaps.size8,
              children: [
                // Icon
                Icon(
                  widget.isSelected ? Icons.check_circle_outline : Icons.circle_outlined,
                  size: CardOption.iconSize,
                  color: AppColors.secondaryGreen,
                ),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.card.name,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.primaryForest,
                        ),
                        maxLines: CardOption.cardNameMaxLines,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        MerchantDetailText.selectOptions,
                        style: AppTextStyles.bodyExtraSmall.copyWith(
                          color: AppColors.primaryForest.withValues(alpha: CardOption.textOpacity),
                        ),
                      ),
                    ],
                  ),
                ),

                // Right Section (Chỉ hiện nếu có data)
                if (hasDeals)
                  Padding(
                    padding: const EdgeInsets.only(top: UIGaps.size4),
                    child: Row(
                      spacing: UIGaps.size4,
                      children: [
                        if (deals[_currentPage].discountRate != null && deals[_currentPage].discountRate != 0)
                          Text(
                            '${deals[_currentPage].discountRate}${MerchantDetailText.rewardSuffix}',
                            style: AppTextStyles.bodyExtraSmall.copyWith(
                              color: AppColors.primaryForest,
                            ),
                          )
                        else if (deals[_currentPage].cashbackRate != null && deals[_currentPage].cashbackRate != 0)
                          Text(
                            '${deals[_currentPage].cashbackRate}${MerchantDetailText.rewardSuffix}',
                            style: AppTextStyles.bodyExtraSmall.copyWith(
                              color: AppColors.primaryForest,
                            ),
                          ),
                        const Icon(Icons.keyboard_arrow_down, size: CardOption.iconSize, color: AppColors.primaryForest,),
                      ],
                    ),
                  ),
              ],
            ),
            
            if (hasDeals)
              SizedBox(
                height: CardOption.pageViewHeight,
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                    if (widget.isSelected) {
                      context.read<MerchantDetailBloc>().add(
                        MerchantDetailDealIndexChanged(dealIndex: index),
                      );
                    }
                  },
                  itemCount: deals.length,
                  itemBuilder: (context, index) {
                    final deal = deals[index];
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Image.network(widget.card.imageUrl, height: CardOption.cardImageHeight),
                        Column(
                          spacing: UIGaps.size4,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              widget.card.name,
                              style: AppTextStyles.textLink.copyWith(
                                color: AppColors.primaryForest,
                              ),
                            ),
                            if (deal.cashbackRate != null && deal.cashbackRate != 0)
                              Text(
                                '${MerchantDetailText.cashbackPrefix}${deal.cashbackRate}${MerchantDetailText.percentSuffix}',
                                style: AppTextStyles.bodyExtraSmall.copyWith(
                                  color: AppColors.primaryForest,
                                ),
                              ),
                            if (deal.discountRate != null && deal.discountRate != 0)
                              Text(
                                '${MerchantDetailText.discountPrefix}${deal.discountRate}${MerchantDetailText.percentSuffix}',
                                style: AppTextStyles.bodyExtraSmall.copyWith(
                                  color: AppColors.primaryForest,
                                ),
                              ),
                            if (deal.dealName != null)
                              Text(
                                deal.dealName!,
                                style: AppTextStyles.bodyExtraSmall.copyWith(
                                  color: AppColors.secondaryGreen,
                                ),
                              ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: UIGaps.size4,
                children: [
                  Text(
                    MerchantDetailText.detailedConditions,
                    style: AppTextStyles.textLink.copyWith(
                      color: AppColors.secondaryCoral,
                    ),
                  ),
                  const Icon(
                    Icons.info_outline_rounded,
                    size: CardOption.infoIconSize,
                    color: AppColors.secondaryCoral,
                  ),
                ],
              ),
            ),
            
            // Page indicator (three dots)
            if (hasDeals && deals.length > 1)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  deals.length,
                  (index) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: CardOption.dotMarginHorizontal),
                    width: CardOption.dotSize,
                    height: CardOption.dotSize,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentPage == index
                          ? AppColors.primaryForest
                          : AppColors.primaryForest.withValues(alpha: CardOption.inactiveDotOpacity),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

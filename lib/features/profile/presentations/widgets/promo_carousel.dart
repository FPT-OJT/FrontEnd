import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:fpt_ojt/core/theme/app_colors.dart';
import 'package:fpt_ojt/core/theme/app_text_styles.dart';
import 'package:fpt_ojt/core/theme/ui_gaps.dart';
import 'package:fpt_ojt/features/profile/presentations/constants/data.dart';
import 'package:fpt_ojt/features/profile/presentations/widgets/carousel_card.dart';

class PromoCarousel extends StatefulWidget {
  const PromoCarousel({super.key});

  @override
  State<PromoCarousel> createState() => _PromoCarouselState();
}

class _PromoCarouselState extends State<PromoCarousel> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Did you know...',
        style: AppTextStyles.h3.copyWith(color: AppColors.primaryForest),
      ),
      UIGaps.h20,

      /// Carousel
      CarouselSlider.builder(
        itemCount: promoItems.length,
        itemBuilder: (context, index, realIndex) =>
            CarouselCard(item: promoItems[index]),
        options: CarouselOptions(
          height: 152,
          enlargeCenterPage: true,
          onPageChanged: (index, reason) {
            setState(() {
              _currentIndex = index;
            });
          },
          disableCenter: true,
          padEnds: false,
        ),
      ),

      const SizedBox(height: 8),

      /// Dots indicator
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(promoItems.length, _buildDot),
      ),
    ],
  );

  Widget _buildDot(int index) => AnimatedContainer(
    duration: const Duration(milliseconds: 300),
    margin: const EdgeInsets.symmetric(horizontal: 4),
    width: UIGaps.size4,
    height: UIGaps.size4,
    decoration: BoxDecoration(
      color: _currentIndex == index
          ? AppColors.primaryForest
          : Colors.grey.shade400,
      borderRadius: BorderRadius.circular(4),
    ),
  );
}

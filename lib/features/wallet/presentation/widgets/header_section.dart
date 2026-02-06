import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fpt_ojt/core/theme/app_text_styles.dart';
import 'package:fpt_ojt/core/theme/ui_gaps.dart';

class HeaderSection extends StatelessWidget {
  @Preview(name: 'Wallet Header Section')
  const HeaderSection({super.key});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.only(
      top: UIGaps.size40,
      left: UIGaps.size10,
      right: UIGaps.size10,
      bottom: UIGaps.size10,
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Alysa's\nwallet",
          style: AppTextStyles.h2.copyWith(color: Colors.white),
        ),
        SvgPicture.asset(
          'assets/images/wallet/images/image.svg',
          width: 120,
          height: 120,
          placeholderBuilder: (context) => const SizedBox(
            width: 120,
            height: 120,
            child: Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
          ),
        ),
      ],
    ),
  );
}

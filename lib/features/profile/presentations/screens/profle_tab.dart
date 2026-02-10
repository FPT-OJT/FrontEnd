import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:fpt_ojt/core/theme/app_colors.dart';
import 'package:fpt_ojt/core/theme/ui_gaps.dart';
import 'package:fpt_ojt/features/profile/presentations/widgets/logout_section.dart';
import 'package:fpt_ojt/features/profile/presentations/widgets/profile_action.dart';
import 'package:fpt_ojt/features/profile/presentations/widgets/profile_head_section.dart';
import 'package:fpt_ojt/features/profile/presentations/widgets/promo_carousel.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) => const _ProfileTabContent();
}

class _ProfileTabContent extends StatelessWidget {
  const _ProfileTabContent();

  @override
  Widget build(BuildContext context) => AnnotatedRegion<SystemUiOverlayStyle>(
    value: const SystemUiOverlayStyle(
      statusBarColor: AppColors.primaryForest,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
      systemNavigationBarColor: AppColors.primaryForest,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
    child: Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          color: AppColors.primaryForest,
          child: Column(
            children: [
              UIGaps.h48,
              Container(
                padding: const EdgeInsets.symmetric(horizontal: UIGaps.size20),
                child: const ProfileHeadSection(),
              ),
              UIGaps.h24,
              const _ContentSection(),
            ],
          ),
        ),
      ),
    ),
  );
}

class _ContentSection extends StatelessWidget {
  const _ContentSection();

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(
      horizontal: UIGaps.size20,
      vertical: UIGaps.size20,
    ),
    decoration: const BoxDecoration(
      color: AppColors.neutralEggShell20,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(16),
        topRight: Radius.circular(16),
      ),
    ),
    width: double.infinity,
    constraints: const BoxConstraints(minHeight: 700),
    child: const Column(
      spacing: UIGaps.size20,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [PromoCarousel(), ProfileAction(), UIGaps.h24, LogoutSection()],
    ),
  );
}

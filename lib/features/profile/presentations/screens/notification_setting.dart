import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:fpt_ojt/core/theme/app_colors.dart';
import 'package:fpt_ojt/core/theme/ui_gaps.dart';
import 'package:fpt_ojt/features/profile/presentations/constants/notification.dart';
import 'package:fpt_ojt/features/profile/presentations/constants/terms_conditions.dart';
import 'package:fpt_ojt/features/profile/presentations/widgets/notification/switch_item.dart';
import 'package:fpt_ojt/features/profile/presentations/widgets/terms_conditions/terms_conditions_head_section.dart';

class NotificationSettingScreen extends StatelessWidget {
  const NotificationSettingScreen({super.key});

  @override
  Widget build(BuildContext context) =>
      const _NotificationSettingScreenContent();
}

class _NotificationSettingScreenContent extends StatelessWidget {
  const _NotificationSettingScreenContent();

  @override
  Widget build(BuildContext context) => AnnotatedRegion<SystemUiOverlayStyle>(
    value: const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
      systemNavigationBarColor: AppColors.primaryForest,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
    child: Scaffold(
      body: Container(
        width: double.infinity,
        color: AppColors.primaryForest,
        child: Column(
          children: [
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(NotificationConstants.bgImage),
                  fit: BoxFit.fitHeight,
                ),
              ),
              height: 250,
              padding: const EdgeInsets.only(
                left: UIGaps.size20,
                right: UIGaps.size20,
                top: UIGaps.size48,
                bottom: UIGaps.size20,
              ),
              child: const TermsConditionsHeadSection(),
            ),
            const Expanded(
              child: SingleChildScrollView(child: _ContentSection()),
            ),
          ],
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
        topLeft: Radius.circular(TermsConditionsConstants.contentBorderRadius),
        topRight: Radius.circular(TermsConditionsConstants.contentBorderRadius),
      ),
    ),
    width: double.infinity,
    constraints: const BoxConstraints(
      minHeight: TermsConditionsConstants.contentMinHeight,
    ),
    child: SingleChildScrollView(
      child: Column(
        children: [
          SwitchItem(
            label: 'Notifications about service promotions and special offers',
            initialValue: true,
            onChanged: (value) {
              debugPrint('Service promotions: $value');
            },
            onInfoTap: () {
              debugPrint('Info tapped: Service promotions');
            },
          ),
          const SizedBox(height: 16),
          SwitchItem(
            label: 'Notifications for offers that are about to expire',
            onChanged: (value) {
              debugPrint('Expiring offers: $value');
            },
            onInfoTap: () {
              debugPrint('Info tapped: Expiring offers');
            },
          ),
          const SizedBox(height: 16),
          SwitchItem(
            label: 'Advertising and marketing notifications',
            onChanged: (value) {
              debugPrint('Marketing notifications: $value');
            },
            onInfoTap: () {
              debugPrint('Info tapped: Marketing notifications');
            },
          ),
          const SizedBox(height: 16),
          SwitchItem(
            label: 'System updates and new feature announcements',
            onChanged: (value) {
              debugPrint('System updates: $value');
            },
            onInfoTap: () {
              debugPrint('Info tapped: System updates');
            },
          ),
        ],
      ),
    ),
  );
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:fpt_ojt/core/theme/app_colors.dart';
import 'package:fpt_ojt/core/theme/ui_gaps.dart';
import 'package:fpt_ojt/features/location/blocs/geofence/geofence_bloc.dart';
import 'package:fpt_ojt/features/location/blocs/geofence/geofence_event.dart';
import 'package:fpt_ojt/features/profile/presentations/constants/profile_tab.dart';
import 'package:fpt_ojt/features/profile/presentations/widgets/logout_section.dart';
import 'package:fpt_ojt/features/profile/presentations/widgets/profile_action.dart';
import 'package:fpt_ojt/features/profile/presentations/widgets/profile_head_section.dart';
import 'package:fpt_ojt/features/profile/presentations/widgets/promo_carousel.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  @override
  void initState() {
    super.initState();
    context.read<GeofenceBloc>().add(const GeofenceStarted());
  }

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
        topLeft: Radius.circular(ProfileTabConstants.contentBorderRadius),
        topRight: Radius.circular(ProfileTabConstants.contentBorderRadius),
      ),
    ),
    width: double.infinity,
    constraints: const BoxConstraints(
      minHeight: ProfileTabConstants.contentMinHeight,
    ),
    child: const Column(
      spacing: UIGaps.size20,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [PromoCarousel(), ProfileAction(), UIGaps.h24, LogoutSection()],
    ),
  );
}

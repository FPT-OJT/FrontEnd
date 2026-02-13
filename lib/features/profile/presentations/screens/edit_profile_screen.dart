import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:fpt_ojt/core/theme/app_colors.dart';
import 'package:fpt_ojt/core/theme/ui_gaps.dart';
import 'package:fpt_ojt/features/profile/presentations/blocs/update_profile/update_profile_bloc.dart';
import 'package:fpt_ojt/features/profile/presentations/blocs/update_profile/update_profile_event.dart';
import 'package:fpt_ojt/features/profile/presentations/constants/profile_update.dart';
import 'package:fpt_ojt/features/profile/presentations/widgets/update_profile/edit_profile_head_section.dart';
import 'package:fpt_ojt/features/profile/presentations/widgets/update_profile/update_profile_section.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  @override
  void initState() {
    super.initState();
    context.read<UpdateProfileBloc>().add(const UpdateProfileEvent.started());
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
                child: const EditProfileHeadSection(),
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
        topLeft: Radius.circular(ProfileUpdateConstants.contentBorderRadius),
        topRight: Radius.circular(ProfileUpdateConstants.contentBorderRadius),
      ),
    ),
    width: double.infinity,
    constraints: const BoxConstraints(
      minHeight: ProfileUpdateConstants.contentMinHeight,
    ),
    child: const Column(
      spacing: UIGaps.size20,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [UpdateProfileSection()],
    ),
  );
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:fpt_ojt/core/theme/app_colors.dart';
import 'package:fpt_ojt/core/theme/ui_gaps.dart';
import 'package:fpt_ojt/features/profile/presentations/blocs/update_profile/update_profile_bloc.dart';
import 'package:fpt_ojt/features/profile/presentations/blocs/update_profile/update_profile_event.dart';
import 'package:fpt_ojt/features/profile/presentations/widgets/edit_profile_head_section.dart';
import 'package:fpt_ojt/features/profile/presentations/widgets/update_profile_section.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  @override
  void initState() {
    super.initState();
    context.read<UpdateProfileBloc>().add(const UpdateProfileStarted());
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
        topLeft: Radius.circular(16),
        topRight: Radius.circular(16),
      ),
    ),
    width: double.infinity,
    constraints: const BoxConstraints(minHeight: 700),
    child: const Column(
      spacing: UIGaps.size20,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [UpdateProfileSection()],
    ),
  );
}

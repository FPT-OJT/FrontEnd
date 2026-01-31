import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpt_ojt/app/router/route_names.dart';
import 'package:fpt_ojt/core/theme/app_colors.dart';
import 'package:fpt_ojt/core/theme/rounded.dart';
import 'package:fpt_ojt/core/theme/ui_gaps.dart';
import 'package:fpt_ojt/features/auth/presentation/blocs/auth/auth_bloc.dart';
import 'package:fpt_ojt/features/auth/presentation/blocs/auth/auth_state.dart';
import 'package:fpt_ojt/features/home/presentation/widgets/ai_section.dart';
import 'package:fpt_ojt/features/home/presentation/widgets/explore_section.dart';
import 'package:fpt_ojt/features/home/presentation/widgets/first_card_prompt.dart';
import 'package:fpt_ojt/features/home/presentation/widgets/merchant_section.dart';
import 'package:fpt_ojt/features/home/presentation/widgets/search_section.dart';
import 'package:fpt_ojt/features/shared/utils/snackbar_utils.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) => BlocConsumer<AuthBloc, AuthState>(
    listener: _authListener,
    builder: (context, state) => const _HomeScreenContent(),
  );

  void _authListener(BuildContext context, AuthState state) {
    if (state is AuthFailure || state is AuthUnAuthenticated) {
      SnackBarUtils.showError(context, 'Please login to continue');
      context.go(RouteNames.loginOptions);
      return;
    }
    if (state is AuthLoggedIn) {
      SnackBarUtils.showSuccess(context, 'Welcome back ${state.user.name}');
    }
  }
}

class _HomeScreenContent extends StatelessWidget {
  const _HomeScreenContent();

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
              Container(
                padding: const EdgeInsets.symmetric(horizontal: UIGaps.size20),
                child: const Column(
                  children: [ExploreSection(), UIGaps.h24, FirstCardPrompt()],
                ),
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
    decoration: BoxDecoration(
      borderRadius: Rounded.lg,
      color: AppColors.neutralEggShell20,
    ),
    width: double.infinity,
    constraints: const BoxConstraints(minHeight: 700),
    child: const Column(
      spacing: UIGaps.size20,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [SearchSection(), MerchantSection(), AiSection()],
    ),
  );
}

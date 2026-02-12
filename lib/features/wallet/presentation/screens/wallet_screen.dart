import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widget_previews.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpt_ojt/app/router/route_names.dart';
import 'package:fpt_ojt/core/theme/app_colors.dart';
import 'package:fpt_ojt/core/theme/ui_gaps.dart';
import 'package:fpt_ojt/features/auth/presentation/blocs/auth/auth_bloc.dart';
import 'package:fpt_ojt/features/auth/presentation/blocs/auth/auth_state.dart';
import 'package:fpt_ojt/features/shared/utils/snackbar_utils.dart';
import 'package:fpt_ojt/features/wallet/presentation/widgets/header_section.dart';
import 'package:fpt_ojt/features/wallet/presentation/widgets/wallet_section.dart';
import 'package:go_router/go_router.dart';

class WalletScreen extends StatelessWidget {
  @Preview(name: 'Wallet Screen')
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) => BlocConsumer<AuthBloc, AuthState>(
    listener: _authListener,
    builder: (context, state) => const _WalletScreenContent(),
  );

  void _authListener(BuildContext context, AuthState state) {
    if (state is AuthFailure || state is AuthUnAuthenticated) {
      SnackBarUtils.showError(context, 'Please login to continue');
      context.go(RouteNames.loginOptions);
      return;
    }
    if (state is AuthLoggedIn) {
      SnackBarUtils.showSuccess(
        context,
        'Welcome back ${state.user.firstName}',
      );
    }
  }
}

class _WalletScreenContent extends StatelessWidget {
  const _WalletScreenContent();

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
                child: const _WalletPromptSection(),
              ),
              const _ContentSection(),
            ],
          ),
        ),
      ),
    ),
  );
}

class _WalletPromptSection extends StatelessWidget {
  const _WalletPromptSection();

  @override
  Widget build(BuildContext context) => BlocBuilder<AuthBloc, AuthState>(
    builder: (context, authState) {
      final firstName = authState is AuthLoggedIn
          ? authState.user.firstName
          : 'User';
      return Column(
        children: [
          HeaderSection(firstName: firstName),
          UIGaps.h8,
        ],
      );
    },
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
    child: const WalletSection(),
  );
}

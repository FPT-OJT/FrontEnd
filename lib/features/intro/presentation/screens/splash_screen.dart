import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpt_ojt/app/router/route_names.dart';
import 'package:fpt_ojt/core/theme/app_colors.dart';
import 'package:fpt_ojt/core/theme/app_text_styles.dart';
import 'package:fpt_ojt/core/theme/ui_gaps.dart';
import 'package:fpt_ojt/features/auth/presentation/blocs/auth/auth_bloc.dart';
import 'package:fpt_ojt/features/auth/presentation/blocs/auth/auth_event.dart';
import 'package:fpt_ojt/features/auth/presentation/blocs/auth/auth_state.dart';
import 'package:fpt_ojt/features/intro/presentation/blocs/onboarding/onboarding_cubit.dart';
import 'package:fpt_ojt/features/intro/presentation/blocs/onboarding/onboarding_state.dart';
import 'package:fpt_ojt/features/shared/constants/app_constants.dart';
import 'package:go_router/go_router.dart';

const double logoHeight = 50;
const double logoWidth = 50;

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  var _didRecover = false;
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _didRecover) return;
      _didRecover = true;
      context.read<AuthBloc>().add(const AuthIsUserLoggedInEvent());
    });
  }

  @override
  Widget build(BuildContext context) => BlocListener<AuthBloc, AuthState>(
    listener: (context, state) {
      if (state is AuthLoggedIn) {
        context.go(RouteNames.home);
        return;
      }

      if (state is AuthLoggedOut ||
          state is AuthUnAuthenticated ||
          state is AuthFailure) {
        context.read<OnboardingCubit>().initialize();
        return;
      }
    },
    child: BlocListener<OnboardingCubit, OnboardingState>(
      listener: (context, state) {
        switch (state) {
          case OnboardingSession():
            context.go(RouteNames.onboarding);
            break;
          case OnboardingCompleted():
          case OnboardingError():
            context.go(RouteNames.welcome);
            break;
          default:
            break;
        }
      },
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
          systemNavigationBarColor: AppColors.neutralEggShell60,
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
        child: Scaffold(
          backgroundColor: AppColors.neutralEggShell60,
          body: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  AppConstants.logoImage,
                  height: logoHeight,
                  width: logoWidth,
                ),
                UIGaps.w16,
                Text(AppConstants.appName, style: AppTextStyles.h1),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpt_ojt/app/router/route_names.dart';
import 'package:fpt_ojt/features/intro/presentation/blocs/onboarding/onboarding_cubit.dart';
import 'package:fpt_ojt/features/intro/presentation/blocs/onboarding/onboarding_state.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) =>
      BlocListener<OnboardingCubit, OnboardingState>(
        listener: (_, state) {
          switch (state) {
            case OnboardingSession():
              context.go(RouteNames.onboarding);
            case OnboardingCompleted():
              context.go(RouteNames.welcome);
            case OnboardingError():
              context.go(RouteNames.welcome);
            case OnboardingInitial():
              break;
            case OnboardingLoading():
              break;
            default:
              break;
          }
        },
        child: Scaffold(
          body: Center(
            child: Text(
              'Splash Screen',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),
        ),
      );
}

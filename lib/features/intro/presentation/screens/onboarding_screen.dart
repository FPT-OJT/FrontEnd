import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpt_ojt/app/router/route_names.dart';
import 'package:fpt_ojt/core/theme/app_colors.dart';
import 'package:fpt_ojt/core/theme/ui_gaps.dart';
import 'package:fpt_ojt/features/intro/domain/entities/onboarding_item.dart';
import 'package:fpt_ojt/features/intro/presentation/blocs/onboarding/onboarding_cubit.dart';
import 'package:fpt_ojt/features/intro/presentation/blocs/onboarding/onboarding_state.dart';
import 'package:fpt_ojt/features/intro/presentation/widgets/onboarding/onboarding_controls.dart';
import 'package:fpt_ojt/features/intro/presentation/widgets/onboarding/onboarding_indicator.dart';
import 'package:fpt_ojt/features/intro/presentation/widgets/onboarding/onboarding_page.dart';
import 'package:go_router/go_router.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = PageController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      context.read<OnboardingCubit>().pageChanged(_controller.page ?? 0);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _getStarted() {
    context.read<OnboardingCubit>().complete();
    context.go(RouteNames.welcome);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: BlocBuilder<OnboardingCubit, OnboardingState>(
      builder: (context, state) {
        if (state is! OnboardingSession) {
          return const SizedBox.shrink();
        }
        final onboardingSessionState = state;
        return Container(
          color: AppColors.neutralEggShell60,
          padding: const EdgeInsets.only(
            top: 48,
            bottom: 20,
            left: 20,
            right: 20,
          ),
          child: Column(
            children: [
              Expanded(child: _buildPageView()),
              UIGaps.h20,
              Column(
                children: [
                  OnboardingIndicator(
                    itemCount: onboardingSessionState.items.length,
                    activeIndex: onboardingSessionState.currentIndex,
                  ),
                  UIGaps.h20,
                  OnboardingControls(
                    showButton: onboardingSessionState
                        .items[onboardingSessionState.currentIndex]
                        .showGetStarted,
                    onGetStarted: _getStarted,
                  ),
                ],
              ),

              UIGaps.h24,
            ],
          ),
        );
      },
    ),
  );

  Widget _buildPageView() =>
      BlocSelector<OnboardingCubit, OnboardingState, int>(
        selector: (state) =>
            state is OnboardingSession ? state.items.length : 0,
        builder: (context, itemCount) => PageView.builder(
          controller: _controller,
          itemCount: itemCount,
          physics: const BouncingScrollPhysics(),
          itemBuilder: (context, index) => _buildPageItem(index),
        ),
      );

  Widget _buildPageItem(int index) =>
      BlocSelector<
        OnboardingCubit,
        OnboardingState,
        (double, List<OnboardingItem>)
      >(
        selector: (state) {
          //  state is OnboardingSession ? state.page : 0,
          if (state is OnboardingSession) {
            final onboardingSessionState = state;
            return (onboardingSessionState.page, onboardingSessionState.items);
          } else {
            return (0.0, []);
          }
        },
        builder: (context, data) {
          final distance = (index - data.$1).abs().clamp(0.0, 1.0);
          final scale = 1 - 0.06 * distance;
          final opacity = 1 - 0.35 * distance;
          final dx = 24 * (index - data.$1);

          return Transform.translate(
            offset: Offset(dx, 0),
            child: Transform.scale(
              scale: scale,
              child: Opacity(
                opacity: opacity,
                child: OnboardingPage(item: data.$2[index]),
              ),
            ),
          );
        },
      );
}

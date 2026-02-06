import 'package:flutter/material.dart';
import 'package:fpt_ojt/app/router/route_names.dart';
import 'package:fpt_ojt/features/auth/presentation/screens/login_details_screen.dart';
import 'package:fpt_ojt/features/auth/presentation/screens/login_options_screen.dart';
import 'package:fpt_ojt/features/auth/presentation/screens/signup_details_screen.dart';
import 'package:fpt_ojt/features/home/presentation/screens/home_screen.dart';
import 'package:fpt_ojt/features/intro/presentation/screens/onboarding_screen.dart';
import 'package:fpt_ojt/features/intro/presentation/screens/splash_screen.dart';
import 'package:fpt_ojt/features/intro/presentation/screens/welcome_screen.dart';
import 'package:fpt_ojt/features/merchants/presentations/screens/search_screen.dart';
import 'package:fpt_ojt/features/shared/constants/navigation.dart';
import 'package:fpt_ojt/features/shared/widgets/app_bottom_navbar.dart';
import 'package:fpt_ojt/features/wallet/presentation/screens/wallet_screen.dart';
import 'package:go_router/go_router.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final goRouter = GoRouter(
  initialLocation: RouteNames.splash,
  debugLogDiagnostics: true,
  navigatorKey: _rootNavigatorKey,
  routes: [
    GoRoute(
      path: RouteNames.onboarding,
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: RouteNames.splash,
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: RouteNames.welcome,
      builder: (context, state) => const WelcomeScreen(),
    ),
    GoRoute(
      path: RouteNames.loginOptions,
      builder: (context, state) => const LoginOptionsScreen(),
    ),
    GoRoute(
      path: RouteNames.loginDetails,
      builder: (context, state) => const LoginDetailsScreen(),
    ),
    GoRoute(
      path: RouteNames.registerDetails,
      builder: (context, state) => const SignupDetailsScreen(),
    ),
    GoRoute(
      path: RouteNames.search,
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const SearchScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            FadeTransition(opacity: animation, child: child),
      ),
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) => Scaffold(
        body: navigationShell, // Nội dung của tab hiện tại
        bottomNavigationBar: AppBottomNavigationBar(
          items: bottomNavigationItems,
          currentIndex: navigationShell.currentIndex,
          onTap: (index) {
            // Logic chuyển trang của GoRouter
            navigationShell.goBranch(
              index,
              // A common pattern when clicking the current tab is to reset it
              initialLocation: index == navigationShell.currentIndex,
            );
          },
        ),
      ),
      branches: [
        // Tab 1: Call
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: RouteNames.home,
              builder: (context, state) => const HomeScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: RouteNames.wallet,
              builder: (context, state) => const WalletScreen(),
            ),
          ],
        ),
        // Tab 3: Settings
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: RouteNames.profile,
              builder: (context, state) =>
                  const Scaffold(body: Center(child: Text('Profile'))),
            ),
          ],
        ),
      ],
    ),
  ],
);

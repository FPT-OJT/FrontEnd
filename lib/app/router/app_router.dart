import 'package:fpt_ojt/app/router/route_names.dart';
import 'package:fpt_ojt/features/auth/presentation/screens/welcome_screen.dart';
import 'package:fpt_ojt/features/intro/presentation/screens/onboarding_screen.dart';
import 'package:fpt_ojt/features/intro/presentation/screens/splash_screen.dart';
import 'package:go_router/go_router.dart';

final goRouter = GoRouter(
  initialLocation: RouteNames.splash,
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
  ],
);

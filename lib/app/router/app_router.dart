import 'package:fpt_ojt/app/router/route_names.dart';
import 'package:fpt_ojt/features/auth/presentation/screens/login_details_screen.dart';
import 'package:fpt_ojt/features/auth/presentation/screens/login_options_screen.dart';
import 'package:fpt_ojt/features/auth/presentation/screens/signup_details_screen.dart';
import 'package:fpt_ojt/features/intro/presentation/screens/onboarding_screen.dart';
import 'package:fpt_ojt/features/intro/presentation/screens/splash_screen.dart';
import 'package:fpt_ojt/features/intro/presentation/screens/welcome_screen.dart';
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
  ],
);

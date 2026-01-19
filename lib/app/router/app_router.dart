import 'package:fpt_ojt/app/router/route_names.dart';
import 'package:fpt_ojt/features/intro/presentation/screens/onboarding_screen.dart';
import 'package:go_router/go_router.dart';

final goRouter = GoRouter(
  initialLocation: RouteNames.onboarding,
  routes: [
    GoRoute(
      path: RouteNames.onboarding,
      builder: (context, state) => const OnboardingScreen(),
    ),
  ],
);

import 'package:fpt_ojt/app/router/route_names.dart';
import 'package:fpt_ojt/features/intro/presentation/screens/splash_screen.dart';
import 'package:go_router/go_router.dart';

final goRouter = GoRouter(
  initialLocation: RouteNames.splash,
  routes: [
    GoRoute(
      path: RouteNames.splash,
      builder: (context, state) => const SplashScreen(),
    ),
  ],
);

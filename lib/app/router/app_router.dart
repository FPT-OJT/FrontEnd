import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpt_ojt/app/router/route_names.dart';
import 'package:fpt_ojt/features/ai/presentation/blocs/ai_chat/ai_chat_bloc.dart';
import 'package:fpt_ojt/features/ai/presentation/screens/ai_screens.dart';
import 'package:fpt_ojt/features/auth/presentation/screens/login_details_screen.dart';
import 'package:fpt_ojt/features/auth/presentation/screens/login_options_screen.dart';
import 'package:fpt_ojt/features/auth/presentation/screens/signup_details_screen.dart';
import 'package:fpt_ojt/features/card/presentation/screens/card_setting_screen.dart';
import 'package:fpt_ojt/features/card/presentation/screens/search_screen.dart'
    as card_search;
import 'package:fpt_ojt/features/home/presentation/screens/home_screen.dart';
import 'package:fpt_ojt/features/intro/presentation/screens/onboarding_screen.dart';
import 'package:fpt_ojt/features/intro/presentation/screens/splash_screen.dart';
import 'package:fpt_ojt/features/intro/presentation/screens/welcome_screen.dart';
import 'package:fpt_ojt/features/location/presentation/screens/live_map_screen.dart';
import 'package:fpt_ojt/features/merchants/presentation/screens/calculator_screen.dart';
import 'package:fpt_ojt/features/merchants/presentation/screens/detail_screen.dart';
import 'package:fpt_ojt/features/merchants/presentation/screens/search_screen.dart';
import 'package:fpt_ojt/features/profile/presentations/screens/edit_profile_screen.dart';
import 'package:fpt_ojt/features/profile/presentations/screens/notification_setting.dart';
import 'package:fpt_ojt/features/profile/presentations/screens/profle_tab.dart';
import 'package:fpt_ojt/features/profile/presentations/screens/terms_screen.dart';
import 'package:fpt_ojt/features/shared/constants/navigation.dart';
import 'package:fpt_ojt/features/shared/widgets/app_bottom_navbar.dart';
import 'package:fpt_ojt/features/wallet/presentation/screens/card_details.dart';
import 'package:fpt_ojt/features/wallet/presentation/screens/wallet_screen.dart';
import 'package:get_it/get_it.dart';
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
    GoRoute(
      path: RouteNames.merchantDetail,
      builder: (context, state) =>
          MerchantDetailScreen(merchantId: state.pathParameters['merchantId']!),
    ),
    GoRoute(
      path: RouteNames.cardSearch,
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const card_search.SearchScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            FadeTransition(opacity: animation, child: child),
      ),
    ),
    GoRoute(
      path: RouteNames.editAccount,
      builder: (context, state) => const EditProfileScreen(),
    ),
    GoRoute(
      path: RouteNames.notificationSettings,
      builder: (context, state) => const NotificationSettingScreen(),
    ),
    GoRoute(
      path: RouteNames.termsConditions,
      builder: (context, state) => const TermsScreen(),
    ),
    GoRoute(
      path: '${RouteNames.cardDetails}/:cardId',
      builder: (context, state) {
        final cardId = state.pathParameters['cardId'] ?? '';
        return CardDetails(cardId: cardId);
      },
    ),
    GoRoute(
      path: '${RouteNames.cardSettings}/:cardId',
      builder: (context, state) {
        final cardId = state.pathParameters['cardId'] ?? '';
        return CardSettingScreen(cardId: cardId);
      },
    ),
    GoRoute(
      path: RouteNames.aiSuggestion,
      builder: (context, state) => BlocProvider(
        create: (_) => GetIt.instance<AiChatBloc>(),
        child: const AiScreens(),
      ),
    ),
    GoRoute(
      path: RouteNames.liveMap,
      builder: (context, _) => const LiveMapScreen(),
    ),
    GoRoute(
      path: RouteNames.merchantDealCalculator,
      builder: (context, state) =>
          CalculatorScreen(merchantId: state.pathParameters['merchantId']!),
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
              builder: (context, state) => const ProfileTab(),
            ),
          ],
        ),
      ],
    ),
  ],
);

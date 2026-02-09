import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:fpt_ojt/app/router/app_router.dart';
import 'package:fpt_ojt/app/router/route_names.dart';
import 'package:fpt_ojt/core/theme/app_theme.dart';
import 'package:fpt_ojt/features/auth/presentation/blocs/auth/auth_bloc.dart';
import 'package:fpt_ojt/features/auth/presentation/blocs/auth/auth_state.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FlutterNativeSplash.remove();
    });

    return BlocListener<AuthBloc, AuthState>(
      listener: _authListener,
      child: MaterialApp.router(
        routerConfig: goRouter,
        title: 'Minstant',
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.light,
        theme: AppTheme.light(),
      ),
    );
  }

  void _authListener(BuildContext context, AuthState state) {
    // Global authentication error handler
    // Automatically navigate to login when authentication fails
    if (state is AuthUnAuthenticated || state is AuthLoggedOut) {
      goRouter.go(RouteNames.loginOptions);
    }
  }
}

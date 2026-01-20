import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpt_ojt/app/router/route_names.dart';
import 'package:fpt_ojt/features/auth/presentation/blocs/auth/auth_bloc.dart';
import 'package:fpt_ojt/features/auth/presentation/blocs/auth/auth_state.dart';
import 'package:fpt_ojt/features/shared/utils/snackbar_utils.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) => BlocConsumer<AuthBloc, AuthState>(
    listener: (context, state) {
      if (state is AuthFailure || state is AuthUnAuthenticated) {
        SnackBarUtils.showError(context, "Please login to continue");
        context.go(RouteNames.loginOptions);
        return;
      }
      if (state is AuthLoggedIn) {
        SnackBarUtils.showSuccess(context, "Welcome back ${state.user.name}");
        return;
      }
    },
    builder: (context, state) => Scaffold(
      body: Center(
        child: Text('Home ${state is AuthLoggedIn ? state.user.name : ''}'),
      ),
    ),
  );
}

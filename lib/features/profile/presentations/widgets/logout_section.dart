import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpt_ojt/app/router/route_names.dart';
import 'package:fpt_ojt/core/theme/ui_gaps.dart';
import 'package:fpt_ojt/features/auth/presentation/blocs/auth/auth_bloc.dart';
import 'package:fpt_ojt/features/auth/presentation/blocs/auth/auth_event.dart';
import 'package:fpt_ojt/features/profile/presentations/constants/profile_tab.dart';
import 'package:fpt_ojt/features/shared/widgets/outlined_primary_button.dart';
import 'package:go_router/go_router.dart';

class LogoutSection extends StatelessWidget {
  const LogoutSection({super.key});

  @override
  Widget build(BuildContext context) => SizedBox(
    width: double.infinity,
    height: UIGaps.size48,
    child: OutlinedPrimaryButton(
      onPressed: () {
        context.read<AuthBloc>().add(const AuthLoggedOutEvent());
        context.go(RouteNames.loginOptions);
      },
      text: ProfileTabConstants.logoutButtonText,
    ),
  );
}

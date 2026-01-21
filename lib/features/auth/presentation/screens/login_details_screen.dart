import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpt_ojt/app/di/init_dependencies.dart';
import 'package:fpt_ojt/app/router/route_names.dart';
import 'package:fpt_ojt/core/theme/app_colors.dart';
import 'package:fpt_ojt/core/theme/app_text_styles.dart';
import 'package:fpt_ojt/core/theme/ui_gaps.dart';
import 'package:fpt_ojt/features/auth/presentation/blocs/auth/auth_bloc.dart';
import 'package:fpt_ojt/features/auth/presentation/blocs/auth/auth_event.dart';
import 'package:fpt_ojt/features/auth/presentation/blocs/forgot_password/forgot_password_bloc.dart';
import 'package:fpt_ojt/features/auth/presentation/blocs/forgot_password/forgot_password_event.dart';
import 'package:fpt_ojt/features/auth/presentation/blocs/login_details/login_details_bloc.dart';
import 'package:fpt_ojt/features/auth/presentation/blocs/login_details/login_details_event.dart';
import 'package:fpt_ojt/features/auth/presentation/blocs/login_details/login_details_state.dart';
import 'package:fpt_ojt/features/auth/presentation/widgets/auth_bottom_section.dart';
import 'package:fpt_ojt/features/auth/presentation/widgets/custom_text_field.dart';
import 'package:fpt_ojt/features/auth/presentation/widgets/forgot_password_bottom_sheet.dart';
import 'package:fpt_ojt/features/auth/presentation/widgets/password_text_field.dart';
import 'package:fpt_ojt/features/shared/utils/snackbar_utils.dart';
import 'package:go_router/go_router.dart';

class LoginDetailsScreen extends StatefulWidget {
  const LoginDetailsScreen({super.key});

  @override
  State<LoginDetailsScreen> createState() => _LoginDetailsScreenState();
}

class _LoginDetailsScreenState extends State<LoginDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;
  bool _rememberMe = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    // Bật autovalidate sau lần validate đầu tiên
    if (_autovalidateMode == AutovalidateMode.disabled) {
      setState(() {
        _autovalidateMode = AutovalidateMode.onUserInteraction;
      });
    }

    if (_formKey.currentState?.validate() ?? false) {
      context.read<LoginDetailsBloc>().add(
        LoginSubmitted(
          email: _usernameController.text.trim(),
          password: _passwordController.text,
          rememberMe: _rememberMe,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocListener<LoginDetailsBloc, LoginDetailsState>(
      listener: (context, state) {
        switch (state) {
          case LoginSubmitting _:
            return;
          case final LoginSuccess loginSuccess:
            final user = loginSuccess.user;
            SnackBarUtils.showSuccess(context, 'Login successful!');
            context.read<AuthBloc>().add(AuthLoggedInEvent(user: user));
            context.go(RouteNames.home);
          case final LoginFailure loginFailure:
            SnackBarUtils.showError(context, loginFailure.message);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.neutralEggShell60,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Form(
                key: _formKey,
                autovalidateMode: _autovalidateMode,
                child: Column(
                  children: [
                    UIGaps.h8,
                    _buildTitle(theme),
                    UIGaps.h32,
                    _buildIllustration(),
                    UIGaps.h40,
                    CustomTextField(
                      label: 'Username',
                      controller: _usernameController,
                      validator: _validateUsername,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    UIGaps.h20,
                    PasswordTextField(
                      label: 'Password',
                      controller: _passwordController,
                      validator: _validatePassword,
                    ),
                    UIGaps.h12,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildRememberMeCheckbox(theme),
                        _buildForgotPasswordLink(theme),
                      ],
                    ),
                    UIGaps.h32,
                    _buildLoginButton(theme),
                    UIGaps.h32,
                    const AuthBottomSection(
                      promptText: "Don't have an account?",
                      actionText: 'Sign up now',
                      routeName: RouteNames.registerDetails,
                    ),
                    UIGaps.h24,
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitle(ThemeData theme) => Text(
    'Log in:',
    style: theme.textTheme.headlineLarge?.copyWith(
      color: AppColors.secondaryNavy,
      fontWeight: FontWeight.bold,
      fontSize: 28,
    ),
    textAlign: TextAlign.center,
  );

  Widget _buildIllustration() => SizedBox(
    height: 210,
    child: Image.asset('assets/images/welcome_image.png', fit: BoxFit.contain),
  );

  Widget _buildRememberMeCheckbox(ThemeData theme) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      SizedBox(
        height: 24,
        width: 24,
        child: Checkbox(
          value: _rememberMe,
          onChanged: (value) {
            setState(() {
              _rememberMe = value ?? false;
            });
          },
          activeColor: AppColors.secondaryCoral,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
      ),
      UIGaps.w8,
      GestureDetector(
        onTap: () {
          setState(() {
            _rememberMe = !_rememberMe;
          });
        },
        child: Text(
          'Remember me',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: AppColors.secondaryNavy,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    ],
  );

  Widget _buildForgotPasswordLink(ThemeData theme) => TextButton(
    onPressed: _showForgotPasswordBottomSheet,
    style: TextButton.styleFrom(
      padding: EdgeInsets.zero,
      minimumSize: Size.zero,
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
    ),
    child: Text(
      'Forgot password?',
      style: theme.textTheme.bodyMedium?.copyWith(
        color: AppColors.secondaryCoral,
        fontWeight: FontWeight.w600,
      ),
    ),
  );

  void _showForgotPasswordBottomSheet() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => BlocProvider(
        create: (context) =>
            serviceLocator<ForgotPasswordBloc>()
              ..add(ResetForgotPasswordFlow()),
        child: const ForgotPasswordBottomSheet(),
      ),
    );
  }

  Widget _buildLoginButton(ThemeData theme) =>
      BlocBuilder<LoginDetailsBloc, LoginDetailsState>(
        builder: (context, state) {
          final isLoading = state is LoginSubmitting;
          return SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: isLoading ? null : _handleLogin,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.secondaryCoral,
                foregroundColor: AppColors.neutralWhite,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
                disabledBackgroundColor: AppColors.secondaryCoral.withAlpha(
                  135,
                ),
              ),
              child: isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.neutralWhite,
                        ),
                      ),
                    )
                  : Text('Log in', style: AppTextStyles.button),
            ),
          );
        },
      );

  String? _validateUsername(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Username is required';
    }

    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    return null;
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpt_ojt/app/di/init_dependencies.dart';
import 'package:fpt_ojt/app/router/route_names.dart';
import 'package:fpt_ojt/core/theme/app_colors.dart';
import 'package:fpt_ojt/core/theme/app_text_styles.dart';
import 'package:fpt_ojt/core/theme/borders.dart';
import 'package:fpt_ojt/core/theme/rounded.dart';
import 'package:fpt_ojt/core/theme/ui_gaps.dart';
import 'package:fpt_ojt/core/utils/validators.dart';
import 'package:fpt_ojt/features/auth/presentation/blocs/auth/auth_bloc.dart';
import 'package:fpt_ojt/features/auth/presentation/blocs/auth/auth_event.dart';
import 'package:fpt_ojt/features/auth/presentation/blocs/forgot_password/forgot_password_bloc.dart';
import 'package:fpt_ojt/features/auth/presentation/blocs/forgot_password/forgot_password_event.dart';
import 'package:fpt_ojt/features/auth/presentation/blocs/login_details/login_details_bloc.dart';
import 'package:fpt_ojt/features/auth/presentation/blocs/login_details/login_details_event.dart';
import 'package:fpt_ojt/features/auth/presentation/blocs/login_details/login_details_state.dart';
import 'package:fpt_ojt/features/auth/presentation/constants/login_details.dart';
import 'package:fpt_ojt/features/auth/presentation/constants/validations.dart';
import 'package:fpt_ojt/features/auth/presentation/widgets/auth_bottom_section.dart';
import 'package:fpt_ojt/features/auth/presentation/widgets/custom_text_field.dart';
import 'package:fpt_ojt/features/auth/presentation/widgets/forgot_password_bottom_sheet.dart';
import 'package:fpt_ojt/features/auth/presentation/widgets/password_text_field.dart';
import 'package:fpt_ojt/features/shared/utils/snackbar_utils.dart';
import 'package:fpt_ojt/l10n/app_localizations.dart';
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
            SnackBarUtils.showSuccess(
              context,
              AppLocalizations.of(
                context,
              )!.login_details_login_successful_message,
            );
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
              padding: const EdgeInsets.symmetric(horizontal: UIGaps.size24),
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
                      label: AppLocalizations.of(
                        context,
                      )!.login_details_username_label,
                      controller: _usernameController,
                      validator: Validators.compose([
                        Validators.required(
                          message: AppLocalizations.of(
                            context,
                          )!.username_required_error,
                        ),
                        Validators.minLen(
                          ValidationsConstants.usernameMinLength,
                          message: AppLocalizations.of(context)!
                              .username_min_length_error(
                                ValidationsConstants.usernameMinLength,
                              ),
                        ),
                        Validators.maxLen(
                          ValidationsConstants.usernameMaxLength,
                          message: AppLocalizations.of(context)!
                              .username_max_length_error(
                                ValidationsConstants.usernameMaxLength,
                              ),
                        ),
                        Validators.email(
                          message: AppLocalizations.of(
                            context,
                          )!.username_invalid_error,
                        ),
                      ]),
                      keyboardType: TextInputType.text,
                    ),
                    UIGaps.h20,
                    PasswordTextField(
                      label: AppLocalizations.of(
                        context,
                      )!.login_details_password_label,
                      controller: _passwordController,
                      validator: Validators.compose([
                        Validators.required(
                          message: AppLocalizations.of(
                            context,
                          )!.password_required_error,
                        ),
                        Validators.minLen(
                          ValidationsConstants.passwordMinLength,
                          message: AppLocalizations.of(context)!
                              .password_min_length_error(
                                ValidationsConstants.passwordMinLength,
                              ),
                        ),
                        Validators.maxLen(
                          ValidationsConstants.passwordMaxLength,
                          message: AppLocalizations.of(context)!
                              .password_max_length_error(
                                ValidationsConstants.passwordMaxLength,
                              ),
                        ),
                      ]),
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
                    AuthBottomSection(
                      promptText: AppLocalizations.of(
                        context,
                      )!.login_details_signup_prompt,
                      actionText: AppLocalizations.of(
                        context,
                      )!.login_details_signup_now,
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
    AppLocalizations.of(context)!.login_details_login_title,
    style: AppTextStyles.h2.copyWith(color: AppColors.secondaryNavy),
    textAlign: TextAlign.center,
  );

  Widget _buildIllustration() => SizedBox(
    height: LoginDetailsConstants.imageHeight,
    child: Image.asset(LoginDetailsConstants.welcomeImage, fit: BoxFit.contain),
  );

  Widget _buildRememberMeCheckbox(ThemeData theme) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      SizedBox(
        height: UIGaps.size24,
        width: UIGaps.size24,
        child: Checkbox(
          value: _rememberMe,
          onChanged: (value) {
            setState(() {
              _rememberMe = value ?? false;
            });
          },
          activeColor: AppColors.secondaryCoral,
          shape: RoundedRectangleBorder(borderRadius: Rounded.xs),
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
          AppLocalizations.of(context)!.login_details_remember_me_label,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.secondaryNavy,
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
      AppLocalizations.of(context)!.login_details_forgot_password_label,
      style: AppTextStyles.bodySmall.copyWith(color: AppColors.secondaryCoral),
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
            height: UIGaps.size48,
            child: ElevatedButton(
              onPressed: isLoading ? null : _handleLogin,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.secondaryCoral,
                foregroundColor: AppColors.neutralWhite,
                shape: RoundedRectangleBorder(borderRadius: Rounded.md),
                elevation: 0,
                disabledBackgroundColor: AppColors.secondaryCoralDisabled,
              ),
              child: isLoading
                  ? const SizedBox(
                      height: UIGaps.size20,
                      width: UIGaps.size20,
                      child: CircularProgressIndicator(
                        strokeWidth: Borders.xs,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.neutralWhite,
                        ),
                      ),
                    )
                  : Text(
                      AppLocalizations.of(context)!.login_details_login_button,
                      style: AppTextStyles.button,
                    ),
            ),
          );
        },
      );
}

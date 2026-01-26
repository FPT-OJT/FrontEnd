import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpt_ojt/app/di/init_dependencies.dart';
import 'package:fpt_ojt/app/router/route_names.dart';
import 'package:fpt_ojt/core/theme/app_colors.dart';
import 'package:fpt_ojt/core/theme/app_text_styles.dart';
import 'package:fpt_ojt/core/theme/borders.dart';
import 'package:fpt_ojt/core/theme/rounded.dart';
import 'package:fpt_ojt/core/theme/shadows.dart';
import 'package:fpt_ojt/core/theme/ui_gaps.dart';
import 'package:fpt_ojt/core/utils/validators.dart';
import 'package:fpt_ojt/features/auth/presentation/blocs/auth/auth_bloc.dart';
import 'package:fpt_ojt/features/auth/presentation/blocs/auth/auth_event.dart';
import 'package:fpt_ojt/features/auth/presentation/blocs/register/register_bloc.dart';
import 'package:fpt_ojt/features/auth/presentation/blocs/register/register_event.dart';
import 'package:fpt_ojt/features/auth/presentation/blocs/register/register_state.dart';
import 'package:fpt_ojt/features/auth/presentation/constants/validations.dart';
import 'package:fpt_ojt/features/auth/presentation/widgets/auth_bottom_section.dart';
import 'package:fpt_ojt/features/auth/presentation/widgets/custom_text_field.dart';
import 'package:fpt_ojt/features/auth/presentation/widgets/password_text_field.dart';
import 'package:fpt_ojt/features/shared/utils/snackbar_utils.dart';
import 'package:fpt_ojt/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

class SignupDetailsScreen extends StatelessWidget {
  const SignupDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (context) => serviceLocator<RegisterBloc>(),
    child: const _SignupDetailsView(),
  );
}

class _SignupDetailsView extends StatefulWidget {
  const _SignupDetailsView();

  @override
  State<_SignupDetailsView> createState() => _SignupDetailsScreenState();
}

class _SignupDetailsScreenState extends State<_SignupDetailsView> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _repeatPasswordController = TextEditingController();
  final _emailController = TextEditingController();
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _repeatPasswordController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _handleCreateAccount() {
    // Bật autovalidate sau lần validate đầu tiên
    if (_autovalidateMode == AutovalidateMode.disabled) {
      setState(() {
        _autovalidateMode = AutovalidateMode.onUserInteraction;
      });
    }

    if (_formKey.currentState?.validate() ?? false) {
      context.read<RegisterBloc>().add(
        RegisterSubmitted(
          firstName: _firstNameController.text.trim(),
          lastName: _lastNameController.text.trim(),
          username: _usernameController.text.trim(),
          password: _passwordController.text,
          repeatPassword: _repeatPasswordController.text,
          email: _emailController.text.trim(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocListener<RegisterBloc, RegisterState>(
      listener: (context, state) {
        if (state is RegisterSubmitting) {
        } else if (state is RegisterSuccess) {
          final user = state.user;
          SnackBarUtils.showSuccess(
            context,
            AppLocalizations.of(
              context,
            )!.signup_details_signup_successful_message,
          );
          context.read<AuthBloc>().add(AuthLoggedInEvent(user: user));
          context.go(RouteNames.home);
        } else if (state is RegisterFailure) {
          SnackBarUtils.showError(context, state.message);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.neutralEggShell60,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: UIGaps.size24),
            child: Form(
              key: _formKey,
              autovalidateMode: _autovalidateMode,
              child: Column(
                children: [
                  UIGaps.h40,
                  _buildTitle(theme),
                  UIGaps.h32,
                  CustomTextField(
                    label: AppLocalizations.of(
                      context,
                    )!.signup_details_first_name_label,
                    controller: _firstNameController,
                    validator: Validators.compose([
                      Validators.required(
                        message: AppLocalizations.of(
                          context,
                        )!.first_name_required_error,
                      ),
                      Validators.minLen(
                        ValidationsConstants.firstNameMinLength,
                        message: AppLocalizations.of(context)!
                            .first_name_min_length_error(
                              ValidationsConstants.firstNameMinLength,
                            ),
                      ),
                      Validators.maxLen(
                        ValidationsConstants.firstNameMaxLength,
                        message: AppLocalizations.of(context)!
                            .first_name_max_length_error(
                              ValidationsConstants.firstNameMaxLength,
                            ),
                      ),
                    ]),
                    keyboardType: TextInputType.name,
                  ),
                  UIGaps.h20,
                  CustomTextField(
                    label: AppLocalizations.of(
                      context,
                    )!.signup_details_last_name_label,
                    controller: _lastNameController,
                    validator: Validators.compose([
                      Validators.required(
                        message: AppLocalizations.of(
                          context,
                        )!.last_name_required_error,
                      ),
                      Validators.minLen(
                        ValidationsConstants.lastNameMinLength,
                        message: AppLocalizations.of(context)!
                            .last_name_min_length_error(
                              ValidationsConstants.lastNameMinLength,
                            ),
                      ),
                      Validators.maxLen(
                        ValidationsConstants.lastNameMaxLength,
                        message: AppLocalizations.of(context)!
                            .last_name_max_length_error(
                              ValidationsConstants.lastNameMaxLength,
                            ),
                      ),
                    ]),
                    keyboardType: TextInputType.name,
                  ),
                  UIGaps.h20,
                  CustomTextField(
                    label: AppLocalizations.of(
                      context,
                    )!.signup_details_username_label,
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
                    ]),
                    keyboardType: TextInputType.text,
                  ),
                  UIGaps.h20,
                  CustomTextField(
                    label: AppLocalizations.of(
                      context,
                    )!.signup_details_email_label,
                    controller: _emailController,
                    validator: Validators.compose([
                      Validators.required(
                        message: AppLocalizations.of(
                          context,
                        )!.email_required_error,
                      ),
                      Validators.email(
                        message: AppLocalizations.of(
                          context,
                        )!.email_invalid_error,
                      ),
                    ]),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  UIGaps.h20,
                  PasswordTextField(
                    label: AppLocalizations.of(
                      context,
                    )!.signup_details_password_label,
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
                  UIGaps.h20,
                  PasswordTextField(
                    label: AppLocalizations.of(
                      context,
                    )!.signup_details_confirm_password_label,
                    controller: _repeatPasswordController,
                    validator: Validators.compose([
                      Validators.required(
                        message: AppLocalizations.of(
                          context,
                        )!.password_confirmation_required_error,
                      ),
                      Validators.minLen(
                        ValidationsConstants.passwordConfirmationMinLength,
                        message: AppLocalizations.of(context)!
                            .password_confirmation_min_length_error(
                              ValidationsConstants
                                  .passwordConfirmationMinLength,
                            ),
                      ),
                      Validators.maxLen(
                        ValidationsConstants.passwordConfirmationMaxLength,
                        message: AppLocalizations.of(context)!
                            .password_confirmation_max_length_error(
                              ValidationsConstants
                                  .passwordConfirmationMaxLength,
                            ),
                      ),
                      Validators.sameAs(
                        () => _passwordController.text,
                        message: AppLocalizations.of(
                          context,
                        )!.password_confirmation_match_error,
                      ),
                    ]),
                  ),
                  UIGaps.h40,
                  _buildCreateAccountButton(theme),
                  UIGaps.h32,
                  AuthBottomSection(
                    promptText: AppLocalizations.of(
                      context,
                    )!.signup_details_login_prompt,
                    actionText: AppLocalizations.of(
                      context,
                    )!.signup_details_login_now,
                    routeName: RouteNames.loginDetails,
                  ),
                  UIGaps.h24,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitle(ThemeData theme) => Text(
    AppLocalizations.of(context)!.signup_details_signup_title,
    style: AppTextStyles.h2,
    textAlign: TextAlign.center,
  );

  Widget _buildCreateAccountButton(ThemeData theme) =>
      BlocBuilder<RegisterBloc, RegisterState>(
        builder: (context, state) {
          final isLoading = state is RegisterSubmitting;
          return SizedBox(
            width: double.infinity,
            height: UIGaps.size48,
            child: ElevatedButton(
              onPressed: isLoading ? null : _handleCreateAccount,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.secondaryCoral,
                foregroundColor: AppColors.neutralWhite,
                shape: RoundedRectangleBorder(borderRadius: Rounded.md),
                elevation: Shadows.none,
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
                      AppLocalizations.of(
                        context,
                      )!.signup_details_signup_button,
                      style: AppTextStyles.button,
                    ),
            ),
          );
        },
      );
}

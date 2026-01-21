import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpt_ojt/app/di/init_dependencies.dart';
import 'package:fpt_ojt/app/router/route_names.dart';
import 'package:fpt_ojt/core/theme/app_colors.dart';
import 'package:fpt_ojt/core/theme/app_text_styles.dart';
import 'package:fpt_ojt/core/theme/ui_gaps.dart';
import 'package:fpt_ojt/core/utils/validators.dart';
import 'package:fpt_ojt/features/auth/presentation/blocs/auth/auth_bloc.dart';
import 'package:fpt_ojt/features/auth/presentation/blocs/auth/auth_event.dart';
import 'package:fpt_ojt/features/auth/presentation/blocs/register/register_bloc.dart';
import 'package:fpt_ojt/features/auth/presentation/blocs/register/register_event.dart';
import 'package:fpt_ojt/features/auth/presentation/blocs/register/register_state.dart';
import 'package:fpt_ojt/features/auth/presentation/constants/sigup_details.dart';
import 'package:fpt_ojt/features/auth/presentation/constants/validations.dart';
import 'package:fpt_ojt/features/auth/presentation/widgets/auth_bottom_section.dart';
import 'package:fpt_ojt/features/auth/presentation/widgets/custom_text_field.dart';
import 'package:fpt_ojt/features/auth/presentation/widgets/password_text_field.dart';
import 'package:fpt_ojt/features/shared/utils/snackbar_utils.dart';
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
            SignupDetailsConstants.signupSuccessMessage,
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
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Form(
              key: _formKey,
              autovalidateMode: _autovalidateMode,
              child: Column(
                children: [
                  UIGaps.h40,
                  _buildTitle(theme),
                  UIGaps.h32,
                  CustomTextField(
                    label: SignupDetailsConstants.firstNameLabel,
                    controller: _firstNameController,
                    validator: Validators.compose([
                      Validators.required(
                        message: ValidationsConstants.firstNameRequiredError,
                      ),
                      Validators.minLen(
                        ValidationsConstants.firstNameMinLength,
                        message: ValidationsConstants.firstNameMinLengthError,
                      ),
                      Validators.maxLen(
                        ValidationsConstants.firstNameMaxLength,
                        message: ValidationsConstants.firstNameMaxLengthError,
                      ),
                    ]),
                    keyboardType: TextInputType.name,
                  ),
                  UIGaps.h20,
                  CustomTextField(
                    label: SignupDetailsConstants.lastNameLabel,
                    controller: _lastNameController,
                    validator: Validators.compose([
                      Validators.required(
                        message: ValidationsConstants.lastNameRequiredError,
                      ),
                      Validators.minLen(
                        ValidationsConstants.lastNameMinLength,
                        message: ValidationsConstants.lastNameMinLengthError,
                      ),
                      Validators.maxLen(
                        ValidationsConstants.lastNameMaxLength,
                        message: ValidationsConstants.lastNameMaxLengthError,
                      ),
                    ]),
                    keyboardType: TextInputType.name,
                  ),
                  UIGaps.h20,
                  CustomTextField(
                    label: SignupDetailsConstants.usernameLabel,
                    controller: _usernameController,
                    validator: Validators.compose([
                      Validators.required(
                        message: ValidationsConstants.usernameRequiredError,
                      ),
                      Validators.minLen(
                        ValidationsConstants.usernameMinLength,
                        message: ValidationsConstants.usernameMinLengthError,
                      ),
                      Validators.maxLen(
                        ValidationsConstants.usernameMaxLength,
                        message: ValidationsConstants.usernameMaxLengthError,
                      ),
                    ]),
                    keyboardType: TextInputType.text,
                  ),
                  UIGaps.h20,
                  CustomTextField(
                    label: SignupDetailsConstants.emailLabel,
                    controller: _emailController,
                    validator: Validators.compose([
                      Validators.required(
                        message: ValidationsConstants.emailRequiredError,
                      ),
                      Validators.email(
                        message: ValidationsConstants.emailInvalidError,
                      ),
                    ]),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  UIGaps.h20,
                  PasswordTextField(
                    label: SignupDetailsConstants.passwordLabel,
                    controller: _passwordController,
                    validator: Validators.compose([
                      Validators.required(
                        message: ValidationsConstants.passwordRequiredError,
                      ),
                      Validators.minLen(
                        ValidationsConstants.passwordMinLength,
                        message: ValidationsConstants.passwordMinLengthError,
                      ),
                      Validators.maxLen(
                        ValidationsConstants.passwordMaxLength,
                        message: ValidationsConstants.passwordMaxLengthError,
                      ),
                    ]),
                  ),
                  UIGaps.h20,
                  PasswordTextField(
                    label: SignupDetailsConstants.confirmPasswordLabel,
                    controller: _repeatPasswordController,
                    validator: Validators.compose([
                      Validators.required(
                        message: ValidationsConstants
                            .passwordConfirmationRequiredError,
                      ),
                      Validators.minLen(
                        ValidationsConstants.passwordConfirmationMinLength,
                        message: ValidationsConstants
                            .passwordConfirmationMinLengthError,
                      ),
                      Validators.maxLen(
                        ValidationsConstants.passwordConfirmationMaxLength,
                        message: ValidationsConstants
                            .passwordConfirmationMaxLengthError,
                      ),
                      Validators.sameAs(
                        () => _passwordController.text,
                        message:
                            ValidationsConstants.passwordConfirmationMatchError,
                      ),
                    ]),
                  ),
                  UIGaps.h40,
                  _buildCreateAccountButton(theme),
                  UIGaps.h32,
                  const AuthBottomSection(
                    promptText: SignupDetailsConstants.loginPromptText,
                    actionText: SignupDetailsConstants.loginNowText,
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
    SignupDetailsConstants.signupTitle,
    style: AppTextStyles.h2,
    textAlign: TextAlign.center,
  );

  Widget _buildCreateAccountButton(ThemeData theme) =>
      BlocBuilder<RegisterBloc, RegisterState>(
        builder: (context, state) {
          final isLoading = state is RegisterSubmitting;
          return SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: isLoading ? null : _handleCreateAccount,
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
                  : Text(
                      SignupDetailsConstants.signupButtonText,
                      style: AppTextStyles.button,
                    ),
            ),
          );
        },
      );
}

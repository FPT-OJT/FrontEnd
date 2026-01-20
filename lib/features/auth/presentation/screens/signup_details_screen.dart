import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpt_ojt/app/di/init_dependencies.dart';
import 'package:fpt_ojt/app/router/route_names.dart';
import 'package:fpt_ojt/core/theme/app_colors.dart';
import 'package:fpt_ojt/core/theme/app_text_styles.dart';
import 'package:fpt_ojt/features/auth/presentation/blocs/register/register_bloc.dart';
import 'package:fpt_ojt/features/auth/presentation/blocs/register/register_event.dart';
import 'package:fpt_ojt/features/auth/presentation/blocs/register/register_state.dart';
import 'package:fpt_ojt/features/auth/presentation/widgets/auth_bottom_section.dart';
import 'package:fpt_ojt/features/auth/presentation/widgets/custom_text_field.dart';
import 'package:fpt_ojt/features/auth/presentation/widgets/password_text_field.dart';
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
          // Show loading indicator
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Creating account...'),
              duration: Duration(seconds: 1),
            ),
          );
        } else if (state is RegisterSuccess) {
          // Show success message and navigate
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Account created successfully!'),
              backgroundColor: Colors.green,
            ),
          );
          context.go(RouteNames.home);
        } else if (state is RegisterFailure) {
          // Show error message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.neutralEggShell60,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  _buildTitle(theme),
                  const SizedBox(height: 32),
                  CustomTextField(
                    label: 'First name',
                    controller: _firstNameController,
                    validator: _validateFirstName,
                    keyboardType: TextInputType.name,
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    label: 'Last name',
                    controller: _lastNameController,
                    validator: _validateLastName,
                    keyboardType: TextInputType.name,
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    label: 'Username',
                    controller: _usernameController,
                    validator: _validateUsername,
                    keyboardType: TextInputType.text,
                  ),
                  const SizedBox(height: 20),
                   CustomTextField(
                    label: 'Email',
                    controller: _emailController,
                    validator: _validateEmail,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 20),
                  PasswordTextField(
                    label: 'Password',
                    controller: _passwordController,
                    validator: _validatePassword,
                  ),
                  const SizedBox(height: 20),
                  PasswordTextField(
                    label: 'Repeat password',
                    controller: _repeatPasswordController,
                    validator: _validateRepeatPassword,
                  ),
                  const SizedBox(height: 40),
                  _buildCreateAccountButton(theme),
                  const SizedBox(height: 32),
                  const AuthBottomSection(
                    promptText: 'Already have an account?',
                    actionText: 'Log in now',
                    routeName: RouteNames.loginOptions,
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }
    if (!value.trim().contains('@')) {
      return 'Email is invalid';
    }
    return null;
  }

  Widget _buildTitle(ThemeData theme) => Text(
    'Create new account:',
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
                disabledBackgroundColor: AppColors.secondaryCoral.withOpacity(
                  0.6,
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
                  : Text('Create account', style: AppTextStyles.button),
            ),
          );
        },
      );

  // Validators
  String? _validateFirstName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'First name is required';
    }
    if (value.trim().length < 2) {
      return 'First name must be at least 2 characters';
    }
    return null;
  }

  String? _validateLastName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Last name is required';
    }
    if (value.trim().length < 2) {
      return 'Last name must be at least 2 characters';
    }
    return null;
  }

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
    if (value.length < 5) {
      return 'Password must be at least 5 characters';
    }
    return null;
  }

  String? _validateRepeatPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please repeat your password';
    }
    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }
}

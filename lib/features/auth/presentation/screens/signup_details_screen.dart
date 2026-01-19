import 'package:flutter/material.dart';
import 'package:fpt_ojt/app/router/route_names.dart';
import 'package:fpt_ojt/core/theme/app_colors.dart';
import 'package:fpt_ojt/features/auth/presentation/widgets/auth_bottom_section.dart';
import 'package:fpt_ojt/features/auth/presentation/widgets/custom_text_field.dart';
import 'package:fpt_ojt/features/auth/presentation/widgets/password_text_field.dart';

class SignupDetailsScreen extends StatefulWidget {
  const SignupDetailsScreen({super.key});

  @override
  State<SignupDetailsScreen> createState() => _SignupDetailsScreenState();
}

class _SignupDetailsScreenState extends State<SignupDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _repeatPasswordController = TextEditingController();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _repeatPasswordController.dispose();
    super.dispose();
  }

  void _handleCreateAccount() {
    if (_formKey.currentState?.validate() ?? false) {
      // TODO: Implement signup logic
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Creating account...')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
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
                  label: 'Repead password',
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
    );
  }

  Widget _buildTitle(ThemeData theme) => Text(
    'Create new account:',
    style: theme.textTheme.headlineLarge?.copyWith(
      color: AppColors.secondaryNavy,
      fontWeight: FontWeight.bold,
      fontSize: 28,
    ),
    textAlign: TextAlign.center,
  );

  Widget _buildCreateAccountButton(ThemeData theme) => SizedBox(
    width: double.infinity,
    height: 56,
    child: ElevatedButton(
      onPressed: _handleCreateAccount,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.secondaryCoral,
        foregroundColor: AppColors.neutralWhite,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 0,
      ),
      child: Text(
        'Create account',
        style: theme.textTheme.titleMedium?.copyWith(
          color: AppColors.neutralWhite,
          fontWeight: FontWeight.w600,
          fontSize: 18,
        ),
      ),
    ),
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
    // Check if it's an email format
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Please enter a valid email address';
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
    // Check for at least one uppercase letter
    if (!value.contains(RegExp('[A-Z]'))) {
      return 'Password must contain at least one uppercase letter';
    }
    // Check for at least one lowercase letter
    if (!value.contains(RegExp('[a-z]'))) {
      return 'Password must contain at least one lowercase letter';
    }
    // Check for at least one digit
    if (!value.contains(RegExp('[0-9]'))) {
      return 'Password must contain at least one number';
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

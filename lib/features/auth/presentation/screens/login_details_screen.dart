import 'package:flutter/material.dart';
import 'package:fpt_ojt/app/router/route_names.dart';
import 'package:fpt_ojt/core/theme/app_colors.dart';
import 'package:fpt_ojt/features/auth/presentation/widgets/auth_bottom_section.dart';
import 'package:fpt_ojt/features/auth/presentation/widgets/custom_text_field.dart';
import 'package:fpt_ojt/features/auth/presentation/widgets/password_text_field.dart';

class LoginDetailsScreen extends StatefulWidget {
  const LoginDetailsScreen({super.key});

  @override
  State<LoginDetailsScreen> createState() => _LoginDetailsScreenState();
}

class _LoginDetailsScreenState extends State<LoginDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_formKey.currentState?.validate() ?? false) {
      // TODO: Implement login logic
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Logging in...')));
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
                _buildIllustration(),
                const SizedBox(height: 40),
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
                const SizedBox(height: 40),
                _buildLoginButton(theme),
                const SizedBox(height: 32),
                const AuthBottomSection(
                  promptText: "Don't have an account?",
                  actionText: 'Sign up now',
                  routeName: RouteNames.registerDetails,
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

  Widget _buildLoginButton(ThemeData theme) => SizedBox(
    width: double.infinity,
    height: 48,
    child: ElevatedButton(
      onPressed: _handleLogin,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.secondaryCoral,
        foregroundColor: AppColors.neutralWhite,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 0,
      ),
      child: Text(
        'Log in',
        style: theme.textTheme.titleMedium?.copyWith(
          color: AppColors.neutralWhite,
          fontWeight: FontWeight.w600,
          fontSize: 18,
        ),
      ),
    ),
  );

  // Validators
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
    return null;
  }
}

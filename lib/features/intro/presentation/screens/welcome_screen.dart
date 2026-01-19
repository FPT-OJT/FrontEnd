import 'package:flutter/material.dart';
import 'package:fpt_ojt/app/router/route_names.dart';
import 'package:fpt_ojt/core/theme/app_colors.dart';
import 'package:go_router/go_router.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppColors.neutralEggShell60,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 60),
              _buildTitle(theme),
              const SizedBox(height: 16),
              _buildSubtitle(theme),
              const Spacer(),
              _buildIllustration(),
              const Spacer(),
              _buildLoginButton(context, theme),
              const SizedBox(height: 16),
              _buildSignUpButton(context, theme),
              const SizedBox(height: 32),
              _buildBrand(theme),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitle(ThemeData theme) => Text(
    'Welcome!',
    style: theme.textTheme.displayLarge?.copyWith(
      color: AppColors.secondaryNavy,
      fontWeight: FontWeight.bold,
      fontSize: 48,
    ),
  );

  Widget _buildSubtitle(ThemeData theme) => Text(
    'We help you make the most of your money.',
    style: theme.textTheme.bodyLarge?.copyWith(
      color: AppColors.secondaryNavy,
      fontSize: 16,
    ),
    textAlign: TextAlign.center,
  );

  Widget _buildIllustration() => Image.asset(
    'assets/images/welcome_image.png',
    height: 280,
    fit: BoxFit.contain,
  );

  Widget _buildLoginButton(BuildContext context, ThemeData theme) => SizedBox(
    width: double.infinity,
    height: 56,
    child: ElevatedButton(
      onPressed: () => context.push(RouteNames.loginOptions),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.secondaryCoral,
        foregroundColor: AppColors.neutralWhite,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 0,
      ),
      child: Text(
        'Log In',
        style: theme.textTheme.titleMedium?.copyWith(
          color: AppColors.neutralWhite,
          fontWeight: FontWeight.w600,
          fontSize: 18,
        ),
      ),
    ),
  );

  Widget _buildSignUpButton(BuildContext context, ThemeData theme) => SizedBox(
    width: double.infinity,
    height: 56,
    child: OutlinedButton(
      onPressed: () => context.push(RouteNames.registerDetails),
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.secondaryCoral,
        side: const BorderSide(color: AppColors.secondaryCoral, width: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: Colors.transparent,
      ),
      child: Text(
        'Sign up',
        style: theme.textTheme.titleMedium?.copyWith(
          color: AppColors.secondaryCoral,
          fontWeight: FontWeight.w600,
          fontSize: 18,
        ),
      ),
    ),
  );

  Widget _buildBrand(ThemeData theme) => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Image.asset('assets/images/logo.png', height: 32, width: 32),
      const SizedBox(width: 8),
      Text(
        'Minstant',
        style: theme.textTheme.titleLarge?.copyWith(
          color: AppColors.neutralBlack,
          fontWeight: FontWeight.bold,
          fontSize: 24,
        ),
      ),
    ],
  );
}

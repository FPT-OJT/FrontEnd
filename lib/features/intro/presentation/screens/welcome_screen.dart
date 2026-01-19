import 'package:flutter/material.dart';
import 'package:fpt_ojt/app/router/route_names.dart';
import 'package:fpt_ojt/core/theme/app_colors.dart';
import 'package:fpt_ojt/core/theme/app_text_styles.dart';
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
              const SizedBox(height: 24),
              _buildSubtitle(theme),
              const SizedBox(height: 32),
              _buildIllustration(),
              const SizedBox(height: 32),
              _buildLoginButton(context, theme),
              const SizedBox(height: 16),
              _buildSignUpButton(context, theme),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [_buildBrand(theme), const SizedBox(height: 32)],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitle(ThemeData theme) =>
      Text('Welcome!', style: AppTextStyles.h1);

  Widget _buildSubtitle(ThemeData theme) => Text(
    'We help you make the most of your money.',
    style: AppTextStyles.bodyLarge,
    textAlign: TextAlign.center,
  );

  Widget _buildIllustration() => Image.asset(
    'assets/images/welcome_image.png',
    height: 210,
    fit: BoxFit.contain,
  );

  Widget _buildLoginButton(BuildContext context, ThemeData theme) => SizedBox(
    width: double.infinity,
    height: 48,
    child: ElevatedButton(
      onPressed: () => context.push(RouteNames.loginOptions),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.secondaryCoral,
        foregroundColor: AppColors.neutralWhite,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 0,
      ),
      child: Text('Log In', style: AppTextStyles.button),
    ),
  );

  Widget _buildSignUpButton(BuildContext context, ThemeData theme) => SizedBox(
    width: double.infinity,
    height: 48,
    child: OutlinedButton(
      onPressed: () => context.push(RouteNames.registerDetails),
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.secondaryCoral,
        side: const BorderSide(color: AppColors.secondaryCoral, width: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: Colors.transparent,
      ),
      child: Text('Sign up', style: AppTextStyles.button),
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

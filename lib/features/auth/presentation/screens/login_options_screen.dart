import 'package:flutter/material.dart';
import 'package:fpt_ojt/app/router/route_names.dart';
import 'package:fpt_ojt/core/theme/app_colors.dart';
import 'package:go_router/go_router.dart';
import 'package:icons_plus/icons_plus.dart';

class LoginOptionsScreen extends StatelessWidget {
  const LoginOptionsScreen({super.key});

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
              const SizedBox(height: 40),
              _buildTitle(theme),
              const SizedBox(height: 40),
              _buildIllustration(),
              const Spacer(),
              _buildEmailLoginButton(context, theme),
              const SizedBox(height: 24),
              _buildOrDivider(theme),
              const SizedBox(height: 24),
              _buildFacebookButton(context, theme),
              const SizedBox(height: 16),
              _buildGoogleButton(context, theme),
              const SizedBox(height: 32),
              _buildSignUpPrompt(context, theme),
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
    'Login to Minstant',
    style: theme.textTheme.headlineLarge?.copyWith(
      color: AppColors.secondaryNavy,
      fontWeight: FontWeight.bold,
      fontSize: 32,
    ),
  );

  Widget _buildIllustration() => Image.asset(
    'assets/images/welcome_image.png',
    height: 280,
    fit: BoxFit.contain,
  );

  Widget _buildEmailLoginButton(BuildContext context, ThemeData theme) =>
      SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.secondaryCoral,
            foregroundColor: AppColors.neutralWhite,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 0,
          ),
          child: Text(
            'Login with email address',
            style: theme.textTheme.titleMedium?.copyWith(
              color: AppColors.neutralWhite,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ),
      );

  Widget _buildOrDivider(ThemeData theme) => Row(
    children: [
      const Expanded(child: Divider(color: AppColors.neutralGrey)),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Text(
          'or',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: AppColors.neutralGrey,
          ),
        ),
      ),
      const Expanded(child: Divider(color: AppColors.neutralGrey)),
    ],
  );

  Widget _buildFacebookButton(BuildContext context, ThemeData theme) =>
      SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton.icon(
          onPressed: () {
            context.push(RouteNames.loginDetails);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1877F2),
            foregroundColor: AppColors.neutralWhite,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 0,
          ),
          icon: const Icon(Icons.facebook, size: 24),
          label: Text(
            'Continue with Facebook',
            style: theme.textTheme.titleMedium?.copyWith(
              color: AppColors.neutralWhite,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ),
      );

  Widget _buildGoogleButton(BuildContext context, ThemeData theme) => SizedBox(
    width: double.infinity,
    height: 56,
    child: ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        foregroundColor: AppColors.neutralBlack,
        backgroundColor: AppColors.neutralWhite,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2,
        shadowColor: AppColors.shadowNavyA10,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Brand(Brands.google, size: 24),
          const SizedBox(width: 12),
          Text(
            'Continue with Google',
            style: theme.textTheme.titleMedium?.copyWith(
              color: AppColors.neutralBlack,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ],
      ),
    ),
  );

  Widget _buildSignUpPrompt(BuildContext context, ThemeData theme) => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
        "Don't have an account?",
        style: theme.textTheme.bodyMedium?.copyWith(
          color: AppColors.secondaryNavy,
        ),
      ),
      const SizedBox(width: 4),
      TextButton(
        onPressed: () => context.push(RouteNames.registerDetails),
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: GestureDetector(
          onTap: () => context.push(RouteNames.registerDetails),
          child: Text(
            'Sign up now',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.secondaryCoral,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    ],
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

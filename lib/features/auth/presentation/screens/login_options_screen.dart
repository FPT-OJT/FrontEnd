import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpt_ojt/app/router/route_names.dart';
import 'package:fpt_ojt/core/theme/app_colors.dart';
import 'package:fpt_ojt/core/theme/app_text_styles.dart';
import 'package:fpt_ojt/core/theme/rounded.dart';
import 'package:fpt_ojt/core/theme/shadows.dart';
import 'package:fpt_ojt/core/theme/ui_gaps.dart';
import 'package:fpt_ojt/features/auth/presentation/blocs/auth/auth_bloc.dart';
import 'package:fpt_ojt/features/auth/presentation/blocs/auth/auth_event.dart';
import 'package:fpt_ojt/features/auth/presentation/blocs/login_options/login_options_cubit.dart';
import 'package:fpt_ojt/features/auth/presentation/blocs/login_options/login_options_state.dart';
import 'package:fpt_ojt/features/auth/presentation/constants/login_options.dart';
import 'package:fpt_ojt/features/auth/presentation/widgets/social_button.dart';
import 'package:fpt_ojt/features/shared/constants/app_constants.dart';
import 'package:fpt_ojt/features/shared/utils/snackbar_utils.dart';
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
          padding: const EdgeInsets.symmetric(horizontal: UIGaps.size16),
          child: BlocConsumer<LoginOptionsCubit, LoginOptionsState>(
            listener: (context, state) {
              switch (state) {
                case LoginWithFacebookLoading _:
                  return;
                case LoginWithFacebookSuccess _:
                  return;
                case final LoginWithFacebookError loginWithFacebookError:
                  SnackBarUtils.showError(
                    context,
                    loginWithFacebookError.message,
                  );
                  return;
                case LoginWithGoogleLoading _:
                  return;
                case final LoginWithGoogleSuccess loginWithGoogleSuccess:
                  SnackBarUtils.showSuccess(
                    context,
                    LoginOptionsConstants.loginSuccessMessage,
                  );
                  context.read<AuthBloc>().add(
                    AuthLoggedInEvent(user: loginWithGoogleSuccess.user),
                  );
                  context.go(RouteNames.home);
                  return;
                case final LoginWithGoogleError loginWithGoogleError:
                  SnackBarUtils.showError(
                    context,
                    loginWithGoogleError.message,
                  );
                  return;
              }
            },
            builder: (context, state) => Column(
              children: [
                UIGaps.h40,
                _buildTitle(theme),
                Expanded(child: Container(child: _buildIllustration())),
                _buildEmailLoginButton(context, theme),
                UIGaps.h24,
                _buildOrDivider(theme),
                UIGaps.h24,
                _buildFacebookButton(context, theme),
                UIGaps.h16,
                _buildGoogleButton(context, theme),
                UIGaps.h32,
                _buildSignUpPrompt(context, theme),
                UIGaps.h32,
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [_buildBrand(theme), UIGaps.h32],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitle(ThemeData theme) =>
      Text(LoginOptionsConstants.loginTitle, style: AppTextStyles.h2);

  Widget _buildIllustration() => Image.asset(
    LoginOptionsConstants.welcomeImage,
    height: LoginOptionsConstants.imageHeight,
    width: LoginOptionsConstants.imageWidth,
    fit: BoxFit.contain,
  );

  Widget _buildEmailLoginButton(BuildContext context, ThemeData theme) =>
      SizedBox(
        width: double.infinity,
        height: UIGaps.size48,
        child: ElevatedButton(
          onPressed: () {
            context.push(RouteNames.loginDetails);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.secondaryCoral,
            foregroundColor: AppColors.neutralWhite,
            shape: RoundedRectangleBorder(borderRadius: Rounded.md),
            elevation: Shadows.none,
          ),
          child: Text(
            LoginOptionsConstants.loginWithEmailAddressText,
            style: AppTextStyles.button,
          ),
        ),
      );

  Widget _buildOrDivider(ThemeData theme) => Row(
    children: [
      const Expanded(child: Divider(color: AppColors.neutralGrey)),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: UIGaps.size16),
        child: Text(
          LoginOptionsConstants.orText,
          style: AppTextStyles.bodySmall.copyWith(color: AppColors.neutralGrey),
        ),
      ),
      const Expanded(child: Divider(color: AppColors.neutralGrey)),
    ],
  );

  Widget _buildFacebookButton(BuildContext context, ThemeData theme) =>
      SocialButton(
        onPressed: () {
          context.push(RouteNames.loginDetails);
        },
        text: LoginOptionsConstants.continueWithFacebookText,
        icon: const Icon(Icons.facebook, size: UIGaps.size24),
        backgroundColor: const Color(0xFF1877F2),
        foregroundColor: AppColors.neutralWhite,
        elevation: Shadows.none,
      );

  Widget _buildGoogleButton(BuildContext context, ThemeData theme) =>
      SocialButton(
        onPressed: () {
          context.read<LoginOptionsCubit>().loginWithGoogle();
        },
        text: LoginOptionsConstants.continueWithGoogleText,
        icon: Brand(Brands.google, size: UIGaps.size24),
        backgroundColor: AppColors.neutralWhite,
        foregroundColor: AppColors.neutralBlack,
        elevation: Shadows.btn,
        shadowColor: AppColors.shadowNavyA10,
      );

  Widget _buildSignUpPrompt(BuildContext context, ThemeData theme) => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
        LoginOptionsConstants.signupPromptText,
        style: AppTextStyles.bodyLarge.copyWith(color: AppColors.secondaryNavy),
      ),
      UIGaps.w4,
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
            LoginOptionsConstants.signupNowText,
            style: AppTextStyles.h3.copyWith(color: AppColors.secondaryCoral),
          ),
        ),
      ),
    ],
  );

  Widget _buildBrand(ThemeData theme) => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Image.asset(
        AppConstants.logoImage,
        height: LoginOptionsConstants.brandImageHeight,
        width: LoginOptionsConstants.brandImageWidth,
      ),
      UIGaps.w8,
      Text(
        AppConstants.appName,
        style: AppTextStyles.h2.copyWith(color: AppColors.neutralBlack),
      ),
    ],
  );
}

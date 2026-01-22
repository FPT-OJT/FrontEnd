import 'package:flutter/material.dart';
import 'package:fpt_ojt/core/theme/app_colors.dart';
import 'package:fpt_ojt/core/theme/app_text_styles.dart';
import 'package:fpt_ojt/core/theme/ui_gaps.dart';

class SnackBarUtils {
  const SnackBarUtils._();

  // Duration constants
  static const Duration _defaultDuration = Duration(seconds: 3);
  static const Duration _errorDuration = Duration(seconds: 4);

  // Visual constants
  static const double _iconSize = 24;
  static const double _borderRadius = 12;
  static const double _horizontalMargin = 16;
  static const double _topMarginOffset = 16;
  static const double _snackBarHeight = 80;
  static const double _horizontalPadding = 16;
  static const double _verticalPadding = 14;

  static void showSuccess(
    BuildContext context,
    String message, {
    Duration duration = _defaultDuration,
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    _showSnackBar(
      context,
      message: message,
      backgroundColor: AppColors.notifySuccess,
      icon: Icons.check_circle_rounded,
      duration: duration,
      actionLabel: actionLabel,
      onAction: onAction,
    );
  }

  static void showError(
    BuildContext context,
    String message, {
    Duration duration = _errorDuration,
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    _showSnackBar(
      context,
      message: message,
      backgroundColor: AppColors.notifyError,
      icon: Icons.error_rounded,
      duration: duration,
      actionLabel: actionLabel,
      onAction: onAction,
    );
  }

  static void showWarning(
    BuildContext context,
    String message, {
    Duration duration = _defaultDuration,
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    _showSnackBar(
      context,
      message: message,
      backgroundColor: AppColors.notifyAlert,
      icon: Icons.warning_rounded,
      duration: duration,
      actionLabel: actionLabel,
      onAction: onAction,
    );
  }

  static void showInfo(
    BuildContext context,
    String message, {
    Duration duration = _defaultDuration,
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    _showSnackBar(
      context,
      message: message,
      backgroundColor: AppColors.notifyInfo,
      icon: Icons.info_rounded,
      duration: duration,
      actionLabel: actionLabel,
      onAction: onAction,
    );
  }

  static void _showSnackBar(
    BuildContext context, {
    required String message,
    required Color backgroundColor,
    required IconData icon,
    required Duration duration,
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    // Dismiss any existing snackbar first
    ScaffoldMessenger.of(context).clearSnackBars();

    final mediaQuery = MediaQuery.of(context);
    final topPadding = mediaQuery.padding.top;
    final keyboardHeight = mediaQuery.viewInsets.bottom;

    final snackBar = SnackBar(
      content: Row(
        children: [
          Icon(icon, color: AppColors.neutralWhite, size: _iconSize),
          UIGaps.w12,
          Expanded(
            child: Text(
              message,
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.neutralWhite,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: backgroundColor,
      duration: duration,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_borderRadius),
      ),
      margin: EdgeInsets.only(
        left: _horizontalMargin,
        right: _horizontalMargin,
        top: topPadding + _topMarginOffset,
        bottom:
            mediaQuery.size.height -
            topPadding -
            keyboardHeight -
            _snackBarHeight,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: _horizontalPadding,
        vertical: _verticalPadding,
      ),
      action: actionLabel != null
          ? SnackBarAction(
              label: actionLabel,
              textColor: AppColors.neutralWhite,
              onPressed: onAction ?? () {},
            )
          : null,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}

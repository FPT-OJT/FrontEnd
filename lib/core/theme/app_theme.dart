import 'package:flutter/material.dart';
import 'package:fpt_ojt/core/theme/app_colors.dart';
import 'package:fpt_ojt/core/theme/app_text_styles.dart';

class AppTheme {
  const AppTheme._();
  static ThemeData light() {
    final scheme = ColorScheme(
      brightness: Brightness.light,

      primary: AppColors.primaryCoin,
      onPrimary: AppColors.neutralBlack, // coin is bright
      primaryContainer: AppColors.primaryCoin.withAlpha(64),
      onPrimaryContainer: AppColors.neutralBlack,

      secondary: AppColors.primaryMint,
      onSecondary: AppColors.neutralBlack,
      secondaryContainer: AppColors.primaryMint.withAlpha(64),
      onSecondaryContainer: AppColors.neutralBlack,

      tertiary: AppColors.secondaryCoral,
      onTertiary: AppColors.neutralBlack,
      tertiaryContainer: AppColors.secondaryCoral.withAlpha(51),
      onTertiaryContainer: AppColors.neutralBlack,

      error: AppColors.notifyError,
      onError: AppColors.neutralWhite,
      errorContainer: AppColors.notifyError.withAlpha(51),
      onErrorContainer: AppColors.neutralBlack,

      surface: AppColors.neutralWhite,
      onSurface: AppColors.neutralBlack,

      surfaceContainerHighest: AppColors.neutralEggShell60,
      onSurfaceVariant: AppColors.secondaryNavy,

      outline: AppColors.neutralGrey,
      outlineVariant: AppColors.neutralGrey.withAlpha(153),

      shadow: AppColors.shadowNavyA10,
      scrim: Colors.black54,

      inverseSurface: AppColors.secondaryNavy,
      onInverseSurface: AppColors.neutralWhite,
      inversePrimary: AppColors.primaryCoin,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: scheme.surface,

      textTheme: AppTextTheme.light(scheme),

      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: AppTextStyles.h3.copyWith(color: scheme.onSurface),
      ),

      cardTheme: CardThemeData(
        color: scheme.surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),

      dividerTheme: DividerThemeData(
        color: scheme.outlineVariant,
        thickness: 1,
        space: 1,
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: scheme.outlineVariant),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: scheme.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: scheme.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: scheme.error),
        ),
        hintStyle: AppTextStyles.bodySmall.copyWith(
          color: scheme.onSurfaceVariant,
        ),
        labelStyle: AppTextStyles.bodySmall.copyWith(
          color: scheme.onSurfaceVariant,
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          textStyle: WidgetStatePropertyAll(
            AppTextStyles.button.copyWith(color: scheme.onPrimary),
          ),
          padding: const WidgetStatePropertyAll(
            EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return scheme.primary.withAlpha(102);
            }
            return scheme.primary;
          }),
          foregroundColor: WidgetStatePropertyAll(scheme.onPrimary),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          textStyle: WidgetStatePropertyAll(
            AppTextStyles.button.copyWith(color: scheme.primary),
          ),
          foregroundColor: WidgetStatePropertyAll(scheme.primary),
        ),
      ),

      snackBarTheme: SnackBarThemeData(
        backgroundColor: scheme.inverseSurface,
        contentTextStyle: AppTextStyles.bodyLarge.copyWith(
          color: scheme.onInverseSurface,
        ),
      ),
    );
  }

  static List<BoxShadow> cardShadows() => const [
    BoxShadow(
      color: AppColors.shadowNavyA10,
      offset: Offset(2, 2),
      blurRadius: 10,
    ),
  ];
}

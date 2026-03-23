import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  const AppTextStyles._();
  // Header
  static final h1 = GoogleFonts.notoSerif(
    fontWeight: FontWeight.w700,
    fontSize: 36,
    height: 1.5,
    letterSpacing: 0,
  );

  static final h2 = GoogleFonts.notoSerif(
    fontWeight: FontWeight.w700,
    fontSize: 24,
    height: 1.5,
    letterSpacing: 0,
  );

  static final h3 = GoogleFonts.notoSans(
    fontWeight: FontWeight.w700,
    fontSize: 16,
    height: 1.5,
    letterSpacing: 0,
  );

  // Body
  static final title = GoogleFonts.notoSans(
    fontWeight: FontWeight.w700,
    fontSize: 16,
    height: 1.5,
    letterSpacing: 0,
  );

  static final bodyLarge = GoogleFonts.notoSans(
    fontWeight: FontWeight.w400,
    fontSize: 16,
    height: 1.5,
    letterSpacing: 0,
  );

  static final bodySmall = GoogleFonts.notoSans(
    fontWeight: FontWeight.w400,
    fontSize: 14,
    height: 1.5,
    letterSpacing: 0,
  );

  static final bodyExtraSmall = GoogleFonts.notoSansRejang(
    fontWeight: FontWeight.w400,
    fontSize: 12,
    height: 1.5,
    letterSpacing: 0,
  );

  static final button = GoogleFonts.notoSans(
    fontWeight: FontWeight.w700,
    fontSize: 16,
    letterSpacing: 0.5,
  );

  static final textLink = GoogleFonts.notoSans(
    fontWeight: FontWeight.w700,
    fontSize: 12,
    letterSpacing: 0.5,
    decoration: TextDecoration.none,
  );
  static final btn = GoogleFonts.notoSans(
    fontWeight: FontWeight.bold,
    fontSize: 16,
    letterSpacing: 0.5,
  );
}

class AppTextTheme {
  const AppTextTheme._();
  static TextTheme light(ColorScheme scheme) => TextTheme(
    displayLarge: AppTextStyles.h1.copyWith(color: scheme.onSurface),
    displayMedium: AppTextStyles.h2.copyWith(color: scheme.onSurface),
    titleLarge: AppTextStyles.h3.copyWith(color: scheme.onSurface),

    titleMedium: AppTextStyles.title.copyWith(color: scheme.onSurface),
    bodyLarge: AppTextStyles.bodyLarge.copyWith(color: scheme.onSurface),
    bodyMedium: AppTextStyles.bodySmall.copyWith(color: scheme.onSurface),
    bodySmall: AppTextStyles.bodyExtraSmall.copyWith(
      color: scheme.onSurfaceVariant,
    ),

    labelLarge: AppTextStyles.button.copyWith(color: scheme.onPrimary),
    labelMedium: AppTextStyles.textLink.copyWith(color: scheme.primary),
  );

  static TextTheme dark(ColorScheme scheme) => TextTheme(
    displayLarge: AppTextStyles.h1.copyWith(color: scheme.onSurface),
    displayMedium: AppTextStyles.h2.copyWith(color: scheme.onSurface),
    titleLarge: AppTextStyles.h3.copyWith(color: scheme.onSurface),

    titleMedium: AppTextStyles.title.copyWith(color: scheme.onSurface),
    bodyLarge: AppTextStyles.bodyLarge.copyWith(color: scheme.onSurface),
    bodyMedium: AppTextStyles.bodySmall.copyWith(color: scheme.onSurface),
    bodySmall: AppTextStyles.bodyExtraSmall.copyWith(
      color: scheme.onSurfaceVariant,
    ),

    labelLarge: AppTextStyles.button.copyWith(color: scheme.onPrimary),
    labelMedium: AppTextStyles.textLink.copyWith(color: scheme.primary),
  );
}

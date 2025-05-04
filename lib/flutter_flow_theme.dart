import 'package:flutter/material.dart';

abstract class FlutterFlowTheme {
  static ThemeData of(BuildContext context) => Theme.of(context);

  static const Color primary = Color(0xFF4B39EF);
  static const Color secondary = Color(0xFF39D2C0);
  static const Color tertiary = Color(0xFFEE8B60);
  static const Color alternate = Color(0xFFFF5963);
  static const Color primaryText = Color(0xFF101213);
  static const Color secondaryText = Color(0xFF57636C);
  static const Color primaryBackground = Color(0xFFF1F4F8);
  static const Color secondaryBackground = Color(0xFFFFFFFF);
  static const Color accent1 = Color(0xFF616161);
  static const Color accent2 = Color(0xFF757575);
  static const Color accent3 = Color(0xFFE0E0E0);
  static const Color accent4 = Color(0xFFEEEEEE);
  static const Color success = Color(0xFF04A24C);
  static const Color warning = Color(0xFFFCDC0C);
  static const Color error = Color(0xFFE21C3D);
  static const Color info = Color(0xFF1C4494);

  // Reusable text styles
  static TextStyle get displayLarge => const TextStyle(
        fontFamily: 'Inter',
        color: primaryText,
        fontWeight: FontWeight.normal,
        fontSize: 57.0,
      );

  static TextStyle get displayMedium => const TextStyle(
        fontFamily: 'Inter',
        color: primaryText,
        fontWeight: FontWeight.normal,
        fontSize: 45.0,
      );

  static TextStyle get displaySmall => const TextStyle(
        fontFamily: 'Inter',
        color: primaryText,
        fontWeight: FontWeight.normal,
        fontSize: 36.0,
      );

  static TextStyle get headlineLarge => const TextStyle(
        fontFamily: 'Inter',
        color: primaryText,
        fontWeight: FontWeight.normal,
        fontSize: 32.0,
      );

  static TextStyle get headlineMedium => const TextStyle(
        fontFamily: 'Inter',
        color: primaryText,
        fontWeight: FontWeight.normal,
        fontSize: 28.0,
      );

  static TextStyle get headlineSmall => const TextStyle(
        fontFamily: 'Inter',
        color: primaryText,
        fontWeight: FontWeight.normal,
        fontSize: 24.0,
      );

  static TextStyle get titleLarge => const TextStyle(
        fontFamily: 'Inter',
        color: primaryText,
        fontWeight: FontWeight.w500,
        fontSize: 22.0,
      );

  static TextStyle get titleMedium => const TextStyle(
        fontFamily: 'Inter',
        color: primaryText,
        fontWeight: FontWeight.w500,
        fontSize: 16.0,
      );

  static TextStyle get titleSmall => const TextStyle(
        fontFamily: 'Inter',
        color: secondaryText,
        fontWeight: FontWeight.w500,
        fontSize: 14.0,
      );

  static TextStyle get labelLarge => const TextStyle(
        fontFamily: 'Inter',
        color: primaryText,
        fontWeight: FontWeight.w500,
        fontSize: 14.0,
      );

  static TextStyle get labelMedium => const TextStyle(
        fontFamily: 'Inter',
        color: primaryText,
        fontWeight: FontWeight.w500,
        fontSize: 12.0,
      );

  static TextStyle get labelSmall => const TextStyle(
        fontFamily: 'Inter',
        color: primaryText,
        fontWeight: FontWeight.w500,
        fontSize: 11.0,
      );

  static TextStyle get bodyLarge => const TextStyle(
        fontFamily: 'Inter',
        color: primaryText,
        fontWeight: FontWeight.normal,
        fontSize: 16.0,
      );

  static TextStyle get bodyMedium => const TextStyle(
        fontFamily: 'Inter',
        color: primaryText,
        fontWeight: FontWeight.normal,
        fontSize: 14.0,
      );

  static TextStyle get bodySmall => const TextStyle(
        fontFamily: 'Inter',
        color: secondaryText,
        fontWeight: FontWeight.normal,
        fontSize: 12.0,
      );
}

extension TextStyleHelper on TextStyle {
  TextStyle override({
    String? fontFamily,
    Color? color,
    double? fontSize,
    FontWeight? fontWeight,
    FontStyle? fontStyle,
    double? letterSpacing,
    double? lineHeight,
  }) {
    return copyWith(
      fontFamily: fontFamily,
      color: color,
      fontSize: fontSize,
      fontWeight: fontWeight,
      fontStyle: fontStyle,
      letterSpacing: letterSpacing,
      height: lineHeight,
    );
  }
}

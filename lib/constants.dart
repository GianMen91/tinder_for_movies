import 'package:flutter/material.dart';


const Color primary = Color(0xFF4B39EF);
const Color secondary = Color(0xFF39D2C0);
const Color tertiary = Color(0xFFEE8B60);
const Color alternate = Color(0xFFFF5963);
const Color primaryText = Color(0xFF101213);
const Color secondaryText = Color(0xFF57636C);
const Color primaryBackground = Color(0xFFF1F4F8);
const Color secondaryBackground = Color(0xFFFFFFFF);
const Color accent1 = Color(0xFF616161);
const Color accent2 = Color(0xFF757575);
const Color accent3 = Color(0xFFE0E0E0);
const Color accent4 = Color(0xFFEEEEEE);
const Color success = Color(0xFF04A24C);
const Color warning = Color(0xFFFCDC0C);
const Color error = Color(0xFFE21C3D);
const Color info = Color(0xFF1C4494);

// Reusable text styles
TextStyle get displayLarge =>
    const TextStyle(
      fontFamily: 'Inter',
      color: primaryText,
      fontWeight: FontWeight.normal,
      fontSize: 57.0,
    );

TextStyle get displayMedium =>
    const TextStyle(
      fontFamily: 'Inter',
      color: primaryText,
      fontWeight: FontWeight.normal,
      fontSize: 45.0,
    );

TextStyle get displaySmall =>
    const TextStyle(
      fontFamily: 'Inter',
      color: primaryText,
      fontWeight: FontWeight.normal,
      fontSize: 36.0,
    );

TextStyle get headlineLarge =>
    const TextStyle(
      fontFamily: 'Inter',
      color: primaryText,
      fontWeight: FontWeight.normal,
      fontSize: 32.0,
    );

TextStyle get headlineMedium =>
    const TextStyle(
      fontFamily: 'Inter',
      color: primaryText,
      fontWeight: FontWeight.normal,
      fontSize: 28.0,
    );

TextStyle get headlineSmall =>
    const TextStyle(
      fontFamily: 'Inter',
      color: primaryText,
      fontWeight: FontWeight.normal,
      fontSize: 24.0,
    );

TextStyle get titleLarge =>
    const TextStyle(
      fontFamily: 'Inter',
      color: primaryText,
      fontWeight: FontWeight.w500,
      fontSize: 22.0,
    );

TextStyle get titleMedium =>
    const TextStyle(
      fontFamily: 'Inter',
      color: primaryText,
      fontWeight: FontWeight.w500,
      fontSize: 16.0,
    );

TextStyle get titleSmall =>
    const TextStyle(
      fontFamily: 'Inter',
      color: secondaryText,
      fontWeight: FontWeight.w500,
      fontSize: 14.0,
    );

TextStyle get labelLarge =>
    const TextStyle(
      fontFamily: 'Inter',
      color: primaryText,
      fontWeight: FontWeight.w500,
      fontSize: 14.0,
    );

TextStyle get labelMedium =>
    const TextStyle(
      fontFamily: 'Inter',
      color: primaryText,
      fontWeight: FontWeight.w500,
      fontSize: 12.0,
    );

TextStyle get labelSmall =>
    const TextStyle(
      fontFamily: 'Inter',
      color: primaryText,
      fontWeight: FontWeight.w500,
      fontSize: 11.0,
    );

TextStyle get bodyLarge =>
    const TextStyle(
      fontFamily: 'Inter',
      color: primaryText,
      fontWeight: FontWeight.normal,
      fontSize: 16.0,
    );

TextStyle get bodyMedium =>
    const TextStyle(
      fontFamily: 'Inter',
      color: primaryText,
      fontWeight: FontWeight.normal,
      fontSize: 14.0,
    );

TextStyle get bodySmall =>
    const TextStyle(
      fontFamily: 'Inter',
      color: secondaryText,
      fontWeight: FontWeight.normal,
      fontSize: 12.0,
    );


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

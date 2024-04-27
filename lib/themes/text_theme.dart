import 'package:flutter/material.dart';
import 'package:pesse/themes/colors.dart';

class PesseTextTheme {
  PesseTextTheme._();

  static const textTheme = TextTheme(
    displayLarge: TextStyle(
      fontSize: 57,
      letterSpacing: 0.25,
      fontWeight: FontWeight.w700,
    ),
    displayMedium: TextStyle(
      fontSize: 45,
      letterSpacing: 0,
    ),
    displaySmall: TextStyle(
      fontSize: 36,
      letterSpacing: 0,
    ),
    headlineLarge: TextStyle(
      fontSize: 32,
      letterSpacing: 0,
      fontWeight: FontWeight.w700,
      color: PesseColors.primary,
    ),
    headlineMedium: TextStyle(
      fontSize: 28,
      letterSpacing: 0,
      fontWeight: FontWeight.w600,
    ),
    headlineSmall: TextStyle(
      fontSize: 24,
      letterSpacing: 0,
    ),
    titleLarge: TextStyle(
      fontSize: 22,
      letterSpacing: 0,
      fontWeight: FontWeight.w700,
    ),
    titleMedium: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.15,
    ),
    titleSmall: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.1,
    ),
    bodyLarge: TextStyle(
      fontSize: 16,
      letterSpacing: 0.5,
      color: PesseColors.black,
    ),
    bodyMedium: TextStyle(
      fontSize: 14,
      letterSpacing: 0.25,
    ),
    bodySmall: TextStyle(
      fontSize: 12,
      letterSpacing: 0.4,
    ),
    labelLarge: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.1,
    ),
    labelMedium: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.5,
    ),
    labelSmall: TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.5,
    ),
  );
}

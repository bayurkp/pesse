import 'package:flutter/material.dart';
import 'package:pesse/themes/colors.dart';
import 'package:pesse/themes/text_theme.dart';

class PesseTheme {
  PesseTheme._();

  static final lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Poppins',
    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: PesseColors.primary,
      onPrimary: PesseColors.onPrimary,
      secondary: PesseColors.secondary,
      onSecondary: PesseColors.onSecondary,
      error: PesseColors.error,
      onError: PesseColors.onError,
      background: PesseColors.lightBackground,
      onBackground: PesseColors.lightOnBackground,
      surface: PesseColors.lightSurface,
      onSurface: PesseColors.lightOnSurface,
    ),
    textTheme: PesseTextTheme.textTheme,
  );

  static final darkTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Poppins',
    colorScheme: const ColorScheme(
      brightness: Brightness.dark,
      primary: PesseColors.primary,
      onPrimary: PesseColors.onPrimary,
      secondary: PesseColors.secondary,
      onSecondary: PesseColors.onSecondary,
      error: PesseColors.error,
      onError: PesseColors.onError,
      background: PesseColors.darkBackground,
      onBackground: PesseColors.darkOnBackground,
      surface: PesseColors.darkSurface,
      onSurface: PesseColors.darkOnSurface,
    ),
    textTheme: PesseTextTheme.textTheme,
  );
}

import 'package:flutter/material.dart';
import 'package:pesse/themes/colors.dart';
import 'package:pesse/themes/input_decoration_theme.dart';
import 'package:pesse/themes/text_button_theme.dart';
import 'package:pesse/themes/text_theme.dart';

class PesseTheme {
  PesseTheme._();

  static final theme = ThemeData(
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
      background: PesseColors.background,
      onBackground: PesseColors.onBackground,
      surface: PesseColors.surface,
      onSurface: PesseColors.onSurface,
    ),
    textTheme: PesseTextTheme.textTheme,
    textButtonTheme: PesseTextButtonTheme.textButtonTheme,
    inputDecorationTheme: PesseInputDecorationTheme.inputDecorationTheme,
  );
}

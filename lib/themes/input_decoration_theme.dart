import 'package:flutter/material.dart';
import 'package:pesse/themes/colors.dart';
import 'package:pesse/themes/text_theme.dart';

class PesseInputDecorationTheme {
  PesseInputDecorationTheme._();

  static InputDecorationTheme inputDecorationTheme = InputDecorationTheme(
    contentPadding: const EdgeInsets.all(20.0),
    hintStyle: PesseTextTheme.textTheme.bodyMedium!.copyWith(
      fontWeight: FontWeight.w500,
    ),
    fillColor: PesseColors.surface,
    filled: true,
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: PesseColors.white.withOpacity(0.0),
      ),
      borderRadius: const BorderRadius.all(
        Radius.circular(15.0),
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: PesseColors.white.withOpacity(0.0),
      ),
      borderRadius: const BorderRadius.all(
        Radius.circular(15.0),
      ),
    ),
    errorBorder: const OutlineInputBorder(
      borderSide: BorderSide(
        color: PesseColors.error,
      ),
      borderRadius: BorderRadius.all(
        Radius.circular(15.0),
      ),
    ),
    focusedErrorBorder: const OutlineInputBorder(
      borderSide: BorderSide(
        color: PesseColors.error,
      ),
      borderRadius: BorderRadius.all(
        Radius.circular(15.0),
      ),
    ),
    errorMaxLines: 3,
    errorStyle: PesseTextTheme.textTheme.bodySmall!.copyWith(
      color: PesseColors.error,
    ),
  );
}

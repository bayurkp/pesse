import 'package:flutter/material.dart';
import 'package:pesse/themes/colors.dart';

class PesseTextButtonTheme {
  PesseTextButtonTheme._();

  static TextButtonThemeData textButtonTheme = TextButtonThemeData(
    style: ButtonStyle(
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
      ),
      backgroundColor: MaterialStateProperty.all<Color>(PesseColors.primary),
      foregroundColor: MaterialStateProperty.all<Color>(PesseColors.onPrimary),
    ),
  );
}

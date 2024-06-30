import 'package:flutter/material.dart';

class PesseColors {
  PesseColors._();

  // Basic Colors
  static const white = Colors.white;
  static const black = Colors.black;
  static const royalBlue = Color(0xFF00296B);
  static const marianBlue = Color(0xFF003F88);
  static const polynesianBlue = Color(0xFF00509D);
  static const mikadoYellow = Color(0xFFFDC500);
  static const gold = Color(0xFFFFD500);
  static const red = Color(0xFFCC0000);
  static const green = Color(0xFF15803d);
  static const yellow = Color(0xFFFFC107);
  static const transparent = Colors.transparent;

  // Grays
  static const Color gray50 = Color(0xFFFAFAFA);
  static const Color gray100 = Color(0xFFF5F5F5);
  static const Color gray200 = Color(0xFFEEEEEE);
  static const Color gray300 = Color(0xFFE0E0E0);
  static const Color gray400 = Color(0xFFBDBDBD);
  static const Color gray500 = Color(0xFF9E9E9E);
  static const Color gray600 = Color(0xFF757575);
  static const Color gray700 = Color(0xFF616161);
  static const Color gray800 = Color(0xFF424242);
  static const Color gray900 = Color(0xFF212121);

  // General Theme Colors
  static const primary = polynesianBlue;
  static const onPrimary = white;
  static const secondary = mikadoYellow;
  static const onSecondary = black;
  static const error = red;
  static const onError = white;
  static const warning = yellow;
  static const onWarning = black;
  static const success = green;
  static const onSuccess = white;

  // Light Theme Colors
  static const background = white;
  static const onBackground = black;
  static const surface = gray200;
  static const onSurface = gray600;
}

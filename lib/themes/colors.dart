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

  // Grays
  static const gray50 = Color(0xFFF7FAFC);
  static const gray100 = Color(0xFFE5EAFE);
  static const gray200 = Color(0xFFCED4EE);
  static const gray300 = Color(0xFFADB5C7);
  static const gray400 = Color(0xFF8899A6);
  static const gray500 = Color(0xFF687587);
  static const gray600 = Color(0xFF4B5563);
  static const gray700 = Color(0xFF374151);
  static const gray800 = Color(0xFF1B2631);
  static const gray900 = Color(0xFF171A24);

  // General Theme Colors
  static const primary = polynesianBlue;
  static const onPrimary = black;
  static const secondary = mikadoYellow;
  static const onSecondary = black;
  static const error = red;
  static const onError = white;

  // Light Theme Colors
  static const lightBackground = white;
  static const lightOnBackground = black;
  static const lightSurface = gray50;
  static const lightOnSurface = gray900;

  // Dark Theme Colors
  static const darkBackground = gray900;
  static const darkOnBackground = white;
  static const darkSurface = gray800;
  static const darkOnSurface = white;
}

import 'package:flutter/material.dart';
import 'package:pesse/screens/login_screen.dart';
import 'package:pesse/screens/register_screen.dart';
import 'package:pesse/themes/theme.dart';

void main() {
  runApp(const PesseApp());
}

class PesseApp extends StatelessWidget {
  const PesseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pesse',
      themeMode: ThemeMode.light,
      theme: PesseTheme.lightTheme,
      darkTheme: PesseTheme.darkTheme,
      debugShowCheckedModeBanner: false,
      home: const LoginScreen(),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
      },
    );
  }
}

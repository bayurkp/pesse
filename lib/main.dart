import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pesse/screens/profile_screen.dart';
import 'package:pesse/screens/login_screen.dart';
import 'package:pesse/screens/register_screen.dart';
import 'package:pesse/themes/theme.dart';

Future<void> main() async {
  await GetStorage.init();
  await dotenv.load(fileName: '.env');

  runApp(const PesseApp());
}

class PesseApp extends StatelessWidget {
  const PesseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pesse',
      themeMode: ThemeMode.light,
      theme: PesseTheme.theme,
      debugShowCheckedModeBanner: false,
      home: const LoginScreen(),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/profile': (context) => const ProfileScreen(),
      },
    );
  }
}

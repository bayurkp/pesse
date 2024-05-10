import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_storage/get_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:pesse/providers/auth_provider.dart';
import 'package:pesse/screens/home_screen.dart';
import 'package:pesse/screens/profile_screen.dart';
import 'package:pesse/screens/login_screen.dart';
import 'package:pesse/screens/register_screen.dart';
import 'package:pesse/themes/theme.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  await GetStorage.init();
  await dotenv.load(fileName: '.env');

  runApp(PesseApp());
}

class PesseApp extends StatelessWidget {
  PesseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthNotifier>(
          create: (context) => AuthNotifier(),
        )
      ],
      child: MaterialApp.router(
        routerDelegate: _router.routerDelegate,
        routeInformationParser: _router.routeInformationParser,
        routeInformationProvider: _router.routeInformationProvider,
        title: 'Pesse',
        themeMode: ThemeMode.light,
        theme: PesseTheme.theme,
        debugShowCheckedModeBanner: false,
      ),
    );
  }

  final _router = GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      if (Provider.of<AuthNotifier>(context, listen: true).isLoggedIn ==
          false) {
        return '/login';
      } else {
        return '/';
      }
    },
    routes: <GoRoute>[
      GoRoute(
        name: 'home',
        path: '/',
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        name: 'login',
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        name: 'register',
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        name: 'profile',
        path: '/profile',
        builder: (context, state) => const ProfileScreen(),
      ),
    ],
  );
}

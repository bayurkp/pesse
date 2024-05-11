import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pesse/providers/auth_provider.dart';
import 'package:pesse/screens/login_screen.dart';
import 'package:pesse/screens/profile_screen.dart';
import 'package:pesse/screens/register_screen.dart';

class PesseRouter {
  static GoRouter configureRouter(BuildContext context, AuthNotifier auth) {
    return GoRouter(
      initialLocation: '/',
      redirect: (context, state) {
        if (auth.isLoggedIn) {
          return null;
        } else {
          if (state.uri.path == '/register') {
            return null;
          } else {
            return '/login';
          }
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
          name: 'profile.index',
          path: '/profile',
          builder: (context, state) => const ProfileScreen(),
        ),
        GoRoute(
          name: 'members.index',
          path: '/members',
          builder: (context, state) => const ProfileScreen(),
        ),
        GoRoute(
          name: 'member.add',
          path: '/members/add',
          builder: (context, state) => const ProfileScreen(),
        ),
        GoRoute(
          name: 'member.edit',
          path: '/members/:id',
          builder: (context, state) => const ProfileScreen(),
        ),
      ],
    );
  }
}

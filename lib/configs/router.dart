import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pesse/providers/auth_provider.dart';
import 'package:pesse/screens/add_member_screen.dart';
import 'package:pesse/screens/edit_member_screen.dart';
import 'package:pesse/screens/home_screen.dart';
import 'package:pesse/screens/login_screen.dart';
import 'package:pesse/screens/members_screen.dart';
import 'package:pesse/screens/profile_screen.dart';
import 'package:pesse/screens/register_screen.dart';
import 'package:pesse/screens/test_screen.dart';

class PesseRouter {
  static GoRouter configureRouter(BuildContext context, AuthNotifier auth) {
    return GoRouter(
      initialLocation: '/',
      redirect: (context, state) {
        if (state.uri.path == '/test') {
          return null;
        }

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
          builder: (context, state) => const HomeScreen(),
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
        GoRoute(
          name: 'members.index',
          path: '/members',
          builder: (context, state) => const MembersScreen(),
        ),
        GoRoute(
          name: 'member.add',
          path: '/members/add',
          builder: (context, state) => const AddMemberScreen(),
        ),
        GoRoute(
          name: 'member.edit',
          path: '/members/:memberId',
          builder: (context, state) => EditMemberScreen(
            memberId: state.pathParameters['memberId']!,
          ),
        ),
        GoRoute(
          name: 'test',
          path: '/test',
          builder: (context, state) => const TestScreen(),
        ),
      ],
    );
  }
}

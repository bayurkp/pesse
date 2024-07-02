import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pesse/providers/auth_provider.dart';
import 'package:pesse/screens/add_member_screen.dart';
import 'package:pesse/screens/edit_member_screen.dart';
import 'package:pesse/screens/home_screen.dart';
import 'package:pesse/screens/login_screen.dart';
import 'package:pesse/screens/member_details_screen.dart';
import 'package:pesse/screens/members_screen.dart';
import 'package:pesse/screens/profile_screen.dart';
import 'package:pesse/screens/register_screen.dart';
import 'package:pesse/screens/test_screen.dart';
import 'package:pesse/screens/interest_screen.dart';

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
          pageBuilder: (context, state) => NoTransitionPage<void>(
            key: state.pageKey,
            child: const HomeScreen(),
          ),
        ),
        GoRoute(
          name: 'login',
          path: '/login',
          pageBuilder: (context, state) => NoTransitionPage<void>(
            key: state.pageKey,
            child: const LoginScreen(),
          ),
        ),
        GoRoute(
          name: 'register',
          path: '/register',
          pageBuilder: (context, state) => NoTransitionPage<void>(
            key: state.pageKey,
            child: const RegisterScreen(),
          ),
        ),
        GoRoute(
          name: 'profile',
          path: '/profile',
          pageBuilder: (context, state) => NoTransitionPage<void>(
            key: state.pageKey,
            child: const ProfileScreen(),
          ),
        ),
        GoRoute(
          name: 'interest',
          path: '/interest',
          pageBuilder: (context, state) => NoTransitionPage<void>(
            key: state.pageKey,
            child: const InterestScreen(),
          ),
        ),
        GoRoute(
          name: 'members.index',
          path: '/members',
          pageBuilder: (context, state) => NoTransitionPage<void>(
            key: state.pageKey,
            child: const MemberScreen(),
          ),
        ),
        GoRoute(
          name: 'member.add',
          path: '/members/add',
          pageBuilder: (context, state) => NoTransitionPage<void>(
            key: state.pageKey,
            child: const AddMemberScreen(),
          ),
        ),
        GoRoute(
          name: 'member.edit',
          path: '/members/:memberId/edit',
          pageBuilder: (context, state) => NoTransitionPage<void>(
            key: state.pageKey,
            child: EditMemberScreen(
              memberId: state.pathParameters['memberId']!,
            ),
          ),
        ),
        GoRoute(
          name: 'member.details',
          path: '/members/:memberId',
          pageBuilder: (context, state) => NoTransitionPage<void>(
            key: state.pageKey,
            child: MemberDetailsScreen(
              memberId: state.pathParameters['memberId']!,
            ),
          ),
        ),
        GoRoute(
          name: 'test',
          path: '/test',
          pageBuilder: (context, state) => NoTransitionPage<void>(
            key: state.pageKey,
            child: const TestScreen(),
          ),
        ),
      ],
    );
  }
}

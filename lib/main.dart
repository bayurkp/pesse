import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pesse/configs/router.dart';
import 'package:pesse/providers/auth_provider.dart';
import 'package:pesse/providers/bottom_navigation_provider.dart';
import 'package:pesse/providers/member_provider.dart';
import 'package:pesse/themes/theme.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  await GetStorage.init();
  await dotenv.load(fileName: '.env');

  runApp(const PesseApp());
}

class PesseApp extends StatelessWidget {
  const PesseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthNotifier>(
          create: (context) => AuthNotifier(),
        ),
        ChangeNotifierProvider<MemberNotifier>(
          create: (context) => MemberNotifier(),
        ),
        ChangeNotifierProvider<BottomNavigationNotifier>(
          create: (context) => BottomNavigationNotifier(),
        )
      ],

      // Dev
      child: Consumer<AuthNotifier>(
        builder: (context, auth, child) {
          final router = PesseRouter.configureRouter(context, auth);

          return MaterialApp.router(
            routerDelegate: router.routerDelegate,
            routeInformationParser: router.routeInformationParser,
            routeInformationProvider: router.routeInformationProvider,
            title: 'Pesse',
            themeMode: ThemeMode.light,
            theme: PesseTheme.theme,
            debugShowCheckedModeBanner: false,
          );
        },
      ),

      // Test
      // child: MaterialApp(
      //   title: 'Pesse',
      //   themeMode: ThemeMode.light,
      //   theme: PesseTheme.theme,
      //   debugShowCheckedModeBanner: false,
      //   home: AddMemberScreen(),
      // ),
    );
  }
}

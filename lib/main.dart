import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:pesse/configs/router.dart';
import 'package:pesse/providers/area_provider.dart';
import 'package:pesse/providers/auth_provider.dart';
import 'package:pesse/providers/bottom_navigation_provider.dart';
import 'package:pesse/providers/member_provider.dart';
import 'package:pesse/providers/transaction_provider.dart';
import 'package:pesse/themes/theme.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  await dotenv.load(fileName: '.env');
  await GetStorage.init();
  await initializeDateFormatting('id_ID', null)
      .then((_) => runApp(const PesseApp()));
  runApp(const PesseApp());
}

class PesseApp extends StatelessWidget {
  const PesseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AreaNotifier>(
          create: (context) => AreaNotifier(),
        ),
        ChangeNotifierProvider<AuthNotifier>(
          create: (context) => AuthNotifier(),
        ),
        ChangeNotifierProvider<MemberNotifier>(
          create: (context) => MemberNotifier(),
        ),
        ChangeNotifierProvider<BottomNavigationNotifier>(
          create: (context) => BottomNavigationNotifier(),
        ),
        ChangeNotifierProvider<TransactionNotifier>(
          create: (context) => TransactionNotifier(),
        ),
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
    );
  }
}

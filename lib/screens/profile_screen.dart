import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:pesse/providers/auth_provider.dart';
import 'package:pesse/providers/bottom_navigation_provider.dart';
import 'package:pesse/themes/colors.dart';
import 'package:pesse/themes/theme_extension.dart';
import 'package:pesse/utils/format_full_name.dart';
import 'package:pesse/widgets/app_bar.dart';
import 'package:pesse/widgets/bottom_navigation_bar.dart';
import 'package:pesse/widgets/text_button.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<BottomNavigationNotifier>(context, listen: false)
        .setCurrentIndex(3);
  }

  final user = GetStorage().read('user');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PesseAppBar(
        title: 'Profil',
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(20.0),
              width: double.infinity,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: const BorderRadius.all(
                  Radius.circular(15.0),
                ),
                border: Border.all(
                  color: PesseColors.surface,
                  width: 2.0,
                ),
              ),
              child: Column(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    clipBehavior: Clip.antiAlias,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: Image.asset(
                      'assets/images/default_person.jpg',
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Text(
                    formatFullName(user['name']),
                    style: context.titleMedium.copyWith(
                      color: PesseColors.onSurface,
                    ),
                  ),
                  Text(
                    user['email'],
                    style: context.bodySmall.copyWith(
                      color: PesseColors.onSurface,
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 20.0),
            PesseTextButton(
              onPressed: () {
                context.goNamed('login');
                Provider.of<AuthNotifier>(context, listen: false).logout();
              },
              label: 'Keluar',
              backgroundColor: PesseColors.error,
            ),
          ],
        ),
      )),
      bottomNavigationBar: const PesseBottomNavigationBar(),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_storage/get_storage.dart';
import 'package:logger/logger.dart';
import 'package:pesse/controllers/authentication_controller.dart';
import 'package:pesse/themes/colors.dart';
import 'package:pesse/themes/theme_extension.dart';
import 'package:pesse/widgets/text_button.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  List<BottomNavigationBarItem> bottomNavigationBarItems = [
    const BottomNavigationBarItem(
      icon: Icon(Icons.home),
      label: 'Beranda',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.group),
      label: 'Anggota',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.person),
      label: 'Profil',
    ),
  ];

  int selectedNavigationIndex = 0;

  void onNavigationTapped(int index) {
    setState(() {
      selectedNavigationIndex = index;
    });
  }

  final user = GetStorage().read('user');

  var logger = Logger();

  @override
  Widget build(BuildContext context) {
    logger.d(user);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: PesseColors.surface,
        title: const Text('Profil'),
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(20.0),
              decoration: const BoxDecoration(
                color: PesseColors.surface,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.all(Radius.circular(15.0)),
              ),
              child: Row(
                children: [
                  SvgPicture.asset(
                    'assets/images/pic_profile.svg',
                    semanticsLabel: 'Pic Profile',
                    height: 75.0,
                  ),
                  const SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user['name'],
                        style: context.body,
                      ),
                      Text(user['email']),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 20.0),
            PesseTextButton(
              onPressed: () {},
              label: 'Edit Profil',
              color: PesseColors.error,
            ),
            const SizedBox(height: 10.0),
            PesseTextButton(
              onPressed: () {
                logout();
                Navigator.pushNamed(context, '/login');
              },
              label: 'Keluar',
              color: PesseColors.error,
            ),
          ],
        ),
      )),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: PesseColors.onSurface.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 10,
            ),
          ],
        ),
        child: BottomNavigationBar(
          items: bottomNavigationBarItems,
          currentIndex: selectedNavigationIndex,
          onTap: onNavigationTapped,
          selectedItemColor: PesseColors.primary,
          unselectedItemColor: PesseColors.onSurface,
          backgroundColor: PesseColors.surface,
          type: BottomNavigationBarType.shifting,
        ),
      ),
    );
  }
}

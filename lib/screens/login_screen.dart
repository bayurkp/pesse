import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pesse/themes/colors.dart';
import 'package:pesse/themes/text_theme.dart';
import 'package:pesse/themes/theme_extension.dart';
import 'package:pesse/widgets/password_field.dart';
import 'package:pesse/widgets/text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Center(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SvgPicture.asset(
                    'assets/images/logo.svg',
                    semanticsLabel: 'Pesse\'s Logo',
                    height: 25.0,
                  ),
                  const SizedBox(height: 40.0),
                  SvgPicture.asset(
                    'assets/images/make_it_rain.svg',
                    semanticsLabel: 'Make It Rain',
                    height: 200.0,
                  ),
                  const SizedBox(height: 40.0),
                  Text(
                    'Masuk',
                    style: PesseTextTheme.textTheme.headlineLarge,
                  ),
                  const SizedBox(height: 10.0),
                  Text(
                    'Selamat datang kembali, Pessian!',
                    style: PesseTextTheme.textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 40.0),
                  PesseTextField(
                    controller: emailController,
                    hintText: 'Alamat Surel',
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 20.0),
                  PessePasswordField(
                    controller: passwordController,
                    hintText: 'Kata Sandi',
                  ),
                  const SizedBox(height: 40.0),
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () {},
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          'Masuk',
                          style: PesseTextTheme.textTheme.bodyLarge!.copyWith(
                            color: PesseColors.onPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Center(
                    child: RichText(
                      text: TextSpan(
                        text: 'Belum punya akun? ',
                        style: context.bodyMedium,
                        children: <WidgetSpan>[
                          WidgetSpan(
                            child: GestureDetector(
                              child: Text(
                                'Daftar di sini',
                                style: context.link.copyWith(
                                  fontSize: 14.0,
                                ),
                              ),
                              onTap: () {
                                Navigator.pushNamed(context, '/register');
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

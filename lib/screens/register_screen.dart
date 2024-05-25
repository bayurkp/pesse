import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:pesse/providers/auth_provider.dart';
import 'package:pesse/themes/colors.dart';
import 'package:pesse/themes/text_theme.dart';
import 'package:pesse/themes/theme_extension.dart';
import 'package:pesse/utils/show_alert_dialog.dart';
import 'package:pesse/widgets/password_field.dart';
import 'package:pesse/widgets/text_field.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthNotifier>(
      builder: (context, authNotifier, child) {
        WidgetsBinding.instance.addPostFrameCallback(
          (_) {
            if (authNotifier.isSuccess == false) {
              showPesseAlertDialog(
                context,
                title: 'Gagal',
                content: '${authNotifier.message}',
              );
            }
          },
        );

        return authNotifier.isPending
            ? const Center(child: CircularProgressIndicator())
            : Scaffold(
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
                              height: 75.0,
                            ),
                            const SizedBox(height: 40.0),
                            Text(
                              'Buat Akun',
                              style: PesseTextTheme.textTheme.headlineLarge,
                            ),
                            const SizedBox(height: 10.0),
                            Text(
                              textAlign: TextAlign.center,
                              'Daftarkan dirimu dan jadilah bagian dari Pessians!',
                              style: PesseTextTheme.textTheme.bodyLarge,
                            ),
                            const SizedBox(height: 40.0),
                            _registerForm(context),
                            const SizedBox(height: 20.0),
                            _loginLink(context),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
      },
    );
  }

  Widget _registerForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          PesseTextField(
            controller: emailController,
            hintText: 'Alamat Surel',
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 20.0),
          PesseTextField(
            controller: nameController,
            hintText: 'Nama Lengkap',
            keyboardType: TextInputType.name,
          ),
          const SizedBox(height: 20.0),
          PessePasswordField(
            controller: passwordController,
            hintText: 'Kata Sandi',
          ),
          const SizedBox(height: 20.0),
          _registerButton(),
        ],
      ),
    );
  }

  Widget _registerButton() {
    return SizedBox(
      width: double.infinity,
      child: TextButton(
        onPressed: () {
          Provider.of<AuthNotifier>(context, listen: false).register(
            email: emailController.text,
            name: nameController.text,
            password: passwordController.text,
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Text(
            'Daftar',
            style: PesseTextTheme.textTheme.bodyLarge!.copyWith(
              color: PesseColors.onPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _loginLink(BuildContext context) {
    return Center(
      child: RichText(
        text: TextSpan(
          text: 'Sudah punya akun? ',
          style: context.bodyMedium,
          children: <WidgetSpan>[
            WidgetSpan(
              child: GestureDetector(
                child: Text(
                  'Masuk di sini',
                  style: context.link.copyWith(
                    fontSize: 14.0,
                  ),
                ),
                onTap: () {
                  context.go('/login');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

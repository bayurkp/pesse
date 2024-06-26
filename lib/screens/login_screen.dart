import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:form_validator/form_validator.dart';
import 'package:go_router/go_router.dart';
import 'package:pesse/providers/auth_provider.dart';
import 'package:pesse/themes/text_theme.dart';
import 'package:pesse/themes/theme_extension.dart';
import 'package:pesse/utils/show_alert_dialog.dart';
import 'package:pesse/widgets/password_field.dart';
import 'package:pesse/widgets/text_button.dart';
import 'package:pesse/widgets/text_field.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController emailController =
      TextEditingController(text: 'bayskie123@gmail.com');
  TextEditingController passwordController =
      TextEditingController(text: '12345678');

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
                content: Text(authNotifier.message),
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
                            _loginForm(),
                            const SizedBox(height: 20.0),
                            _registerLink(),
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

  Widget _loginForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          PesseTextField(
            controller: emailController,
            hintText: 'Alamat Surel',
            keyboardType: TextInputType.emailAddress,
            validator: ValidationBuilder(
              requiredMessage: 'Alamat surel tidak boleh kosong',
            ).email('Alamat surel tidak valid').build(),
          ),
          const SizedBox(height: 20.0),
          PessePasswordField(
            controller: passwordController,
            hintText: 'Kata Sandi',
          ),
          const SizedBox(height: 20.0),
          _loginButton(),
        ],
      ),
    );
  }

  Widget _loginButton() {
    return PesseTextButton(
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          Provider.of<AuthNotifier>(context, listen: false).login(
            email: emailController.text,
            password: passwordController.text,
          );
        }
      },
      label: 'Masuk',
    );
  }

  Widget _registerLink() {
    return Center(
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
                  context.goNamed('register');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';

class PessePasswordField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;

  const PessePasswordField({
    super.key,
    required this.controller,
    required this.hintText,
  });

  @override
  State<PessePasswordField> createState() => _PessePasswordFieldState();
}

class _PessePasswordFieldState extends State<PessePasswordField> {
  bool _isHidden = true;
  final _passwordValidator = ValidationBuilder(
    requiredMessage: 'Kata sandi tidak boleh kosong',
  ).minLength(8, 'Kata sandi minimal 8 karakter').build();

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: _isHidden,
      obscuringCharacter: '•',
      textAlign: TextAlign.left,
      validator: _passwordValidator,
      decoration: InputDecoration(
        hintText: widget.hintText,
        suffixIcon: Transform.translate(
          offset: const Offset(-15, 0),
          child: IconButton(
            icon: _isHidden
                ? const Icon(Icons.visibility)
                : const Icon(Icons.visibility_off),
            onPressed: () {
              setState(() {
                _isHidden = !_isHidden;
              });
            },
          ),
        ),
      ),
    );
  }
}

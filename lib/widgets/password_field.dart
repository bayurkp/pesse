import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      obscureText: _isHidden,
      obscuringCharacter: '•',
      textAlign: TextAlign.left,
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

import 'package:flutter/material.dart';

class PesseTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final TextInputType? keyboardType;

  const PesseTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.keyboardType,
  });

  @override
  State<PesseTextField> createState() => _PesseTextFieldState();
}

class _PesseTextFieldState extends State<PesseTextField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: widget.keyboardType ?? TextInputType.text,
      controller: widget.controller,
      textAlign: TextAlign.left,
      decoration: InputDecoration(
        hintText: widget.hintText,
      ),
    );
  }
}

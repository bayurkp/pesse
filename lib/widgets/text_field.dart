import 'package:flutter/material.dart';
import 'package:pesse/themes/theme_extension.dart';

class PesseTextField extends StatefulWidget {
  final String? labelText;
  final TextEditingController controller;
  final String? hintText;
  final TextInputType keyboardType;
  final bool readOnly;
  final Icon? prefixIcon;
  final Icon? suffixIcon;
  final Function()? onTap;

  const PesseTextField({
    super.key,
    this.labelText,
    required this.controller,
    this.hintText,
    this.keyboardType = TextInputType.text,
    this.readOnly = false,
    this.prefixIcon,
    this.suffixIcon,
    this.onTap,
  });

  @override
  State<PesseTextField> createState() => _PesseTextFieldState();
}

class _PesseTextFieldState extends State<PesseTextField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Builder(
          builder: (context) {
            if (widget.labelText == null) {
              return const SizedBox();
            } else {
              return Text(
                widget.labelText!,
                style: context.label,
              );
            }
          },
        ),
        const SizedBox(
          height: 8.0,
        ),
        TextField(
          keyboardType: widget.keyboardType,
          controller: widget.controller,
          readOnly: widget.readOnly,
          onTap: widget.onTap,
          textAlign: TextAlign.left,
          decoration: InputDecoration(
            prefixIcon: widget.prefixIcon,
            suffixIcon: Transform.translate(
              offset: const Offset(-15, 0),
              child: widget.suffixIcon,
            ),
            hintText: widget.hintText,
          ),
        ),
      ],
    );
  }
}

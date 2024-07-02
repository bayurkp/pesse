import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pesse/themes/colors.dart';
import 'package:pesse/themes/theme_extension.dart';

class PesseTextField extends StatefulWidget {
  final String? labelText;
  final TextEditingController controller;
  final TextInputFormatter? inputFormatters;
  final String? Function(String?)? validator;
  final String? hintText;
  final TextInputType keyboardType;
  final bool readOnly;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final Function()? onTap;
  final Color backgroundColor;
  final EdgeInsetsGeometry? contentPadding;

  const PesseTextField({
    super.key,
    this.labelText,
    required this.controller,
    this.inputFormatters,
    this.validator,
    this.hintText,
    this.keyboardType = TextInputType.text,
    this.readOnly = false,
    this.prefixIcon,
    this.suffixIcon,
    this.onTap,
    this.backgroundColor = PesseColors.surface,
    this.contentPadding,
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
        SizedBox(
          height: widget.labelText == null ? 0.0 : 4.0,
        ),
        TextFormField(
          validator: widget.validator,
          keyboardType: widget.keyboardType,
          controller: widget.controller,
          readOnly: widget.readOnly,
          onTap: widget.onTap,
          textAlign: TextAlign.left,
          inputFormatters:
              widget.inputFormatters != null ? [widget.inputFormatters!] : null,
          decoration: InputDecoration(
            fillColor: widget.backgroundColor,
            prefixIcon: widget.prefixIcon,
            suffixIcon: Transform.translate(
              offset: const Offset(-15, 0),
              child: widget.suffixIcon,
            ),
            hintText: widget.hintText,
            contentPadding: widget.contentPadding,
          ),
        ),
      ],
    );
  }
}

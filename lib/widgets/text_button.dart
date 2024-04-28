import 'package:flutter/material.dart';
import 'package:pesse/themes/colors.dart';
import 'package:pesse/themes/theme_extension.dart';

class PesseTextButton extends StatefulWidget {
  final void Function() onPressed;
  final String label;
  final Color? color;

  const PesseTextButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.color,
  });

  @override
  State<PesseTextButton> createState() => _PesseTextButtonState();
}

class _PesseTextButtonState extends State<PesseTextButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TextButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(
            widget.color ?? PesseColors.primary,
          ),
        ),
        onPressed: widget.onPressed,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            widget.label,
            style: context.body.copyWith(
              color: PesseColors.onPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

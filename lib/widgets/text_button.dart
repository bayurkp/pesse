import 'package:flutter/material.dart';
import 'package:pesse/themes/colors.dart';
import 'package:pesse/themes/theme_extension.dart';

class PesseTextButton extends StatefulWidget {
  final void Function() onPressed;
  final String label;
  final IconData? icon;
  final Color? foregroundColor;
  final Color? backgroundColor;

  const PesseTextButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.icon,
    this.foregroundColor,
    this.backgroundColor,
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
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
          ),
          backgroundColor: MaterialStateProperty.all(
            widget.backgroundColor ?? PesseColors.primary,
          ),
        ),
        onPressed: widget.onPressed,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Builder(
                builder: (context) {
                  return Row(
                    children: <Widget>[
                      if (widget.icon != null)
                        Icon(
                          widget.icon,
                          color:
                              widget.foregroundColor ?? PesseColors.onPrimary,
                        ),
                      const SizedBox(width: 5.0),
                    ],
                  );
                },
              ),
              Text(
                widget.label,
                style: context.body.copyWith(
                  color: widget.foregroundColor ?? PesseColors.onPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

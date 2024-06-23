import 'package:flutter/material.dart';
import 'package:pesse/themes/colors.dart';
import 'package:pesse/themes/theme_extension.dart';

class PesseLabelledIconButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final void Function() onPressed;

  const PesseLabelledIconButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  State<PesseLabelledIconButton> createState() =>
      _PesseLabelledIconButtonState();
}

class _PesseLabelledIconButtonState extends State<PesseLabelledIconButton> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton.filled(
          color: PesseColors.onPrimary,
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(
              PesseColors.primary,
            ),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
            ),
          ),
          onPressed: widget.onPressed,
          icon: SizedBox(
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Icon(
                widget.icon,
                size: 20.0,
              ),
            ),
          ),
        ),
        const SizedBox(height: 10.0),
        SizedBox(
          width: 90.0,
          child: Text(
            widget.label,
            textAlign: TextAlign.center,
            style: context.label,
          ),
        ),
      ],
    );
  }
}

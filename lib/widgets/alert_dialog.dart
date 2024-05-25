import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:pesse/themes/colors.dart';
import 'package:pesse/themes/theme_extension.dart';

class PesseAlertDialog extends StatelessWidget {
  final String title;
  final String content;
  final String? actionLabel;
  final Function? actionOnPressed;

  const PesseAlertDialog({
    super.key,
    required this.title,
    required this.content,
    this.actionLabel,
    this.actionOnPressed,
  }) : assert(
          actionLabel == null || actionOnPressed == null,
          'actionLabel cannot be empty if actionOnPressed is provided or vice versa.',
        );

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        title,
        style: context.title.copyWith(color: PesseColors.primary),
      ),
      content: SingleChildScrollView(
        child: Text(content),
      ),
      actions: <Widget>[
        Builder(
          builder: (context) {
            if (actionLabel == null ||
                actionOnPressed == null ||
                (actionLabel == null && actionOnPressed == null)) {
              return TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: ButtonStyle(
                  padding: const MaterialStatePropertyAll<EdgeInsetsGeometry>(
                    EdgeInsets.all(20.0),
                  ),
                  shape: MaterialStatePropertyAll<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                ),
                child: const Text('Tutup'),
              );
            } else {
              return TextButton(
                child: Text(actionLabel!),
                onPressed: () {
                  actionOnPressed!();
                },
              );
            }
          },
        ),
      ],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
    );
  }
}

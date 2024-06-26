import 'package:flutter/material.dart';
import 'package:pesse/themes/colors.dart';
import 'package:pesse/themes/theme_extension.dart';

enum PesseAlertDialogType { success, error, warning }

class PesseAlertDialog extends StatelessWidget {
  final String title;
  final Widget content;
  final String? actionLabel;
  final Function? actionOnPressed;
  final Function? additionalOnCloseAction;
  final PesseAlertDialogType? type;

  const PesseAlertDialog({
    super.key,
    required this.title,
    required this.content,
    this.actionLabel,
    this.actionOnPressed,
    this.additionalOnCloseAction,
    this.type,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        title,
        style: context.title,
      ),
      content: SingleChildScrollView(
        child: content,
      ),
      actions: <Widget>[
        Builder(
          builder: (context) {
            if (actionLabel != null && actionOnPressed != null) {
              return TextButton(
                style: ButtonStyle(
                  padding: const MaterialStatePropertyAll<EdgeInsetsGeometry>(
                    EdgeInsets.all(15.0),
                  ),
                  shape: MaterialStatePropertyAll<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                  backgroundColor: MaterialStatePropertyAll<Color>(
                    type == PesseAlertDialogType.success
                        ? PesseColors.success
                        : type == PesseAlertDialogType.error
                            ? PesseColors.error
                            : type == PesseAlertDialogType.warning
                                ? PesseColors.warning
                                : PesseColors.primary,
                  ),
                ),
                child: Text(
                  actionLabel!,
                  style: context.label.copyWith(
                    color: PesseColors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onPressed: () {
                  actionOnPressed!();
                },
              );
            } else {
              return Container();
            }
          },
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            if (additionalOnCloseAction != null) {
              additionalOnCloseAction!();
            }
          },
          style: ButtonStyle(
            padding: const MaterialStatePropertyAll<EdgeInsetsGeometry>(
              EdgeInsets.all(15.0),
            ),
            shape: MaterialStatePropertyAll<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
            ),
            backgroundColor: const MaterialStatePropertyAll<Color>(
              PesseColors.surface,
            ),
          ),
          child: Text('Tutup',
              style: context.label.copyWith(
                color: PesseColors.onSurface,
                fontWeight: FontWeight.w600,
              )),
        ),
      ],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      surfaceTintColor: PesseColors.background,
    );
  }
}

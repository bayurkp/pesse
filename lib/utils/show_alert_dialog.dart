import 'package:flutter/material.dart';
import 'package:pesse/widgets/alert_dialog.dart';

Future<void> showPesseAlertDialog(BuildContext context,
    {required String title,
    required Widget content,
    String? actionLabel,
    Function? actionOnPressed,
    Function? additionalOnCloseAction,
    PesseAlertDialogType? type}) async {
  return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return PesseAlertDialog(
          title: title,
          content: content,
          actionLabel: actionLabel,
          actionOnPressed: actionOnPressed,
          additionalOnCloseAction: additionalOnCloseAction,
          type: type,
        );
      });
}

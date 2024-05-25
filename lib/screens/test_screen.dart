import 'package:flutter/material.dart';
import 'package:pesse/utils/show_alert_dialog.dart';
import 'package:pesse/widgets/text_button.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  @override
  Widget build(BuildContext context) {
    return PesseTextButton(
        onPressed: () {
          showPesseAlertDialog(
            context,
            title: 'Test',
            content: 'Test',
          );
        },
        label: "Test");
  }
}

import 'package:flutter/material.dart';
import 'package:pesse/models/member_model.dart';
import 'package:pesse/providers/member_provider.dart';
import 'package:pesse/themes/colors.dart';
import 'package:pesse/themes/theme_extension.dart';
import 'package:pesse/utils/show_alert_dialog.dart';
import 'package:pesse/widgets/bottom_navigation_bar.dart';
import 'package:pesse/widgets/member_form.dart';
import 'package:pesse/widgets/text_button.dart';
import 'package:pesse/widgets/text_field.dart';
import 'package:provider/provider.dart';

class AddMemberScreen extends StatefulWidget {
  const AddMemberScreen({super.key});

  @override
  State<AddMemberScreen> createState() => _AddMemberScreenState();
}

class _AddMemberScreenState extends State<AddMemberScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<MemberNotifier>(
      builder: (context, memberNotifier, child) {
        WidgetsBinding.instance.addPostFrameCallback(
          (_) {
            if (memberNotifier.isSuccess == false) {
              showPesseAlertDialog(
                context,
                title: 'Gagal',
                content: memberNotifier.message,
              );
            }
          },
        );

        return memberNotifier.isPending
            ? const Center(child: CircularProgressIndicator())
            : Scaffold(
                appBar: AppBar(
                  title: const Text('Anggota'),
                ),
                body: const SafeArea(
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Padding(
                      padding: EdgeInsets.all(40.0),
                      child: MemberForm(
                        formType: MemberFormType.add,
                      ),
                    ),
                  ),
                ),
                bottomNavigationBar: const PesseBottomNavigationBar(),
              );
      },
    );
  }
}

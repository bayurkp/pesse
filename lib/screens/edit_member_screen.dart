import 'package:flutter/material.dart';
import 'package:pesse/providers/member_provider.dart';
import 'package:pesse/utils/show_alert_dialog.dart';
import 'package:pesse/widgets/app_bar.dart';
import 'package:pesse/widgets/bottom_navigation_bar.dart';
import 'package:pesse/widgets/member_form.dart';
import 'package:provider/provider.dart';

class EditMemberScreen extends StatefulWidget {
  final String memberId;

  const EditMemberScreen({
    required this.memberId,
    super.key,
  });

  @override
  State<EditMemberScreen> createState() => _EditMemberScreenState();
}

class _EditMemberScreenState extends State<EditMemberScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      Provider.of<MemberNotifier>(context, listen: false)
          .getMemberById(memberId: int.parse(widget.memberId));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MemberNotifier>(builder: (context, memberNotifier, child) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) {
          if (memberNotifier.isSuccess == false) {
            showPesseAlertDialog(
              context,
              title: 'Gagal',
              content: Text(memberNotifier.message),
            );
          }
        },
      );

      return memberNotifier.isPending
          ? const Center(child: CircularProgressIndicator())
          : Scaffold(
              appBar: const PesseAppBar(
                title: 'Tambah Anggota',
              ),
              body: SafeArea(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.all(40.0),
                    child: MemberForm(
                      formType: MemberFormType.edit,
                      member: memberNotifier.member,
                    ),
                  ),
                ),
              ),
              bottomNavigationBar: const PesseBottomNavigationBar(),
            );
    });
  }
}

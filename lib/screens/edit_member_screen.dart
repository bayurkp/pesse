import 'package:flutter/material.dart';
import 'package:pesse/providers/member_provider.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Anggota'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
              padding: const EdgeInsets.all(40.0),
              child: Consumer<MemberNotifier>(
                  builder: (context, memberNotifier, child) {
                return MemberForm(
                  formType: MemberFormType.edit,
                  member: memberNotifier.member,
                );
              })),
        ),
      ),
    );
  }
}
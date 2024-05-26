import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pesse/models/member_model.dart';
import 'package:pesse/providers/member_provider.dart';
import 'package:pesse/themes/colors.dart';
import 'package:pesse/utils/format_full_name.dart';
import 'package:pesse/utils/show_alert_dialog.dart';
import 'package:pesse/widgets/bottom_navigation_bar.dart';
import 'package:pesse/widgets/isactive_indicator.dart';
import 'package:provider/provider.dart';

class MembersScreen extends StatefulWidget {
  const MembersScreen({super.key});

  @override
  State<MembersScreen> createState() => _MembersScreenState();
}

class _MembersScreenState extends State<MembersScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      Provider.of<MemberNotifier>(context, listen: false).getMembers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MemberNotifier>(
      builder: (context, memberNotifier, child) {
        return memberNotifier.isPending
            ? const Center(child: CircularProgressIndicator())
            : Scaffold(
                appBar: AppBar(
                  title: const Text('Anggota'),
                ),
                body: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        IconButton.filled(
                          color: PesseColors.onPrimary,
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                            ),
                          ),
                          onPressed: () {
                            context.pushNamed('member.add');
                          },
                          icon: const SizedBox(
                            width: double.infinity,
                            child: Padding(
                              padding: EdgeInsets.all(5.0),
                              child: Icon(Icons.group_add_rounded),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20.0),
                        Expanded(
                          child: ListView.builder(
                            itemCount: memberNotifier.members.length,
                            itemBuilder: (context, index) {
                              return _memberListTile(
                                  memberNotifier.members[index]);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                bottomNavigationBar: const PesseBottomNavigationBar(),
              );
      },
    );
  }

  Widget _memberListTile(Member member) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: member.imageUrl == null
          ? const Icon(Icons.person)
          : CircleAvatar(
              radius: 15,
              backgroundImage: NetworkImage(member.imageUrl!),
            ),
      title: Text(
        formatFullName(member.name),
        // style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: IsActiveIndicator(
        isActive: member.isActive,
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          GestureDetector(
            child: const Icon(Icons.account_balance_wallet_rounded),
            onTap: () {
              context.pushNamed(
                'member.details',
                pathParameters: {'memberId': member.id.toString()},
              );
            },
          ),
          const SizedBox(width: 5.0),
          GestureDetector(
            child: const Icon(Icons.edit),
            onTap: () {
              context.pushNamed(
                'member.edit',
                pathParameters: {'memberId': member.id.toString()},
              );
            },
          ),
          const SizedBox(width: 5.0),
          GestureDetector(
            child: const Icon(Icons.delete),
            onTap: () {
              showPesseAlertDialog(
                context,
                title: 'Hapus Anggota',
                content: 'Apakah Anda yakin ingin menghapus ${member.name}?',
                actionLabel: 'Hapus',
                actionOnPressed: () {
                  Navigator.of(context).pop();
                  Provider.of<MemberNotifier>(context, listen: false)
                      .removeMember(member.id);
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

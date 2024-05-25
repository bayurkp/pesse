import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pesse/providers/member_provider.dart';
import 'package:pesse/widgets/bottom_navigation_bar.dart';
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
                body: ListView.builder(
                  itemCount: memberNotifier.members.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(memberNotifier.members[index].name),
                      subtitle: Text(memberNotifier.members[index].address),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          GestureDetector(
                            child: const Icon(Icons.edit),
                            onTap: () {
                              context.pushNamed(
                                'member.edit',
                                pathParameters: {
                                  'memberId': memberNotifier.members[index].id
                                      .toString()
                                },
                              );
                            },
                          ),
                          GestureDetector(
                            child: const Icon(Icons.delete),
                            onTap: () {
                              memberNotifier.removeMember(
                                memberNotifier.members[index].id,
                              );
                            },
                          ),
                        ],
                      ),
                      leading: const Icon(Icons.account_circle),
                    );
                  },
                ),
                floatingActionButton: FloatingActionButton(
                  onPressed: () {
                    context.pushNamed('member.add');
                  },
                  child: const Icon(Icons.add),
                ),
                bottomNavigationBar: const PesseBottomNavigationBar(),
              );
      },
    );
  }
}

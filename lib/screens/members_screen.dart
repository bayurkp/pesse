import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:pesse/models/member_model.dart';
import 'package:pesse/providers/member_provider.dart';
import 'package:pesse/themes/colors.dart';
import 'package:pesse/themes/theme_extension.dart';
import 'package:pesse/utils/format_full_name.dart';
import 'package:pesse/utils/show_alert_dialog.dart';
import 'package:pesse/widgets/bottom_navigation_bar.dart';
import 'package:pesse/widgets/isactive_indicator.dart';
import 'package:pesse/widgets/text_field.dart';
import 'package:provider/provider.dart';

class MembersScreen extends StatefulWidget {
  const MembersScreen({super.key});

  @override
  State<MembersScreen> createState() => _MembesrScreenState();
}

class _MembesrScreenState extends State<MembersScreen> {
  TextEditingController searchController = TextEditingController();

  List<Member> members = [];
  List<Member> filteredMembers = [];
  Map<String, List<Member>> groupedMembers = {};

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      Provider.of<MemberNotifier>(context, listen: false)
          .getMembers()
          .then((_) {
        setState(() {
          members = Provider.of<MemberNotifier>(context, listen: false).members;
          filteredMembers = members;
          groupMembersByAlphabet();
        });
      });
    });

    searchController.addListener(() {
      setState(() {
        filteredMembers = members.where((member) {
          return member.name
              .toLowerCase()
              .contains(searchController.text.toLowerCase());
        }).toList();
        groupMembersByAlphabet();
      });
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void groupMembersByAlphabet() {
    groupedMembers = {};
    for (var member in filteredMembers) {
      if (groupedMembers[member.name[0].toUpperCase()] == null) {
        groupedMembers[member.name[0].toUpperCase()] = <Member>[];
      }

      groupedMembers[member.name[0].toUpperCase()]!.add(member);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MemberNotifier>(
      builder: (context, memberNotifier, child) {
        // WidgetsBinding.instance.addPostFrameCallback(
        //   (_) {
        //     if (memberNotifier.isSuccess == false) {
        //       showPesseAlertDialog(
        //         context,
        //         title: 'Gagal',
        //         content: memberNotifier.message,
        //       );
        //     }
        //   },
        // );

        filteredMembers = memberNotifier.members;
        return Scaffold(
          appBar: AppBar(
            backgroundColor: PesseColors.transparent,
            surfaceTintColor: PesseColors.transparent,
            elevation: 0,
            title: Row(
              children: [
                SvgPicture.asset(
                  'assets/images/min_logo.svg',
                  semanticsLabel: 'Pesse\'s Logo',
                  height: 25.0,
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  'Anggota',
                  style: context.titleMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          body: memberNotifier.isPending
              ? const Center(child: CircularProgressIndicator())
              : SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: PesseTextField(
                                controller: searchController,
                                hintText: 'Cari anggota',
                                prefixIcon: const Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 10.0),
                                  child: Icon(
                                    Icons.search,
                                    size: 20.0,
                                  ),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 20.0,
                                  vertical: 10.0,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10.0),
                            IconButton.filled(
                              color: PesseColors.onSurface,
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                  PesseColors.surface,
                                ),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                ),
                              ),
                              onPressed: () {
                                context.pushNamed('member.add');
                              },
                              icon: const SizedBox(
                                child: Padding(
                                  padding: EdgeInsets.all(5.0),
                                  child: Icon(
                                    Icons.group_add_rounded,
                                    size: 20.0,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20.0),
                        Expanded(
                          child: ListView(
                            physics: const BouncingScrollPhysics(),
                            children: <Widget>[
                              for (var entry in groupedMembers.entries)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    groupedMembers.entries.first.key !=
                                            entry.key
                                        ? const SizedBox(
                                            height: 20.0,
                                          )
                                        : Container(),
                                    Text(
                                      entry.key,
                                      style: context.titleMedium,
                                    ),
                                    ListView.builder(
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: entry.value.length,
                                      itemBuilder: (context, index) {
                                        return _memberListTile(
                                            entry.value[index]);
                                      },
                                    ),
                                    groupedMembers.entries.last.key != entry.key
                                        ? const Divider(
                                            color: PesseColors.surface,
                                          )
                                        : Container(),
                                  ],
                                ),
                            ],
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
    return GestureDetector(
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: member.imageUrl == null
            ? const Icon(Icons.person)
            : ClipOval(
                child: Image.network(
                  member.imageUrl!,
                  height: 35,
                  width: 35,
                  fit: BoxFit.cover,
                  cacheWidth: 35,
                  cacheHeight: 35,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    }
                    return const CircularProgressIndicator();
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      'assets/images/default_person.jpg',
                      height: 35,
                      width: 35,
                      fit: BoxFit.cover,
                      cacheWidth: 35,
                      cacheHeight: 35,
                    );
                  },
                ),
              ),
        title: Text(
          formatFullName(member.name),
        ),
        subtitle: IsActiveIndicator(
          isActive: member.isActive,
        ),
        trailing: GestureDetector(
          child: const Icon(Icons.info),
          onTap: () {
            context.pushNamed(
              'member.details',
              pathParameters: {'memberId': member.id.toString()},
            );
          },
        ),
      ),
      onTap: () {
        context.pushNamed(
          'member.details',
          pathParameters: {'memberId': member.id.toString()},
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:pesse/providers/member_provider.dart';
import 'package:pesse/themes/colors.dart';
import 'package:provider/provider.dart';

class PesseDropdownMenu extends StatefulWidget {
  final List<DropdownMenuEntry<String>> dropdownMenuEntries;
  final TextEditingController dropdownController;
  final Function(String?) onSelected;
  final String selectedEntry;

  const PesseDropdownMenu({
    super.key,
    required this.dropdownMenuEntries,
    required this.onSelected,
    required this.selectedEntry,
    required this.dropdownController,
  });

  @override
  State<PesseDropdownMenu> createState() => _PesseDropdownMenuState();
}

class _PesseDropdownMenuState extends State<PesseDropdownMenu> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: PesseColors.surface,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: DropdownMenu(
        expandedInsets: const EdgeInsets.all(0.0),
        dropdownMenuEntries: Provider.of<MemberNotifier>(context)
            .members
            .map((member) => DropdownMenuEntry<String>(
                  value: member.id.toString(),
                  label: member.name,
                ))
            .toList(),
        controller: widget.dropdownController,
        enableSearch: true,
        menuHeight: 150.0,
        menuStyle: MenuStyle(
          backgroundColor:
              MaterialStateProperty.all<Color>(PesseColors.surface),
          shape: MaterialStateProperty.all<OutlinedBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
          ),
          padding: MaterialStateProperty.all<EdgeInsets>(
            const EdgeInsets.only(top: 20),
          ),
          elevation: MaterialStateProperty.all<double>(0.0),
        ),
        onSelected: widget.onSelected,
      ),
    );
  }
}

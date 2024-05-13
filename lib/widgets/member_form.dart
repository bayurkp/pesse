import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pesse/models/member_model.dart';
import 'package:pesse/providers/member_provider.dart';
import 'package:pesse/themes/colors.dart';
import 'package:pesse/themes/theme_extension.dart';
import 'package:pesse/widgets/text_button.dart';
import 'package:pesse/widgets/text_field.dart';
import 'package:provider/provider.dart';

enum MemberFormType { add, edit }

class MemberForm extends StatefulWidget {
  final MemberFormType formType;
  final Member? member;

  const MemberForm({
    super.key,
    required this.formType,
    this.member,
  }) : assert(formType == MemberFormType.edit ? member != null : true,
            'Member is required for edit form type');

  @override
  State<MemberForm> createState() => _MemberFormState();
}

class _MemberFormState extends State<MemberForm> {
  int? _isActive;

  @override
  Widget build(BuildContext context) {
    GlobalKey formKey = GlobalKey<FormState>();
    final memberNumberController = TextEditingController();
    final nameController = TextEditingController();
    final addressController = TextEditingController();
    final birthDateController = TextEditingController();
    final phoneNumberController = TextEditingController();
    final imageUrlController = TextEditingController();

    if (widget.formType == MemberFormType.edit) {
      memberNumberController.text = widget.member!.memberNumber.toString();
      nameController.text = widget.member!.name;
      addressController.text = widget.member!.address;
      birthDateController.text = widget.member!.birthDate;
      phoneNumberController.text = widget.member!.phoneNumber;
      imageUrlController.text = widget.member?.imageUrl ?? '';
      _isActive = widget.member!.isActive;
    }

    void handleRadioValueChange(int? value) {
      setState(() {
        _isActive = value;
      });
    }

    Future<void> selectDate() async {
      DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime(2100),
      );

      if (pickedDate != null) {
        birthDateController.text = pickedDate.toString().substring(0, 10);
      }
    }

    return Form(
      key: formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          PesseTextField(
            labelText: 'Nomor Induk',
            controller: memberNumberController,
          ),
          const SizedBox(height: 20.0),
          PesseTextField(
            labelText: 'Nama',
            controller: nameController,
          ),
          const SizedBox(height: 20.0),
          PesseTextField(
            labelText: 'Alamat',
            controller: addressController,
          ),
          const SizedBox(height: 20.0),
          PesseTextField(
            labelText: 'Tanggal Lahir',
            controller: birthDateController,
            hintText: 'TTTT-BB-HH',
            suffixIcon: const Icon(Icons.calendar_month),
            readOnly: true,
            onTap: () {
              selectDate();
            },
          ),
          const SizedBox(height: 20.0),
          PesseTextField(
            labelText: 'Telepon',
            controller: phoneNumberController,
          ),
          const SizedBox(height: 20.0),
          PesseTextField(
            labelText: 'Gambar',
            controller: imageUrlController,
          ),
          const SizedBox(height: 20.0),
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              'Status',
              style: context.label,
            ),
          ),
          const SizedBox(height: 8.0),
          Row(
            children: <Widget>[
              Expanded(
                child: RadioListTile<int>(
                  title: Text(
                    'Aktif',
                    style: context.label,
                  ),
                  tileColor: PesseColors.surface,
                  contentPadding: const EdgeInsets.all(5.0),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(15.0),
                    ),
                  ),
                  value: 1,
                  groupValue: _isActive,
                  onChanged: handleRadioValueChange,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: RadioListTile<int>(
                  title: Text(
                    'Tidak Aktif',
                    style: context.label,
                  ),
                  tileColor: PesseColors.surface,
                  contentPadding: const EdgeInsets.all(5.0),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(15.0),
                    ),
                  ),
                  value: 0,
                  groupValue: _isActive,
                  onChanged: handleRadioValueChange,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20.0),
          PesseTextButton(
            onPressed: () {
              final newMember = Member(
                id: widget.formType == MemberFormType.edit
                    ? widget.member!.id
                    : 0,
                memberNumber: int.parse(memberNumberController.text),
                name: nameController.text,
                address: addressController.text,
                birthDate: birthDateController.text,
                phoneNumber: phoneNumberController.text,
                imageUrl: imageUrlController.text,
                isActive: _isActive ?? 1,
              );

              if (widget.formType == MemberFormType.edit) {
                Provider.of<MemberNotifier>(context, listen: false)
                    .updateMember(
                  member: newMember,
                );
              } else {
                Provider.of<MemberNotifier>(context, listen: false).addMember(
                  member: newMember,
                );
              }
              context.goNamed('members.index');
            },
            label: widget.formType == MemberFormType.add
                ? 'Tambah Anggota'
                : 'Edit Anggota',
          ),
        ],
      ),
    );
  }
}

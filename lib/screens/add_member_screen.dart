import 'package:flutter/material.dart';
import 'package:pesse/models/member_model.dart';
import 'package:pesse/providers/member_provider.dart';
import 'package:pesse/themes/colors.dart';
import 'package:pesse/themes/theme_extension.dart';
import 'package:pesse/widgets/bottom_navigation_bar.dart';
import 'package:pesse/widgets/text_button.dart';
import 'package:pesse/widgets/text_field.dart';
import 'package:provider/provider.dart';

class AddMemberScreen extends StatefulWidget {
  const AddMemberScreen({super.key});

  @override
  State<AddMemberScreen> createState() => _AddMemberScreenState();
}

class _AddMemberScreenState extends State<AddMemberScreen> {
  int? _isActive;

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
            child: _addMemberForm(context, null),
          ),
        ),
      ),
      bottomNavigationBar: const PesseBottomNavigationBar(),
    );
  }

  Widget _addMemberForm(BuildContext context, Member? member) {
    GlobalKey formKey = GlobalKey<FormState>();
    final memberNumberController = TextEditingController(text: '1023');
    final nameController = TextEditingController(text: 'John Doe');
    final addressController =
        TextEditingController(text: '123 Main St, Anytown USA');
    final birthDateController = TextEditingController(text: '1990-01-01');
    final phoneNumberController = TextEditingController(text: '1234567890');
    final imageUrlController = TextEditingController();

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
              member = Member(
                id: 0,
                memberNumber: int.parse(memberNumberController.text),
                name: nameController.text,
                address: addressController.text,
                birthDate: birthDateController.text,
                phoneNumber: phoneNumberController.text,
                imageUrl: imageUrlController.text,
                isActive: _isActive ?? 1,
              );

              Provider.of<MemberNotifier>(context, listen: false).addMember(
                member: member!,
              );
            },
            label: 'Tambah Anggota',
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:go_router/go_router.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:pesse/models/member_model.dart';
import 'package:pesse/providers/area_provider.dart';
import 'package:pesse/providers/member_provider.dart';
import 'package:pesse/themes/colors.dart';
import 'package:pesse/themes/theme_extension.dart';
import 'package:pesse/utils/parse_area_code.dart';
import 'package:pesse/widgets/dropdown.dart';
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
  final _formKey = GlobalKey<FormState>();

  late final AreaNotifier _areaNotifier;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _provinceController = TextEditingController();
  final TextEditingController _regencyController = TextEditingController();
  final TextEditingController _districtController = TextEditingController();
  final TextEditingController _villageController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();

  final _phoneInputFormatter = MaskTextInputFormatter(
    mask: '+62 ####-####-######',
    type: MaskAutoCompletionType.eager,
  );

  int _isActive = 0;
  final ValueNotifier<String> _selectedProvinceCode = ValueNotifier<String>('');
  final ValueNotifier<String> _selectedRegencyCode = ValueNotifier<String>('');
  final ValueNotifier<String> _selectedDistrictCode = ValueNotifier<String>('');
  final ValueNotifier<String> _selectedVillageCode = ValueNotifier<String>('');

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initData();
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _birthDateController.dispose();
    _phoneNumberController.dispose();
    _imageUrlController.dispose();
    _provinceController.dispose();
    _regencyController.dispose();
    _districtController.dispose();
    _villageController.dispose();
    _selectedProvinceCode.dispose();
    _selectedRegencyCode.dispose();
    _selectedDistrictCode.dispose();
    _selectedVillageCode.dispose();
    super.dispose();
  }

  void _initData() {
    _areaNotifier = Provider.of<AreaNotifier>(context, listen: false);

    if (widget.formType == MemberFormType.edit && widget.member != null) {
      _nameController.text = widget.member!.name;
      _birthDateController.text = widget.member!.birthDate;
      _phoneNumberController.text = widget.member!.phoneNumber;
      _imageUrlController.text = widget.member!.imageUrl ?? '';
      _isActive = widget.member!.isActive;

      final codes = parseAreaCodeInAddress(widget.member!.address);
      if (codes.isNotEmpty) {
        _initArea(widget.member!.address);

        String tempAddress = widget.member!.address;
        List<String> tempAddresses = tempAddress.split(',');
        int start = tempAddresses.length - 4;
        tempAddresses.removeRange(start, tempAddresses.length);

        _addressController.text = tempAddresses.join(',');
      } else {
        _addressController.text = widget.member!.address;
      }
    } else {
      _isActive = 1;
    }

    _areaNotifier.getProvinces();
    _addAreaListeners();
  }

  Future<void> _initArea(String address) async {
    final List<String> codes = parseAreaCodeInAddress(address);
    _setSelectedAreaCodes(codes);
    await _fetchAreaData();
    _updateUIWithAreaData();
  }

  void _setSelectedAreaCodes(List<String> codes) {
    _selectedProvinceCode.value = codes[0];
    _selectedRegencyCode.value = codes[1];
    _selectedDistrictCode.value = codes[2];
    _selectedVillageCode.value = codes[3];
  }

  void _updateUIWithAreaData() {
    if (!mounted) return;

    _provinceController.text =
        _getNameForCode(_areaNotifier.provinces, _selectedProvinceCode.value);
    _regencyController.text =
        _getNameForCode(_areaNotifier.regencies, _selectedRegencyCode.value);
    _districtController.text =
        _getNameForCode(_areaNotifier.districts, _selectedDistrictCode.value);
    _villageController.text =
        _getNameForCode(_areaNotifier.villages, _selectedVillageCode.value);
  }

  Future<void> _fetchAreaData() async {
    await _areaNotifier.getProvinces();
    await _areaNotifier.getRegencies(_selectedProvinceCode.value);
    await _areaNotifier.getDistricts(
      _selectedProvinceCode.value,
      _selectedRegencyCode.value,
    );
    await _areaNotifier.getVillages(
      _selectedProvinceCode.value,
      _selectedRegencyCode.value,
      _selectedDistrictCode.value,
    );
  }

  String _getNameForCode(List<dynamic> areaList, String code) {
    try {
      return areaList.firstWhere((area) => area.code == code).name;
    } catch (e) {
      return '';
    }
  }

  void _addAreaListeners() {
    _selectedProvinceCode.addListener(() {
      _areaNotifier.getRegencies(_selectedProvinceCode.value);
      _clearControllers(
          [_regencyController, _districtController, _villageController]);
    });

    _selectedRegencyCode.addListener(() {
      _areaNotifier.getDistricts(
          _selectedProvinceCode.value, _selectedRegencyCode.value);
      _clearControllers([_districtController, _villageController]);
    });

    _selectedDistrictCode.addListener(() {
      _areaNotifier.getVillages(
        _selectedProvinceCode.value,
        _selectedRegencyCode.value,
        _selectedDistrictCode.value,
      );
      _villageController.clear();
    });
  }

  void _clearControllers(List<TextEditingController> controllers) {
    for (var controller in controllers) {
      controller.clear();
    }
  }

  void _onIsActiveChange(int? value) {
    setState(() {
      _isActive = value ?? 1;
    });
  }

  Future<void> _selectDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      _birthDateController.text = pickedDate.toString().substring(0, 10);
    }
  }

  int _generateMemberNumber() {
    int milliseconds = DateTime.now().millisecondsSinceEpoch;
    int memberNumber = milliseconds % 10000;

    return memberNumber;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MemberNotifier>(
      builder: (context, memberNotifier, child) {
        return Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              PesseTextField(
                labelText: 'Nama',
                validator: ValidationBuilder(
                  requiredMessage: 'Nama tidak boleh kosong',
                ).build(),
                controller: _nameController,
              ),
              const SizedBox(height: 20.0),
              Consumer<AreaNotifier>(
                builder: (context, areaNotifier, child) {
                  return Column(
                    children: [
                      _buildAreaDropdown(
                        label: 'Provinsi',
                        valueListenable: _selectedProvinceCode,
                        controller: _provinceController,
                        entries: areaNotifier.provinces
                            .map((province) => DropdownMenuEntry<String>(
                                  value: province.code,
                                  label: province.name,
                                ))
                            .toList(),
                      ),
                      const SizedBox(height: 20.0),
                      _buildAreaDropdown(
                        label: 'Kabupaten/Kota',
                        valueListenable: _selectedRegencyCode,
                        controller: _regencyController,
                        entries: areaNotifier.regencies
                            .map((regency) => DropdownMenuEntry<String>(
                                  value: regency.code,
                                  label: regency.name,
                                ))
                            .toList(),
                      ),
                      const SizedBox(height: 20.0),
                      _buildAreaDropdown(
                        label: 'Kecamatan',
                        valueListenable: _selectedDistrictCode,
                        controller: _districtController,
                        entries: areaNotifier.districts
                            .map((district) => DropdownMenuEntry<String>(
                                  value: district.code,
                                  label: district.name,
                                ))
                            .toList(),
                      ),
                      const SizedBox(height: 20.0),
                      _buildAreaDropdown(
                        label: 'Desa/Kelurahan',
                        valueListenable: _selectedVillageCode,
                        controller: _villageController,
                        entries: areaNotifier.villages
                            .map((village) => DropdownMenuEntry<String>(
                                  value: village.code,
                                  label: village.name,
                                ))
                            .toList(),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 20.0),
              PesseTextField(
                labelText: 'Alamat',
                controller: _addressController,
                validator: ValidationBuilder(
                  requiredMessage: 'Alamat tidak boleh kosong',
                ).build(),
              ),
              const SizedBox(height: 20.0),
              PesseTextField(
                labelText: 'Tanggal Lahir',
                controller: _birthDateController,
                validator: ValidationBuilder(
                  requiredMessage: 'Tanggal lahir tidak boleh kosong',
                ).build(),
                hintText: 'TTTT-BB-HH',
                suffixIcon: const Icon(Icons.calendar_month),
                readOnly: true,
                onTap: () {
                  _selectDate();
                },
              ),
              const SizedBox(height: 20.0),
              PesseTextField(
                labelText: 'Telepon',
                controller: _phoneNumberController,
                keyboardType: TextInputType.phone,
                inputFormatters: _phoneInputFormatter,
                validator: ValidationBuilder(
                  requiredMessage: 'Nomor telepon tidak boleh kosong',
                ).build(),
              ),
              const SizedBox(height: 20.0),
              PesseTextField(
                labelText: 'Gambar',
                controller: _imageUrlController,
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
                      onChanged: _onIsActiveChange,
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
                      onChanged: _onIsActiveChange,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20.0),
              _submitButton(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAreaDropdown({
    required ValueNotifier<String> valueListenable,
    required TextEditingController controller,
    required List<DropdownMenuEntry<String>> entries,
    required String label,
  }) {
    return ValueListenableBuilder<String>(
      valueListenable: valueListenable,
      builder: (context, selectedValue, child) {
        return Column(
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                label,
                style: context.label,
              ),
            ),
            PesseDropdownMenu(
              dropdownMenuEntries: entries,
              onSelected: (String? value) {
                valueListenable.value = value!;
              },
              selectedEntry: selectedValue,
              dropdownController: controller,
            ),
          ],
        );
      },
    );
  }

  Widget _submitButton() {
    return Consumer<MemberNotifier>(
      builder: (context, memberNotifier, child) {
        return PesseTextButton(
          onPressed: () {
            late final Area area;

            if (_formKey.currentState!.validate()) {
              area = Area(
                province: Province(
                  code: _selectedProvinceCode.value,
                  name: _provinceController.text,
                ),
                regency: Regency(
                  code: _selectedRegencyCode.value,
                  name: _regencyController.text,
                ),
                district: District(
                  code: _selectedDistrictCode.value,
                  name: _districtController.text,
                ),
                village: Village(
                  code: _selectedVillageCode.value,
                  name: _villageController.text,
                ),
              );

              String address = _addressController.text.trim() +
                  (area.toString().isEmpty ? '' : ', ${area.toString()}');

              final newMember = Member(
                id: widget.formType == MemberFormType.edit
                    ? widget.member!.id
                    : 0,
                memberNumber: widget.formType == MemberFormType.edit
                    ? widget.member!.memberNumber
                    : _generateMemberNumber(),
                name: _nameController.text,
                address: address,
                birthDate: _birthDateController.text,
                phoneNumber: _phoneNumberController.text,
                imageUrl: _imageUrlController.text,
                isActive: _isActive,
              );

              if (widget.formType == MemberFormType.edit) {
                memberNotifier.updateMember(
                  member: newMember,
                );
              } else {
                memberNotifier.addMember(
                  member: newMember,
                );
              }

              if (memberNotifier.isSuccess == true) {
                context.replaceNamed('members.index');
              }
            }
          },
          label: widget.formType == MemberFormType.add
              ? 'Tambah Anggota'
              : 'Edit Anggota',
        );
      },
    );
  }
}

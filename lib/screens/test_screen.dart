import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pesse/providers/area_provider.dart';
import 'package:pesse/widgets/app_bar.dart';
import 'package:pesse/widgets/dropdown.dart';
import 'package:provider/provider.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  late final AreaNotifier _areaNotifier;

  final TextEditingController _provinceController = TextEditingController();
  final TextEditingController _regencyController = TextEditingController();
  final TextEditingController _districtController = TextEditingController();
  final TextEditingController _villageController = TextEditingController();

  final ValueNotifier<String> _selectedProvinceCode = ValueNotifier<String>('');
  final ValueNotifier<String> _selectedRegencyCode = ValueNotifier<String>('');
  final ValueNotifier<String> _selectedDistrictCode = ValueNotifier<String>('');
  final ValueNotifier<String> _selectedVillageCode = ValueNotifier<String>('');

  @override
  void initState() {
    super.initState();
    _areaNotifier = Provider.of<AreaNotifier>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _areaNotifier.getProvinces();
    });

    _addListeners();
  }

  void _addListeners() {
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

  @override
  void dispose() {
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

  @override
  Widget build(BuildContext context) {
    print(_selectedVillageCode.value);
    return Scaffold(
      appBar: const PesseAppBar(
        title: 'Test Screen',
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Consumer<AreaNotifier>(
            builder: (context, areaNotifier, child) {
              return Column(
                children: [
                  _buildDropdown(
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
                  _buildDropdown(
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
                  _buildDropdown(
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
                  _buildDropdown(
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
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required ValueNotifier<String> valueListenable,
    required TextEditingController controller,
    required List<DropdownMenuEntry<String>> entries,
  }) {
    return ValueListenableBuilder<String>(
      valueListenable: valueListenable,
      builder: (context, selectedValue, child) {
        return PesseDropdownMenu(
          dropdownMenuEntries: entries,
          onSelected: (String? value) {
            valueListenable.value = value!;
          },
          selectedEntry: selectedValue,
          dropdownController: controller,
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pesse/utils/format_sentence_case.dart';

class Province {
  final String code;
  final String name;

  Province({required this.code, required this.name});
}

class Regency {
  final String code;
  final String name;

  Regency({required this.code, required this.name});
}

class District {
  final String code;
  final String name;

  District({required this.code, required this.name});
}

class Village {
  final String code;
  final String name;

  Village({required this.code, required this.name});
}

class Area {
  final Province province;
  final Regency regency;
  final District district;
  final Village village;

  Area({
    required this.province,
    required this.regency,
    required this.district,
    required this.village,
  });

  String getCode() {
    return '${province.code}${regency.code}${district.code}${village.code}';
  }

  List<String> getCodes(String code) {
    List<String> codes = [];

    codes.add(code.substring(0, 2));
    codes.add(code.substring(2, 4));
    codes.add(code.substring(4, 7));
    codes.add(code.substring(7, 10));

    return codes;
  }

  @override
  String toString() {
    String area =
        '${village.name}, ${district.name}, ${regency.name}, ${province.name} ${getCode()}';
    return formatSentenceCase(area);
  }
}

class AreaNotifier with ChangeNotifier {
  final String apiUrl = dotenv.env['INDONESIA_AREA_API_URL']!;
  final dio = Dio();
  bool _isPending = false;

  List<Province> _provinces = [
    Province(code: '0', name: ''),
  ];
  List<Regency> _regencies = [
    Regency(code: '0', name: ''),
  ];
  List<District> _districts = [
    District(code: '0', name: ''),
  ];
  List<Village> _villages = [
    Village(code: '0', name: ''),
  ];

  Area _selectedArea = Area(
    province: Province(code: '0', name: ''),
    regency: Regency(code: '0', name: ''),
    district: District(code: '0', name: ''),
    village: Village(code: '0', name: ''),
  );

  List<Province> get provinces => _provinces;
  List<Regency> get regencies => _regencies;
  List<District> get districts => _districts;
  List<Village> get villages => _villages;
  Area get selectedArea => _selectedArea;

  bool get isPending => _isPending;

  Future<void> getProvinces() async {
    _isPending = true;
    notifyListeners();

    try {
      final response = await dio.get('$apiUrl/list_pro', queryParameters: {
        'thn': '2024',
        'lvl': '10',
      });

      Map<String, dynamic> data = response.data;
      _provinces = data.entries
          .map(
            (entry) => Province(
              code: entry.key,
              name: entry.value,
            ),
          )
          .toList();

      _isPending = false;
      notifyListeners();
    } on DioException catch (e) {
      print('Dio error: ${e.message}');
    } catch (e) {
      print('Unexpected error: $e');
    }
  }

  Future<void> getRegencies(String provinceCode) async {
    _isPending = true;
    notifyListeners();

    try {
      final response = await dio.get('$apiUrl/list_kab', queryParameters: {
        'thn': '2024',
        'lvl': '11',
        'pro': provinceCode,
      });

      Map<String, dynamic> data = response.data;
      _regencies = data.entries
          .map(
            (entry) => Regency(
              code: entry.key,
              name: entry.value,
            ),
          )
          .toList();

      _isPending = false;
      notifyListeners();
    } on DioException catch (e) {
      print('Dio error: ${e.message}');
    } catch (e) {
      print('Unexpected error: $e');
    }
  }

  Future<void> getDistricts(String provinceCode, String regencyCode) async {
    _isPending = true;
    notifyListeners();

    try {
      final response = await dio.get('$apiUrl/list_kec', queryParameters: {
        'thn': '2024',
        'lvl': '12',
        'pro': provinceCode,
        'kab': regencyCode,
      });

      Map<String, dynamic> data = response.data;
      _districts = data.entries
          .map(
            (entry) => District(
              code: entry.key,
              name: entry.value,
            ),
          )
          .toList();

      _isPending = false;
      notifyListeners();
    } on DioException catch (e) {
      print('Dio error: ${e.message}');
    } catch (e) {
      print('Unexpected error: $e');
    }
  }

  Future<void> getVillages(
    String provinceCode,
    String regencyCode,
    String districtCode,
  ) async {
    _isPending = true;
    notifyListeners();

    try {
      final response = await dio.get('$apiUrl/list_des', queryParameters: {
        'thn': '2024',
        'lvl': '13',
        'pro': provinceCode,
        'kab': regencyCode,
        'kec': districtCode,
      });

      Map<String, dynamic> data = response.data;
      _villages = data.entries
          .map(
            (entry) => Village(
              code: entry.key,
              name: entry.value,
            ),
          )
          .toList();

      _isPending = false;
      notifyListeners();
    } on DioException catch (e) {
      print('Dio error: ${e.message}');
    } catch (e) {
      print('Unexpected error: $e');
    }
  }

  Future<void> setSelectedArea(Area area) async {
    _selectedArea = area;
    notifyListeners();
  }
}

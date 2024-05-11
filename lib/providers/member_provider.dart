import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pesse/models/member_model.dart';

class MemberNotifier extends ChangeNotifier {
  final String apiUrl = dotenv.env['API_URL']!;
  final dio = Dio();

  bool _isPending = false;
  String _message = '';
  bool _isSuccess = true;
  List<Member> _members = <Member>[];

  bool get isPending => _isPending;
  String get message => _message;
  bool get isSuccess => _isSuccess;
  List<Member> get members => _members;

  Future<void> getMembers() async {
    _isPending = true;
    try {
      final response = await dio.get(
        '$apiUrl/anggota',
        options: Options(
          headers: {'Authorization': 'Bearer ${GetStorage().read('token')}'},
        ),
      );

      print(response);

      // _members = (response.data['data'] as List)
      //     .map((e) => Member.fromJson(e))
      //     .toList();

      _isPending = false;
      notifyListeners();
    } on DioException catch (e) {
      print(e);
      _isPending = false;
      notifyListeners();
    }
  }
}

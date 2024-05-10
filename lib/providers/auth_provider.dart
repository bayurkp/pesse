import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_storage/get_storage.dart';

class AuthNotifier with ChangeNotifier {
  final String apiUrl = dotenv.env['API_URL']!;
  final dio = Dio();

  bool _isPending = false;
  String _message = '';
  bool _isSuccess = true;
  bool _isLoggedIn = false;

  get isPending => _isPending;
  get message => _message;
  get isSuccess => _isSuccess;
  get isLoggedIn => _isLoggedIn;

  Future<void> login({required String email, required String password}) async {
    _isPending = true;
    try {
      final response = await dio.post('$apiUrl/login', data: {
        'email': email,
        'password': password,
      });

      print(response);

      GetStorage().write('token', response.data['data']['token']);
      GetStorage().write('user', response.data['data']['user']);

      _isPending = false;
      _isLoggedIn = true;
      notifyListeners();
    } on DioException catch (e) {
      print(e);
      _isPending = false;
      notifyListeners();
    }
  }
}

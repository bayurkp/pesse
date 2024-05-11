import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pesse/models/profile_model.dart';

class AuthNotifier with ChangeNotifier {
  final String apiUrl = dotenv.env['API_URL']!;
  final dio = Dio();

  bool _isPending = false;
  String _message = '';
  bool _isSuccess = true;
  bool _isLoggedIn = false;
  Profile userProfile = Profile(id: 0, email: '', name: '');

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

  Future<void> register(
      {required String name,
      required String email,
      required String password}) async {
    _isPending = true;
    try {
      final response = await dio.post(
        '$apiUrl/register',
        data: {
          'name': name,
          'email': email,
          'password': password,
        },
      );
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

  Future<void> logout() async {
    _isPending = true;
    try {
      await dio.get(
        '$apiUrl/logout',
        options: Options(
          headers: {
            'Authorization': 'Bearer ${GetStorage().read('token')}',
          },
        ),
      );
      GetStorage().remove('token');
      GetStorage().remove('user');
      _isLoggedIn = false;
      notifyListeners();
    } on DioException catch (e) {
      print(e);
      _isPending = false;
      notifyListeners();
    }
  }

  Future<void> getProfile() async {
    _isPending = true;
    try {
      final response = await dio.get(
        '$apiUrl/user',
      );

      dynamic user = response.data['data']['user'];

      userProfile = Profile(email: user.email, name: user.name, id: user.id);
      _isPending = false;
      notifyListeners();
    } on DioException catch (e) {
      print(e);
      _isPending = false;
      notifyListeners();
    }
  }
}

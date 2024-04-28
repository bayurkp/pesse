import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_storage/get_storage.dart';
import 'package:logger/logger.dart';
import 'package:pesse/models/user_model.dart';

var logger = Logger();
final String apiUrl = dotenv.env['API_URL']!;

void login(String email, String password) async {
  final dio = Dio();
  try {
    final response = await dio.post('$apiUrl/login', data: {
      'email': email,
      'password': password,
    });

    GetStorage().write('token', response.data['data']['token']);
    GetStorage().write('user', response.data['data']['user']);
  } on DioException catch (e) {
    logger.e(e);
  }
}

void register(String email, String name, String password) async {
  final dio = Dio();
  try {
    final response = await dio.post(
      '$apiUrl/register',
      data: {
        'email': email,
        'name': name,
        'password': password,
      },
    );

    GetStorage().write('token', response.data['data']['token']);
    GetStorage().write('user', response.data['data']['user']);
  } on DioException catch (e) {
    logger.e(e);
  }
}

void logout() async {
  final dio = Dio();
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
  } on DioException catch (e) {
    logger.e(e);
  }
}

Future<User?> getUserProfile() async {
  final dio = Dio();
  try {
    final response = await dio.get(
      '$apiUrl/profile',
      options: Options(
        headers: {
          'Authorization': 'Bearer ${GetStorage().read('token')}',
        },
      ),
    );
    return response.data['data']['user'];
  } on DioException catch (e) {
    logger.e(e);
  }

  return null;
}

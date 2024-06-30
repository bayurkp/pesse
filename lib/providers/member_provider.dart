import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pesse/models/member_model.dart';

final defaultMember = Member(
  id: 0,
  memberNumber: 0,
  name: '',
  address: '',
  birthDate: '1900-01-01',
  phoneNumber: '',
  imageUrl: '',
  isActive: 0,
);

class MemberNotifier extends ChangeNotifier {
  final String _apiUrl = dotenv.env['API_URL']!;
  final _dio = Dio();

  bool _isPending = false;
  String _message = '';
  bool _isSuccess = true;
  List<Member> _members = <Member>[];
  Member _member = defaultMember;

  bool get isPending => _isPending;
  String get message => _message;
  bool get isSuccess => _isSuccess;
  List<Member> get members => _members;
  Member get member => _member;

  Future<void> getMembers() async {
    _isPending = true;
    notifyListeners();

    try {
      final response = await _dio.get(
        '$_apiUrl/anggota',
        options: Options(
          headers: {'Authorization': 'Bearer ${GetStorage().read('token')}'},
        ),
      );

      _members = (response.data['data']['anggotas'] as List)
          .map(
            (e) => Member(
              id: e['id'],
              memberNumber: e['nomor_induk'],
              name: e['nama'],
              address: e['alamat'],
              birthDate: e['tgl_lahir'],
              phoneNumber: e['telepon'],
              imageUrl: e['image_url'],
              isActive: e['status_aktif'],
            ),
          )
          .toList();

      _members.sort((a, b) => a.name.compareTo(b.name));

      _isPending = false;
      _isSuccess = true;
      _message = response.data['message'];
      notifyListeners();
    } on DioException catch (e) {
      print(e.response?.data);
      _isPending = false;
      _isSuccess = false;
      _message = e.response!.data['message'].toString();
      notifyListeners();
    }
  }

  Future<void> getMemberById({required int memberId}) async {
    _isPending = true;
    notifyListeners();

    try {
      final response = await _dio.get(
        '$_apiUrl/anggota/$memberId',
        options: Options(
          headers: {'Authorization': 'Bearer ${GetStorage().read('token')}'},
        ),
      );

      Map<String, dynamic> memberDataFromResponse =
          response.data['data']['anggota'];

      Member member = Member(
        id: memberDataFromResponse['id'],
        memberNumber: memberDataFromResponse['nomor_induk'],
        name: memberDataFromResponse['nama'],
        address: memberDataFromResponse['alamat'],
        birthDate: memberDataFromResponse['tgl_lahir'],
        phoneNumber: memberDataFromResponse['telepon'],
        imageUrl: memberDataFromResponse['image_url'],
        isActive: memberDataFromResponse['status_aktif'],
      );

      _member = member;
      _isPending = false;
      _isSuccess = true;
      _message = response.data['message'];
      notifyListeners();
    } on DioException catch (e) {
      print(e.response?.data);
      _isPending = false;
      _isSuccess = false;
      _message = e.response!.data['message'].toString();
      notifyListeners();
    }
  }

  Future<void> addMember({required Member member}) async {
    _isPending = true;
    notifyListeners();

    Map<String, dynamic> memberJson = member.toJson();
    memberJson.remove('id');

    try {
      final response = await _dio.post(
        '$_apiUrl/anggota',
        data: memberJson,
        options: Options(
          headers: {'Authorization': 'Bearer ${GetStorage().read('token')}'},
        ),
      );

      Map<String, dynamic> memberDataFromResponse =
          response.data['data']['anggota'];

      member = Member(
        id: memberDataFromResponse['id'],
        memberNumber: memberDataFromResponse['nomor_induk'],
        name: memberDataFromResponse['nama'],
        address: memberDataFromResponse['alamat'],
        birthDate: memberDataFromResponse['tgl_lahir'],
        phoneNumber: memberDataFromResponse['telepon'],
        imageUrl: memberDataFromResponse['image_url'],
        isActive: memberDataFromResponse['status_aktif'],
      );

      _members.add(member);
      _isPending = false;
      _isSuccess = true;
      _message = response.data['message'];
      notifyListeners();
    } on DioException catch (e) {
      _isPending = false;
      _isSuccess = false;
      _message = e.response!.data['message'].toString();
      print(e.response?.data);
      notifyListeners();
    }
  }

  Future<void> updateMember({required Member member}) async {
    _isPending = true;
    notifyListeners();

    Map<String, dynamic> memberJson = member.toJson();

    try {
      final response = await _dio.put(
        '$_apiUrl/anggota/${member.id}',
        data: memberJson,
        options: Options(
          headers: {'Authorization': 'Bearer ${GetStorage().read('token')}'},
        ),
      );

      _members[_members.indexWhere((m) => m.id == member.id)] = member;
      _isPending = false;
      _isSuccess = true;
      _message = response.data['message'];
      notifyListeners();
    } on DioException catch (e) {
      _isPending = false;
      _isSuccess = false;
      _message = e.response!.data['message'].toString();
      print(e.response?.data);
      notifyListeners();
    }
  }

  Future<void> removeMember({required int memberId}) async {
    _isPending = true;
    notifyListeners();

    try {
      final response = await _dio.delete(
        '$_apiUrl/anggota/$memberId',
        options: Options(
          headers: {'Authorization': 'Bearer ${GetStorage().read('token')}'},
        ),
      );

      _members.removeWhere((member) => member.id == memberId);
      _isPending = false;
      _isSuccess = true;
      _message = response.data['message'];
      notifyListeners();
    } on DioException catch (e) {
      _isPending = false;
      _isSuccess = false;
      _message = e.response!.data['message'].toString();
      print(e.response?.data);
      notifyListeners();
    }
  }
}

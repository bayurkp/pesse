import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pesse/models/transaction_model.dart';

class TransactionType {
  final int id;
  final String type;
  final int multiply;

  TransactionType({
    required this.id,
    required this.type,
    required this.multiply,
  });
}

class TransactionNotifer extends ChangeNotifier {
  final String _apiUrl = dotenv.env['API_URL']!;
  final _dio = Dio();

  bool _isPending = false;
  String _message = '';
  bool _isSuccess = true;
  List<Transaction> _transactions = <Transaction>[];
  double _balance = 0;
  List<TransactionType> _transactionTypes = <TransactionType>[];

  bool get isPending => _isPending;
  String get message => _message;
  bool get isSuccess => _isSuccess;
  List<Transaction> get transactions => _transactions;
  double get balance => _balance;
  List<TransactionType> get transactionTypes => _transactionTypes;

  Future<void> getMemberTransactionsDetails({required int memberId}) async {
    _isPending = true;
    notifyListeners();

    try {
      final response = await _dio.get(
        '$_apiUrl/tabungan/$memberId',
        options: Options(
          headers: {'Authorization': 'Bearer ${GetStorage().read('token')}'},
        ),
      );

      _transactions = (response.data['data']['tabungan'] as List)
          .map(
            (e) => Transaction(
              id: e['id'],
              date: e['trx_tanggal'],
              transactionType: e['trx_id'],
              amount: e['trx_nominal'],
            ),
          )
          .toList();
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

  Future<void> getMemberBalance({required int memberId}) async {
    _isPending = true;
    notifyListeners();

    try {
      final response = await _dio.get(
        '$_apiUrl/saldo/$memberId',
        options: Options(
          headers: {'Authorization': 'Bearer ${GetStorage().read('token')}'},
        ),
      );

      _balance = response.data['data']['saldo'];
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

  Future<void> addMemberTransaction({
    required int memberId,
    required int transactionTypeId,
    required double transactionAmount,
  }) async {
    _isPending = true;
    notifyListeners();

    try {
      final response = await _dio.post(
        '$_apiUrl/tabungan',
        options: Options(
          headers: {'Authorization': 'Bearer ${GetStorage().read('token')}'},
        ),
        data: {
          'anggota_id': memberId,
          'trx_id': transactionTypeId,
          'trx_nominal': transactionAmount,
        },
      );

      final newTransaction = Transaction(
        id: response.data['data']['id'],
        date: response.data['data']['trx_tanggal'],
        transactionType: response.data['data']['trx_id'],
        amount: response.data['data']['trx_nominal'],
      );
      _transactions.add(newTransaction);

      final multiplier = transactionTypes[transactionTypeId - 1].multiply;
      _balance += transactionAmount * multiplier;
      _balance +=
          transactionAmount * transactionTypes[transactionTypeId - 1].multiply;

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
    } catch (e) {
      print(e);
    }
  }

  Future<void> getTransactionTypes() async {
    _isPending = true;
    notifyListeners();

    try {
      final response = await _dio.get(
        '$_apiUrl/jenistransaksi',
        options: Options(
          headers: {'Authorization': 'Bearer ${GetStorage().read('token')}'},
        ),
      );

      _transactionTypes = (response.data['data']['jenistransaksi'] as List)
          .map(
            (e) => TransactionType(
              id: e['id'],
              type: e['trx_name'],
              multiply: e['trx_multiply'],
            ),
          )
          .toList();
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
}

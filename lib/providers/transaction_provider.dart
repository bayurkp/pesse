import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pesse/models/transaction_model.dart';

class TransactionType {
  final int id;
  final String type;
  final int multiplier;

  TransactionType({
    required this.id,
    required this.type,
    required this.multiplier,
  });
}

class TransactionNotifier extends ChangeNotifier {
  final String _apiUrl = dotenv.env['API_URL']!;
  final _dio = Dio();

  bool _isPending = false;
  String _message = '';
  bool _isSuccess = true;
  List<Transaction> _transactions = <Transaction>[];
  double _balance = 0;
  double _interest = 0;
  List<double> _interestHistory = <double>[];
  List<TransactionType> _transactionTypes = <TransactionType>[];

  bool get isPending => _isPending;
  String get message => _message;
  bool get isSuccess => _isSuccess;
  List<Transaction> get transactions => _transactions;
  double get balance => _balance;
  double get interest => _interest;
  List<double> get interestHistory => _interestHistory;
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
              amount: double.parse(e['trx_nominal'].toString()),
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

      print(response);

      _balance = double.parse(response.data['data']['saldo'].toString());
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

      if (response.data['success'] == false) {
        throw DioException(
            requestOptions: RequestOptions(
              responseType: ResponseType.json,
            ),
            response: Response(
              requestOptions: RequestOptions(
                responseType: ResponseType.json,
              ),
              statusCode: 500,
              data: response.data,
            ));
      }

      print(response);

      final newTransaction = Transaction(
        id: response.data['data']['tabungan']['id'],
        date: response.data['data']['tabungan']['trx_tanggal'],
        transactionType: response.data['data']['tabungan']['trx_id'],
        amount: double.parse(
            response.data['data']['tabungan']['trx_nominal'].toString()),
      );
      _transactions.add(newTransaction);

      final multiplier = transactionTypes[transactionTypeId].multiplier;
      _balance += transactionAmount * multiplier;

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
      print(response);

      _transactionTypes = (response.data['data']['jenistransaksi'] as List)
          .map(
            (e) => TransactionType(
              id: e['id'],
              type: e['trx_name'],
              multiplier: e['trx_multiply'],
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

  Future<void> getInterest() async {
    _isPending = true;
    notifyListeners();

    try {
      final response = await _dio.get(
        '$_apiUrl/settingbunga',
        options: Options(
          headers: {'Authorization': 'Bearer ${GetStorage().read('token')}'},
        ),
      );
      print(response);
      _interest = response.data['data']['activebunga']['persen'];

      var interestHistory = List<Map<String, dynamic>>.from(
          response.data['data']['settingbungas']);
      interestHistory.sort((a, b) => b['id'].compareTo(a['id']));

      _interestHistory =
          interestHistory.map<double>((e) => e['persen'].toDouble()).toList();

      print(_interestHistory);
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

  Future<void> updateInterest({required double newInterest}) async {
    _isPending = true;
    notifyListeners();

    try {
      final response = await _dio.post(
        '$_apiUrl/addsettingbunga',
        options: Options(
          headers: {'Authorization': 'Bearer ${GetStorage().read('token')}'},
        ),
        data: {
          'persen': newInterest,
          'isaktif': 1,
        },
      );

      _interest = response.data['data']['settingbungas']['persen'];
      _isPending = false;
      _isSuccess = true;
      _message = response.data['message'];
      notifyListeners();
    } on DioException catch (e) {
      _isPending = false;
      _isSuccess = false;
      _message = e.response!.data['message'].toString();
      notifyListeners();
    }
  }
}

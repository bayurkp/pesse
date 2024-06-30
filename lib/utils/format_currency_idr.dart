import 'package:intl/intl.dart';

String formatCurrencyIdr({required String amount, int decimalDigit = 0}) {
  NumberFormat currencyFormatter = NumberFormat.currency(
    locale: 'id',
    symbol: '',
    decimalDigits: decimalDigit,
  );

  double numericAmount = double.parse(amount);
  return currencyFormatter.format(numericAmount);
}

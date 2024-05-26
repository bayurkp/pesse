class Transaction {
  final int id;
  final int transactionType;
  final double amount;
  final String date;

  Transaction({
    required this.id,
    required this.date,
    required this.transactionType,
    required this.amount,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      date: json['trx_tanggal'],
      transactionType: json['trx_id'],
      amount: json['trx_nominal'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'trx_tanggal': date,
      'trx_id': transactionType,
      'trx_nominal': amount
    };
  }
}

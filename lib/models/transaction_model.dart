class Transaction {
  final int id;
  final int transactionTypeId;
  final double amount;
  final String date;

  Transaction({
    required this.id,
    required this.date,
    required this.transactionTypeId,
    required this.amount,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      date: json['trx_tanggal'],
      transactionTypeId: json['trx_id'],
      amount: json['trx_nominal'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'trx_tanggal': date,
      'trx_id': transactionTypeId,
      'trx_nominal': amount
    };
  }
}

class TransactionType {
  final int id;
  final String type;
  final int multiplier;

  TransactionType({
    required this.id,
    required this.type,
    required this.multiplier,
  });

  factory TransactionType.fromJson(Map<String, dynamic> json) {
    return TransactionType(
      id: json['id'],
      type: json['trx_name'],
      multiplier: json['trx_multiply'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'trx_name': type,
      'trx_multiply': multiplier,
    };
  }
}

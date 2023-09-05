class PaymentFields {
  static const String expense = 'despesa';
  static const String amount = 'valor';
  static const String paymentDate = 'data';
  static const String description = 'descricao';

  List<String> getFields() => [expense, amount, paymentDate, description];
}

class Payment {
  final String expense;
  final double amount;
  final String paymentDate;
  final String description;

  Payment({required this.expense, required this.amount, required this.paymentDate, required this.description});

  Map<String, dynamic> toJson() => {
    PaymentFields.expense: expense,
    PaymentFields.amount: amount,
    PaymentFields.paymentDate: paymentDate,
    PaymentFields.description: description
  };
}
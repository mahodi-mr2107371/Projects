
import 'package:yala_pay/models/payment.dart';

class Invoice {
  String invoiceNumber;
  String customerId;
  final double amount;
  final DateTime invoiceDate;
  final DateTime dueDate;
  double balance;

  Invoice({
    required this.invoiceNumber,
    required this.customerId,
    required this.amount,
    required this.invoiceDate,
    required this.dueDate,
    required this.balance,
  });

  factory Invoice.fromJson(Map<String, dynamic> json) {
    return Invoice(
      invoiceNumber: json['id'],
      customerId: json['customerId'],
      amount: json['amount'],
      invoiceDate: DateTime.parse(json['invoiceDate']),
      dueDate: DateTime.parse(json['dueDate']),
      balance: json['amount'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': invoiceNumber.toString(),
      'customerId': customerId.toString(),
      'amount': amount,
      'invoiceDate': invoiceDate.toIso8601String(),
      'dueDate': dueDate.toIso8601String(),
      'balance': balance,
    };
  }

  // Methods to update balance
  void updateBalance(double paymentAmount) {
    balance -= paymentAmount;
  }

  // Method to calculate balance excluding returned cheques
  void calculateBalance(List<Payment> payments) {
    balance = amount;
    for (var payment in payments) {
      if (payment.invoiceNo == invoiceNumber) {
        balance -= payment.amount;
      }
    }
  }
}

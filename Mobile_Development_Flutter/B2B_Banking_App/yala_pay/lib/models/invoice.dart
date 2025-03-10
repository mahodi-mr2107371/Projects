import 'package:yala_pay/models/payment.dart';

class Invoice {
  final int _invoiceNumber;
  final int _customerId;
  final double _amount;
  final DateTime _invoiceDate;
  final DateTime _dueDate;
  double _balance;

  Invoice({
    required int invoiceNumber,
    required int customerId,
    required double amount,
    required DateTime invoiceDate,
    required DateTime dueDate,
    required double balance,
  })  : _invoiceNumber = invoiceNumber,
        _customerId = customerId,
        _amount = amount,
        _invoiceDate = invoiceDate,
        _dueDate = dueDate,
        _balance = balance;

  factory Invoice.fromJson(Map<String, dynamic> json) {
    return Invoice(
      invoiceNumber: int.parse(json['id']),
      customerId: int.parse(json['customerId']),
      amount: json['amount'],
      invoiceDate: DateTime.parse(json['invoiceDate']),
      dueDate: DateTime.parse(json['dueDate']),
      balance: json['amount'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': _invoiceNumber.toString(),
      'customerId': _customerId.toString(),
      'amount': _amount,
      'invoiceDate': _invoiceDate.toIso8601String(),
      'dueDate': _dueDate.toIso8601String(),
      'balance': _balance,
    };
  }

  // Getters
  int get invoiceNumber => _invoiceNumber;
  int get customerId => _customerId;
  double get amount => _amount;
  DateTime get invoiceDate => _invoiceDate;
  DateTime get dueDate => _dueDate;
  double get balance => _balance;

  // Methods to update balance
  void updateBalance(double paymentAmount) {
    _balance -= paymentAmount;
  }

  // Method to calculate balance excluding returned cheques
  void calculateBalance(List<Payment> payments) {
    _balance = _amount;
    for (var payment in payments) {
      if (payment.invoiceNo == _invoiceNumber) {
        _balance -= payment.amount;
      }
    }
  }
}


class Payment {
  String id;
  String invoiceNo;
  final double amount;
  final DateTime paymentDate;
  final String modeOfPayment;
  String? chequeNo;

  Payment({
    required this.id,
    required this.invoiceNo,
    required this.amount,
    required this.paymentDate,
    required this.modeOfPayment,
    this.chequeNo,
  });

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      id: json['id'],
      invoiceNo: json['invoiceNo'],
      amount: json['amount'],
      paymentDate: DateTime.parse(json['paymentDate']),
      modeOfPayment: json['paymentMode'],
      chequeNo: json['chequeNo'].toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id.toString(),
      'invoiceNo': invoiceNo.toString(),
      'amount': amount,
      'paymentDate': paymentDate.toIso8601String(),
      'paymentMode': modeOfPayment,
      'chequeNo': chequeNo,
    };
  }
}

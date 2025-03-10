class Payment {
  final int _id;
  final int _invoiceNo;
  final double _amount;
  final DateTime _paymentDate;
  final String _modeOfPayment;
  final int? _chequeNo;

  Payment({
    required int id,
    required int invoiceNo,
    required double amount,
    required DateTime paymentDate,
    required String modeOfPayment,
    int? chequeNo,
  })  : _id = id,
        _invoiceNo = invoiceNo,
        _amount = amount,
        _paymentDate = paymentDate,
        _modeOfPayment = modeOfPayment,
        _chequeNo = chequeNo;

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      id: int.parse(json['id']),
      invoiceNo: int.parse(json['invoiceNo']),
      amount: json['amount'],
      paymentDate: DateTime.parse(json['paymentDate']),
      modeOfPayment: json['paymentMode'],
      chequeNo: json['chequeNo'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': _id.toString(),
      'invoiceNo': _invoiceNo.toString(),
      'amount': _amount,
      'paymentDate': _paymentDate.toIso8601String(),
      'paymentMode': _modeOfPayment,
      'chequeNo': _chequeNo,
    };
  }

  // Getters
  int get id => _id;
  int get invoiceNo => _invoiceNo;
  double get amount => _amount;
  DateTime get paymentDate => _paymentDate;
  String get modeOfPayment => _modeOfPayment;
  int? get chequeNo => _chequeNo;
}

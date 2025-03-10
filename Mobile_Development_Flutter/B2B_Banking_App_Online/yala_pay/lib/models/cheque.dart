class Cheque {
  String chequeNumber;
  final double amount;
  final String drawer;
  final String drawerBank;
  String status;
  DateTime receivedDate;
  DateTime dueDate;
  String chequeImage;
  DateTime? depositDate;
  DateTime? cashedDate;
  DateTime? returnDate;
  String? returnReason;

  Cheque({
    required this.chequeNumber,
    required this.amount,
    required this.drawer,
    required this.drawerBank,
    required this.status,
    required this.receivedDate,
    required this.dueDate,
    required this.chequeImage,
    this.depositDate,
    this.cashedDate,
    this.returnDate,
    this.returnReason,
  });

  factory Cheque.fromJson(Map<String, dynamic> json) {
    return Cheque(
      chequeNumber: json['chequeNo'].toString(),
      amount: json['amount'],
      drawer: json['drawer'],
      drawerBank: json['bankName'],
      status: json['status'],
      receivedDate: DateTime.parse(json['receivedDate']),
      dueDate: DateTime.parse(json['dueDate']),
      chequeImage: json['chequeImageUri'],
      depositDate: json['depositDate'] != null
          ? DateTime.parse(json['depositDate'])
          : null,
      cashedDate: json['cashedDate'] != null
          ? DateTime.parse(json['cashedDate'])
          : null,
      returnDate: json['returnDate'] != null
          ? DateTime.parse(json['returnDate'])
          : null,
      returnReason: json['returnReason'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'chequeNo': chequeNumber,
      'amount': amount,
      'drawer': drawer,
      'bankName': drawerBank,
      'status': status,
      'receivedDate': receivedDate.toIso8601String(),
      'dueDate': dueDate.toIso8601String(),
      'chequeImageUri': chequeImage,
      'depositDate': depositDate?.toIso8601String(),
      'cashedDate': cashedDate?.toIso8601String(),
      'returnDate': returnDate?.toIso8601String(),
      'returnReason': returnReason,
    };
  }

  // Methods to update status and dates
  void depositCheque() {
    status = 'Deposited';
    depositDate = DateTime.now();
  }

  void cashCheque(DateTime date) {
    status = 'Cashed';
    cashedDate = date;
  }

  void returnCheque(DateTime date, String? reason) {
    status = 'Returned';
    returnDate = date;
    returnReason = reason ?? '';
  }
}

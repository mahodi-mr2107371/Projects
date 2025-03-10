class Cheque {
  final int _chequeNumber;
  final double _amount;
  final String _drawer;
  final String _drawerBank;
  String status;
  DateTime _receivedDate;
  DateTime _dueDate;
  String _chequeImage;
  DateTime? _depositDate;
  DateTime? _cashedDate;
  DateTime? _returnDate;
  String? _returnReason;

  Cheque({
    required int chequeNumber,
    required double amount,
    required String drawer,
    required String drawerBank,
    required this.status,
    required DateTime receivedDate,
    required DateTime dueDate,
    required String chequeImage,
    DateTime? depositDate,
    DateTime? cashedDate,
    DateTime? returnDate,
    String? returnReason,
  })  : _chequeNumber = chequeNumber,
        _amount = amount,
        _drawer = drawer,
        _drawerBank = drawerBank,
        _receivedDate = receivedDate,
        _dueDate = dueDate,
        _chequeImage = chequeImage,
        _depositDate = depositDate,
        _cashedDate = cashedDate,
        _returnDate = returnDate,
        _returnReason = returnReason;

  factory Cheque.fromJson(Map<String, dynamic> json) {
    return Cheque(
      chequeNumber: json['chequeNo'],
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
      'chequeNo': _chequeNumber,
      'amount': _amount,
      'drawer': _drawer,
      'bankName': _drawerBank,
      'status': status,
      'receivedDate': _receivedDate.toIso8601String(),
      'dueDate': _dueDate.toIso8601String(),
      'chequeImageUri': _chequeImage,
      'depositDate': _depositDate?.toIso8601String(),
      'cashedDate': _cashedDate?.toIso8601String(),
      'returnDate': _returnDate?.toIso8601String(),
      'returnReason': _returnReason,
    };
  }

  // Getters
  int get chequeNumber => _chequeNumber;
  double get amount => _amount;
  String get drawer => _drawer;
  String get drawerBank => _drawerBank;
  DateTime get receivedDate => _receivedDate;
  DateTime get dueDate => _dueDate;
  String get chequeImage => _chequeImage;
  DateTime? get depositDate => _depositDate;
  DateTime? get cashedDate => _cashedDate;
  DateTime? get returnDate => _returnDate;
  String? get returnReason => _returnReason;

  // Methods to update status and dates
  void depositCheque() {
    status = 'Deposited';
    _depositDate = DateTime.now();
  }

  void cashCheque(DateTime date) {
    status = 'Cashed';
    _cashedDate = date;
  }

  void returnCheque(DateTime date, String? reason) {
    status = 'Returned';
    _returnDate = date;
    _returnReason = reason ?? '';
  }
}

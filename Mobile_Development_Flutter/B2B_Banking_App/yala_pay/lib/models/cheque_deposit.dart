class ChequeDeposit {
  final int _id;
  final List<int> _cheques;
  final DateTime _depositDate;
  final String _bankAccountId;
  String _status;
  ChequeDeposit({
    required int id,
    required List<int> cheques,
    required DateTime depositDate,
    required String bankAccountId,
    required String status,
  })  : _id = id,
        _cheques = cheques,
        _depositDate = depositDate,
        _bankAccountId = bankAccountId,
        _status = status;

  factory ChequeDeposit.fromJson(Map<String, dynamic> json) {
    return ChequeDeposit(
      id: int.parse(json['id']),
      cheques: List<int>.from(json['chequeNos']),
      depositDate: DateTime.parse(json['depositDate']),
      bankAccountId: json['bankAccountNo'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': _id,
      'cheques': _cheques.toList(),
      'depositDate': _depositDate.toIso8601String(),
      'bankAccountNo': _bankAccountId,
      'status': _status,
    };
  }

  // Getters
  int get id => _id;
  List<int> get cheques => _cheques;
  DateTime get depositDate => _depositDate;
  String get bankAccountId => _bankAccountId;
  // ignore: unnecessary_getters_setters
  String get status => _status;
  set status(String stat) => _status=stat;


  // Methods to update status and deposit date
  void updateStatus(String newStatus) {
    _status = newStatus;
  }
}

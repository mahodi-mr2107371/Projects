// import 'package:floor/floor.dart';

// @Entity(tableName: 'chequeDeposits')
class ChequeDeposit {
  // @PrimaryKey(autoGenerate: false)
  String id;
  final List<String> cheques;
  final DateTime depositDate;
  final String bankAccountId;
  String status;
  ChequeDeposit({
    required this.id,
    required this.cheques,
    required this.depositDate,
    required this.bankAccountId,
    required this.status,
  });

  factory ChequeDeposit.fromJson(Map<String, dynamic> json) {
    return ChequeDeposit(
      id: json['id'],
      cheques: List<String>.from(json['chequeNos']),
      depositDate: DateTime.parse(json['depositDate']),
      bankAccountId: json['bankAccountNo'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'cheques': cheques.toList(),
      'depositDate': depositDate.toIso8601String(),
      'bankAccountNo': bankAccountId,
      'status': status,
    };
  }

  // Methods to update status and deposit date
  void updateStatus(String newStatus) {
    status = newStatus;
  }
}

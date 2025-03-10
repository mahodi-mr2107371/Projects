class BankAccount {
  final String _accountName;
  final String _accountNumber;

  BankAccount({
    required String accountName,
    required String accountNumber,
  })  : _accountName = accountName,
        _accountNumber = accountNumber;

  factory BankAccount.fromJson(Map<String, dynamic> json) {
    return BankAccount(
      accountName: json['bank'],
      accountNumber: json['accountNo'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bank': _accountName,
      'accountNo': _accountNumber,
    };
  }

  String get accountNumber => _accountNumber;
  String get accountName => _accountName;
}

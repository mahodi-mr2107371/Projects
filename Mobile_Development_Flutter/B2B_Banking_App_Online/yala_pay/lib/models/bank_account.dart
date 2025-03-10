import 'package:floor/floor.dart';

@Entity(tableName: 'bankAccounts')
class BankAccount {
  final String accountName;

  @PrimaryKey(autoGenerate: false)
  final String accountNumber;

  BankAccount({
    required this.accountName,
    required this.accountNumber,
  });

  factory BankAccount.fromJson(Map<String, dynamic> json) {
    return BankAccount(
      accountName: json['bank'],
      accountNumber: json['accountNo'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bank': accountName,
      'accountNo': accountNumber,
    };
  }
}

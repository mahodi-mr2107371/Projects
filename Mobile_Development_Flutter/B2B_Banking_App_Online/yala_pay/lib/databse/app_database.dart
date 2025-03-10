import 'dart:async';

import 'package:floor/floor.dart';

import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:yala_pay/databse/bank_account_dao.dart';
// import 'package:yala_pay/databse/cheque_deposit_dao.dart';
// import 'package:yala_pay/databse/cheque_dao.dart';
// import 'package:yala_pay/databse/customer_dao.dart';
// import 'package:yala_pay/databse/invoice_dao.dart';
// import 'package:yala_pay/databse/payment_dao.dart';
import 'package:yala_pay/databse/return_reasons_dao.dart';
// import 'package:yala_pay/databse/user_dao.dart';
import 'package:yala_pay/models/bank_account.dart';
// import 'package:yala_pay/models/cheque.dart';
// import 'package:yala_pay/models/cheque_deposit.dart';
// import 'package:yala_pay/models/customer.dart';
// import 'package:yala_pay/models/invoice.dart';
// import 'package:yala_pay/models/payment.dart';
import 'package:yala_pay/models/return_reason.dart';
// import 'package:yala_pay/models/user.dart';

part 'app_database.g.dart';

//comditional datetime converter for db
class DateTimeConverterConditional extends TypeConverter<DateTime?, int> {
  @override
  DateTime decode(int databaseValue) {
    return DateTime.fromMillisecondsSinceEpoch(databaseValue);
  }

  @override
  int encode(DateTime? value) {
    return value!.millisecondsSinceEpoch;
  }
}

//datetime converter for db
class DateTimeConverter extends TypeConverter<DateTime, int> {
  @override
  DateTime decode(int databaseValue) {
    return DateTime.fromMillisecondsSinceEpoch(databaseValue);
  }

  @override
  int encode(DateTime value) {
    return value.millisecondsSinceEpoch;
  }
}

//List<int> converter
class IntListConverter extends TypeConverter<List<int>, String> {
  @override
  List<int> decode(String databaseValue) {
    return databaseValue.split(',').map(int.parse).toList();
  }

  @override
  String encode(List<int> value) {
    return value.join(',');
  }
}

@TypeConverters(
    [DateTimeConverter, DateTimeConverterConditional, IntListConverter])
@Database(
  version: 1,
  entities: [
    BankAccount,
    // ChequeDeposit,
    // Cheque,
    // Customer,
    // Invoice,
    // Payment,
    ReturnReason,
    // User,
  ],
)
abstract class AppDatabase extends FloorDatabase {
  BankAccountDao get bankAccountDao;
  // ChequeDepositDao get chequeDepositDao;
  // ChequeDao get chequeDao;
  // CustomerDao get customerDao;
  // InvoiceDao get invoiceDao;
  // PaymentDao get paymentDao;
  ReturnReasonsDao get returnReasonsDao;
  // UserDao get userDao;
}

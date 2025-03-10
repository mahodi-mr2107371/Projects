import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yala_pay/databse/app_database.dart';
import 'package:yala_pay/repo/yalapay_repo.dart';

final yalaPayRepoProvider = FutureProvider<YalapayRepo>((ref) async {
  final db = FirebaseFirestore.instance;
  final chequesRef = db.collection('cheques');
  final chequeDepositsRef = db.collection('cheque-deposits');
  final invoicesRef = db.collection('invoices');
  final customersRef = db.collection('customers');
  final paymentsRef = db.collection('payments');
  final database =
      await $FloorAppDatabase.databaseBuilder('app_database.db').build();

  return YalapayRepo(
    bankAccountDao: database.bankAccountDao,
    returnReasonsDao: database.returnReasonsDao,
    chequesRef: chequesRef,
    chequeDepositsRef: chequeDepositsRef,
    invoicesRef: invoicesRef,
    customersRef: customersRef,
    paymentsRef: paymentsRef,
  );
});
final selectedProjectIdProvider = StateProvider<int?>((ref) => null);

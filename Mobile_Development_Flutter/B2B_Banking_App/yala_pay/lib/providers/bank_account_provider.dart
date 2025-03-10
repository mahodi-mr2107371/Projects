import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yala_pay/models/bank_account.dart';

class BankAccountProvider extends Notifier<List<BankAccount>> {
  @override
  List<BankAccount> build() {
    _initializeState();
    return []; // Initialize with an empty list or load from your data source
  }

  void _initializeState() async {
    List<BankAccount> temp = [];
    var data =
        await rootBundle.loadString('assets/YalaPay-data/bank-accounts.json');
    var bankAccountsMap = jsonDecode(data);
    for (var bankAccount in bankAccountsMap) {
      temp.add(BankAccount.fromJson(bankAccount));
    }
    state = temp;
  }

  void addBankAccount(BankAccount account) {
    state = [...state, account];
  }

  // void updateBankAccount(BankAccount updatedAccount) {
  //   state = [
  //     for (final account in state)
  //       if (account.accountNumber == updatedAccount.accountNumber)
  //         updatedAccount
  //       else
  //         account
  //   ];
  // }

  void deleteBankAccount(String accountNo) {
    state =
        state.where((account) => account.accountNumber != accountNo).toList();
  }
}

final bankAccountProvider =
    NotifierProvider<BankAccountProvider, List<BankAccount>>(
        () => BankAccountProvider());

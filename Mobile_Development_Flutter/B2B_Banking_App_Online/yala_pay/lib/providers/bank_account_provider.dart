import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yala_pay/models/bank_account.dart';
import 'package:yala_pay/providers/repo_provider.dart';
import 'package:yala_pay/repo/yalapay_repo.dart';

class BankAccountProvider extends AsyncNotifier<List<BankAccount>> {
  late final YalapayRepo _yalapayRepo;

  @override
  Future<List<BankAccount>> build() async {
    // Load the YalaPayRepo instance from the provider
    _yalapayRepo = await ref.watch(yalaPayRepoProvider.future);

    // Listen to changes in the bank accounts stream and update the state
    _yalapayRepo.observeBankAccounts().listen((accounts) {
      state = AsyncData(accounts); // Update the state with new data
    });
    if (state.value == null || state.value!.isEmpty) {
      initializeData();
      print(state.value);
    }
    // Return the initial state (empty list or fetched data)
    return state.value ?? [];
  }

  void initializeData() async {
    var data =
        await rootBundle.loadString('assets/YalaPay-data/bank-accounts.json');
    var bankAccountsMap = jsonDecode(data);
    for (var bankAccount in bankAccountsMap) {
      addBankAccount(BankAccount.fromJson(bankAccount));
    }
  }

  void addBankAccount(BankAccount account) async {
    await _yalapayRepo.insertBankAccount(account);
  }

  void deleteBankAccount(BankAccount account) async {
    await _yalapayRepo.deleteBankAccount(account);
  }

  void updateBankAccount(BankAccount account) async {
    await _yalapayRepo.updateBankAccount(account);
  }

  void findBankAccountById(String id) async {
    await _yalapayRepo.findBankAccountById(id);
  }
}

final bankAccountProvider =
    AsyncNotifierProvider<BankAccountProvider, List<BankAccount>>(
        () => BankAccountProvider());

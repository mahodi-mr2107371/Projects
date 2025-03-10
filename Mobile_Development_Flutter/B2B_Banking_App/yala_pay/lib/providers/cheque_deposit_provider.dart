import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yala_pay/models/cheque_deposit.dart';
import 'package:yala_pay/models/cheque.dart';
import 'package:yala_pay/providers/cheques_provider.dart';

class ChequeDepositProvider extends Notifier<List<ChequeDeposit>> {
  List<Cheque> cheques = [];
  @override
  List<ChequeDeposit> build() {
    cheques = ref.read(chequesProvider);
    initializeState();
    return [];
  }

  void initializeState() async {
    List<ChequeDeposit> temp = [];
    var data =
        await rootBundle.loadString('assets/YalaPay-data/cheque-deposits.json');
    var chequesMap = jsonDecode(data);
    for (var cheque in chequesMap) {
      temp.add(ChequeDeposit.fromJson(cheque));
    }
    // print('Temp$temp');
    state = temp;
  }

  void addChequeDeposit(ChequeDeposit deposit) {
    state = [...state, deposit];
  }


  void deleteChequeDeposit(int depositId) {
    state = state.map((deposit) {
      if (deposit.id == depositId) {
        deposit.cheques.map((e) {
          Cheque temp = ref.read(chequesProvider.notifier).getChequeById(e);
          temp.status = 'Awaiting';
          return temp;
        }).toList();
      }

      return deposit;
    }).toList();
    state = state.where((deposit) => deposit.id != depositId).toList();
  }

  int _generateDepositId() {
    if (state.isEmpty) {
      return 1;
    } else {
      return state
              .map((deposit) => deposit.id)
              .reduce((a, b) => a > b ? a : b) +
          1;
    }
  }

  void createChequeDeposit(
      List<Cheque> selectedCheques, String? bankAccountId) {
    final depositDate = DateTime.now();
    final newDeposit = ChequeDeposit(
      id: _generateDepositId(),
      cheques: selectedCheques.map((e) => e.chequeNumber).toList(),
      depositDate: depositDate,
      bankAccountId: bankAccountId ?? '',
      status: 'Deposited',
    );

    // Update the status and deposit date of the selected cheques
    for (var cheque in selectedCheques) {
      cheque.depositCheque();
    }

    addChequeDeposit(newDeposit);
  }

  void updateChequeDepositStatus(int depositId, String status,
      {DateTime? cashedDate, DateTime? returnDate, String? returnReason}) {
    final deposit = state.firstWhere((d) => d.id == depositId);
    deposit.cheques.map((cheque) {
      if (status.toLowerCase() == 'Cashed'.toLowerCase()) {
        deposit.status = 'Cashed';
        ref.read(chequesProvider)
            .firstWhere((e) => e.chequeNumber == cheque)
            .cashCheque(cashedDate ?? DateTime.now());
      } else if (status.toLowerCase() == 'Returned'.toLowerCase()) {
        deposit.status = 'Returned';
        ref.read(chequesProvider)
            .firstWhere((e) => e.chequeNumber == cheque)
            .returnCheque(returnDate ?? DateTime.now(), returnReason ?? '');
      }
      return cheque;
    }).toList();
    state = state.where((deposite) => deposite.id != depositId).toList();
    
  }
}

final chequeDepositProvider =
    NotifierProvider<ChequeDepositProvider, List<ChequeDeposit>>(
        () => ChequeDepositProvider());

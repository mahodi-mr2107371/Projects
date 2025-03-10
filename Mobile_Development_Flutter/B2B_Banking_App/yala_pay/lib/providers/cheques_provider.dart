import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yala_pay/models/cheque.dart';

class ChequesProvider extends Notifier<List<Cheque>> {
  @override
  List<Cheque> build() {
    initializeState();
    return [];
  }

  void initializeState() async {
    List<Cheque> temp = [];
    var data = await rootBundle.loadString('assets/YalaPay-data/cheques.json');
    var chequesMap = jsonDecode(data);
    for (var cheque in chequesMap) {
      temp.add(Cheque.fromJson(cheque));
    }
    state = temp;
  }

  void addCheque(Cheque newCheque) {
    state = [...state, newCheque];
  }

  void removeCheque(Cheque cheque) {
    state = state.where((e) => e.chequeNumber != cheque.chequeNumber).toList();
  }

  List<Cheque> getAwaitingCheques() {
    return state.where((cheque) => cheque.status == 'Awaiting').toList();
  }

  List<Cheque> getChequesByDateAndStatus(
      DateTime fromDate, DateTime toDate, String status) {
    return state.where((cheque) {
      final chequeDate = cheque.receivedDate;

      // Check if the cheque date is within the specified range
      final isWithinDateRange =
          chequeDate.isAfter(fromDate) && chequeDate.isBefore(toDate) ||
              chequeDate.isAtSameMomentAs(fromDate) ||
              chequeDate.isAtSameMomentAs(toDate);

      // Check if the cheque status matches the specified status
      final isStatusMatch = (status == 'All' || cheque.status == status);

      return isWithinDateRange && isStatusMatch;
    }).toList();
  }

  void updateCheque(Cheque updatedCheque) {
    state = state.map((c){
      if(c.chequeNumber==updatedCheque.chequeNumber){return updatedCheque;}
      return c;
    }).toList();
  }

  Cheque getChequeById(int id) {
    return state.firstWhere((cheque) => cheque.chequeNumber == id);
  }
}

final chequesProvider =
    NotifierProvider<ChequesProvider, List<Cheque>>(() => ChequesProvider());

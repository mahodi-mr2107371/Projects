import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yala_pay/models/cheque_deposit.dart';
import 'package:yala_pay/models/cheque.dart';
import 'package:yala_pay/providers/repo_provider.dart';
import 'package:yala_pay/repo/yalapay_repo.dart';

class ChequeDepositProvider extends AsyncNotifier<List<ChequeDeposit>> {
  late final YalapayRepo _repo;

  @override
  Future<List<ChequeDeposit>> build() async {
    _repo = await ref.watch(yalaPayRepoProvider.future);

    // Observe cheque deposits in real time
    _repo.observeChequeDeposits().listen((deposits) {
      state = AsyncValue.data(deposits);
    }).onError((error) {
      print(error);
    });

    return [];
  }

  // void initializeState() async {
  //   List<ChequeDeposit> temp = [];
  //   var data =
  //       await rootBundle.loadString('assets/YalaPay-data/cheque-deposits.json');
  //   var chequesMap = jsonDecode(data);
  //   for (var cheque in chequesMap) {
  //     temp.add(ChequeDeposit.fromJson(cheque));
  //   }
  //   // print('Temp$temp');
  // }

  Future<void> addChequeDeposit(ChequeDeposit deposit) async {
    await _repo.addChequeDeposit(deposit);
  }

  Future<void> deleteChequeDeposit(int depositId) async {
    await _repo.deleteChequeDeposit(depositId);
  }

  Future<void> createChequeDeposit(
      List<Cheque> selectedCheques, String? bankAccountId) async {
    await _repo.createChequeDeposit(selectedCheques, bankAccountId);
  }

  Future<void> updateChequeDepositStatus(
    String depositId,
    String status, {
    DateTime? cashedDate,
    DateTime? returnDate,
    String? returnReason,
  }) async {
    await _repo.updateChequeDepositStatus(
      depositId,
      status,
      cashedDate: cashedDate,
      returnDate: returnDate,
      returnReason: returnReason,
    );
  }
}

final chequeDepositProvider =
    AsyncNotifierProvider<ChequeDepositProvider, List<ChequeDeposit>>(
  () => ChequeDepositProvider(),
);

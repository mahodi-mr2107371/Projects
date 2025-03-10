import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yala_pay/models/cheque.dart';
import 'package:yala_pay/providers/repo_provider.dart';
import 'package:yala_pay/repo/yalapay_repo.dart';

class ChequesProvider extends AsyncNotifier<List<Cheque>> {
  late final YalapayRepo _repo;

  @override
  Future<List<Cheque>> build() async {
    _repo = await ref.watch(yalaPayRepoProvider.future);

    _repo.observeCheques().listen((cheques) {
      state = AsyncValue.data(cheques);
    }).onError((error) {
      print(error);
    });

    return [];
  }

  Future<void> addCheque(Cheque newCheque) async {
    await _repo.addCheque(newCheque);
  }

  Future<void> removeCheque(Cheque cheque) async {
    await _repo.deleteCheque(cheque);
  }

  Future<List<Cheque>> getAwaitingCheques() async {
    return await _repo.getAwaitingCheques();
  }

  Future<List<Cheque>> getChequesByDateAndStatusFirestore(
      DateTime fromDate, DateTime toDate, String status) async {
    return await _repo.getChequesByDateAndStatus(fromDate, toDate, status);
  }

  // Future<List<Cheque>> getChequesByDateAndStatusFirestore(
  //     DateTime fromDate, DateTime toDate, String status) async {
  //   return await _repo.getChequesByDateAndStatus(
  //       fromDate, toDate, status);
  // }

  Future<void> updateCheque(Cheque updatedCheque) async {
    await _repo.updateCheque(updatedCheque);
  }

  Future<Cheque?> getChequeById(String id) async {
    return await _repo.getChequeById(id);
  }
}

final chequesProvider = AsyncNotifierProvider<ChequesProvider, List<Cheque>>(
    () => ChequesProvider());

import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yala_pay/models/return_reason.dart';
import 'package:yala_pay/providers/repo_provider.dart';
import 'package:yala_pay/repo/yalapay_repo.dart';

class ReturnReasonProvider extends AsyncNotifier<List<ReturnReason>> {
  late final YalapayRepo _yalapayRepo;

  @override
  Future<List<ReturnReason>> build() async {
    _yalapayRepo = await ref.watch(yalaPayRepoProvider.future);

    _yalapayRepo.observeReturnReasons().listen((returnReasons) {
      state = AsyncData(returnReasons);
    });
    if (state.value == null || state.value!.isEmpty) {
      initializeData();
      print(state.value);
    }

    return state.value ?? [];
  }

  void initializeData() async {
    List<String> temp = [];
    var data =
        await rootBundle.loadString('assets/YalaPay-data/return-reasons.json');
    List<dynamic> reasonsMap = jsonDecode(data);
    temp = reasonsMap.cast<String>();
    for (int i = 0; i < temp.length; i++) {
      addReturnReason(ReturnReason(description: temp[i]));
    }
  }

  Future<ReturnReason?> findReturnReason(int id) async {
    return await _yalapayRepo.findReturnReason(id);
  }

  Future<void> addReturnReason(ReturnReason r) async {
    await _yalapayRepo.addReturnReason(r);
  }
}

final returnReasonProvider =
    AsyncNotifierProvider<ReturnReasonProvider, List<ReturnReason>>(
  () => ReturnReasonProvider(),
);

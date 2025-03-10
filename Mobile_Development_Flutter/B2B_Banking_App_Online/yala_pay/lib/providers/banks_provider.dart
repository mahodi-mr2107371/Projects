import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BanksProvider extends Notifier<List<String>> {
  @override
  List<String> build() {
    initializeState(); // This will be async
    return []; // Return an empty initial state
  }

  Future<void> initializeState() async {
    List<String> temp = [];
    var data = await rootBundle.loadString('assets/YalaPay-data/banks.json');
    List<dynamic> statusesMap = jsonDecode(data); // Decode as List<dynamic>
    temp = statusesMap.cast<String>(); // Cast to List<String>
    // print('Loaded statuses: $temp');

    // Update the provider's state with the loaded data
    state = temp;
  }

  // Add, update methods can be added if necessary...
}

final banksProviderNotifier = NotifierProvider<BanksProvider, List<String>>(
  () => BanksProvider(),
);

import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReturnReasonProvider extends Notifier<List<String>> {
  @override
  List<String> build() {
    _initializeState(); // This will be async
    return []; // Return an empty initial state
  }

  Future<void> _initializeState() async {
    List<String> temp = [];
    var data =
        await rootBundle.loadString('assets/YalaPay-data/return-reasons.json');
    List<dynamic> reasonsMap = jsonDecode(data); // Decode as List<dynamic>
    temp = reasonsMap.cast<String>(); // Cast to List<String>
    // print('Loaded return reasons: $temp');

    // Update the provider's state with the loaded data
    state = temp;
  }

  // Add, update, delete methods remain unchanged...
}

final returnReasonProvider =
    NotifierProvider<ReturnReasonProvider, List<String>>(
  () => ReturnReasonProvider(),
);

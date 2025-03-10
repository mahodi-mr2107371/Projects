import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class InvoiceStatusProvider extends Notifier<List<String>> {
  @override
  List<String> build() {
    initializeState(); // This will be async
    return []; // Return an empty initial state
  }

  Future<void> initializeState() async {
    List<String> temp = [];
    var data =
        await rootBundle.loadString('assets/YalaPay-data/invoice-status.json');
    List<dynamic> statusesMap = jsonDecode(data);
    temp = statusesMap.cast<String>();

    state = temp;
  }
}

final invoiceStatusProviderNotifier =
    NotifierProvider<InvoiceStatusProvider, List<String>>(
  () => InvoiceStatusProvider(),
);

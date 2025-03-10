import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yala_pay/models/invoice.dart';
import 'package:yala_pay/models/payment.dart';
import 'package:yala_pay/providers/invoice_provider.dart';
//import 'package:yala_pay/providers/cheques_provider.dart';

class PaymentProvider extends Notifier<List<Payment>> {
    List<Invoice>invoices = [];
  @override
  List<Payment> build() {
    _initializeState();
    ref.read(invoiceProvider.notifier).invoiceBalanceCalc();
    return [];
  }

  void _initializeState() async {
    List<Payment> temp = [];
    var data = await rootBundle.loadString('assets/YalaPay-data/payments.json');
    var paymentsMap = jsonDecode(data);
    for (var paymentJson in paymentsMap) {
      temp.add(Payment.fromJson(paymentJson));
    }
    state = temp;
    
  }

  int generatePaymentId() {
    if (state.isEmpty) {
      return 1;
    } else {
      return state.map((pay) => pay.id).reduce((a, b) => a > b ? a : b) + 1;
    }
  }

  void addPayment(Payment payment) {

    // Add the payment to the state
    state = [...state, payment];
    ref.read(invoiceProvider.notifier).invoiceBalanceCalc();
    
  }

  void updatePayment(Payment updatedPayment) {
    state = [
      for (final payment in state)
        if (payment.id == updatedPayment.id) updatedPayment else payment
    ];
    ref.read(invoiceProvider.notifier).invoiceBalanceCalc();

  }

  void deletePayment(Payment payment) {
    /*if(payment.chequeNo != null) {
     ref.read(chequesProvider.notifier).removeCheque(ref.read(chequesProvider.notifier).getChequeById(payment.chequeNo!));
   
    } */
    
    state = state.where((p) => p.id != payment.id).toList();
    ref.read(invoiceProvider.notifier).invoiceBalanceCalc();
  }

  List<Payment> getPaymentsByInvoice(int invoiceNo) {
    return state.where((payment) => payment.invoiceNo == invoiceNo).toList();
  }
}

final paymentProvider =
    NotifierProvider<PaymentProvider, List<Payment>>(() => PaymentProvider());

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yala_pay/models/payment.dart';
import 'package:yala_pay/providers/repo_provider.dart';
import 'package:yala_pay/repo/yalapay_repo.dart';

class PaymentProvider extends AsyncNotifier<List<Payment>> {
  late final YalapayRepo _repo;

  @override
  Future<List<Payment>> build() async {
    _repo = await ref.watch(yalaPayRepoProvider.future);

    _repo.observePayments().listen((payments) {
      state = AsyncValue.data(payments);
    }).onError((error) {
      print(error);
    });

    return [];
  }

  Future<void> addPayment(Payment payment) async {
    await _repo.addPayment(payment);
  }

  Future<void> updatePayment(Payment updatedPayment) async {
    await _repo.updatePayment(updatedPayment);
  }

  Future<void> deletePayment(String paymentId) async {
    await _repo.deletePayment(paymentId);
  }

  Future<List<Payment>> getPaymentsByInvoice(String invoiceNo) async {
    return await _repo.getPaymentsByInvoice(invoiceNo);
  }
}

final paymentNotifierProvider =
    AsyncNotifierProvider<PaymentProvider, List<Payment>>(
        () => PaymentProvider());

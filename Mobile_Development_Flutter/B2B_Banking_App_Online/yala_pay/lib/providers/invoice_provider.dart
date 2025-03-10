import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yala_pay/models/invoice.dart';
import 'package:yala_pay/providers/repo_provider.dart';
import 'package:yala_pay/repo/yalapay_repo.dart';

class InvoiceProvider extends AsyncNotifier<List<Invoice>> {
  late final YalapayRepo _repo;
  String query = '';

  @override
  Future<List<Invoice>> build() async {
    _repo = await ref.watch(yalaPayRepoProvider.future);

    _repo.observeInvoices().listen((invoices) {
      state = AsyncValue.data(invoices);
    }).onError((error) {
      throw Exception(error);
    });

    return [];
  }

  Future<void> addInvoice(Invoice invoice) async {
    await _repo.addInvoice(invoice);
  }

  Future<void> updateInvoice(Invoice updatedInvoice) async {
    await _repo.updateInvoice(updatedInvoice);
  }

  Future<void> deleteInvoice(String invoiceNumber) async {
    await _repo.deleteInvoice(invoiceNumber);
  }

  Future<void> invoiceSearch(String searchQuery) async {
    query = searchQuery;
    final invoices = await _repo.searchInvoices(query);
    state = AsyncValue.data(invoices);
  }

  Future<Invoice?> getInvoiceByNumber(int invoiceNumber) async {
    return await _repo.getInvoiceByNumber(invoiceNumber);
  }

  Future<List<Invoice>> getInvoicesByDateAndStatus(
    DateTime fromDate,
    DateTime toDate,
    String status,
  ) async {
    final invoices = await _repo.getInvoicesByDateAndStatus(
      fromDate,
      toDate,
      status,
    );
    // state = AsyncValue.data(invoices);
    return AsyncValue.data(invoices).value!;
  }

  Future<List<Invoice>> getInvoicesByDateAndStatusFirestore(
      DateTime fromDate, DateTime toDate, String status) async {
    return await _repo.getInvoicesByDateAndStatus(fromDate, toDate, status);
  }

  Future<void> invoiceBalanceCalc() async {
    await _repo.invoiceBalanceCalc();
    final updatedInvoices = await _repo.observeInvoices().first;
    state = AsyncValue.data(updatedInvoices);
  }
}

final invoiceNotifierProvider =
    AsyncNotifierProvider<InvoiceProvider, List<Invoice>>(
        () => InvoiceProvider());

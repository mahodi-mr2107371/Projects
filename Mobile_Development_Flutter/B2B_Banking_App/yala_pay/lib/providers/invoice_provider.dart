import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yala_pay/models/invoice.dart';
import 'package:yala_pay/models/payment.dart';
import 'package:yala_pay/providers/payment_provider.dart';

class InvoiceProvider extends Notifier<List<Invoice>> {
  List<Invoice> _originalInvoices = []; // To store the original invoices
  String query = '';
  bool isInit = false;
  
  @override
  List<Invoice> build() {
    !isInit?_initializeState():null;
    
    return [];
  }
  

  void _initializeState() async {

    List<Invoice> temp = [];
    var data = await rootBundle.loadString('assets/YalaPay-data/invoices.json');
    var invoicesMap = jsonDecode(data);
    for (var invoice in invoicesMap) {
      var inv = Invoice.fromJson(invoice);
      inv.calculateBalance(ref.read(paymentProvider.notifier).getPaymentsByInvoice(inv.invoiceNumber));
      temp.add(inv);
    }
    _originalInvoices = temp;
    state = temp;
    isInit = true;
  }

  void addInvoice(Invoice invoice) {
    state = [...state, invoice];
  }

  void updateInvoice(Invoice updatedInvoice) {
    state = state.map((invoice){
      if(invoice.invoiceNumber==updatedInvoice.invoiceNumber){
        return updatedInvoice;
      }
      return invoice;
    }).toList();
  }

  void deleteInvoice(int invoiceNumber) {
    state = state
        .where((invoice) => invoice.invoiceNumber != invoiceNumber)
        .toList();
  }

  void invoiceSearch(String searchQuery) {
    query = searchQuery;

    // Attempt to parse the search query as an integer
    final int? invoiceNumberQuery = int.tryParse(query);
    final int? customerIdQuery = int.tryParse(query);

    if (query.isEmpty) {
      // If the search query is empty, reset to original invoices
      state = List.from(_originalInvoices);
      return;
    }

    state = _originalInvoices.where((invoice) {
      // Check for matches in both invoice number and customer ID
      return invoiceNumberQuery != null &&
              invoice.invoiceNumber == invoiceNumberQuery ||
          customerIdQuery != null && invoice.customerId == customerIdQuery;
    }).toList();
  }

  Invoice? getInvoiceByNumber(int invoiceNumber) {
    try {
      return state
          .firstWhere((invoice) => invoice.invoiceNumber == invoiceNumber);
    } catch (e) {
      return null;
    }
  }

  int generateInvoiceNumber() {
    if (state.isEmpty) {
      return 1;
    } else {
      return state
              .map((invoice) => invoice.invoiceNumber)
              .reduce((a, b) => a > b ? a : b) +
          1;
    }
  }

  void invoiceBalanceCalc(){
    state.map((invoice){
      invoice.calculateBalance(ref.read(paymentProvider.notifier).getPaymentsByInvoice(invoice.invoiceNumber));
    });
  }

  List<Invoice> getInvoicesByDateAndStatus(DateTime fromDate, DateTime toDate,
      String status, List<Payment> payments) {
    return state.where((invoice) {
      final invoiceDate = invoice.invoiceDate;

      // Check if the invoice date is within the specified range
      final isWithinDateRange =
          invoiceDate.isAfter(fromDate) && invoiceDate.isBefore(toDate);

      // Calculate balance based on payments for the current invoice
      invoice.calculateBalance(payments
          .where((payment) => payment.invoiceNo == invoice.invoiceNumber)
          .toList());

      // Determine if the status matches the specified filter
      final isStatusMatch = (status == 'All' ||
          (status == 'Pending' && invoice.balance == invoice.amount) ||
          (status == 'Partially Paid' &&
              invoice.balance > 0 &&
              invoice.balance < invoice.amount) ||
          (status == 'Paid' && invoice.balance == 0));

      return isWithinDateRange && isStatusMatch;
    }).toList();
  }

}

final invoiceProvider =
    NotifierProvider<InvoiceProvider, List<Invoice>>(() => InvoiceProvider());

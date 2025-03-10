import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yala_pay/providers/cheques_provider.dart';
import 'package:yala_pay/providers/invoice_provider.dart';
import 'package:yala_pay/utility/info_card.dart';

class Dashboard extends ConsumerWidget {
  const Dashboard({super.key});

  Future<double> getChequeTotal(WidgetRef ref, String status) async {
    final fromDate = DateTime(2000);
    final toDate = DateTime.now();
    final cheques = await ref
        .read(chequesProvider.notifier)
        .getChequesByDateAndStatusFirestore(fromDate, toDate, status);
    double total = 0;
    for (var cheque in cheques) {
      final amount = cheque.amount;
      total += amount;
    }
    return total;
  }

  Future<double> getInvoiceTotal(
      WidgetRef ref, DateTime dueDate, String status) async {
    final fromDate = DateTime.now();
    final toDate = dueDate;
    final invoices = await ref
        .read(invoiceNotifierProvider.notifier)
        .getInvoicesByDateAndStatusFirestore(fromDate, toDate, status);
    double total = 0.0;
    for (var invoice in invoices) {
      final balance = invoice.balance;
      total += balance;
    }
    return total;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(chequesProvider);
    ref.watch(invoiceNotifierProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard',
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color.fromRGBO(226, 149, 120, 1),
        centerTitle: true,
      ),
      backgroundColor: const Color(0xFFE0F7FA),
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: _loadData(ref),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Error loading dashboard: ${snapshot.error}',
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }

            if (!snapshot.hasData) {
              return const Center(child: Text('No data available'));
            }

            final chequeData =
                snapshot.data!['chequeData'] as Map<String, double>;
            final invoiceData =
                snapshot.data!['invoiceData'] as Map<String, double>;

            return Column(
              children: [
                InfoCard(
                  title: "Cheques",
                  details: Text.rich(
                    TextSpan(
                      text: 'Awaiting: ',
                      style: const TextStyle(color: Colors.black),
                      children: [
                        TextSpan(
                          text:
                              '${chequeData['Awaiting']!.toStringAsFixed(2)} QR',
                          style: const TextStyle(
                              color: Colors.orange,
                              fontWeight: FontWeight.bold),
                        ),
                        const TextSpan(
                          text: '\nDeposited: ',
                          style: TextStyle(color: Colors.black),
                        ),
                        TextSpan(
                          text:
                              '${chequeData['Deposited']!.toStringAsFixed(2)} QR',
                          style: const TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold),
                        ),
                        const TextSpan(
                          text: '\nCashed: ',
                          style: TextStyle(color: Colors.black),
                        ),
                        TextSpan(
                          text:
                              '${chequeData['Cashed']!.toStringAsFixed(2)} QR',
                          style: const TextStyle(
                              color: Colors.green, fontWeight: FontWeight.bold),
                        ),
                        const TextSpan(
                          text: '\nReturned: ',
                          style: TextStyle(color: Colors.black),
                        ),
                        TextSpan(
                          text:
                              '${chequeData['Returned']!.toStringAsFixed(2)} QR',
                          style: const TextStyle(
                              color: Colors.red, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                InfoCard(
                  title: "Invoices",
                  details: Text.rich(
                    TextSpan(
                      text: 'All: ',
                      style: const TextStyle(color: Colors.black),
                      children: [
                        TextSpan(
                          text: '${invoiceData['All']!.toStringAsFixed(2)} QR',
                          style: const TextStyle(
                              color: Colors.green, fontWeight: FontWeight.bold),
                        ),
                        const TextSpan(
                          text: '\nDue in 30 days: ',
                          style: TextStyle(color: Colors.black),
                        ),
                        TextSpan(
                          text:
                              '${invoiceData['30Days']!.toStringAsFixed(2)} QR',
                          style: const TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold),
                        ),
                        const TextSpan(
                          text: '\nDue in 60 days: ',
                          style: TextStyle(color: Colors.black),
                        ),
                        TextSpan(
                          text:
                              '${invoiceData['60Days']!.toStringAsFixed(2)} QR',
                          style: const TextStyle(
                              color: Colors.red, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Future<Map<String, Map<String, double>>> _loadData(WidgetRef ref) async {
    try {
      // Initialize with default values
      final chequeData = <String, double>{
        'Awaiting': 0.0,
        'Deposited': 0.0,
        'Cashed': 0.0,
        'Returned': 0.0
      };

      final invoiceData = <String, double>{
        'All': 0.0,
        '30Days': 0.0,
        '60Days': 0.0
      };

      // Fetch Cheque Totals
      final chequeStatuses = ['Awaiting', 'Deposited', 'Cashed', 'Returned'];
      for (var status in chequeStatuses) {
        chequeData[status] = await getChequeTotal(ref, status);
      }

      // Fetch Invoice Totals
      final allInvoices = await ref
          .read(invoiceNotifierProvider.notifier)
          .getInvoicesByDateAndStatusFirestore(
              DateTime(2000), DateTime.now(), 'All');

      if (allInvoices.isNotEmpty) {
        invoiceData['All'] =
            allInvoices.fold(0.0, (sum, invoice) => sum + (invoice.amount));
      }

      // Due dates
      invoiceData['30Days'] = await getInvoiceTotal(
          ref, DateTime.now().add(const Duration(days: 30)), 'All');
      invoiceData['60Days'] = await getInvoiceTotal(
          ref, DateTime.now().add(const Duration(days: 60)), 'All');

      return {
        'chequeData': chequeData,
        'invoiceData': invoiceData,
      };
    } catch (e) {
      print('Error loading dashboard data: $e');
      // Return empty data on error
      return {
        'chequeData': {
          'Awaiting': 0.0,
          'Deposited': 0.0,
          'Cashed': 0.0,
          'Returned': 0.0
        },
        'invoiceData': {'All': 0.0, '30Days': 0.0, '60Days': 0.0}
      };
    }
  }
}

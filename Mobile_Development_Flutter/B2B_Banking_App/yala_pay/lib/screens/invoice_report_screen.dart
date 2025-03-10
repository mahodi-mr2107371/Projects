import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:yala_pay/models/invoice.dart';
import 'package:yala_pay/models/payment.dart';
import 'package:yala_pay/providers/invoice_provider.dart';
import 'package:yala_pay/providers/payment_provider.dart';
import 'package:yala_pay/providers/invoice_status_provider.dart';
import 'package:yala_pay/screens/invoice_detail_screen.dart';

class InvoiceReportScreen extends ConsumerStatefulWidget {
  const InvoiceReportScreen({super.key});

  @override
  ConsumerState<InvoiceReportScreen> createState() =>
      _InvoiceReportScreenState();
}

class _InvoiceReportScreenState extends ConsumerState<InvoiceReportScreen> {
  DateTime fromDate = DateTime(2024, 1, 1);
  DateTime toDate = DateTime.now();
  List<String> statusOptions = [];
  // late List<Payment> payments;
  String selectedStatus = 'All';
  List<Invoice> filteredInvoices = [];
  // bool isLoading = true; // Add loading state

  // @override
  // void initState() {
  //   super.initState();
  //   initialState();
  // }

  // void initialState() {
  //   // Set default date range to show all invoices
  //   fromDate = DateTime(2000, 1, 1); // Start date
  //   toDate = DateTime.now(); // End date

  //   _loadInvoices();
  // }

  // Future<void> _loadInvoices() async {
  //   setState(() {
  //     isLoading = true; // Set loading to true
  //   });

  //   final payments = ref.read(paymentProvider);
  //   filteredInvoices = ref
  //       .read(invoiceProvider.notifier)
  //       .getInvoicesByDateAndStatus(fromDate, toDate, selectedStatus, payments);

  //   setState(() {
  //     isLoading = false; // Set loading to false
  //   });
  // }

  // void _filterInvoices() {
  //   _loadInvoices();
  // }
  // @override
  // void initState() {
  //   super.initState();
  //   _filterCheques();
  // }

  // void _filterCheques() {
  //   filteredInvoices = ref
  //       .read(invoiceProvider.notifier)
  //       .getInvoicesByDateAndStatus(fromDate, toDate, selectedStatus, payments);
  // }

  Map<String, int> get totals {
    return {
      'pending': filteredInvoices
          .where((invoice) => invoice.balance == invoice.amount)
          .length,
      'partial': filteredInvoices
          .where((invoice) =>
              invoice.balance > 0 && invoice.balance < invoice.amount)
          .length,
      'paid': filteredInvoices.where((invoice) => invoice.balance == 0).length,
      'total': filteredInvoices.length,
    };
  }

  @override
  Widget build(BuildContext context) {
    List<Payment> payments = ref.read(paymentProvider);
    final statusOptions = ref.watch(invoiceStatusProviderNotifier);
    filteredInvoices = ref
        .read(invoiceProvider.notifier)
        .getInvoicesByDateAndStatus(fromDate, toDate, selectedStatus, payments);

    return Scaffold(
      body: Container(
        color: const Color(0xFFE0F7FA),
        child: Column(
          children: [
            // Header Section
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFF8D1C1),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 1),
                    Row(
                      children: [
                        Expanded(
                          child: _buildDateField(
                            'From Date',
                            fromDate,
                            (date) {
                              setState(() =>
                                  fromDate = date ?? DateTime(2024, 1, 1));
                              // _filterInvoices();
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildDateField(
                            'To Date',
                            toDate,
                            (date) {
                              setState(() => toDate = date ?? DateTime.now());
                              // _filterInvoices();
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildStatusDropdown(statusOptions),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Invoices List
            Expanded(
              child: filteredInvoices.isNotEmpty
                  ? ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: filteredInvoices.length,
                      itemBuilder: (context, index) {
                        final invoice = filteredInvoices[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    InvoiceDetailsScreen(invoice: invoice),
                              ),
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 243, 229, 248),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.1),
                                  spreadRadius: 1,
                                  blurRadius: 2,
                                  offset: const Offset(0, 1),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Invoice No: ${invoice.invoiceNumber}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        DateFormat('yyyy-MM-dd')
                                            .format(invoice.invoiceDate),
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        'Amount: \$${invoice.amount.toStringAsFixed(2)}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Balance: \$${invoice.balance.toStringAsFixed(2)}',
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('No Invoices found'),
                        TextButton(
                            onPressed: () {
                              setState(() {
                                fromDate = DateTime(2024, 1, 1);
                                toDate = DateTime.now();
                                selectedStatus = 'All';
                              });
                            },
                            child: const Text("Reload"))
                      ],
                    ),
            ),

            // Summary Section
            if (selectedStatus == 'All')
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Total Amounts and Reports ',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Pending: ${totals['pending']}'),
                            Text('Partially Paid: ${totals['partial']}'),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Paid: ${totals['paid']}'),
                            Text('Grand Total: ${totals['total']}'),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateField(
      String label, DateTime? value, Function(DateTime?) onChanged) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.055,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
      ),
      child: TextField(
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(fontSize: 14),
          border: InputBorder.none,
          contentPadding: EdgeInsets.zero,
        ),
        readOnly: true,
        style: const TextStyle(fontSize: 12),
        controller: TextEditingController(
          text: value != null ? DateFormat('yyyy-MM-dd').format(value) : '',
        ),
        onTap: () async {
          final pickedDate = await showDatePicker(
            context: context,
            initialDate: value ?? DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime(2101),
          );
          if (pickedDate != null) {
            onChanged(pickedDate);
          }
        },
      ),
    );
  }

  Widget _buildStatusDropdown(List<String> statusOptions) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.055,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
      ),
      child: DropdownButton<String>(
        isExpanded: true,
        hint: const Text('Status:'),
        value: selectedStatus,
        underline: Container(),
        items: ['All', ...statusOptions].map((String status) {
          return DropdownMenuItem(
            value: status,
            child: Text(
              status,
              style: const TextStyle(fontSize: 12),
            ),
          );
        }).toList(),
        onChanged: (String? newValue) {
          if (newValue != null) {
            setState(() => selectedStatus = newValue);
            // _filterInvoices();
          }
        },
      ),
    );
  }
}

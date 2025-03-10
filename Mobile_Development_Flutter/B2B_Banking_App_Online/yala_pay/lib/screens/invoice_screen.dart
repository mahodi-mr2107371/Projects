import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yala_pay/models/customer.dart';
import 'package:yala_pay/models/invoice.dart';
import 'package:yala_pay/providers/customer_provider.dart';
import 'package:yala_pay/providers/invoice_provider.dart';
import 'package:yala_pay/providers/payment_provider.dart';
import 'package:yala_pay/utility/invoice_tile.dart';

class InvoiceScreen extends ConsumerStatefulWidget {
  const InvoiceScreen({super.key});

  @override
  ConsumerState<InvoiceScreen> createState() => _InvoiceScreenState();
}

class _InvoiceScreenState extends ConsumerState<InvoiceScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool showSearch = false;
  List<Customer> customers = [];
  List<Invoice> invoices = [];

  // Function to select a date
  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      controller.text =
          "${pickedDate.toLocal()}".split(' ')[0]; // Format date to YYYY-MM-DD
    }
  }

  void _showInvoiceDialog(BuildContext context, WidgetRef ref,
      {Invoice? invoice}) {
    final isEditing = invoice != null;
    final id = invoice?.invoiceNumber ?? "0";
    final customerIdController =
        TextEditingController(text: invoice?.customerId.toString() ?? '');
    final amountController =
        TextEditingController(text: invoice?.amount.toString() ?? '');
    final invoiceDateController = TextEditingController(
        text: invoice?.invoiceDate.toString().split(' ')[0] ??
            ''); // Format date to YYYY-MM-DD
    final dueDateController = TextEditingController(
        text: invoice?.dueDate.toString().split(' ')[0] ??
            ''); // Format date to YYYY-MM-DD

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(isEditing ? 'Edit Invoice' : 'Add Invoice'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: customerIdController,
                  decoration: const InputDecoration(labelText: 'Customer ID'),
                ),
                TextField(
                  controller: amountController,
                  decoration: const InputDecoration(labelText: 'Amount'),
                ),
                TextField(
                  controller: invoiceDateController,
                  decoration: const InputDecoration(labelText: 'Invoice Date'),
                  readOnly: true, // Make it read-only to prevent keyboard input
                  onTap: () => _selectDate(
                      context, invoiceDateController), // Call date picker
                ),
                TextField(
                  controller: dueDateController,
                  decoration: const InputDecoration(labelText: 'Due Date'),
                  readOnly: true, // Make it read-only to prevent keyboard input
                  onTap: () => _selectDate(
                      context, dueDateController), // Call date picker
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (customers
                    .any((e) => e.customerId == customerIdController.text)) {
                  final newInvoice = Invoice(
                    invoiceNumber: isEditing ? id : "0",
                    customerId: customerIdController.text,
                    amount: double.tryParse(amountController.text) ?? 0.0,
                    invoiceDate: DateTime.parse(invoiceDateController.text),
                    dueDate: DateTime.parse(dueDateController.text),
                    balance: double.tryParse(amountController.text) ?? 0.0,
                  );

                  if (isEditing) {
                    ref
                        .read(invoiceNotifierProvider.notifier)
                        .updateInvoice(newInvoice);
                  } else {
                    ref
                        .read(invoiceNotifierProvider.notifier)
                        .addInvoice(newInvoice);
                  }

                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Enter Valid Customer ID'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              },
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(paymentNotifierProvider);
    customers = ref.watch(customerNotifierProvider).when(
          data: (cts) => cts.toList(),
          loading: () => [],
          error: (_, __) => [],
        );
    invoices = ref.watch(invoiceNotifierProvider).when(
          data: (chequeDeposits) => chequeDeposits.toList(),
          loading: () => [],
          error: (_, __) => [],
        );

    _searchController.text = ref.read(invoiceNotifierProvider.notifier).query;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(226, 149, 120, 1),
        title: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: showSearch
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 227, 186, 170),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: _searchController,
                          onChanged: (value) => ref
                              .read(invoiceNotifierProvider.notifier)
                              .invoiceSearch(_searchController.text),
                          onTapOutside: (event) =>
                              FocusScope.of(context).requestFocus(FocusNode()),
                          decoration: const InputDecoration(
                            hintText: 'Search...',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          showSearch = !showSearch;
                          ref
                              .read(invoiceNotifierProvider.notifier)
                              .invoiceSearch('');
                        });
                      },
                      icon: const Icon(Icons.close, color: Colors.black),
                    ),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        _showInvoiceDialog(context, ref);
                      },
                      icon: const Icon(Icons.note_add),
                    ),
                    const Text(
                      "Invoices",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          showSearch = !showSearch;
                        });
                      },
                      icon: const Icon(Icons.search),
                    ),
                  ],
                ),
        ),
        centerTitle: true,
        elevation: 2,
      ),
      body: invoices.isEmpty
          ? Center(
              child: Text(
                'No invoices found.',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey[600],
                ),
              ),
            )
          : Container(
              padding: const EdgeInsets.all(5),
              color: const Color(0xFFE0F7FA),
              height: MediaQuery.of(context).size.height * 0.8,
              child: ListView.builder(
                itemCount: invoices.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(10),
                    child: Container(
                      padding: const EdgeInsets.all(0),
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 243, 229, 248),
                          borderRadius: BorderRadius.circular(15)),
                      child: Column(
                        children: [
                          InvoiceTile(
                            invoice: invoices[index],
                            delete: () => ref
                                .read(invoiceNotifierProvider.notifier)
                                .deleteInvoice(invoices[index].invoiceNumber),
                            edit: () {
                              _showInvoiceDialog(context, ref,
                                  invoice: invoices[index]);
                            },
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              elevation: 3,
                              foregroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              minimumSize:
                                  Size(MediaQuery.of(context).size.width, 45),
                              backgroundColor:
                                  const Color.fromARGB(255, 131, 197, 149),
                            ),
                            onPressed: () {
                              Navigator.of(context).pushNamed(
                                'payments',
                                arguments: invoices[index],
                              );
                            },
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Invoice Payments"),
                                Icon(Icons.arrow_forward_sharp),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}

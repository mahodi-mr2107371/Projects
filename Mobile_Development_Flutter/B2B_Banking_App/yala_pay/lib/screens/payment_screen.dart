import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yala_pay/models/payment.dart';
import 'package:yala_pay/models/cheque.dart';
import 'package:yala_pay/providers/banks_provider.dart';
import 'package:yala_pay/providers/cheques_provider.dart';
import 'package:yala_pay/providers/invoice_provider.dart';
import 'package:yala_pay/providers/payment_provider.dart';
import 'package:yala_pay/models/invoice.dart';
import 'package:yala_pay/utility/payment_tile.dart';

class PaymentScreen extends ConsumerStatefulWidget {
  final Invoice invoice;

  const PaymentScreen({super.key, required this.invoice});

  @override
  ConsumerState<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends ConsumerState<PaymentScreen> {
  List<String> banks = [];
  List<Invoice> invoices =[];
  List<Payment> payments = [];
  
  final TextEditingController _searchController = TextEditingController();
  bool showSearch = false;
  List<Payment> allPayments = [];
  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      controller.text = picked.toIso8601String().split("T").first;
    }
  }

  void _showPaymentDialog(BuildContext context, WidgetRef ref,
      {Payment? payment}) {
    final isEditing = payment != null;
    final id = payment?.id ?? 0;
    final amountController =
        TextEditingController(text: payment?.amount.toString() ?? "");
    final dateController = TextEditingController(
        text: payment?.paymentDate.toIso8601String().split("T").first ?? "");
    String selectedPaymentMode = payment?.modeOfPayment ?? 'Bank Transfer';
    Cheque? cheque;
    payment?.chequeNo != null
        ? cheque = ref
            .read(chequesProvider.notifier)
            .getChequeById(payment?.chequeNo ?? 0)
        : null;

    final chequeNoController =
        TextEditingController(text: cheque?.chequeNumber.toString() ?? '');
    final drawerController = TextEditingController(text: cheque?.drawer ?? '');
    final dueDateController =
        TextEditingController(text: cheque?.dueDate.toIso8601String().split("T").first ?? '');
    String selectedChequeImage = cheque?.chequeImage.split('.')[0] ?? 'cheque1';
    DateTime receivedDate = DateTime.now();
    String selectedDrawerBank = cheque?.drawerBank ?? 'Qatar National Bank';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Text(isEditing ? 'Edit Payment' : 'Add Payment'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: amountController,
                      decoration: const InputDecoration(labelText: 'Amount'),
                      keyboardType: TextInputType.number,
                    ),
                    TextField(
                      controller: dateController,
                      readOnly: true,
                      decoration: const InputDecoration(
                          labelText: 'Payment Date (YYYY-MM-DD)'),
                      onTap: () => _selectDate(context, dateController),
                    ),
                    DropdownButtonFormField<String>(
                      value: selectedPaymentMode,
                      items: ['Cheque', 'Bank Transfer', 'Credit Card']
                          .map((mode) => DropdownMenuItem(
                                value: mode,
                                child: Text(mode),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedPaymentMode = value!;
                        });
                      },
                      decoration:
                          const InputDecoration(labelText: 'Payment Method'),
                    ),
                    if (selectedPaymentMode == 'Cheque') ...[
                      TextField(
                        controller: chequeNoController,
                        decoration:
                            const InputDecoration(labelText: 'Cheque No'),
                        keyboardType: TextInputType.number,
                      ),
                      TextField(
                        controller: drawerController,
                        decoration: const InputDecoration(labelText: 'Drawer'),
                      ),
                      DropdownButtonFormField<String>(
                        value: selectedDrawerBank,
                        onChanged: (String? value) {
                          setState(() {
                            selectedDrawerBank = value!;
                          });
                        },
                        items: banks
                            .map((bank) => DropdownMenuItem(
                                  value: bank,
                                  child: Text(bank),
                                ))
                            .toList(),
                        decoration:
                            const InputDecoration(labelText: 'Drawer Bank'),
                      ),
                      TextField(
                        controller: dueDateController,
                        readOnly: true,
                        decoration: const InputDecoration(
                            labelText: 'Due Date (YYYY-MM-DD)'),
                        onTap: () => _selectDate(context, dueDateController),
                      ),
                      DropdownButtonFormField<String>(
                        value: selectedChequeImage,
                        items: [
                          'cheque1',
                          'cheque2',
                          'cheque3',
                          'cheque4',
                          'cheque5',
                          'cheque6',
                          'cheque7'
                        ]
                            .map((image) => DropdownMenuItem(
                                  value: image,
                                  child: Text(image),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedChequeImage = value!;
                          });
                        },
                        decoration: const InputDecoration(
                            labelText: 'Cheque Image Name'),
                      ),
                    ],
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
                    
                      final newPayment = selectedPaymentMode.toLowerCase() !=
                              'cheque'
                          ? Payment(
                              id: isEditing
                                  ? id
                                  : ref
                                      .read(paymentProvider.notifier)
                                      .generatePaymentId(),
                              invoiceNo: widget.invoice.invoiceNumber,
                              amount:
                                  double.tryParse(amountController.text) ?? 0.0,
                              paymentDate:
                                  DateTime.tryParse(dateController.text) ??
                                      DateTime.now(),
                              modeOfPayment: selectedPaymentMode,
                            )
                          : Payment(
                              id: isEditing
                                  ? id
                                  : ref
                                      .read(paymentProvider.notifier)
                                      .generatePaymentId(),
                              invoiceNo: widget.invoice.invoiceNumber,
                              amount:
                                  double.tryParse(amountController.text) ?? 0.0,
                              paymentDate:
                                  DateTime.tryParse(dateController.text) ??
                                      DateTime.now(),
                              modeOfPayment: selectedPaymentMode,
                              chequeNo:
                                  int.tryParse(chequeNoController.text),
                            );

                      // Add cheque if payment mode is 'Cheque'
                      Cheque? newCheque;
                      if (selectedPaymentMode == 'Cheque') {
                        
                        newCheque = Cheque(
                          chequeNumber:
                              int.tryParse(chequeNoController.text) ?? 0,
                          drawer: drawerController.text,
                          drawerBank: selectedDrawerBank,
                          amount: double.tryParse(amountController.text) ?? 0.0,
                          status: 'Awaiting',
                          receivedDate: receivedDate,
                          dueDate: DateTime.tryParse(dueDateController.text) ??
                              DateTime.now(),
                          chequeImage: '$selectedChequeImage.jpg',
                        );
                      }

                      // Update or add payment
                      if (isEditing) {
                        ref
                            .read(paymentProvider.notifier)
                            .updatePayment(newPayment);
                        newPayment.modeOfPayment.toLowerCase()=='cheque'?ref.read(chequesProvider.notifier).updateCheque(newCheque!):null;
                      } else {
                        
                        ref
                            .read(paymentProvider.notifier)
                            .addPayment(newPayment);
                        
                        newPayment.modeOfPayment.toLowerCase()=='cheque'?ref.read(chequesProvider.notifier).addCheque(newCheque!):null;
                       
                        
                      }

                      // Calculate balance and update invoice
                      widget.invoice
                          .calculateBalance(ref.read(paymentProvider));
                      ref
                          .read(invoiceProvider.notifier)
                          .updateInvoice(widget.invoice);

                      Navigator.of(context).pop();
                    
                  },
                  child: const Text('Submit'),
                )
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    allPayments = ref.watch(paymentProvider);
    payments = ref.read(paymentProvider.notifier).getPaymentsByInvoice(widget.invoice.invoiceNumber);
    banks = ref.watch(banksProviderNotifier);
    ref.watch(chequesProvider);

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
                          onChanged: (value) => setState(() {}),
                          decoration: const InputDecoration(
                            hintText: 'Search by Amount or ID...',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          showSearch = !showSearch;
                          _searchController.clear();
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
                        onPressed: widget.invoice.balance > 0
                            ? () {
                                _showPaymentDialog(context, ref);
                              }
                            : null,
                        icon: const Icon(Icons.add)),
                    const Text(
                      "Payments",
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
      body: payments.isEmpty
          ? Center(
              child: Text(
                'No payment history.',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey[600],
                ),
              ),
            )
          : Container(
              padding: const EdgeInsets.all(5),
              color: const Color(0xFFE0F7FA),
              child: ListView.builder(
                itemCount: payments.length,
                itemBuilder: (context, index) {
                  final payment = payments[index];
                  final query = _searchController.text;

                  final isVisible = query.isEmpty ||
                      payment.amount.toString().contains(query) ||
                      payment.id.toString().contains(query);

                  return isVisible
                      ? Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: PaymentTile(
                            payment: payment,
                            delete: () {
                              ref
                                  .read(paymentProvider.notifier)
                                  .deletePayment(payment);
                              setState(() {
                                // Recalculate the balance after deletion
                                widget.invoice.calculateBalance(
                                    ref.watch(paymentProvider));
                              });
                            },
                            edit: () => _showPaymentDialog(context, ref,
                                payment: payment),
                          ),
                        )
                      : const SizedBox.shrink();
                },
              ),
            ),
    );
  }
}

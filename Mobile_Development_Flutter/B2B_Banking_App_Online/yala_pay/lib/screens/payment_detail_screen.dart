import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yala_pay/models/cheque.dart';
import 'package:yala_pay/models/payment.dart';
import 'package:yala_pay/providers/cheques_provider.dart';

class PaymentDetailScreen extends ConsumerStatefulWidget {
  final Payment _payment;

  const PaymentDetailScreen({super.key, required Payment payment})
      : _payment = payment;

  @override
  ConsumerState<PaymentDetailScreen> createState() =>
      _PaymentDetailScreenState();
}

class _PaymentDetailScreenState extends ConsumerState<PaymentDetailScreen> {
  @override
  Widget build(BuildContext context) {
    Cheque? cheque;
    Payment payment = widget._payment;

    if (payment.modeOfPayment.toLowerCase() == 'cheque') {
      cheque = ref
          .watch(chequesProvider)
          .value!
          .firstWhere((c) => c.chequeNumber == payment.chequeNo);
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(226, 149, 120, 1),
        title: const Text(
          'Payment Detail',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Payment Details',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ListTile(
              title: Text('Invoice No: ${payment.invoiceNo}'),
            ),
            ListTile(
              title: Text('Amount: ${payment.amount.toStringAsFixed(2)}'),
            ),
            ListTile(
              title: Text(
                  'Payment Date: ${payment.paymentDate.day}/${payment.paymentDate.month}/${payment.paymentDate.year}'),
            ),
            ListTile(
              title: Text('Mode of Payment: ${payment.modeOfPayment}'),
            ),
            const SizedBox(height: 20),
            if (cheque != null)
              ExpansionTile(
                title: const Text('Cheque Details'),
                children: [
                  ListTile(
                    title: Text('Cheque Number: ${cheque.chequeNumber}'),
                  ),
                  ListTile(
                    title: Text('Drawer: ${cheque.drawer}'),
                  ),
                  ListTile(
                    title: Text('Status: ${cheque.status}'),
                  ),
                  ListTile(
                    title: Text(
                        'Due Date: ${cheque.dueDate.day}/${cheque.dueDate.month}/${cheque.dueDate.year}'),
                  ),
                  ListTile(
                    title: Text('Amount: ${cheque.amount.toStringAsFixed(2)}'),
                  ),
                  ListTile(
                    title: Text('Drawer Bank: ${cheque.drawerBank}'),
                  ),
                  ListTile(
                    title: Text(
                        'Received Date: ${cheque.receivedDate.day}/${cheque.receivedDate.month}/${cheque.receivedDate.year}'),
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return Dialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.9,
                              height: MediaQuery.of(context).size.height * 0.8,
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Expanded(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: InteractiveViewer(
                                        boundaryMargin:
                                            const EdgeInsets.all(20),
                                        minScale: 0.5,
                                        maxScale: 4.0,
                                        child: Image.asset(
                                          'assets/YalaPay-data/cheques/${cheque!.chequeImage}',
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Close'),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        'assets/YalaPay-data/cheques/${cheque.chequeImage}',
                        fit: BoxFit.cover,
                        height: 150,
                        width: double.infinity,
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:yala_pay/models/cheque.dart';

class ChequeDetailScreen extends StatelessWidget {
  final Cheque cheque;

  const ChequeDetailScreen({super.key, required this.cheque});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE0F7FA),
      appBar: AppBar(
        title: const Text(
          'Cheque Details',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color.fromRGBO(226, 149, 120, 1),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Cheque Number: #${cheque.chequeNumber}',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Drawer: ${cheque.drawer}',
                    style: const TextStyle(fontSize: 18, color: Colors.black),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Drawer Bank: ${cheque.drawerBank}',
                    style: const TextStyle(fontSize: 18, color: Colors.black),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Amount: \$${cheque.amount.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Received Date: ${cheque.receivedDate.toLocal().toString().split(' ')[0]}',
                    style: const TextStyle(fontSize: 16, color: Colors.black),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Due Date: ${cheque.dueDate.toLocal().toString().split(' ')[0]}',
                    style: const TextStyle(fontSize: 16, color: Colors.black),
                  ),
                  const SizedBox(height: 20),
                  Divider(color: Colors.grey.shade300, thickness: 1),
                  const SizedBox(height: 20),
                  Text(
                    'Status: ${cheque.status}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (cheque.returnReason != null && cheque.returnReason!.isNotEmpty)
                    Text(
                      'Return Reason: ${cheque.returnReason}',
                      style: const TextStyle(fontSize: 16, color: Colors.red),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
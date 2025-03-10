import 'package:flutter/material.dart';
import 'package:yala_pay/models/payment.dart';

class PaymentTile extends StatelessWidget {
  final Payment _payment;
  final VoidCallback _delete;
  final VoidCallback _edit;

  const PaymentTile({
    super.key,
    required Payment payment,
    required VoidCallback delete,
    required VoidCallback edit,
  })  : _payment = payment,
        _delete = delete,
        _edit = edit;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: const Color.fromARGB(255, 243, 229, 248),
      margin: const EdgeInsets.all(0),
      elevation: 0,
      child: ListTile(
        title: Text(
          "Invoice #${_payment.invoiceNo}",
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Payment ID: ${_payment.id}"),
            Text("Amount: \$${_payment.amount}"),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blueAccent),
              onPressed: _edit,
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.redAccent),
              onPressed: _delete,
            ),
          ],
        ),
        onTap: () {
          Navigator.of(context).pushNamed('paymentDetail', arguments: _payment);
        },
      ),
    );
  }
}

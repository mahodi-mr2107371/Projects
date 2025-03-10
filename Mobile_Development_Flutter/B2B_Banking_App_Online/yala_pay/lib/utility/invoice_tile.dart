import 'package:flutter/material.dart';
import 'package:yala_pay/models/invoice.dart';

class InvoiceTile extends StatelessWidget {
  final Invoice _invoice;
  final VoidCallback _delete;
  final VoidCallback _edit;

  const InvoiceTile({
    super.key,
    required Invoice invoice,
    required VoidCallback delete,
    required VoidCallback edit,
  })  : _invoice = invoice,
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
          "Invoice #${_invoice.invoiceNumber}",
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Customer ID: ${_invoice.customerId}"),
            Text("Amount: \$${_invoice.amount}"),
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
          Navigator.pushNamed(context, 'invoiceDetail', arguments: {
            'invoice': _invoice,
          });
        },
      ),
    );
  }
}

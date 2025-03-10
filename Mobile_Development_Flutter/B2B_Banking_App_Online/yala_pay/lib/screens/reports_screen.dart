import 'package:flutter/material.dart';
import 'package:yala_pay/screens/cheque_report_screen.dart';
import 'package:yala_pay/screens/invoice_report_screen.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  String _selectedTitle = 'Cheques'; // Initial title

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(226, 149, 120, 1),
        title: DropdownButton<String>(
          value: _selectedTitle,
          dropdownColor: Colors.white,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
          underline: Container(),
          items: ['Cheques', 'Invoices'].map((String title) {
            return DropdownMenuItem<String>(
              value: title,
              child: Text(title),
            );
          }).toList(),
          onChanged: (String? newValue) {
            if (newValue != null) {
              setState(() {
                _selectedTitle = newValue;
              });
              // _navigateToSelectedScreen(context, newValue);
            }
          },
        ),
        centerTitle: true,
      ),
      body: _selectedTitle == 'Invoices'
          ? const InvoiceReportScreen()
          : const ChequeReportScreen(),
    );
  }
}

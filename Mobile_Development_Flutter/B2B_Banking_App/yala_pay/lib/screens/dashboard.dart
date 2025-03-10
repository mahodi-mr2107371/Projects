import 'package:flutter/material.dart';
import 'package:yala_pay/utility/info_card.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color.fromRGBO(226, 149, 120, 1),
        centerTitle: true,
      ),
      backgroundColor: const Color(0xFFE0F7FA), // Light background color
      body: const SingleChildScrollView(
  child: Column(
    children: [
      InfoCard(
        title: "Cheques",
        details:  Text.rich(
          TextSpan(
            text: 'Awaiting: ',
            style: TextStyle(color: Colors.black),
            children: [
              TextSpan(
                text: '99.99 QR',
                style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold), 
              ),
              TextSpan(
                text: '\nDeposited: ',
                style: TextStyle(color: Colors.black),
              ),
              TextSpan(
                text: '22.22 QR',
                style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold), 
              ),
              TextSpan(
                text: '\nCashed: ',
                style: TextStyle(color: Colors.black),
              ),
              TextSpan(
                text: '44.44 QR',
                style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold), 
              ),
               TextSpan(
                text: '\nReturned: ',
                style: TextStyle(color: Colors.black),
              ),
              TextSpan(
                text: '11.11 QR',
                style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold), 
              ),
            ],
          ),
        ),
      ),
      InfoCard(
        title: "Invoices",
        details:  Text.rich(
          TextSpan(
            text: 'All: ',
            style: TextStyle(color: Colors.black),
            children: [
              TextSpan(
                text: '99.99 QR',
                style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text: '\nDue Date in 30 days: ',
                style: TextStyle(color: Colors.black),
              ),
              TextSpan(
                text: '33.33 QR',
                style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text: '\nDue Date in 60 days: ',
                style: TextStyle(color: Colors.black),
              ),
              TextSpan(
                text: '66.66 QR',
                style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    ],
  ),
)
    );
  }
}

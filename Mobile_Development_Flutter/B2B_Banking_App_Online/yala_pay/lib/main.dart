import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yala_pay/firebase_options.dart';
import 'package:yala_pay/models/customer.dart';
import 'package:yala_pay/models/invoice.dart';
import 'package:yala_pay/models/payment.dart';
import 'package:yala_pay/screens/awaiting_cheques.dart';
import 'package:yala_pay/screens/cheque_cache_screen.dart';
import 'package:yala_pay/screens/customer_detail_screen.dart';
import 'package:yala_pay/screens/customers_screen.dart';
import 'package:yala_pay/screens/invoice_detail_screen.dart';
import 'package:yala_pay/screens/invoice_screen.dart';
import 'package:yala_pay/screens/login.dart';
import 'package:yala_pay/screens/dashboard.dart';
import 'package:yala_pay/screens/payment_detail_screen.dart';
import 'package:yala_pay/screens/payment_screen.dart';
import 'package:yala_pay/screens/reports_screen.dart';
import 'package:yala_pay/screens/shell_screen.dart';
import 'package:yala_pay/screens/signup_screen.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await loadJsonFilesToFirestore();
  runApp(const ProviderScope(child: MyApp()));
}

Future<void> loadJsonFilesToFirestore() async {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  try {
    List<String> jsonFiles = [
      'assets/YalaPay-data/customers.json',
      'assets/YalaPay-data/invoices.json',
      'assets/YalaPay-data/payments.json',
      'assets/YalaPay-data/cheque-deposits.json',
      'assets/YalaPay-data/cheques.json',
    ];
    for (String filePath in jsonFiles) {
      String collectionName = filePath
          .split('/')
          .last
          .split('.')
          .first;

      // will check if there are collections already present
      QuerySnapshot existingCollections =
          await firestore.collection(collectionName).get();

      if (existingCollections.docs.isNotEmpty) {
        print("---- Note: '$collectionName' is already initialized ----");
        continue;
      }
      String jsonString = await rootBundle.loadString(filePath);
      List<dynamic> jsonData = jsonDecode(jsonString);

      for (var item in jsonData) {
        await firestore.collection(collectionName).add(item);
      }
      print("collection '$collectionName' initialized with data");
    }
    print('---------Firestore initialization successful-----------');
  } catch (e) {
    print('XXXXXX Error initializing Firestore: $e');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/': (context) => const LoginPage(),
        '/signup': (context) => const SignupScreen(),
        'dashboard': (context) =>
            ShellScreen(screenIndex: 0, screen: const Dashboard()),
        'customers': (context) =>
            ShellScreen(screenIndex: 1, screen: const CustomersScreen()),
        'invoices': (context) =>
            ShellScreen(screenIndex: 2, screen: const InvoiceScreen()),
        'chequeCache': (context) =>
            ShellScreen(screenIndex: 3, screen: const ChequeCacheScreen()),
        'reports': (context) =>
            ShellScreen(screenIndex: 4, screen: const ReportsScreen()),
        'payments': (context) {
          final invoice = ModalRoute.of(context)!.settings.arguments as Invoice;
          return PaymentScreen(invoice: invoice);
        },
        'paymentDetail': (context) {
          final payment = ModalRoute.of(context)!.settings.arguments as Payment;
          return PaymentDetailScreen(payment: payment);
        },
        'awaitingCheques': (context) => const AwaitingChequesScreen(),
        'customerDetail': (context) {
          final customer =
              ModalRoute.of(context)!.settings.arguments as Customer;

          return CustomerDetailScreen(
            customer: customer,
          );
        },
        'invoiceDetail': (context) {
          final args = ModalRoute.of(context)!.settings.arguments
              as Map<String, dynamic>;

          final invoice = args['invoice'] as Invoice;
          return InvoiceDetailsScreen(invoice: invoice);
        },
      },
      initialRoute: '/',
      debugShowCheckedModeBanner: false,
      title: 'YalaPay',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
    );
  }
}

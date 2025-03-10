import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const FirestoreTestApp());
}

class FirestoreTestApp extends StatelessWidget {
  const FirestoreTestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Firestore Test')),
        body: FirestoreTestWidget(),
      ),
    );
  }
}

class FirestoreTestWidget extends StatelessWidget {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  FirestoreTestWidget({super.key});

  Future<void> loadJsonFilesToFirestore() async {
    try {
      List<String> jsonFiles = [
        'assets/YalaPay-data/customers.json',
        'assets/YalaPay-data/invoices.json',
        'assets/YalaPay-data/payments.json',
        'assets/YalaPay-data/cheque-deposits.json',
      ];

      for (String filePath in jsonFiles) {
        String collectionName = filePath.split('/').last.split('.').first;
        String jsonString = await rootBundle.loadString(filePath);
        List<dynamic> jsonData = jsonDecode(jsonString);

        for (var item in jsonData) {
          String docId = item['id'];
          await firestore.collection(collectionName).doc(docId).set(item);
        }
      }
      print('data stored in firebase');
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: loadJsonFilesToFirestore,
        child: const Text('Initialize Firestore'),
      ),
    );
  }
}

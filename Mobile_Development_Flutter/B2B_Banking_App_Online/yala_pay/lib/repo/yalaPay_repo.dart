// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yala_pay/databse/bank_account_dao.dart';

import 'package:yala_pay/databse/return_reasons_dao.dart';
import 'package:yala_pay/models/bank_account.dart';
import 'package:yala_pay/models/cheque.dart';
import 'package:yala_pay/models/cheque_deposit.dart';
import 'package:yala_pay/models/customer.dart';
import 'package:yala_pay/models/invoice.dart';
import 'package:yala_pay/models/payment.dart';

import 'package:yala_pay/models/return_reason.dart';

class YalapayRepo {
  final BankAccountDao bankAccountDao;
  final ReturnReasonsDao returnReasonsDao;
  final CollectionReference chequesRef;
  final CollectionReference chequeDepositsRef;
  final CollectionReference invoicesRef;
  final CollectionReference customersRef;
  final CollectionReference paymentsRef;

  YalapayRepo(
      {required this.bankAccountDao,
      required this.returnReasonsDao,
      required this.chequesRef,
      required this.chequeDepositsRef,
      required this.invoicesRef,
      required this.customersRef,
      required this.paymentsRef});

  //Cheques

  Stream<List<Cheque>> observeCheques() {
    return chequesRef.snapshots().map((snapshot) => snapshot.docs
        .map((doc) => Cheque.fromJson(doc.data() as Map<String, dynamic>))
        .toList());
  }

  Future<void> addCheque(Cheque cheque) async {
    final docId = chequesRef.doc().id;
    cheque.chequeNumber = docId;
    await chequesRef.doc(docId).set(cheque.toJson());
  }

  //fixed
  Future<void> updateCheque(Cheque cheque) async {
    QuerySnapshot query = await chequesRef
        .where('chequeNumber', isEqualTo: cheque.chequeNumber)
        .get();
    for (var doc in query.docs) {
      await chequesRef.doc(doc.id).update(cheque.toJson());
    }
  }

  //fixed
  Future<void> deleteCheque(Cheque cheque) async {
    QuerySnapshot query = await chequesRef
        .where('chequeNumber', isEqualTo: cheque.chequeNumber)
        .get();
    for (var doc in query.docs) {
      await chequesRef.doc(doc.id).delete();
    }
  }

  Future<List<Cheque>> getChequesByDateAndStatus(
      DateTime fromDate, DateTime toDate, String status) async {
    final allCheques = await observeCheques().first;

    return allCheques.where((cheque) {
      final chequeDate = cheque.receivedDate;

      final isWithinDateRange =
          (chequeDate.isAfter(fromDate) && chequeDate.isBefore(toDate)) ||
              chequeDate.isAtSameMomentAs(fromDate) ||
              chequeDate.isAtSameMomentAs(toDate);

      final isStatusMatch = (status == 'All' || cheque.status == status);

      return isWithinDateRange && isStatusMatch;
    }).toList();
  }

  Future<List<Cheque>> getChequesByDateAndStatusFirestore(
      DateTime fromDate, DateTime toDate, String status) async {
    Query query = chequesRef;

    if (status.isNotEmpty) {
      query = query.where('status', isEqualTo: status);
    }

    query = query
        .where('dueDate', isGreaterThanOrEqualTo: fromDate.toIso8601String())
        .where('dueDate', isLessThanOrEqualTo: toDate.toIso8601String());

    QuerySnapshot snapshot = await query.get();
    return snapshot.docs
        .map((doc) => Cheque.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
  }

  Future<List<Cheque>> getAwaitingCheques() async {
    QuerySnapshot snapshot =
        await chequesRef.where('status', isEqualTo: 'Awaiting').get();
    return snapshot.docs
        .map((doc) => Cheque.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
  }

  Future<Cheque?> getChequeById(String id) async {
    QuerySnapshot snapshot =
        await chequesRef.where('chequeNo', isEqualTo: id).get();
    if (snapshot.docs.isNotEmpty) {
      return Cheque.fromJson(
          snapshot.docs.first.data() as Map<String, dynamic>);
    }
    return null;
  }

  //Bank Accounts and Return Reasons

  Future<void> deleteBankAccount(BankAccount account) =>
      bankAccountDao.deleteBankAccount(account);

  Future<BankAccount?> findBankAccountById(String id) =>
      bankAccountDao.findBankAccountById(id);

  Future<ReturnReason?> findReturnReason(int id) =>
      returnReasonsDao.findReturnReason(id);

  Future<void> addReturnReason(ReturnReason reason) =>
      returnReasonsDao.insertReturnReason(reason);

  Future<void> insertBankAccount(BankAccount account) =>
      bankAccountDao.insertBankAccount(account);

  Stream<List<BankAccount>> observeBankAccounts() =>
      bankAccountDao.observeBankAccounts();

  Future<void> updateBankAccount(BankAccount account) =>
      bankAccountDao.updateBankAccount(account);
  Stream<List<ReturnReason>> observeReturnReasons() =>
      returnReasonsDao.observeReturnReasons();

  //Cheque Deposits

  Future<void> addChequeDeposit(ChequeDeposit deposit) async {
    final docId = chequeDepositsRef.doc().id;
    deposit.id = docId;
    await chequeDepositsRef.doc(docId).set(deposit.toJson());
  }

  Stream<List<ChequeDeposit>> observeChequeDeposits() {
    return chequeDepositsRef.snapshots().map((snapshot) => snapshot.docs
        .map(
            (doc) => ChequeDeposit.fromJson(doc.data() as Map<String, dynamic>))
        .toList());
  }

  Future<void> createChequeDeposit(
      List<Cheque> selectedCheques, String? bankAccountId) async {
    final depositDate = DateTime.now();

    final newDeposit = ChequeDeposit(
      id: '0',
      cheques: selectedCheques.map((e) => e.chequeNumber).toList(),
      depositDate: depositDate,
      bankAccountId: bankAccountId ?? '',
      status: 'Deposited',
    );

    for (var cheque in selectedCheques) {
      cheque.depositCheque();
    }

    addChequeDeposit(newDeposit);
  }

  Future<void> updateChequeDepositStatus(
    String depositId,
    String status, {
    DateTime? cashedDate,
    DateTime? returnDate,
    String? returnReason,
  }) async {
    QuerySnapshot query =
        await chequeDepositsRef.where('id', isEqualTo: depositId).get();

    for (var doc in query.docs) {
      var deposit = ChequeDeposit.fromJson(doc.data() as Map<String, dynamic>);

      if (status.toLowerCase() == 'cashed') {
        deposit.status = 'Cashed';
        for (var chequeNumber in deposit.cheques) {
          var cheque = await getChequeById(chequeNumber);
          cheque?.cashCheque(cashedDate ?? DateTime.now());
          await updateCheque(cheque!);
        }
      } else if (status.toLowerCase() == 'returned') {
        deposit.status = 'Returned';
        for (var chequeNumber in deposit.cheques) {
          var cheque = await getChequeById(chequeNumber);
          cheque?.returnCheque(
              returnDate ?? DateTime.now(), returnReason ?? '');
          await updateCheque(cheque!);
        }
      }

      await chequeDepositsRef.doc(doc.id).update(deposit.toJson());
    }
  }

  //fixed
  Future<void> deleteChequeDeposit(int depositId) async {
    QuerySnapshot query =
        await chequeDepositsRef.where('id', isEqualTo: depositId).get();

    for (var doc in query.docs) {
      await chequeDepositsRef.doc(doc.id).delete();
    }
  }

  //Customers
  Stream<List<Customer>> observeCustomers() {
    return customersRef.snapshots().map((snapshot) => snapshot.docs
        .map((doc) => Customer.fromJson(doc.data() as Map<String, dynamic>))
        .toList());
  }

  //fixed
  Future<void> updateCustomer(Customer updatedCustomer) async {
    QuerySnapshot query = await customersRef
        .where('id', isEqualTo: updatedCustomer.customerId)
        .get();
    for (var doc in query.docs) {
      await customersRef.doc(doc.id).update(updatedCustomer.toJson());
    }
  }

  //fixed
  Future<void> deleteCustomer(String customerId) async {
    QuerySnapshot query =
        await customersRef.where('id', isEqualTo: customerId).get();
    for (var doc in query.docs) {
      await customersRef.doc(doc.id).delete();
    }
  }

  Future<int> generateCustomerId() async {
    QuerySnapshot snapshot = await customersRef.get();
    if (snapshot.docs.isEmpty) {
      return 1;
    } else {
      final ids =
          snapshot.docs.map((doc) => int.tryParse(doc.id) ?? 0).toList();
      return ids.reduce((a, b) => a > b ? a : b) + 1;
    }
  }

  Future<void> addCustomer(Customer customer) async {
    final docId = customersRef.doc().id;
    customer.customerId = docId;
    await customersRef.doc(docId).set(customer.toJson());
  }

  Future<Customer?> getCustomerById(String customerId) async {
    final snapshot = await customersRef.doc(customerId).get();
    if (snapshot.exists) {
      return Customer.fromJson(snapshot.data() as Map<String, dynamic>);
    }
    return null;
  }

  Future<List<Customer>> searchCustomers(String query) async {
    if (query.isEmpty) {
      final snapshot = await customersRef.get();
      return snapshot.docs
          .map((doc) => Customer.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    }

    final lowerQuery = query.toLowerCase();
    final snapshot = await customersRef.get();
    return snapshot.docs
        .map((doc) {
          final customer =
              Customer.fromJson(doc.data() as Map<String, dynamic>);
          final matches = customer.customerId.toString().contains(lowerQuery) ||
              customer.companyName.toLowerCase().contains(lowerQuery) ||
              customer.street.toLowerCase().contains(lowerQuery) ||
              customer.city.toLowerCase().contains(lowerQuery) ||
              customer.country.toLowerCase().contains(lowerQuery) ||
              customer.contactFirstName.toLowerCase().contains(lowerQuery) ||
              customer.contactLastName.toLowerCase().contains(lowerQuery) ||
              customer.contactMobile.toLowerCase().contains(lowerQuery) ||
              customer.contactEmail.toLowerCase().contains(lowerQuery);

          return matches ? customer : null;
        })
        .whereType<Customer>()
        .toList();
  }

  //invoices

  Stream<List<Invoice>> observeInvoices() {
    return invoicesRef.snapshots().map((snapshot) => snapshot.docs
        .map((doc) => Invoice.fromJson(doc.data() as Map<String, dynamic>))
        .toList());
  }

  Future<List<Invoice>> searchInvoices(String query) async {
    QuerySnapshot snapshot = await invoicesRef.get();
    if (snapshot.docs.isEmpty) {
      return <Invoice>[];
    }
    final searchQuery = query.toLowerCase();
    return snapshot.docs
        .map((doc) {
          final invoice = Invoice.fromJson(doc.data() as Map<String, dynamic>);
          final matches =
              invoice.invoiceNumber.toString().contains(searchQuery) ||
                  invoice.customerId.toString().contains(searchQuery);
          return matches ? invoice : null;
        })
        .whereType<Invoice>()
        .toList();
  }

  Future<void> addInvoice(Invoice invoice) async {
    final docId = invoicesRef.doc().id;
    invoice.invoiceNumber = docId;
    await invoicesRef.doc(docId).set(invoice.toJson());
  }

  //fixed
  Future<void> updateInvoice(Invoice updatedInvoice) async {
    QuerySnapshot query = await invoicesRef
        .where('id', isEqualTo: updatedInvoice.invoiceNumber)
        .get();
    for (var doc in query.docs) {
      await invoicesRef.doc(doc.id).update(updatedInvoice.toJson());
    }
  }

  //fixed
  Future<void> deleteInvoice(String invoiceNumber) async {
    QuerySnapshot query =
        await invoicesRef.where('id', isEqualTo: invoiceNumber).get();
    for (var doc in query.docs) {
      await invoicesRef.doc(doc.id).delete();
    }
    query =
        await paymentsRef.where('invoiceNo', isEqualTo: invoiceNumber).get();
    for (var doc in query.docs) {
      var pay = await paymentsRef.doc(doc.id).get();
      QuerySnapshot chequeQuery = await chequesRef
          .where('chequeNo', isEqualTo: pay.get('chequeNo'))
          .get();
      for (var chequeDoc in chequeQuery.docs) {
        await chequesRef.doc(chequeDoc.id).delete();
      }
      await paymentsRef.doc(doc.id).delete();
    }
  }

  Future<Invoice?> getInvoiceByNumber(int invoiceNumber) async {
    final snapshot = await invoicesRef.doc(invoiceNumber.toString()).get();
    if (snapshot.exists) {
      return Invoice.fromJson(snapshot.data() as Map<String, dynamic>);
    }
    return null;
  }

  Future<void> invoiceBalanceCalc() async {
    QuerySnapshot invoicesSnapshot = await invoicesRef.get();
    for (var doc in invoicesSnapshot.docs) {
      Invoice invoice = Invoice.fromJson(doc.data() as Map<String, dynamic>);
      List<Payment> payments =
          await getPaymentsByInvoice(invoice.invoiceNumber);
      invoice.calculateBalance(payments);
      await updateInvoice(invoice);
    }
  }

  Future<List<Invoice>> getInvoicesByDateAndStatus(
      DateTime fromDate, DateTime toDate, String status) async {
    QuerySnapshot snapshot = await invoicesRef.get();
    return snapshot.docs
        .map((doc) {
          final invoice = Invoice.fromJson(doc.data() as Map<String, dynamic>);
          final isWithinDateRange = invoice.invoiceDate.isAfter(fromDate) &&
              invoice.invoiceDate.isBefore(toDate);
          final isStatusMatch = (status == 'All' ||
              (status == 'Pending' && invoice.balance == invoice.amount) ||
              (status == 'Partially Paid' &&
                  invoice.balance > 0 &&
                  invoice.balance < invoice.amount) ||
              (status == 'Paid' && invoice.balance == 0));
          return isWithinDateRange && isStatusMatch ? invoice : null;
        })
        .whereType<Invoice>()
        .toList();
  }

  Future<List<Invoice>> getInvoicesByDateAndStatusFirestore(
      DateTime fromDate, DateTime toDate, String status) async {
    Query query = invoicesRef;

    if (status.isNotEmpty) {
      query = query.where('status', isEqualTo: status);
    }

    query = query
        .where('dueDate', isGreaterThanOrEqualTo: fromDate.toIso8601String())
        .where('dueDate', isLessThanOrEqualTo: toDate.toIso8601String());

    QuerySnapshot snapshot = await query.get();
    return snapshot.docs
        .map((doc) => Invoice.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
  }

  //Payments

  Stream<List<Payment>> observePayments() {
    return paymentsRef.snapshots().map((snapshot) => snapshot.docs
        .map((doc) => Payment.fromJson(doc.data() as Map<String, dynamic>))
        .toList());
  }

  Future<void> addPayment(Payment payment) async {
    final docId = paymentsRef.doc().id;
    payment.id = docId;
    await paymentsRef.doc(docId).set(payment.toJson());
  }

  //fixed
  Future<void> updatePayment(Payment updatedPayment) async {
    QuerySnapshot query =
        await paymentsRef.where('id', isEqualTo: updatedPayment.id).get();
    for (var doc in query.docs) {
      await paymentsRef.doc(doc.id).update(updatedPayment.toJson());
    }
  }

  //fixed
  Future<void> deletePayment(String paymentId) async {
    QuerySnapshot query =
        await paymentsRef.where('id', isEqualTo: paymentId).get();
    for (var doc in query.docs) {
      var pay = await paymentsRef.doc(doc.id).get();
      QuerySnapshot chequeQuery = await chequesRef
          .where('chequeNo', isEqualTo: pay.get('chequeNo'))
          .get();
      for (var chequeDoc in chequeQuery.docs) {
        await chequesRef.doc(chequeDoc.id).delete();
      }
      await paymentsRef.doc(doc.id).delete();
    }
  }

  Future<List<Payment>> getPaymentsByInvoice(String invoiceNo) async {
    QuerySnapshot snapshot =
        await paymentsRef.where('invoiceNo', isEqualTo: invoiceNo).get();
    return snapshot.docs
        .map((doc) => Payment.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
  }
}

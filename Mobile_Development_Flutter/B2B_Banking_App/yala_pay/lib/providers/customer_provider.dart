import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yala_pay/models/customer.dart';

class CustomerProvider extends Notifier<List<Customer>> {
  List<Customer> _allCustomers = [];
  bool _initialized = false;
  String _query = '';
  @override
  List<Customer> build() {
    if (!_initialized) {
      _initializeState();
    }
    return [];
  }

  void _initializeState() async {
    List<Customer> temp = [];
    var data =
        await rootBundle.loadString('assets/YalaPay-data/customers.json');
    var customersMap = jsonDecode(data);
    for (var customer in customersMap) {
      temp.add(Customer.fromJson(customer));
    }
    _allCustomers = temp;
    state = temp;
    _initialized = true;
  }

  String get query => _query;

  void customerSearch(String query) {
    _query = query;
    if (!_initialized) return;

    if (query.isEmpty) {
      state = _allCustomers;
    } else {
      final searchLower = query.toLowerCase();

      state = _allCustomers.where((customer) {
        return customer.customerId
                .toString()
                .contains(searchLower) || // Searching by ID
            customer.companyName
                .toLowerCase()
                .contains(searchLower) || // Searching by company name
            customer.street
                .toLowerCase()
                .contains(searchLower) || // Searching by street
            customer.city
                .toLowerCase()
                .contains(searchLower) || // Searching by city
            customer.country
                .toLowerCase()
                .contains(searchLower) || // Searching by country
            customer.contactFirstName
                .toLowerCase()
                .contains(searchLower) || // Searching by first name
            customer.contactLastName
                .toLowerCase()
                .contains(searchLower) || // Searching by last name
            customer.contactMobile
                .toLowerCase()
                .contains(searchLower) || // Searching by mobile
            customer.contactEmail
                .toLowerCase()
                .contains(searchLower); // Searching by email
      }).toList();
    }
  }

  void addCustomer(Customer customer) {
    final newCustomer = Customer(
      customerId: _generateCustomerId(),
      companyName: customer.companyName,
      street: customer.street,
      city: customer.city,
      country: customer.country,
      contactFirstName: customer.contactFirstName,
      contactLastName: customer.contactLastName,
      contactMobile: customer.contactMobile,
      contactEmail: customer.contactEmail,
    );
    state = [...state, newCustomer];
  }

  void updateCustomer(Customer updatedCustomer) {
    state = [
      for (final customer in state)
        if (customer.customerId == updatedCustomer.customerId)
          updatedCustomer
        else
          customer
    ];
  }

  void deleteCustomer(int customerId) {
    state =
        state.where((customer) => customer.customerId != customerId).toList();
  }

  Customer? getCustomerById(int customerId) {
    try {
      return state.firstWhere((customer) => customer.customerId == customerId);
    } catch (e) {
      return null;
    }
  }

  int _generateCustomerId() {
    if (state.isEmpty) {
      return 1;
    } else {
      return state
              .map((customer) => customer.customerId)
              .reduce((a, b) => a > b ? a : b) +
          1;
    }
  }
}

final customerNotifierProvider =
    NotifierProvider<CustomerProvider, List<Customer>>(
        () => CustomerProvider());

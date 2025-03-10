import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yala_pay/models/customer.dart';
import 'package:yala_pay/providers/repo_provider.dart';
import 'package:yala_pay/repo/yalapay_repo.dart';

class CustomerProvider extends AsyncNotifier<List<Customer>> {
  YalapayRepo? _repo;
  String _query = '';

  @override
  Future<List<Customer>> build() async {
    _repo = await ref.watch(yalaPayRepoProvider.future);

    _repo?.observeCustomers().listen((customers) {
      state = AsyncData(customers);
    }).onError((error) {
      print(error);
    });

    return [];
  }

  String get query => _query;

  Future<void> customerSearch(String query) async {
    _query = query;
    final results = await _repo?.searchCustomers(query);
    state = AsyncData(results!);
  }

  Future<void> addCustomer(Customer customer) async {
    await _repo?.addCustomer(customer);
  }

  Future<void> updateCustomer(Customer updatedCustomer) async {
    await _repo?.updateCustomer(updatedCustomer);
  }

  Future<void> deleteCustomer(String customerId) async {
    await _repo?.deleteCustomer(customerId.toString());
  }

  Future<Customer?> getCustomerById(int customerId) async {
    return await _repo?.getCustomerById(customerId.toString());
  }
}

final customerNotifierProvider =
    AsyncNotifierProvider<CustomerProvider, List<Customer>>(
  () => CustomerProvider(),
);
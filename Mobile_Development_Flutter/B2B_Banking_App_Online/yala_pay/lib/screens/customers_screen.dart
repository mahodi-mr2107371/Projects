import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yala_pay/models/customer.dart';
import 'package:yala_pay/providers/customer_provider.dart';
import 'package:yala_pay/utility/customer_tile.dart';

class CustomersScreen extends ConsumerStatefulWidget {
  const CustomersScreen({super.key});

  @override
  ConsumerState<CustomersScreen> createState() => _CustomersState();
}

class _CustomersState extends ConsumerState<CustomersScreen> {
  // ignore: prefer_final_fields
  TextEditingController _searchController = TextEditingController();
  bool showSearch = false;

  //dialog box for add and uodate of customers
  void _showCustomerDialog(BuildContext context, WidgetRef ref,
      {Customer? customer}) {
    final isEditing = customer != null;
    final id = customer?.customerId ?? "0";
    final companyNameController =
        TextEditingController(text: customer?.companyName ?? '');
    final streetController =
        TextEditingController(text: customer?.street ?? '');
    final cityController = TextEditingController(text: customer?.city ?? '');
    final countryController =
        TextEditingController(text: customer?.country ?? '');
    final firstNameController =
        TextEditingController(text: customer?.contactFirstName ?? '');
    final lastNameController =
        TextEditingController(text: customer?.contactLastName ?? '');
    final mobileController =
        TextEditingController(text: customer?.contactMobile ?? '');
    final emailController =
        TextEditingController(text: customer?.contactEmail ?? '');

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(isEditing ? 'Edit Customer' : 'Add Customer'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                    controller: companyNameController,
                    decoration:
                        const InputDecoration(labelText: 'Company Name')),
                TextField(
                    controller: streetController,
                    decoration: const InputDecoration(labelText: 'Street')),
                TextField(
                    controller: cityController,
                    decoration: const InputDecoration(labelText: 'City')),
                TextField(
                    controller: countryController,
                    decoration: const InputDecoration(labelText: 'Country')),
                TextField(
                    controller: firstNameController,
                    decoration:
                        const InputDecoration(labelText: 'Contact First Name')),
                TextField(
                    controller: lastNameController,
                    decoration:
                        const InputDecoration(labelText: 'Contact Last Name')),
                TextField(
                    controller: mobileController,
                    decoration: const InputDecoration(labelText: 'Mobile')),
                TextField(
                    controller: emailController,
                    decoration: const InputDecoration(labelText: 'Email')),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                // Create or update the customer
                final newCustomer = Customer(
                  customerId: isEditing
                      ? id
                      : "0", // Set to 0, as the provider generates the ID
                  companyName: companyNameController.text,
                  street: streetController.text,
                  city: cityController.text,
                  country: countryController.text,
                  contactFirstName: firstNameController.text,
                  contactLastName: lastNameController.text,
                  contactMobile: mobileController.text,
                  contactEmail: emailController.text,
                );

                if (isEditing) {
                  await ref
                      .read(customerNotifierProvider.notifier)
                      .updateCustomer(newCustomer);
                } else {
                  await ref
                      .read(customerNotifierProvider.notifier)
                      .addCustomer(newCustomer);
                }

                if(context.mounted) Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final customers = ref.watch(customerNotifierProvider);
    _searchController.text = ref.read(customerNotifierProvider.notifier).query;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(226, 149, 120, 1),
        title: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: showSearch
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 227, 186, 170),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: _searchController,
                          onChanged: (value) => ref
                              .read(customerNotifierProvider.notifier)
                              .customerSearch(_searchController.text),
                          onTapOutside: (event) =>
                              FocusScope.of(context).requestFocus(FocusNode()),
                          decoration: const InputDecoration(
                            hintText: 'Search...',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          showSearch = !showSearch;
                          //resetting the search
                          ref
                              .read(customerNotifierProvider.notifier)
                              .customerSearch('');
                        });
                      },
                      icon: const Icon(Icons.close, color: Colors.black),
                    ),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        onPressed: () {
                          _showCustomerDialog(context, ref);
                        },
                        icon: const Icon(Icons.person_add)),
                    const Text(
                      "Customers",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          showSearch = !showSearch;
                        });
                      },
                      icon: const Icon(Icons.search),
                    ),
                  ],
                ),
        ),
        centerTitle: true,
        elevation: 2,
      ),
      body: customers.value!.isEmpty
          ? Center(
              child: Text(
                'No customers found.',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey[600],
                ),
              ),
            )
          : Container(
              padding: const EdgeInsets.all(5),
              color: const Color(0xFFE0F7FA),
              height: MediaQuery.of(context).size.height * 0.8,
              child: ListView.builder(
                itemCount: customers.value!.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: CustomerTile(
                      customer: customers.value![index],
                      delete: () => ref
                          .read(customerNotifierProvider.notifier)
                          .deleteCustomer(customers.value![index].customerId),
                      edit: () {
                        _showCustomerDialog(context, ref,
                            customer: customers.value![index]);
                      },
                    ),
                  );
                },
              ),
            ),
    );
  }
}

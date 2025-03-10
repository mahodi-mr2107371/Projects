import 'package:flutter/material.dart';
import 'package:yala_pay/models/customer.dart';

class CustomerTile extends StatelessWidget {
  final Customer _customer;
  final VoidCallback _delete;
  final VoidCallback _edit;

  const CustomerTile({
    super.key,
    required Customer customer,
    required VoidCallback delete,
    required VoidCallback edit,
  })  : _customer = customer,
        _delete = delete,
        _edit = edit;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color.fromARGB(255, 243, 229, 248),
      shadowColor: Colors.grey.shade200,
      elevation: 5, // Increased elevation for better shadow effect
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      margin: EdgeInsets.zero, // Remove default Card margin
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            padding: EdgeInsets.zero, // Remove default padding
            backgroundColor: const Color.fromARGB(
                255, 243, 229, 248), // Set background color
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10), // Rounded corners
            ),
          ),
          onPressed: () {
            Navigator.of(context)
                .pushNamed('customerDetail', arguments: _customer);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Customer details with ID and Name
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "ID: ${_customer.customerId}",
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black54, // Softer color for ID
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "${_customer.contactFirstName} ${_customer.contactLastName}",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight:
                            FontWeight.bold, // Bold for better visibility
                        color: Colors.black87,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _customer.companyName,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black54, // Softer color for company name
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),

              // Edit and Delete icons
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blueAccent),
                    onPressed: _edit,
                    tooltip: 'Edit',
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.redAccent),
                    onPressed: _delete,
                    tooltip: 'Delete',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

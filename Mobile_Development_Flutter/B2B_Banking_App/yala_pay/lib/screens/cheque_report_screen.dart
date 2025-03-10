import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:yala_pay/models/cheque.dart';
import 'package:yala_pay/providers/cheque_status_provider.dart';
import 'package:yala_pay/providers/cheques_provider.dart';
import 'package:yala_pay/screens/cheque_detail_screen.dart';

class ChequeReportScreen extends ConsumerStatefulWidget {
  const ChequeReportScreen({super.key});

  @override
  ConsumerState<ChequeReportScreen> createState() => _ChequeReportScreenState();
}

class _ChequeReportScreenState extends ConsumerState<ChequeReportScreen> {
  DateTime fromDate = DateTime(2024, 10, 1);
  DateTime toDate = DateTime.now();
  List<String> statusOptions = [];
  String selectedStatus = 'All';

  List<Cheque> filteredCheques = [];

  // void _filterCheques() {
  //   filteredCheques = ref
  //       .read(chequesProvider.notifier)
  //       .getChequesByDateAndStatus(fromDate, toDate, selectedStatus);
  //   setState(() {});
  // }

  Map<String, int> get totals {
    return {
      'awaiting':
          filteredCheques.where((cheque) => cheque.status == 'Awaiting').length,
      'deposited': filteredCheques
          .where((cheque) => cheque.status == 'Deposited')
          .length,
      'cashed':
          filteredCheques.where((cheque) => cheque.status == 'Cashed').length,
      'returned':
          filteredCheques.where((cheque) => cheque.status == 'Returned').length,
      'total': filteredCheques.length,
    };
  }

  @override
  Widget build(BuildContext context) {
    final statusOptions = ref.watch(chequeStatusProviderNotifier);
    filteredCheques = ref
        .read(chequesProvider.notifier)
        .getChequesByDateAndStatus(fromDate, toDate, selectedStatus);
    return Scaffold(
      body: Container(
        color: const Color(0xFFE0F7FA),
        child: Column(
          children: [
            // Header Section
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFF8D1C1),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 1),
                    Row(
                      children: [
                        Expanded(
                          child: _buildDateField(
                            'From Date',
                            fromDate,
                            (date) {
                              setState(() =>
                                  fromDate = date ?? DateTime(2024, 1, 1));
                              // _filterCheques();
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildDateField(
                            'To Date',
                            toDate,
                            (date) {
                              setState(() => toDate = date ?? DateTime.now());
                              // _filterCheques();
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildStatusDropdown(statusOptions),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Cheques List
            Expanded(
              child: filteredCheques.isNotEmpty
                  ? ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: filteredCheques.length,
                      itemBuilder: (context, index) {
                        final cheque = filteredCheques[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ChequeDetailScreen(cheque: cheque),
                              ),
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 243, 229, 248),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.1),
                                  spreadRadius: 1,
                                  blurRadius: 2,
                                  offset: const Offset(0, 1),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Cheque No: ${cheque.chequeNumber}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        DateFormat('yyyy-MM-dd')
                                            .format(cheque.receivedDate),
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        'Amount: \$${cheque.amount.toStringAsFixed(2)}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Status: ${cheque.status}',
                                        style: TextStyle(
                                          color: _getStatusColor(cheque.status),
                                          fontSize: 14, fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('No Cheques found'),
                        TextButton(
                            onPressed: () {
                              setState(() {
                                filteredCheques = ref
                                    .read(chequesProvider.notifier)
                                    .getChequesByDateAndStatus(
                                        fromDate = DateTime(2024, 1, 1),
                                        toDate = DateTime.now(),
                                        selectedStatus = 'All');
                              });
                            },
                            child: const Text('Reload'))
                      ],
                    ),
            ),

            // Summary Section
            if (selectedStatus == 'All')
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Cheques Summary',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Awaiting: ${totals['awaiting']}'),
                            Text('Deposited: ${totals['deposited']}'),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Cashed: ${totals['cashed']}'),
                            Text('Returned: ${totals['returned']}'),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Total: ${totals['total']}'),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateField(
      String label, DateTime? value, Function(DateTime?) onChanged) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.055,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
      ),
      child: TextField(
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(fontSize: 14),
          border: InputBorder.none,
          contentPadding: EdgeInsets.zero,
        ),
        readOnly: true,
        style: const TextStyle(fontSize: 12),
        controller: TextEditingController(
          text: value != null ? DateFormat('yyyy-MM-dd').format(value) : '',
        ),
        onTap: () async {
          final pickedDate = await showDatePicker(
            context: context,
            initialDate: value ?? DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime(2101),
          );
          if (pickedDate != null) {
            onChanged(pickedDate);
          }
        },
      ),
    );
  }

  Widget _buildStatusDropdown(List<String> statusOptions) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.055,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
      ),
      child: DropdownButton<String>(
        isExpanded: true,
        hint: const Text('Status:'),
        value: selectedStatus,
        underline: Container(),
        items: ['All', ...statusOptions].map((String status) {
          return DropdownMenuItem(
            value: status,
            child: Text(
              status,
              style: const TextStyle(fontSize: 12),
            ),
          );
        }).toList(),
        onChanged: (String? newValue) {
          if (newValue != null) {
            setState(() => selectedStatus = newValue);
            // _filterCheques();
          }
        },
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Awaiting':
        return Colors.orange;
      case 'Deposited':
        return Colors.blue;
      case 'Cashed':
        return Colors.green;
      case 'Returned':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}

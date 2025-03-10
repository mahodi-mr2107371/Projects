import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yala_pay/providers/bank_account_provider.dart';
import 'package:yala_pay/providers/cheque_deposit_provider.dart';
import 'package:yala_pay/providers/cheques_provider.dart';

class AwaitingChequesScreen extends ConsumerStatefulWidget {
  const AwaitingChequesScreen({super.key});

  @override
  ConsumerState<AwaitingChequesScreen> createState() =>
      _AwaitingChequesScreenState();
}

class _AwaitingChequesScreenState extends ConsumerState<AwaitingChequesScreen> {
  bool? _select = false;
  List<bool?> _selectAwaitingRow = [];
  String? selectedAccount = '';

  @override
  Widget build(BuildContext context) {
    ref.watch(chequesProvider);
    final awaitingCheques = ref
        .read(chequesProvider)
        .where((c) => c.status.toLowerCase() == "awaiting")
        .toList();
    final bankAccounts = ref.read(bankAccountProvider);

    void deposit() {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Select Bank Account'),
            content: SizedBox(
              width: double.maxFinite,
              child: StatefulBuilder(
                builder: (context, setState) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      DropdownButton<String>(
                        value: bankAccounts.first.accountNumber,
                        hint: const Text('Choose a bank account'),
                        items: bankAccounts.map((account) {
                          return DropdownMenuItem<String>(
                            value: account.accountNumber,
                            child: Text(account.accountName),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedAccount = value!;
                          });
                        },
                      ),
                    ],
                  );
                },
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  if (selectedAccount != null) {
                    ref
                        .read(chequeDepositProvider.notifier)
                        .createChequeDeposit(
                            awaitingCheques
                                .asMap()
                                .entries
                                .where((e) => _selectAwaitingRow[e.key] == true)
                                .map((e) => e.value)
                                .toList(),
                            selectedAccount);

                    // Update lists to match new awaiting cheques
                    setState(() {
                      _select = false;
                      _selectAwaitingRow =
                          List.generate(awaitingCheques.length, (_) => false);
                    });

                    Navigator.of(context).pop();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Please select a bank account')),
                    );
                  }
                },
                child: const Text('Submit'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),
            ],
          );
        },
      );
    }

    _selectAwaitingRow = List.generate(
        awaitingCheques.length,
        (index) => _selectAwaitingRow.length > index
            ? _selectAwaitingRow[index]
            : false);

    List<DataColumn> awaitingColumnBuilder() {
      return [
        DataColumn(
          label: Checkbox(
            value: _select,
            onChanged: (value) => setState(() {
              _select = value;
              _selectAwaitingRow =
                  List.generate(awaitingCheques.length, (_) => value);
            }),
          ),
        ),
        const DataColumn(
          headingRowAlignment: MainAxisAlignment.center,
          label: Text('Drawer'),
        ),
        const DataColumn(
          headingRowAlignment: MainAxisAlignment.center,
          label: Text('Bank'),
        ),
        const DataColumn(
          headingRowAlignment: MainAxisAlignment.center,
          label: Text('Cheque ID'),
        ),
        const DataColumn(
          headingRowAlignment: MainAxisAlignment.center,
          label: Text('Date'),
        ),
        const DataColumn(
          headingRowAlignment: MainAxisAlignment.center,
          label: Text('Amount'),
        ),
        const DataColumn(
          headingRowAlignment: MainAxisAlignment.center,
          label: Text('Status'),
        ),
      ];
    }

    List<DataRow> awaitingRowBuilder = awaitingCheques.asMap().entries.map((e) {
      int index = e.key;
      var cheque = e.value;
      return DataRow(
        color: index % 2 == 0
            ? WidgetStatePropertyAll(Colors.grey[300])
            : const WidgetStatePropertyAll(Color.fromRGBO(237, 246, 249, 1)),
        cells: [
          DataCell(
            Checkbox(
              value: _selectAwaitingRow[index],
              onChanged: (value) {
                setState(() {
                  _selectAwaitingRow[index] = value;
                });
                value != false
                    ? _selectAwaitingRow.any((e) => e != value)
                        ? setState(() {
                            _select = false;
                          })
                        : setState(() {
                            _select = true;
                          })
                    : setState(() {
                        _select = false;
                      });
              },
            ),
          ),
          DataCell(Center(
            child: Text(cheque.drawer),
          )),
          DataCell(Center(
            child: Text(cheque.drawerBank),
          )),
          DataCell(Center(
            child: Text(cheque.chequeNumber.toString()),
          )),
          DataCell(Center(
            child: Row(
              children: [
                Text(
                    '${cheque.dueDate.day}/${cheque.dueDate.month}/${cheque.dueDate.year}('),
                Text(
                  '${cheque.dueDate.difference(DateTime.now()).inDays}',
                  style: TextStyle(
                      color: cheque.dueDate
                              .difference(DateTime.now())
                              .inDays
                              .isNegative
                          ? Colors.red
                          : Colors.green),
                ),
                const Text(")"),
              ],
            ),
          )),
          DataCell(Center(
            child: Text(cheque.amount.toStringAsFixed(2)),
          )),
          DataCell(Center(
            child: Text(cheque.status),
          )),
        ],
      );
    }).toList();

    void onItemSelected(int index) {
      switch (index) {
        case 0:
          // Call deposit method
          deposit();
          break;
        case 1:
          Navigator.of(context).pop();
          break;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Awaiting Cheques'),
        backgroundColor: const Color.fromRGBO(226, 149, 120, 1),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.add), label: "Deposit"),
          BottomNavigationBarItem(icon: Icon(Icons.cancel), label: "cancel"),
        ],
        onTap: onItemSelected,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black,
      ),
      body: SafeArea(
        child: SizedBox.expand(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: DataTable(
                columns: awaitingColumnBuilder(),
                rows: awaitingRowBuilder,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

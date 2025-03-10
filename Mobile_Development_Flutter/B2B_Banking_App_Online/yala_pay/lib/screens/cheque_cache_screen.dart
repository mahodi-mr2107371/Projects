import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yala_pay/models/cheque.dart';
import 'package:yala_pay/models/cheque_deposit.dart';
import 'package:yala_pay/providers/bank_account_provider.dart';
import 'package:yala_pay/providers/cheque_deposit_provider.dart';
import 'package:yala_pay/providers/cheques_provider.dart';
import 'package:yala_pay/providers/return_reason_provider.dart';
import 'package:yala_pay/utility/update_deposit_dialog.dart';

class ChequeCacheScreen extends ConsumerStatefulWidget {
  const ChequeCacheScreen({super.key});

  @override
  ConsumerState<ChequeCacheScreen> createState() => _ChequeCacheScreenState();
}

class _ChequeCacheScreenState extends ConsumerState<ChequeCacheScreen> {
  bool? _selectDeposits = false;
  List<bool?> _selectDepositRow = [];
  String? selectedAccount;

  @override
  Widget build(BuildContext context) {
    ref.watch(chequeDepositProvider);
    ref.watch(bankAccountProvider);
    ref.watch(returnReasonProvider);
    List<Cheque> cheques = ref.watch(chequesProvider).value!;
    List<ChequeDeposit> deposits = ref.watch(chequeDepositProvider).value!;
    // ignore: unused_local_variable

    void onUpdateButtonPressed() {
      // Get the selected deposits based on the checkboxes
      final selectedDeposits = deposits
          .asMap()
          .entries
          .where((e) => _selectDepositRow[e.key] == true)
          .map((e) => e.value)
          .toList();

      // If there are selected deposits, show the dialog
      if (selectedDeposits.isNotEmpty) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return UpdateDepositDialog(
              deposits: selectedDeposits, // Pass selected deposits
              reset: () {
                setState(() {
                  // Reset the selection state for all rows
                  _selectDeposits = false;
                  _selectDepositRow =
                      List.generate(deposits.length, (_) => false);
                });
              },
            );
          },
        );
      } else {
        // Show a snack bar if no deposits are selected
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Select a deposit to update')),
        );
      }
    }

    _selectDepositRow = List.generate(
        deposits.length,
        (index) => _selectDepositRow.length > index
            ? _selectDepositRow[index]
            : false);

    List<DataColumn> depositsColumnBuilder() {
      return [
        DataColumn(
          label: Checkbox(
            value: _selectDeposits,
            onChanged: (value) => setState(() {
              _selectDeposits = value;
              _selectDepositRow = List.generate(deposits.length, (_) => value);
            }),
          ),
        ),
        const DataColumn(
          headingRowAlignment: MainAxisAlignment.center,
          label: Text('Cheque Image'),
        ),
        const DataColumn(
          headingRowAlignment: MainAxisAlignment.center,
          label: Text('ID'),
        ),
        const DataColumn(
          headingRowAlignment: MainAxisAlignment.center,
          label: Text('Status'),
        ),
        const DataColumn(
          headingRowAlignment: MainAxisAlignment.center,
          label: Text('No. of cheques'),
        ),
        const DataColumn(
          headingRowAlignment: MainAxisAlignment.center,
          label: Text('Date'),
        ),
        const DataColumn(
          headingRowAlignment: MainAxisAlignment.center,
          label: Text('Amount'),
        ),
      ];
    }

    List<DataRow> depositsRowBuilder = deposits.asMap().entries.map((e) {
      int index = e.key;
      var deposit = e.value;
      return DataRow(
        color: index % 2 == 0
            ? WidgetStatePropertyAll(Colors.grey[300])
            : const WidgetStatePropertyAll(Color.fromRGBO(237, 246, 249, 1)),
        cells: [
          DataCell(
            Checkbox(
              value: _selectDepositRow[index],
              onChanged: (value) {
                setState(() {
                  _selectDepositRow[index] = value;
                });
                value != false
                    ? _selectDepositRow.any((e) => e != value)
                        ? setState(() {
                            _selectDeposits = false;
                          })
                        : setState(() {
                            _selectDeposits = true;
                          })
                    : setState(() {
                        _selectDeposits = false;
                      });
              },
            ),
          ),
          DataCell(
            Center(
              child: Wrap(
                children: deposit.cheques.map((chequeNumber) {
                  final cheque = cheques.firstWhere(
                    (c) => c.chequeNumber == chequeNumber,
                  );

                  return TextButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return Dialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.8,
                              height: MediaQuery.of(context).size.height * 0.6,
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Expanded(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: InteractiveViewer(
                                        boundaryMargin:
                                            const EdgeInsets.all(20),
                                        minScale: 0.5,
                                        maxScale: 4.0,
                                        child: Image.asset(
                                          'assets/YalaPay-data/cheques/${cheque.chequeImage}',
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pop(); // Close button
                                    },
                                    child: const Text('Close'),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                    child: Text(cheque.chequeImage),
                  );
                }).toList(),
              ),
            ),
          ),
          DataCell(Center(
            child: Text(deposit.id.toString()),
          )),
          DataCell(Center(
            child: Text(deposit.status),
          )),
          DataCell(Center(
            child: Text(deposit.cheques.length.toString()),
          )),
          DataCell(Center(
            child: Text(
                '${deposit.depositDate.day}/${deposit.depositDate.month}/${deposit.depositDate.year}'),
          )),
          DataCell(Center(
            child: Text(deposit.cheques
                .map((e) => ref
                    .read(chequesProvider)
                    .value!
                    .firstWhere((c) => c.chequeNumber == e)
                    .amount)
                .reduce((acc, numb) => acc + numb)
                .toString()),
          )),
        ],
      );
    }).toList();

    void onItemSelected(int index) {
      switch (index) {
        case 0:
          Navigator.of(context).pushNamed('awaitingCheques');
          break;
        case 1:
          onUpdateButtonPressed();
          break;
        case 2:
          setState(() {
            _selectDeposits = false;
          });
          _selectDepositRow.every((selection) => selection == false)
              ? ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Select a deposit')),
                )
              : deposits
                  .asMap()
                  .entries
                  .map((e) => e)
                  .where((e) => _selectDepositRow[e.key] == true)
                  .map((e) => e.value.id)
                  .forEach((id) => ref
                      .read(chequeDepositProvider.notifier)
                      .deleteChequeDeposit(id as int));
          break;
      }
    }

    return Scaffold(
      backgroundColor: const Color.fromRGBO(237, 246, 249, 1),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(226, 149, 120, 1),
        title: const Text('Deposited Cheques'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SizedBox.expand(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: DataTable(
                columns: depositsColumnBuilder(),
                rows: depositsRowBuilder,
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.add), label: "Add Deposit"),
          BottomNavigationBarItem(icon: Icon(Icons.edit), label: "Update"),
          BottomNavigationBarItem(icon: Icon(Icons.delete), label: "Delete"),
        ],
        onTap: onItemSelected,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yala_pay/models/cheque_deposit.dart';
import 'package:yala_pay/providers/cheque_deposit_provider.dart';
import 'package:yala_pay/providers/return_reason_provider.dart';

class UpdateDepositDialog extends ConsumerStatefulWidget {
  final List<ChequeDeposit> deposits; // Accepts a list of ChequeDeposit
  final VoidCallback reset; // Accepts a list of ChequeDeposit

  const UpdateDepositDialog(
      {super.key, required this.deposits, required this.reset});

  @override
  ConsumerState<UpdateDepositDialog> createState() =>
      _UpdateDepositDialogState();
}

class _UpdateDepositDialogState extends ConsumerState<UpdateDepositDialog> {
  String? selectedStatus;
  Map<int, String?> returnReasons = {};
  Map<int, DateTime?> returnDates = {}; // Store return dates for each cheque

  @override
  void initState() {
    super.initState();
    selectedStatus = "Cashed"; // Default status
    // Initialize return dates to today's date for all cheques
    for (var deposit in widget.deposits) {
      for (var chequeNumber in deposit.cheques) {
        returnDates[chequeNumber] = DateTime.now(); // Set to today
      }
    }
  }

  Future<void> _selectReturnDate(int chequeNumber) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: returnDates[chequeNumber] ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null && pickedDate != returnDates[chequeNumber]) {
      setState(() {
        returnDates[chequeNumber] = pickedDate; // Update return date
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(chequeDepositProvider);
    final returnReasonsList = ref.watch(returnReasonProvider);

    // Show a loading indicator if return reasons data is not yet available
    if (returnReasonsList.isEmpty) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: const Padding(
          padding: EdgeInsets.all(16),
          child: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        width: 400, // Adjust the width of the dialog
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Update Deposit Status",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            DropdownButton<String>(
              value: selectedStatus,
              items: const [
                DropdownMenuItem<String>(
                  value: "Cashed",
                  child: Text("Cashed", style: TextStyle(fontSize: 14)),
                ),
                DropdownMenuItem<String>(
                  value: "Cashed with Returns",
                  child: Text("Cashed with Returns",
                      style: TextStyle(fontSize: 14)),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  selectedStatus = value;
                  // Reset return dates if status changes
                  returnDates.clear();
                  // Initialize return dates to today's date for all cheques
                  for (var deposit in widget.deposits) {
                    for (var chequeNumber in deposit.cheques) {
                      returnDates[chequeNumber] =
                          DateTime.now(); // Set to today
                    }
                  }
                });
              },
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: widget.deposits.length,
                itemBuilder: (context, index) {
                  final deposit = widget.deposits[index];
                  return ExpansionTile(
                    title: Text("Deposit ID: ${deposit.id}",
                        style: const TextStyle(fontSize: 14)),
                    children: [
                      ...deposit.cheques.map((chequeNumber) {
                        return ListTile(
                          title: Text("Cheque #$chequeNumber",
                              style: const TextStyle(fontSize: 14)),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                               const SizedBox(height: 10),
                              GestureDetector(
                                onTap: () => _selectReturnDate(chequeNumber),
                                child: AbsorbPointer(
                                  child: TextField(
                                    decoration: const InputDecoration(
                                      labelText: "Return Date",
                                      hintText: "Tap to select a date",
                                      border: OutlineInputBorder(),
                                      suffixIcon: Icon(Icons.calendar_today),
                                    ),
                                    controller: TextEditingController(
                                      text: returnDates[chequeNumber] != null
                                          ? "${returnDates[chequeNumber]!.toLocal()}"
                                              .split(' ')[0]
                                          : "",
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8), // Space between fields
                              if (selectedStatus == "Cashed with Returns") ...[
                                DropdownButtonFormField<String>(
                                  isExpanded: true, // Make it take full width
                                  items: returnReasonsList.map((reason) {
                                    return DropdownMenuItem<String>(
                                      value: reason,
                                      child: Text(reason,
                                          style: const TextStyle(fontSize: 14)),
                                    );
                                  }).toList(),
                                  onChanged: (reason) {
                                    setState(() {
                                      returnReasons[chequeNumber] =
                                          reason; // Store selected reason
                                    });
                                  },
                                  value: returnReasons[chequeNumber],
                                  hint: const Text("Select Return Reason",
                                      style: TextStyle(fontSize: 14)),
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder()
                                      ),
                                ),
                              ],
                            ],
                          ),
                        );
                      }),
                    ],
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close button
                  },
                  child: const Text('Cancel', style: TextStyle(fontSize: 14)),
                ),
                TextButton(
                  onPressed: () {
                    // Check if all return dates are selected
                    bool isDateValid =
                        returnDates.values.every((date) => date != null);

                    if (selectedStatus == "Cashed with Returns") {
                      // If the status is "Cashed with Returns", also check if reasons are provided
                      bool areReasonsValid = returnReasons.values
                          .every((reason) => reason != null);
                      isDateValid = isDateValid && areReasonsValid;
                    }

                    if (!isDateValid) {
                      // Show a Snackbar to inform the user
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              "Please select all necessary dates and reasons before submitting."),
                        ),
                      );
                      return; // Stop execution if date is not valid
                    }

                    // Proceed with the updates if dates and reasons are valid
                    for (var deposit in widget.deposits) {
                      if (selectedStatus == "Cashed") {
                        ref
                            .read(chequeDepositProvider.notifier)
                            .updateChequeDepositStatus(
                              deposit.id,
                              "Cashed",
                              returnDate: returnDates[deposit.cheques
                                  .first], // Using the first cheque's return date
                              returnReason:
                                  null, // No return reason for cashed only
                            );
                      } else if (selectedStatus == "Cashed with Returns") {
                        for (var chequeNumber in deposit.cheques) {
                          DateTime? returnDate =
                              returnDates[chequeNumber] ?? DateTime.now();
                          ref
                              .read(chequeDepositProvider.notifier)
                              .updateChequeDepositStatus(
                                deposit.id,
                                "Returned",
                                returnDate: returnDate,
                                returnReason: returnReasons[chequeNumber] ?? '',
                              );
                        }
                      }
                    }
                    
                    widget.reset();
                    Navigator.of(context).pop();
                  },
                  child: const Text('Submit', style: TextStyle(fontSize: 14)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:moneytracker/hive/models/expenses_model.dart';
import 'package:moneytracker/hive/services/services.dart';
import 'package:moneytracker/providers/currency_service.dart';
import 'package:moneytracker/widgets/custom_flat_button.dart';
import 'package:moneytracker/widgets/custom_text_field.dart';
import 'package:moneytracker/widgets/snack_bar.dart';

class NewExpensesPage extends StatefulWidget {
  const NewExpensesPage({super.key});
  @override
  State<NewExpensesPage> createState() => _NewExpensesPage();
}

class _NewExpensesPage extends State<NewExpensesPage> {
  final _expensesPriceController = TextEditingController();
  final _expensesDateController = TextEditingController();
  final _expensesNoteController = TextEditingController(text: "");
  final _expensesWhatController = TextEditingController();

  @override
  void dispose() {
    _expensesPriceController.dispose();
    _expensesDateController.dispose();
    _expensesNoteController.dispose();
    _expensesWhatController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    Future<void> datePickerFunction () async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(3000)
    );
    if (picked != null) {
      setState(() {
        _expensesDateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }
    void addExpenseFunction() async {
      if (_expensesPriceController.text.isNotEmpty && _expensesDateController.text.isNotEmpty && _expensesWhatController.text.isNotEmpty) {
        ExpensesModel expense = ExpensesModel(what: _expensesWhatController.text.trim(), price: int.parse(_expensesPriceController.text), date: DateTime.parse(_expensesDateController.text), note: _expensesNoteController.text);
        await Services().addExpenses(expense);
        Snackbar.showSuccessSnack(context, "Expense added");
        Navigator.pop(context);
      } else {
        Snackbar.showErrorSnack(context, "Fields missing");
      }
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text("New Expense"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              CustomTextField(controller: _expensesWhatController, labelText: "What"),
              CustomTextField(controller: _expensesPriceController, labelText: "Price", format: FilteringTextInputFormatter.digitsOnly, type: TextInputType.number, suffixText: getCurrency(context)),
              CustomTextField(controller: _expensesDateController, labelText: "Date", prefixIcon: const Icon(Icons.calendar_today), readOnly: true, ontap: datePickerFunction),
              CustomTextField(controller: _expensesNoteController, labelText: "Note", minLines: 2, maxLines: 10, type: TextInputType.multiline, action: TextInputAction.newline,),
              customFlatButton(text: "Add to expenses", onClicked: addExpenseFunction)
            ],
          ),
        ),
      ),
    );
  }
}
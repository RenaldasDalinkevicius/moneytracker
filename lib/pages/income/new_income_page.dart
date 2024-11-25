// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:moneytracker/hive/models/income_model.dart';
import 'package:moneytracker/hive/services/services.dart';
import 'package:moneytracker/providers/currency_service.dart';
import 'package:moneytracker/widgets/custom_flat_button.dart';
import 'package:moneytracker/widgets/custom_text_field.dart';
import 'package:moneytracker/widgets/snack_bar.dart';

class NewIncomePage extends StatefulWidget {
  const NewIncomePage({super.key});
  @override
  State<NewIncomePage> createState() => _NewIncomePage();
}

class _NewIncomePage extends State<NewIncomePage> {
  final _incomeAmountController = TextEditingController();
  final _incomeDateController = TextEditingController();
  final _incomeNoteController = TextEditingController();
  final _incomeFromController = TextEditingController();

  @override
  void dispose() {
    _incomeAmountController.dispose();
    _incomeDateController.dispose();
    _incomeNoteController.dispose();
    _incomeFromController.dispose();
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
        _incomeDateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }
    void addIncomeFunction() {
      if (_incomeAmountController.text.isNotEmpty && _incomeDateController.text.isNotEmpty && _incomeFromController.text.isNotEmpty) {
        IncomeModel income = IncomeModel(from: _incomeFromController.text.trim(), amount: int.parse(_incomeAmountController.text), date: DateTime.parse(_incomeDateController.text), note: _incomeNoteController.text);
        Services().addIncome(income);
        Snackbar.showSuccessSnack(context, "Income added");
        Navigator.pop(context);
      } else {
        Snackbar.showErrorSnack(context, "Fields missing");
      }
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text("New income"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              CustomTextField(controller: _incomeFromController, labelText: "From where"),
              CustomTextField(controller: _incomeAmountController, labelText: "Amount", format: FilteringTextInputFormatter.digitsOnly, type: TextInputType.number, suffixText: getCurrency(context)),
              CustomTextField(controller: _incomeDateController, labelText: "Date", prefixIcon: const Icon(Icons.calendar_today), readOnly: true, ontap: datePickerFunction),
              CustomTextField(controller: _incomeNoteController, labelText: "Note", minLines: 2, maxLines: 10, type: TextInputType.multiline, action: TextInputAction.newline,),
              customFlatButton(text: "Add income", onClicked: addIncomeFunction)
            ],
          ),
        ),
      ),
    );
  }
}
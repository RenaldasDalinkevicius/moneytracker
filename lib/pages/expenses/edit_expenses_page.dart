// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:moneytracker/hive/models/expenses_model.dart';
import 'package:moneytracker/hive/services/services.dart';
import 'package:moneytracker/providers/currency_service.dart';
import 'package:moneytracker/widgets/custom_flat_button.dart';
import 'package:moneytracker/widgets/custom_list_tile.dart';
import 'package:moneytracker/widgets/custom_text_field.dart';
import 'package:moneytracker/widgets/snack_bar.dart';

class EditExpensesPage extends StatefulWidget {
  final int index;
  const EditExpensesPage({super.key, required this.index});

  @override
  State<EditExpensesPage> createState() => _EditExpensesPage();
}

class _EditExpensesPage extends State<EditExpensesPage> {
  bool isDeleting = false;
  Future openDialog(
      {required ExpensesModel model,
      required String title,
      TextInputFormatter? format,
      TextInputType? type,
      bool? readOnly,
      bool? forDate}) {
    final editController = TextEditingController();
    Future<void> datePickerFunction() async {
      DateTime? picked = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(3000));
      if (picked != null) {
        setState(() {
          editController.text = DateFormat('yyyy-MM-dd').format(picked);
        });
      }
    }

    void update({required ExpensesModel model, required String snackbarText}) {
      Services().updateExpenses(widget.index, model);
      Snackbar.showSuccessSnack(context, snackbarText);
      Navigator.pop(context);
    }

    if (title == "what") {
      editController.text = model.what;
    } else if (title == "price") {
      editController.text = model.price.toString();
    } else if (title == "date") {
      editController.text = DateFormat('yyyy-MM-dd').format(model.date);
    } else if (title == "note") {
      editController.text = model.note ?? "";
    }
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: CustomTextField(
            controller: editController,
            format: format,
            focus: true,
            hintText: title,
            type: type,
            readOnly: readOnly,
            ontap: (forDate ?? false) ? datePickerFunction : null),
        actions: [
          customFlatButton(
              text: "Update",
              onClicked: () async {
                if (editController.text.isNotEmpty) {
                  if (title == "what") {
                    ExpensesModel newModel = ExpensesModel(
                        what: editController.text,
                        price: model.price,
                        date: model.date,
                        note: model.note);
                    update(model: newModel, snackbarText: "Updated");
                  } else if (title == "price") {
                    ExpensesModel newModel = ExpensesModel(
                        what: model.what,
                        price: int.parse(editController.text),
                        date: model.date,
                        note: model.note);
                    update(model: newModel, snackbarText: "Updated");
                  } else if (title == "date") {
                    ExpensesModel newModel = ExpensesModel(
                        what: model.what,
                        price: model.price,
                        date: DateTime.parse(editController.text),
                        note: model.note);
                    update(model: newModel, snackbarText: "Updated");
                  } else if (title == "note") {
                    ExpensesModel newModel = ExpensesModel(
                        what: model.what,
                        price: model.price,
                        date: model.date,
                        note: editController.text);
                    update(model: newModel, snackbarText: "Updated");
                  }
                } else if (editController.text.isEmpty && title == "note") {
                  ExpensesModel newModel = ExpensesModel(
                      what: model.what,
                      price: model.price,
                      date: model.date,
                      note: editController.text);
                  update(model: newModel, snackbarText: "Updated");
                } else if (editController.text.isEmpty) {
                  Snackbar.showErrorSnack(context, "TextField empty");
                }
              })
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Services().getExpensesListenable(),
      builder: (context, box, _) {
        if (isDeleting) {
          return Container();
        }
        final ExpensesModel expense = box.getAt(widget.index)!;
        return Scaffold(
            appBar: AppBar(
              title: Text(expense.what),
              centerTitle: true,
              actions: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: IconButton(
                    icon: const Icon(Icons.delete),
                    tooltip: "Delete Expense",
                    onPressed: () => showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                              title: Text(expense.what),
                              content: const Text("Delete this expense?"),
                              actions: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: customFlatButton(
                                          text: "Yes",
                                          onClicked: () {
                                            Services()
                                                .deleteExpenses(widget.index);
                                            Snackbar.showSuccessSnack(
                                                context, "Deleted");
                                            setState(() {
                                              isDeleting = true;
                                            });
                                            Navigator.pop(context);
                                            Navigator.pop(context);
                                          }),
                                    ),
                                    Expanded(
                                      child: customFlatButton(
                                          text: "No",
                                          onClicked: () {
                                            Navigator.pop(context);
                                          }),
                                    )
                                  ],
                                )
                              ],
                            )),
                  ),
                )
              ],
            ),
            body: ListView(
              children: [
                customListTile(
                    title: expense.what,
                    subtitle: "What expense",
                    onClicked: () => openDialog(model: expense, title: "what"),
                    trailing: Icon(Icons.edit)),
                customListTile(
                    title:
                        "${expense.price.toString()} ${getCurrency(context)}",
                    subtitle: "Price",
                    onClicked: () => openDialog(
                        model: expense,
                        title: "price",
                        format: FilteringTextInputFormatter.digitsOnly,
                        type: TextInputType.number),
                    trailing: Icon(Icons.edit)),
                customListTile(
                    title: DateFormat('yyyy-MM-dd').format(expense.date),
                    subtitle: "Date",
                    onClicked: () => openDialog(
                        model: expense,
                        title: "date",
                        forDate: true,
                        readOnly: true),
                    trailing: Icon(Icons.edit)),
                customListTile(
                    title: expense.note ?? "",
                    subtitle: "Note",
                    onClicked: () => openDialog(model: expense, title: "note"),
                    trailing: Icon(Icons.edit))
              ],
            ));
      },
    );
  }
}

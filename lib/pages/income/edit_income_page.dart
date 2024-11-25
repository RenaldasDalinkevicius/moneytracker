// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:moneytracker/hive/models/income_model.dart';
import 'package:moneytracker/hive/services/services.dart';
import 'package:moneytracker/providers/currency_service.dart';
import 'package:moneytracker/widgets/custom_flat_button.dart';
import 'package:moneytracker/widgets/custom_list_tile.dart';
import 'package:moneytracker/widgets/custom_text_field.dart';
import 'package:moneytracker/widgets/snack_bar.dart';

class EditIncomePage extends StatefulWidget {
  final int index;
  const EditIncomePage({super.key, required this.index});

  @override
  State<EditIncomePage> createState() => _EditIncomePage();
}

class _EditIncomePage extends State<EditIncomePage> {
  bool isDeleting = false;
  Future openDialog(
      {required IncomeModel model,
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

    void update({required IncomeModel model, required String snackbarText}) {
      Services().updateIncome(widget.index, model);
      Snackbar.showSuccessSnack(context, snackbarText);
      Navigator.pop(context);
    }

    if (title == "from") {
      editController.text = model.from;
    } else if (title == "amount") {
      editController.text = model.amount.toString();
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
                  if (title == "from") {
                    IncomeModel newModel = IncomeModel(
                        from: editController.text,
                        amount: model.amount,
                        date: model.date,
                        note: model.note);
                    update(model: newModel, snackbarText: "Updated");
                  } else if (title == "amount") {
                    IncomeModel newModel = IncomeModel(
                        from: model.from,
                        amount: int.parse(editController.text),
                        date: model.date,
                        note: model.note);
                    update(model: newModel, snackbarText: "Updated");
                  } else if (title == "date") {
                    IncomeModel newModel = IncomeModel(
                        from: model.from,
                        amount: model.amount,
                        date: DateTime.parse(editController.text),
                        note: model.note);
                    update(model: newModel, snackbarText: "Updated");
                  } else if (title == "note") {
                    IncomeModel newModel = IncomeModel(
                        from: model.from,
                        amount: model.amount,
                        date: model.date,
                        note: editController.text);
                    update(model: newModel, snackbarText: "Updated");
                  }
                } else if (editController.text.isEmpty && title == "note") {
                  IncomeModel newModel = IncomeModel(
                      from: model.from,
                      amount: model.amount,
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
      valueListenable: Services().getIncomeListenable(),
      builder: (context, box, _) {
        if (isDeleting) {
          return Container();
        }
        final IncomeModel income = box.getAt(widget.index)!;
        return Scaffold(
            appBar: AppBar(
              title: Text(income.from),
              centerTitle: true,
              actions: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: IconButton(
                    icon: const Icon(Icons.delete),
                    tooltip: "Delete income",
                    onPressed: () => showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                              title: Text(income.from),
                              content: const Text("Delete this income?"),
                              actions: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: customFlatButton(
                                          text: "Yes",
                                          onClicked: () {
                                            Services()
                                                .deleteIncome(widget.index);
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
                    title: income.from,
                    subtitle: "Income from where?",
                    onClicked: () => openDialog(model: income, title: "from"),
                    trailing: Icon(Icons.edit)),
                customListTile(
                    title:
                        "${income.amount.toString()} ${getCurrency(context)}",
                    subtitle: "Amount",
                    onClicked: () => openDialog(
                        model: income,
                        title: "amount",
                        format: FilteringTextInputFormatter.digitsOnly,
                        type: TextInputType.number),
                    trailing: Icon(Icons.edit)),
                customListTile(
                    title: DateFormat('yyyy-MM-dd').format(income.date),
                    subtitle: "Date",
                    onClicked: () => openDialog(
                        model: income,
                        title: "date",
                        forDate: true,
                        readOnly: true),
                    trailing: Icon(Icons.edit)),
                customListTile(
                    title: income.note ?? "",
                    subtitle: "Note",
                    onClicked: () => openDialog(model: income, title: "note"),
                    trailing: Icon(Icons.edit))
              ],
            ));
      },
    );
  }
}

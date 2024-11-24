import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:moneytracker/hive/models/expenses_model.dart';
import 'package:moneytracker/hive/services/services.dart';
import 'package:moneytracker/pages/expenses/edit_expenses_page.dart';
import 'package:moneytracker/pages/expenses/new_expenses_page.dart';
import 'package:moneytracker/providers/currency_service.dart';
import 'package:moneytracker/widgets/app_bar.dart';
import 'package:moneytracker/widgets/custom_list_tile.dart';
import 'package:moneytracker/widgets/settings_drawer.dart';

class ExpensesPage extends StatefulWidget {
  const ExpensesPage({super.key});

  @override
  State<ExpensesPage> createState() => _ExpensesPageState();
}

class _ExpensesPageState extends State<ExpensesPage> {
  List<ExpensesModel> sortedList = [];
  int sortOption = 0;
  Icon getIcon(IconData icon) => Icon(icon, size: 20);
  final Map<int, int Function(ExpensesModel, ExpensesModel)> sortingMethods = {
    0: (a, b) => b.date.compareTo(a.date),
    1: (a, b) => a.date.compareTo(b.date),
    2: (a, b) => b.price.compareTo(a.price),
    3: (a, b) => a.price.compareTo(b.price)
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(title: "Expenses", context: context),
      drawer: const SettingsDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const NewExpensesPage())),
        child: const Icon(Icons.add),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
            child: PopupMenuButton<int>(
              splashRadius: 25,
              iconSize: 25,
              icon: const Icon(Icons.more_horiz),
              onSelected: (int value) {
                setState(() {
                  sortOption = value;
                });
              },
              itemBuilder: (BuildContext context) => [
                PopupMenuItem<int>(
                  value: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [Text("Date"), getIcon(Icons.arrow_upward)],
                  ),
                ),
                PopupMenuItem<int>(
                  value: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [Text("Date"), getIcon(Icons.arrow_downward)],
                  ),
                ),
                PopupMenuItem<int>(
                  value: 2,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [Text("Price"), getIcon(Icons.arrow_upward)],
                  ),
                ),
                PopupMenuItem<int>(
                  value: 3,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [Text("Price"), getIcon(Icons.arrow_downward)],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              child: FutureBuilder(
                  future: Services().getexpensesListenable(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (!snapshot.hasData) {
                      return const Center(child: Text("No expenses saved"));
                    }
                    return ValueListenableBuilder(
                      valueListenable: snapshot.data!,
                      builder: (context, box, _) {
                        final List<ExpensesModel> expenses = box.values.toList();
                        sortedList = List.from(expenses);
                        sortedList.sort(sortingMethods[sortOption]!);
                        return ListView.builder(
                          padding: EdgeInsets.only(bottom: kFloatingActionButtonMargin + 56),
                          shrinkWrap: true,
                          itemCount: sortedList.length,
                          itemBuilder: (context, index) {
                            final expense = sortedList[index];
                            final originalIndex =
                                box.values.toList().indexOf(expense);
                            return customListTile(
                              title:
                                  "${expense.price.toString()} ${getCurrency(context)}",
                              subtitle: expense.what,
                              trailing: Text(
                                  DateFormat('yyyy-MM-dd').format(expense.date)),
                              onClicked: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: ((context) => EditExpensesPage(
                                          index: originalIndex)))),
                            );
                          },
                        );
                      },
                    );
                  }),
            ),
          )
        ],
      ),
    );
  }
}

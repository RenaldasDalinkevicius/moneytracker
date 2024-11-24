// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:moneytracker/hive/models/expenses_model.dart';
import 'package:moneytracker/hive/models/income_model.dart';
import 'package:moneytracker/hive/services/services.dart';
import 'package:moneytracker/pages/expenses/edit_expenses_page.dart';
import 'package:moneytracker/pages/home/widgets/sf_cartesian_chart.dart';
import 'package:moneytracker/pages/home/widgets/sf_circular_chart.dart';
import 'package:moneytracker/pages/income/edit_income_page.dart';
import 'package:moneytracker/providers/currency_service.dart';
import 'package:moneytracker/widgets/app_bar.dart';
import 'package:moneytracker/widgets/custom_list_tile.dart';
import 'package:moneytracker/widgets/settings_drawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class TransactionModel {
  final String type;
  final int amount;
  final DateTime date;
  final String description;
  final int index;

  TransactionModel(
      {required this.type,
      required this.amount,
      required this.date,
      required this.description,
      required this.index});
}

class _HomePageState extends State<HomePage> {
  late List<ExpensesModel> expensesData;
  late List<IncomeModel> incomeData;
  late List<TransactionModel> recentTransactions;
  late bool initialised = false;

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  Future<void> fetchData() async {
    List<ExpensesModel> _expensesData = await Services().getExpenses();
    List<IncomeModel> _incomeData = await Services().getIncome();
    setState(() {
      expensesData = _expensesData;
      incomeData = _incomeData;
      recentTransactions = getRecentTransactions(
          incomeData: _incomeData, expensesData: _expensesData);
      initialised = true;
    });
  }

  List<TransactionModel> getRecentTransactions({
    required List<IncomeModel> incomeData,
    required List<ExpensesModel> expensesData,
  }) {
    final List<TransactionModel> allTransactions = [
      ...incomeData.asMap().entries.map((entry) => TransactionModel(
            type: 'Income',
            amount: entry.value.amount,
            date: entry.value.date,
            description: entry.value.from,
            index: entry.key,
          )),
      ...expensesData.asMap().entries.map((entry) => TransactionModel(
            type: 'Expense',
            amount: entry.value.price,
            date: entry.value.date,
            description: entry.value.what,
            index: entry.key,
          )),
    ];
    allTransactions.sort((a, b) => b.date.compareTo(a.date));
    return allTransactions.take(4).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context: context),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
          child: initialised
              ? expensesData.isNotEmpty || incomeData.isNotEmpty
                  ? Column(
                      children: [
                        sfCirculartChart(
                            expensesData: expensesData, incomeData: incomeData),
                        sfCartesianChart(
                            expensesData: expensesData, incomeData: incomeData),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text("Recent transactions")),
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: recentTransactions.length,
                          itemBuilder: (context, index) {
                            final transaction = recentTransactions[index];
                            return customListTile(
                                title:
                                    "${transaction.amount.toString()} ${getCurrency(context)}",
                                subtitle: transaction.type,
                                onClicked: () => {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                        builder: (context) =>
                                            transaction.type == 'Income'
                                                ? EditIncomePage(
                                                    index: transaction.index)
                                                : EditExpensesPage(
                                                    index: transaction.index),
                                      ))
                                    },
                                trailing: Text(DateFormat('yyyy-MM-dd')
                                    .format(transaction.date)));
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton.icon(
                                onPressed: () => Navigator.of(context)
                                    .pushNamed("/expenses"),
                                label: Text("Expenses"),
                                icon: Icon(Icons.attach_money),
                              ),
                              ElevatedButton.icon(
                                onPressed: () =>
                                    Navigator.of(context).pushNamed("/income"),
                                label: Text("Income"),
                                icon: Icon(Icons.shopping_cart),
                              )
                            ],
                          ),
                        )
                      ],
                    )
                  : Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Center(child: Text("Add income or expense to get started")),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton.icon(
                              onPressed: () =>
                                  Navigator.of(context).pushNamed("/expenses"),
                              label: Text("Expenses"),
                              icon: Icon(Icons.attach_money),
                            ),
                            ElevatedButton.icon(
                              onPressed: () =>
                                  Navigator.of(context).pushNamed("/income"),
                              label: Text("Income"),
                              icon: Icon(Icons.shopping_cart),
                            )
                          ],
                        ),
                      ],
                    )
              : Center(child: CircularProgressIndicator()),
        ),
      ),
      drawer: const SettingsDrawer(),
    );
  }
}

/*
// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:moneytracker/hive/models/expenses_model.dart';
import 'package:moneytracker/hive/models/income_model.dart';
import 'package:moneytracker/hive/services/services.dart';
import 'package:moneytracker/pages/expenses/edit_expenses_page.dart';
import 'package:moneytracker/pages/home/widgets/sf_cartesian_chart.dart';
import 'package:moneytracker/pages/home/widgets/sf_circular_chart.dart';
import 'package:moneytracker/pages/income/edit_income_page.dart';
import 'package:moneytracker/providers/currency_service.dart';
import 'package:moneytracker/widgets/app_bar.dart';
import 'package:moneytracker/widgets/custom_list_tile.dart';
import 'package:moneytracker/widgets/settings_drawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class TransactionModel {
  final String type;
  final int amount;
  final DateTime date;
  final String description;
  final int index;

  TransactionModel(
      {required this.type,
      required this.amount,
      required this.date,
      required this.description,
      required this.index});
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context: context),
      body: ValueListenableBuilder<ExpensesModel>(
        valueListenable: Services().getexpensesListenable(),
      ),
      drawer: const SettingsDrawer(),
    );
  }
}


/*
  late List<ExpensesModel> expensesData;
  late List<IncomeModel> incomeData;
  late List<TransactionModel> recentTransactions;
  late bool initialised = false;

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  Future<void> fetchData() async {
    List<ExpensesModel> _expensesData = await Services().getExpenses();
    List<IncomeModel> _incomeData = await Services().getIncome();
    setState(() {
      expensesData = _expensesData;
      incomeData = _incomeData;
      recentTransactions = getRecentTransactions(
          incomeData: _incomeData, expensesData: _expensesData);
      initialised = true;
    });
  }

  List<TransactionModel> getRecentTransactions({
    required List<IncomeModel> incomeData,
    required List<ExpensesModel> expensesData,
  }) {
    final List<TransactionModel> allTransactions = [
      ...incomeData.asMap().entries.map((entry) => TransactionModel(
            type: 'Income',
            amount: entry.value.amount,
            date: entry.value.date,
            description: entry.value.from,
            index: entry.key,
          )),
      ...expensesData.asMap().entries.map((entry) => TransactionModel(
            type: 'Expense',
            amount: entry.value.price,
            date: entry.value.date,
            description: entry.value.what,
            index: entry.key,
          )),
    ];
    allTransactions.sort((a, b) => b.date.compareTo(a.date));
    return allTransactions.take(4).toList();
  }
*/
*/
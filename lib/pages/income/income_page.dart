import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:moneytracker/hive/models/income_model.dart';
import 'package:moneytracker/pages/income/edit_income_page.dart';
import 'package:moneytracker/pages/income/new_income_page.dart';
import 'package:moneytracker/providers/currency_service.dart';
import 'package:moneytracker/widgets/app_bar.dart';
import 'package:moneytracker/widgets/custom_list_tile.dart';
import 'package:moneytracker/widgets/settings_drawer.dart';
import 'package:moneytracker/hive/services/services.dart';

class IncomePage extends StatefulWidget {
  const IncomePage({super.key});

  @override
  State<IncomePage> createState() => _IncomePageState();
}

class _IncomePageState extends State<IncomePage> {
  late List<IncomeModel> sortedList;
  int sortOption = 0;
  Icon getIcon(IconData icon) => Icon(icon, size: 20);
  final Map<int, int Function(IncomeModel, IncomeModel)> sortingMethods = {
    0: (a, b) => b.date.compareTo(a.date),
    1: (a, b) => a.date.compareTo(b.date),
    2: (a, b) => b.amount.compareTo(a.amount),
    3: (a, b) => a.amount.compareTo(b.amount)
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(title: "Income", context: context),
      drawer: const SettingsDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const NewIncomePage())),
        child: const Icon(Icons.add),
      ),
      body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
          child: ValueListenableBuilder(
            valueListenable: Services().getIncomeListenable(),
            builder: (context, box, _) {
              if (box.isEmpty) {
                return const Center(
                    child: Text(
                        "No income found, add income with the action button at the bottom right"));
              }
              final List<IncomeModel> expenses = box.values.toList();
              sortedList = List.from(expenses);
              sortedList.sort(sortingMethods[sortOption]!);
              return Column(
                children: [
                  Align(
                    alignment: Alignment.centerRight,
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
                            children: [
                              Text("Date"),
                              getIcon(Icons.arrow_upward)
                            ],
                          ),
                        ),
                        PopupMenuItem<int>(
                          value: 1,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Date"),
                              getIcon(Icons.arrow_downward)
                            ],
                          ),
                        ),
                        PopupMenuItem<int>(
                          value: 2,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Amount"),
                              getIcon(Icons.arrow_upward)
                            ],
                          ),
                        ),
                        PopupMenuItem<int>(
                          value: 3,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Amount"),
                              getIcon(Icons.arrow_downward)
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.only(
                          bottom: kFloatingActionButtonMargin + 56),
                      shrinkWrap: true,
                      itemCount: sortedList.length,
                      itemBuilder: (context, index) {
                        final income = sortedList[index];
                        final originalIndex =
                            box.values.toList().indexOf(income);
                        return customListTile(
                          title:
                              "${income.amount.toString()} ${getCurrency(context)}",
                          subtitle: income.from,
                          trailing: Text(
                              DateFormat('yyyy-MM-dd').format(income.date)),
                          onClicked: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: ((context) =>
                                      EditIncomePage(index: originalIndex)))),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          )),
    );
  }
}

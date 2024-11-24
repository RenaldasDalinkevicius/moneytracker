// ignore_for_file: camel_case_types, no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:moneytracker/hive/models/expenses_model.dart';
import 'package:moneytracker/hive/models/income_model.dart';
import 'package:moneytracker/pages/home/widgets/chart_data.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class sfCartesianChart extends StatefulWidget {
  const sfCartesianChart(
      {super.key, required this.expensesData, required this.incomeData});
  final List<ExpensesModel> expensesData;
  final List<IncomeModel> incomeData;

  @override
  State<sfCartesianChart> createState() => _sfCartesianChart();
}

class _sfCartesianChart extends State<sfCartesianChart> {
  late List<CartesianChartData> chartData = <CartesianChartData>[];
  List<int> availableYears = [];
  List<int> availableMonths = [];
  late int selectedYear;
  late int selectedMonth;
  @override
  void initState() {
    super.initState();
    availableYears = getUniqueYears();
    availableMonths = getUniqueMonthsForYear(availableYears.first);
    selectedYear = availableYears.first;
    selectedMonth = availableMonths.first;
    mergeIncomeAndExpenses(
      selectedYear,
      selectedMonth
    );
  }
  List<int> getUniqueYears() {
    Set<int> uniqueYears = {};
    for (IncomeModel income in widget.incomeData) {
      uniqueYears.add(income.date.year);
    }
    for (ExpensesModel expense in widget.expensesData) {
      uniqueYears.add(expense.date.year);
    }
    return uniqueYears.toList();
  }
    List<int> getUniqueMonthsForYear(int year) {
    Set<int> uniqueMonths = {};
    for (IncomeModel income in widget.incomeData) {
      if (income.date.year == year) {
        uniqueMonths.add(income.date.month);
      }
    }
    for (ExpensesModel expense in widget.expensesData) {
      if (expense.date.year == year) {
        uniqueMonths.add(expense.date.month);
      }
    }
    return uniqueMonths.toList();
  }
  void mergeIncomeAndExpenses(
    int _year,
    int _month) {
  Map<DateTime, CartesianChartData> chartMap = {};
  for (IncomeModel income in widget.incomeData) {
    if (income.date.year == _year && income.date.month == selectedMonth) {
      DateTime dateKey = DateTime(income.date.year, income.date.month);
      if (chartMap.containsKey(dateKey)) {
        chartMap[dateKey]!.income += income.amount;
      } else {
        chartMap[dateKey] = CartesianChartData(dateKey, income.amount, 0);
      }
    }
  }
  for (ExpensesModel expense in widget.expensesData) {
    if (expense.date.year == _year && expense.date.month == selectedMonth) {
      DateTime dateKey = DateTime(expense.date.year, expense.date.month);
      if (chartMap.containsKey(dateKey)) {
        chartMap[dateKey]!.expense += expense.price;
      } else {
        chartMap[dateKey] = CartesianChartData(dateKey, 0, expense.price);
      }
    }
  }
  setState(() {
    chartData = chartMap.values.toList();
  });
}
String formatLargeNumber(double value) {
    if (value >= 1e9) {
      return '${(value / 1e9).toStringAsFixed(1)}B';
    } else if (value >= 1e6) {
      return '${(value / 1e6).toStringAsFixed(1)}M';
    } else if (value >= 1e3) {
      return '${(value / 1e3).toStringAsFixed(1)}K';
    } else {
      return value.toStringAsFixed(0);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    PopupMenuButton<int>(
                      splashRadius: 25,
                      iconSize: 25,
                      icon: const Icon(Icons.more_horiz),
                      onSelected: (int year) {
                        setState(() {
                          selectedYear = year;
                          availableMonths = getUniqueMonthsForYear(year);
                          selectedMonth = availableMonths.first;
                          mergeIncomeAndExpenses(year, selectedMonth);
                        });
                      },
                      itemBuilder: (BuildContext context) {
                        return availableYears.map((int year) {
                          return PopupMenuItem<int>(
                            value: year,
                            child: Text(year.toString()),
                          );
                        }).toList();
                      },
                    ),
                    Text(selectedYear.toString()),
                  ],
                ),
                Column(
                  children: [
                    PopupMenuButton<int>(
                      splashRadius: 25,
                      iconSize: 25,
                      icon: const Icon(Icons.more_horiz),
                      onSelected: (int month) {
                        setState(() {
                          selectedMonth = month;
                          mergeIncomeAndExpenses(selectedYear, month);
                        });
                      },
                      itemBuilder: (BuildContext context) {
                        return availableMonths.map((int month) {
                          return PopupMenuItem<int>(
                            value: month,
                            child: Text(DateFormat.MMM().format(DateTime(0, month))),
                          );
                        }).toList();
                      },
                    ),
                    Text(DateFormat.MMMM().format(DateTime(0, selectedMonth))),
                  ],
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 25),
              child: SfCartesianChart(
                  primaryXAxis: CategoryAxis(),
                  primaryYAxis: NumericAxis(
                    axisLabelFormatter: (AxisLabelRenderDetails details) {
                      return ChartAxisLabel(
                        formatLargeNumber(details.value.toDouble()), const TextStyle()
                      );
                    },
                  ),
                  series: <CartesianSeries>[
                    ColumnSeries<CartesianChartData, String>(
                      dataSource: chartData,
                      color: Colors.redAccent,
                      dataLabelSettings: DataLabelSettings(isVisible: true),
                      spacing: 0.5,
                      dataLabelMapper:(CartesianChartData data, _) => formatLargeNumber(data.expense.toDouble()),
                      xValueMapper: (CartesianChartData data, _) =>
                        DateFormat.MMMM().format(data.date),
                      yValueMapper: (CartesianChartData data, _) =>
                        data.expense
                    ),
                    ColumnSeries<CartesianChartData, String>(
                      dataSource: chartData,
                      color: Colors.greenAccent,
                      dataLabelSettings: DataLabelSettings(isVisible: true),
                      spacing: 0.5,
                      dataLabelMapper:(CartesianChartData data, _) => formatLargeNumber(data.income.toDouble()),
                      xValueMapper: (CartesianChartData data, _) =>
                        DateFormat.MMMM().format(data.date),
                      yValueMapper: (CartesianChartData data, _) => data.income,
                    ),
                  ]),
            )
          ],
        ),
      ),
    );
  }
}

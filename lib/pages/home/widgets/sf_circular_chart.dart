// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:moneytracker/hive/models/expenses_model.dart';
import 'package:moneytracker/hive/models/income_model.dart';
import 'package:moneytracker/pages/home/widgets/chart_data.dart';
import 'package:moneytracker/providers/currency_service.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class sfCirculartChart extends StatefulWidget {
  const sfCirculartChart({super.key, required this.expensesData, required this.incomeData});
  final List<ExpensesModel> expensesData;
  final List<IncomeModel> incomeData;

  @override
  State<sfCirculartChart> createState() => _SfCirculartChart();
}

class _SfCirculartChart extends State<sfCirculartChart> {
  late int totalIncome = 0;
  late int totalExpenses = 0;
  final List<CircularChartData> chartData = [];

  @override
  void initState() {
    super.initState();
    updateArr();
  }

  Future<void> updateArr() async {
    for (ExpensesModel expense in widget.expensesData) {
      totalExpenses += expense.price;
    }
    for (IncomeModel income in widget.incomeData) {
      totalIncome += income.amount;
    }
    chartData.add(CircularChartData("Expenses", totalExpenses, Colors.redAccent));
    chartData.add(CircularChartData("Income", totalIncome, Colors.greenAccent));
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          SfCircularChart(
            annotations: <CircularChartAnnotation>[
              CircularChartAnnotation(
                  widget: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                          style: Theme.of(context).textTheme.bodyMedium,
                          text: "Total \n",
                          children: <TextSpan>[
                            TextSpan(
                                text: "${totalIncome - totalExpenses} ${getCurrency(context)}",
                                style: TextStyle(
                                    color: totalIncome < totalExpenses
                                        ? Colors.redAccent
                                        : Colors.greenAccent,
                                    fontWeight: FontWeight.bold))
                          ])))
            ],
            series: <CircularSeries>[
              RadialBarSeries<CircularChartData, String>(
                dataSource: chartData,
                xValueMapper: (CircularChartData data, _) => data.x,
                yValueMapper: (CircularChartData data, _) => data.y,
                pointColorMapper: (CircularChartData data, _) => data.color,
                innerRadius: "70%",
                cornerStyle: CornerStyle.bothCurve,
                trackOpacity: 0.1,
                maximumValue: (totalIncome >= totalExpenses
                    ? totalIncome.toDouble()
                    : totalExpenses.toDouble()),
                gap: "20%",
              )
            ],
          ),
          SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 25, horizontal: 25),
                  child: RichText(
                    text: TextSpan(text: "Total income: ", style: Theme.of(context).textTheme.bodyMedium,children: <TextSpan>[
                      TextSpan(
                          text: totalIncome.toString(),
                          style: TextStyle(color: Colors.greenAccent)),
                      TextSpan(text: " ${getCurrency(context)}")
                    ]),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 25, horizontal: 24),
                  child: RichText(
                    text:
                        TextSpan(text: "Total expenses: ", style: Theme.of(context).textTheme.bodyMedium, children: <TextSpan>[
                      TextSpan(
                          text: totalExpenses.toString(),
                          style: TextStyle(color: Colors.redAccent)),
                      TextSpan(text: " ${getCurrency(context)}")
                    ]),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

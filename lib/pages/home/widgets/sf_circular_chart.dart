// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:moneytracker/hive/models/expenses_model.dart';
import 'package:moneytracker/hive/models/income_model.dart';
import 'package:moneytracker/pages/home/widgets/chart_data.dart';
import 'package:moneytracker/providers/currency_service.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class sfCircularChart extends StatefulWidget {
  const sfCircularChart({super.key, required this.expensesData, required this.incomeData});
  final List<ExpensesModel> expensesData;
  final List<IncomeModel> incomeData;

  @override
  State<sfCircularChart> createState() => _SfCirculartChart();
}

class _SfCirculartChart extends State<sfCircularChart> {
  late int totalIncome;
  late int totalExpenses;

  @override
  void initState() {
    super.initState();
    calculateTotals();
  }

void calculateTotals() {
    totalExpenses = widget.expensesData.fold(0, (sum, expense) => sum + expense.price);
    totalIncome = widget.incomeData.fold(0, (sum, income) => sum + income.amount);
  }

  List<CircularChartData> get chartData {
    return [
      CircularChartData("Expenses", totalExpenses, Colors.redAccent),
      CircularChartData("Income", totalIncome, Colors.greenAccent),
    ];
  }

@override
  void didUpdateWidget(covariant sfCircularChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.expensesData != widget.expensesData || oldWidget.incomeData != widget.incomeData) {
      setState(() {
        calculateTotals();
      });
    }
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

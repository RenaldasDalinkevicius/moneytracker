import 'package:flutter/material.dart';

class CircularChartData {
  CircularChartData(this.x, this.y, this.color);
  final String x;
  final int y;
  final Color color;
}

class CartesianChartData {
  CartesianChartData(this.date, this.income, this.expense);
  DateTime date;
  int income;
  int expense;
}

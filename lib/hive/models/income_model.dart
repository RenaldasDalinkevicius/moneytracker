import 'package:hive/hive.dart';

part 'income_model.g.dart';

@HiveType(typeId: 1)
class IncomeModel {
  @HiveField(0)
  final String from;
  @HiveField(1)
  final int amount;
  @HiveField(2)
  final DateTime date;
  @HiveField(3)
  final String? note;
  IncomeModel({required this.from, required this.amount, required this.date, this.note});
}
import 'package:hive/hive.dart';

part 'expenses_model.g.dart';

@HiveType(typeId: 2)
class ExpensesModel {
  @HiveField(0)
  final String what;
  @HiveField(1)
  final int price;
  @HiveField(2)
  final DateTime date;
  @HiveField(3)
  final String? note;
  ExpensesModel({required this.what, required this.price, required this.date, this.note});
}
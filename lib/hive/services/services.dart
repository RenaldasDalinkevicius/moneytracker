import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:moneytracker/hive/models/expenses_model.dart';
import 'package:moneytracker/hive/models/income_model.dart';

class Services {
  final Box<IncomeModel> _incomeBox = Hive.box<IncomeModel>('income');
  final Box<ExpensesModel> _expensesBox = Hive.box<ExpensesModel>('expenses');

  void addIncome(IncomeModel incomeModel) {
    _incomeBox.add(incomeModel);
  }

  List<IncomeModel> getIncome() {
    return _incomeBox.values.toList();
  }

  ValueListenable<Box<IncomeModel>> getIncomeListenable() {
    return _incomeBox.listenable();
  }

  void updateIncome(int index, IncomeModel incomeModel) {
    _incomeBox.putAt(index, incomeModel);
  }

  void deleteIncome(int index) {
    _incomeBox.deleteAt(index);
  }

  void addExpenses(ExpensesModel expensesModel) {
    _expensesBox.add(expensesModel);
  }

  List<ExpensesModel> getExpenses() {
    return _expensesBox.values.toList();
  }

  ValueListenable<Box<ExpensesModel>> getExpensesListenable() {
    return _expensesBox.listenable();
  }

  void updateExpenses(int index, ExpensesModel expensesModel) {
    _expensesBox.putAt(index, expensesModel);
  }

  void deleteExpenses(int index) {
    _expensesBox.deleteAt(index);
  }
}

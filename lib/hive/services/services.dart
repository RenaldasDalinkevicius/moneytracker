import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:moneytracker/hive/models/expenses_model.dart';
import 'package:moneytracker/hive/models/income_model.dart';

class Services {
  final String _boxIncomeName = "income";
  final String _boxExpensesName = "expenses";
  Future<Box<IncomeModel>> get _boxIncome async =>
      await Hive.openBox<IncomeModel>(_boxIncomeName);
  Future<Box<ExpensesModel>> get _boxExpenses async =>
      await Hive.openBox<ExpensesModel>(_boxExpensesName);
  // Future for expenses need to make Model

  // Income
  Future<void> addIncome(IncomeModel incomeModel) async {
    var box = await _boxIncome;
    await box.add(incomeModel);
  }

  Future<List<IncomeModel>> getIncome() async {
    var box = await _boxIncome;
    return box.values.toList();
  }

  Future<ValueListenable<Box<IncomeModel>>> getincomeListenable() async {
    var box = await _boxIncome;
    return box.listenable();
  }

  Future<IncomeModel> getIncomeIndex(int index) async {
    var box = await _boxIncome;
    return box.getAt(index)!;
  }

  Future<void> updateIncome(int index, IncomeModel incomeModel) async {
    var box = await _boxIncome;
    await box.putAt(index, incomeModel);
  }

  Future<void> deleteIncome(int index) async {
    var box = await _boxIncome;
    await box.deleteAt(index);
  }

  // Expenses
  Future<void> addExpenses(ExpensesModel expensesModel) async {
    var box = await _boxExpenses;
    await box.add(expensesModel);
  }

  Future<List<ExpensesModel>> getExpenses() async {
    var box = await _boxExpenses;
    return box.values.toList();
  }

  Future<ValueListenable<Box<ExpensesModel>>> getexpensesListenable() async {
    var box = await _boxExpenses;
    return box.listenable();
  }

  Future<ExpensesModel> getExpensesIndex(int index) async {
    var box = await _boxExpenses;
    return box.getAt(index)!;
  }

  Future<void> updateExpenses(int index, ExpensesModel expensesModel) async {
    var box = await _boxExpenses;
    await box.putAt(index, expensesModel);
  }

  Future<void> deleteExpenses(int index) async {
    var box = await _boxExpenses;
    await box.deleteAt(index);
  }
}

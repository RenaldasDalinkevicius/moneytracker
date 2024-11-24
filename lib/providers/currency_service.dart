import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';


class CurrencyProvider extends ChangeNotifier {
  String _currency = 'Kr';
  String get currency => _currency;
  CurrencyProvider() {
    _loadCurrency();
  }
  Future<void> _loadCurrency() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _currency = prefs.getString('currency') ?? 'Kr';
    notifyListeners();
  }
  Future<void> setCurrency(String newCurrency) async {
    _currency = newCurrency;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('currency', newCurrency);
    notifyListeners();
  }
}
String getCurrency(BuildContext context) =>
    Provider.of<CurrencyProvider>(context, listen: false).currency;

void setCurrency(BuildContext context, String newCurrency) =>
    Provider.of<CurrencyProvider>(context, listen: false).setCurrency(newCurrency);
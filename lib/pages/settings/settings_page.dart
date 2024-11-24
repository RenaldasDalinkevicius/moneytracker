// ignore_for_file: use_build_context_synchronously

import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/material.dart';
import 'package:moneytracker/providers/currency_service.dart';
import 'package:moneytracker/widgets/snack_bar.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _ExpensesPageState();
}

class _ExpensesPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
        child: ListView(
          shrinkWrap: true,
          children: [
            Card(
              child: ListTile(
                title: Text("Currency"),
                subtitle: Text("Change currency"),
                trailing: Consumer<CurrencyProvider>(
                  builder: (context, currencyProvider, child) {
                    return Text(currencyProvider.currency);
                  },
                ),
                onTap: () => showCurrencyPicker(
                    context: context,
                    theme: CurrencyPickerThemeData(
                        flagSize: 20,
                        inputDecoration: InputDecoration(
                            labelText: "Search",
                            hintText: "Search for a currency",
                            prefix: const Icon(Icons.search))),
                    onSelect: (Currency currency) {
                      setCurrency(context, currency.symbol);
                      Snackbar.showSuccessSnack(context, "Currency changed");
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:moneytracker/hive/models/expenses_model.dart';
import 'package:moneytracker/hive/models/income_model.dart';
import 'package:moneytracker/pages/expenses/expenses_page.dart';
import 'package:moneytracker/pages/home/home_page.dart';
import 'package:moneytracker/pages/income/income_page.dart';
import 'package:moneytracker/providers/currency_service.dart';
import 'package:provider/provider.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(IncomeModelAdapter());
  Hive.registerAdapter(ExpensesModelAdapter());
  await Hive.openBox<IncomeModel>('income');
  await Hive.openBox<ExpensesModel>('expenses');
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => CurrencyProvider(),
        )
      ],
      child: MyApp(),
    )
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        "/": (context) => HomePage(),
        "/income": (context) => const IncomePage(),
        "/expenses": (context) => const ExpensesPage()
      },
      initialRoute: "/",
      title: "MoneyTracker",
      themeMode: ThemeMode.dark,
      theme: ThemeData.dark(
        useMaterial3: true
      )
    );
  }
}
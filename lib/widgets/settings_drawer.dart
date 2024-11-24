import 'package:flutter/material.dart';
import 'package:moneytracker/pages/settings/settings_page.dart';

class SettingsDrawer extends StatelessWidget {
  const SettingsDrawer({super.key});
  @override
  Widget build(BuildContext context) {
    Widget buildMenuItem({required String text, required IconData icon, VoidCallback? onClicked}) {
      return ListTile(
        leading: Icon(icon),
        title: Text(text),
        onTap: onClicked,
      );
    }
    selectedItem(BuildContext context, int i) {
      switch (i) {
        case 0:
          Navigator.of(context).pushNamed("/");
          break;
        case 1:
          Navigator.of(context).pushNamed("/income");
          break;
        case 2:
          Navigator.of(context).pushNamed("/expenses");
          break;
        case 3:
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const SettingsPage()
            )
          );
          break;
      }
    }
    return Drawer(
      child: Material(
        child: ListView(
          controller: ScrollController(),
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
          children: <Widget>[
            DrawerHeader(
              child: Center(child: Text("MoneyTracker")),
            ),
            buildMenuItem(text: "Home", icon: Icons.home, onClicked: () => selectedItem(context, 0)),
            buildMenuItem(text: "Income", icon: Icons.attach_money, onClicked: () => selectedItem(context, 1)),
            buildMenuItem(text: "Expenses", icon: Icons.shopping_cart, onClicked: () => selectedItem(context, 2)),
            Divider(thickness: 2),
            buildMenuItem(text: "Settings", icon: Icons.settings, onClicked: () => selectedItem(context, 3)),
          ],
        ),
      ),
    );
  }
}
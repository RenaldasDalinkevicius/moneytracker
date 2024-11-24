import 'package:flutter/material.dart';

Widget customListTile({required String title, required String subtitle, Widget? trailing, required VoidCallback onClicked, Color? backgroundColor}) {
  return Card(
    child: ListTile(
      tileColor: backgroundColor,
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: trailing,
      onTap: onClicked,
    ),
  );
}
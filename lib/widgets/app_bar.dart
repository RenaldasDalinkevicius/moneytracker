import 'package:flutter/material.dart';

AppBar customAppBar({String? title, controller, required BuildContext context}) {
  return AppBar(
    centerTitle: true,
    title: title!=null?Text(title):null,
    leading: Builder(
      builder: (BuildContext context) {
        return IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        );
      })
  );
}
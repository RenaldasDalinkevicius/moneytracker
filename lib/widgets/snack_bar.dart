import 'package:flutter/material.dart';

class Snackbar {
  static void showErrorSnack(BuildContext context, String errorMsg) {
    final snackbar = SnackBar(
      backgroundColor: Colors.red,
      content: Text(errorMsg),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }
  static void showSuccessSnack(BuildContext context, suncessMsg) {
    final snackbar = SnackBar(
      content: Text(
        suncessMsg
      )
    );
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }
}
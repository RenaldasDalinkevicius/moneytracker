import 'package:flutter/material.dart';

Padding customTextButton({required String text, required VoidCallback onClicked}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
    child: TextButton(
      onPressed: onClicked,
      style: TextButton.styleFrom(
        minimumSize: const Size.fromHeight(50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12)
        )
      ), child: Text(text),
    ),
  );
}
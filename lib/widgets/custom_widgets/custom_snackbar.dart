import 'package:flutter/material.dart';

class CustomSnackbar {
  static SnackBar show(BuildContext context, String text) {
    return SnackBar(
      content: Text(text),
      backgroundColor: Colors.green,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(16.0),
      duration: const Duration(seconds: 2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class CustomSnackbar {
  static SnackBar show(BuildContext context, String text) {
    return SnackBar(
      content: Row(
        children: [
          const Icon(Icons.check_circle, color: Colors.white),
          const SizedBox(width: 8.0),
          Expanded(child: Text(text)),
        ],
      ),
      backgroundColor: Colors.green.withOpacity(0.7), // Make background transparent
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(16.0),
      duration: const Duration(seconds: 2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 10,
      // action: SnackBarAction(
      //   label: 'UNDO',
      //   onPressed: () {
      //     // Add your undo action here
      //   },
      //   textColor: Colors.white,
      // ),
    );
  }

  static SnackBar showError(BuildContext context, String text) {
    return SnackBar(
      content: Row(
        children: [
          const Icon(Icons.error, color: Colors.white),
          const SizedBox(width: 8.0),
          Expanded(child: Text(text)),
        ],
      ),
      backgroundColor: Colors.red.withOpacity(0.7), // Make background transparent
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(16.0),
      duration: const Duration(seconds: 2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 10,
      // action: SnackBarAction(
      //   label: 'RETRY',
      //   onPressed: () {
      //     // Add your retry action here
      //   },
      //   textColor: Colors.white,
      // ),
    );
  }
}

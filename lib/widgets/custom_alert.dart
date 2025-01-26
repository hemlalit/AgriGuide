import 'package:AgriGuide/localization/locales.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';

class CustomDialog extends StatelessWidget {
  final VoidCallback onSure;
  final String title;

  const CustomDialog({required this.onSure, required this.title, super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(LocaleData.areYouSure.getString(context)),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
          child: Text(LocaleData.cancel.getString(context)),
        ),
        TextButton(
          onPressed: () async {
            onSure();
            Navigator.of(context).pop(); // Close the dialog
          },
          child: Text(LocaleData.yes.getString(context)),
        ),
      ],
    );
  }
}

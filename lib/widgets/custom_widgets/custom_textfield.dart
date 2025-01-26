import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  final IconData? icon;
  final String hint;
  final TextEditingController controller;
  final bool isPassword;
  final bool isPhone;
  final bool isEmail;
  final String? Function(String?)? validator;

  const CustomTextField({
    super.key,
    this.icon,
    required this.hint,
    required this.controller,
    this.isPassword = false,
    this.isPhone = false,
    this.isEmail = false,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      validator: validator,
      keyboardType: isPhone
          ? TextInputType.phone
          : isEmail
              ? TextInputType.emailAddress
              : null,
      inputFormatters: isPhone
          ? <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(10),
            ]
          : null,
      decoration: _inputDecoration(hint, icon),
    );
  }

  InputDecoration _inputDecoration(String label, IconData? icon) {
    return InputDecoration(
      prefixIcon: icon != null
          ? Icon(
              icon,
              color: Colors.green[700], // Icon color
            )
          : null, // No icon if not provided
      filled: true,
      fillColor: Colors.white,
      hintText: label,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30), // Set border radius here
        borderSide: const BorderSide(
          color: Colors.transparent, // Define color for the default border
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30), // Maintain rounded border
        borderSide: const BorderSide(
          color: Colors.black, // Color when field is focused
          width: 1.2345, // Border width when focused
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30), // Rounded border on error
        borderSide: const BorderSide(
          color: Colors.red, // Color on validation error
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30), // Maintain rounded border
        borderSide: const BorderSide(
          color: Colors.red, // Color when focused and error
          width: 1.2345,
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
    );
  }
}

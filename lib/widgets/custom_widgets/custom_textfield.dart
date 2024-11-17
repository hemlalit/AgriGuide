import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final IconData? icon;
  final String hint;
  final TextEditingController controller;
  final bool isPassword;
  final String? Function(String?)? validator;

  const CustomTextField({
    super.key,
    this.icon,
    required this.hint,
    required this.controller,
    this.isPassword = false,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      validator: validator,
      decoration: _inputDecoration(hint)
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
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
        borderRadius: BorderRadius.circular(30), // Maintain the rounded border when focused
        borderSide: const BorderSide(
          color: Colors.black, // Color when field is focused
          width: 1.2345 ,// Border width when focused
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30), // Rounded border on error
        borderSide: const BorderSide(
          color: Colors.red, // Color on validation error
          // Border width on error
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(
            30), // Maintain rounded border on focused error
        borderSide: const BorderSide(
          color: Colors.red, // Color when focused and error
          width: 1.2345,
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
    );
  }
}




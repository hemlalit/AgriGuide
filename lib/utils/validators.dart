class Validators {
  static String? validateEmail(String? value) {
    const emailPattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    } else if (!RegExp(emailPattern).hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    } else if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    return null;
  }

  static String? validatePhone(String? value) {
    const phonePattern = r'^\+?[0-9]{10,15}$'; // Allows numbers with or without a '+' prefix, between 10-15 digits
    if (value == null || value.isEmpty) {
      return 'Please enter your phone number';
    } else if (!RegExp(phonePattern).hasMatch(value)) {
      return 'Please enter a valid phone number';
    }
    return null;
  }
}

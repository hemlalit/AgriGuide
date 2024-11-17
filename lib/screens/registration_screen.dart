import 'package:AgriGuide/providers/auth_provider.dart';
import 'package:AgriGuide/widgets/custom_widgets/custom_snackbar.dart';
import 'package:AgriGuide/widgets/custom_widgets/custom_textfield.dart';
import 'package:AgriGuide/widgets/social_icons.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'login_screen.dart';
import '../utils/validators.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.green[700]!, Colors.green[400]!],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Register',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 40),
                      CustomTextField(
                        icon: Icons.person,
                        hint: "Full Name",
                        controller: _nameController,
                        validator: null,
                      ),
                      const SizedBox(height: 10),
                      CustomTextField(
                        icon: Icons.email,
                        hint: "Email",
                        controller: _emailController,
                        validator: Validators.validateEmail,
                      ),
                      const SizedBox(height: 10),
                      CustomTextField(
                        icon: Icons.email,
                        hint: "Phone",
                        controller: _phoneController,
                        validator: null,
                      ),
                      const SizedBox(height: 10),
                      CustomTextField(
                        icon: Icons.lock,
                        hint: "Password",
                        isPassword: true,
                        controller: _passwordController,
                        validator: Validators.validatePassword,
                      ),
                      const SizedBox(height: 40),
                      ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            bool isRegistered = await auth.register(
                              _nameController.text,
                              _emailController.text,
                              _phoneController.text,
                              _passwordController.text,
                            );

                            if (isRegistered) {
                              // Show success SnackBar
                              ScaffoldMessenger.of(context).showSnackBar(
                                CustomSnackbar.show(context, auth.message),
                              );

                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LoginScreen()),
                              );
                            } else {
                              // Show failure SnackBar
                              ScaffoldMessenger.of(context).showSnackBar(
                                CustomSnackbar.show(context, auth.errorMessage),
                              );
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            vertical: 15,
                            horizontal: 80,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          backgroundColor: Colors.white,
                          elevation: 5,
                        ),
                        child: Text(
                          'Register',
                          style: TextStyle(
                            color: Colors.green[700],
                            fontSize: 18,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => const LoginScreen()),
                          );
                        },
                        child: const Text('Already have an account? Login',
                            style: TextStyle(color: Colors.white)),
                      ),
                      const SizedBox(height: 20),
                      const SocialLoginButtons(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

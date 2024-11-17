import 'package:AgriGuide/providers/auth_provider.dart';
import 'package:AgriGuide/screens/home_screen.dart';
import 'package:AgriGuide/utils/validators.dart';
import 'package:AgriGuide/widgets/custom_widgets/custom_snackbar.dart';
import 'package:AgriGuide/widgets/social_icons.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'registration_screen.dart';
import '../widgets/custom_widgets/custom_textfield.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isLogin = true;
  final _formKey = GlobalKey<FormState>();

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
                        'Login',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 40),
                      CustomTextField(
                        icon: Icons.email,
                        hint: "Email",
                        validator: Validators.validateEmail,
                        controller: _emailController,
                      ),
                      const SizedBox(height: 20),
                      CustomTextField(
                        icon: Icons.lock,
                        hint: "Password",
                        isPassword: true,
                        validator: Validators.validatePassword,
                        controller: _passwordController,
                      ),
                      const SizedBox(height: 40),
                      ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            await auth.login(
                              _emailController.text,
                              _passwordController.text,
                            );

                            if (auth.isAuthenticated) {
                              // Show success SnackBar
                              ScaffoldMessenger.of(context).showSnackBar(
                                CustomSnackbar.show(context, auth.message),
                              );
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => HomeScreen(),
                                ),
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
                          'Login',
                          style: TextStyle(
                            color: Colors.green[700],
                            fontSize: 18,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const RegisterScreen()));
                        },
                        child: const Text(
                          'Don\'t have an account? Register',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const SocialLoginButtons()
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

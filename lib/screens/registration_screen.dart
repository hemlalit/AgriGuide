import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/custom_widgets/custom_snackbar.dart';
import '../widgets/custom_widgets/custom_textfield.dart';
import '../widgets/social_icons.dart';
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
          // Gradient Background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.lightGreen, Color.fromARGB(255, 1, 128, 5)],
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
                      // App Logo or Icon
                      Image.asset(
                        'assets/icons/app_logo1_wn.png',
                        height: 150,
                      ),
                      const Text(
                        'Create Your Account',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 40),

                      // Name TextField
                      CustomTextField(
                        icon: Icons.person,
                        hint: "Full Name",
                        controller: _nameController,
                        validator: null,
                      ),
                      const SizedBox(height: 15),

                      // Email TextField
                      CustomTextField(
                        icon: Icons.email,
                        hint: "Email",
                        controller: _emailController,
                        validator: Validators.validateEmail,
                      ),
                      const SizedBox(height: 15),

                      // Phone TextField
                      CustomTextField(
                        icon: Icons.phone,
                        hint: "Phone Number",
                        controller: _phoneController,
                        validator: Validators.validatePhone,
                      ),
                      const SizedBox(height: 15),

                      // Password TextField
                      CustomTextField(
                        icon: Icons.lock,
                        hint: "Password",
                        isPassword: true,
                        controller: _passwordController,
                        validator: Validators.validatePassword,
                      ),
                      const SizedBox(height: 40),

                      // Register Button
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
                              ScaffoldMessenger.of(context).showSnackBar(
                                CustomSnackbar.show(context, auth.message),
                              );

                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LoginScreen()),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                CustomSnackbar.show(context, auth.errorMessage),
                              );
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 80),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          backgroundColor: Colors.white,
                          elevation: 5,
                        ),
                        child: const Text(
                          'Sign Up',
                          style: TextStyle(
                            color: Color(0xFF56ab2f),
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Already Have Account
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => const LoginScreen()),
                          );
                        },
                        child: RichText(
                          text: const TextSpan(
                            text: 'Already have an account? ',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                            children: [
                              TextSpan(
                                text: 'Login',
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),

                      // Social Login Buttons
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

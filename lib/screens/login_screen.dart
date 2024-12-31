import 'package:AgriGuide/local_database/database_helper.dart';
import 'package:AgriGuide/providers/auth_provider.dart';
import 'package:AgriGuide/screens/home_screen/home_screen.dart';
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
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login(AuthProvider auth) async {
    setState(() {
      isLoading = true;
    });

    if (_formKey.currentState!.validate()) {
      await auth.login(
        _emailController.text,
        _passwordController.text,
      );

      if (auth.isAuthenticated) {
        // Reinitialize the database for the new user
        DatabaseHelper().resetDatabase();
        await DatabaseHelper().reinitializeDatabase();

        setState(() {
          isLoading = false;
        });

        // Show success SnackBar
        ScaffoldMessenger.of(context).showSnackBar(
          CustomSnackbar.show(context, auth.message),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          ),
        );
      } else {
        setState(() {
          isLoading = false;
        });
        // Show failure SnackBar
        ScaffoldMessenger.of(context).showSnackBar(
          CustomSnackbar.show(context, auth.errorMessage),
        );
      }
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.lightGreen,
                  Color.fromARGB(255, 1, 128, 5)
                ], // Trending colors
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/icons/app_logo1_wn.png',
                        height: 150,
                      ),
                      const Text(
                        'Welcome Back',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Login to your account',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white70,
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
                      isLoading
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : ElevatedButton(
                              onPressed: () async {
                                await _login(auth);
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
                              child: const Text(
                                'Login',
                                style: TextStyle(
                                  color: Color(0xFF56ab2f),
                                  fontWeight: FontWeight.bold,
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
                        child: RichText(
                          text: const TextSpan(
                            text: 'Don\'t have an account? ',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                            children: [
                              TextSpan(
                                text: 'Register',
                                style: TextStyle(
                                  color: Colors.blueAccent,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        ),
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

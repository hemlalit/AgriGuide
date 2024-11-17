import 'package:AgriGuide/providers/auth_provider.dart';
import 'package:AgriGuide/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late AnimationController _dotsController;
  late Animation<double> _dotsAnimation;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 3));
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _controller.forward();

    // Initialize dots animation
    _dotsController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1))
          ..repeat();
    _dotsAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_dotsController);

    // Simulate a delay
    Future.delayed(const Duration(seconds: 5), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => Consumer<AuthProvider>(
            builder: (context, auth, child) {
              print(auth.isAuthenticated);
              return auth.isAuthenticated ? HomeScreen() : const LoginScreen();
            },
          ),
        ),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _dotsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[700],
      body: Center(
        child: FadeTransition(
          opacity: _animation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.agriculture, size: 100, color: Colors.white),
              const SizedBox(height: 20),
              Text(
                'AgriGuide',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 60),
              AnimatedBuilder(
                animation: _dotsAnimation,
                builder: (context, child) {
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Dot(animation: _dotsAnimation, index: 0),
                      Dot(animation: _dotsAnimation, index: 1),
                      Dot(animation: _dotsAnimation, index: 2),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Dot extends StatelessWidget {
  final Animation<double> animation;
  final int index;

  const Dot({required this.animation, required this.index});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2.0),
      child: Opacity(
        opacity: (animation.value - index * 0.3).clamp(0.0, 1.0),
        child: const DotWidget(),
      ),
    );
  }
}

class DotWidget extends StatelessWidget {
  const DotWidget();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 10.0,
      width: 10.0,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

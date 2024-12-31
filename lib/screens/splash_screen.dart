import 'package:AgriGuide/providers/auth_provider.dart';
import 'package:AgriGuide/screens/home_screen/home_screen.dart';
import 'package:AgriGuide/utils/constants.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'login_screen.dart';

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
    _initializeAnimations();
    _startSplashScreenTimer(context);
  }

  void _initializeAnimations() {
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
  }

  void _startSplashScreenTimer(BuildContext context) {
    Future.delayed(const Duration(seconds: 5), () async {
      final storage = FlutterSecureStorage();
      final token = await storage.read(key: 'token');

      if (token != null) {
        try {
          // Provide your JWT secret key here
          final jwt = JWT.verify(token, SecretKey(jwtSecret));
          print('Token is valid: ${jwt.payload}');

          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => Consumer<AuthProvider>(
                builder: (context, auth, child) {
                  return auth.isAuthenticated
                      ? const HomeScreen()
                      : const LoginScreen();
                },
              ),
            ),
          );
        } on JWTExpiredException {
          print('Token has expired');
          // Handle token expiration, e.g., navigate to LoginScreen
          Navigator.of(context)
              .pushReplacement(
            MaterialPageRoute(
              builder: (context) => const LoginScreen(),
            ),
          )
              .then((_) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('You need to login again')),
            );
          });
        } on JWTException catch (ex) {
          print('Token verification error: $ex');
          // Handle token verification error
          Navigator.of(context)
              .pushReplacement(
            MaterialPageRoute(
              builder: (context) => const LoginScreen(),
            ),
          )
              .then((_) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Token verification failed')),
            );
          });
        }
      } else {
        // No token found, navigate to LoginScreen
        Navigator.of(context)
            .pushReplacement(
          MaterialPageRoute(
            builder: (context) => const LoginScreen(),
          ),
        )
            .then((_) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No token found. Please login')),
          );
        });
      }
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
      body: Stack(
        children: [
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
            child: FadeTransition(
              opacity: _animation,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/icons/app_logo1.png',
                  ),
                  // const SizedBox(height: 20),
                  // Text(
                  //   'AgriGuide',
                  //   style: GoogleFonts.poppins(
                  //     color: Colors.white,
                  //     fontSize: 28,
                  //     fontWeight: FontWeight.bold,
                  //   ),
                  // ),
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
        ],
      ),
    );
  }
}

class Dot extends StatelessWidget {
  final Animation<double> animation;
  final int index;

  const Dot({super.key, required this.animation, required this.index});

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
  const DotWidget({super.key});

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

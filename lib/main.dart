import 'package:AgriGuide/providers/news_provider.dart';
import 'package:AgriGuide/providers/profile_provider.dart';
import 'package:AgriGuide/providers/scheme_provider.dart';
import 'package:AgriGuide/providers/weather_provider.dart';
import 'package:AgriGuide/services/message_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'providers/expense_provider.dart';
import 'screens/splash_screen.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/registration_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ExpenseProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ChangeNotifierProvider(create: (_) => WeatherProvider()),
        ChangeNotifierProvider(create: (_) => NewsProvider()),
        ChangeNotifierProvider(create: (_) => SchemeProvider()),
      ],
      child: const AgriGuideApp(),
    ),
  );
}


class AgriGuideApp extends StatelessWidget {
  const AgriGuideApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AgriGuide',
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(),
        primaryColor: Colors.green[800],
        hintColor: Colors.green[600],
      ),
      scaffoldMessengerKey: MessageService.scaffoldMessengerKey,
      home: const SplashScreen(), // Show the splash screen initially
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => HomeScreen(),
      },
    );
  }
}

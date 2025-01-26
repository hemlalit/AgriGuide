import 'package:AgriGuide/firebase_options.dart';
import 'package:AgriGuide/notifications/local_notifications/local_notifications.dart';
import 'package:AgriGuide/notifications/local_notifications/notification_controller.dart';
import 'package:AgriGuide/localization/locales.dart';
import 'package:AgriGuide/providers/news_provider.dart';
import 'package:AgriGuide/providers/post_provider.dart';
import 'package:AgriGuide/providers/product_provider.dart';
import 'package:AgriGuide/providers/profile_provider.dart';
import 'package:AgriGuide/providers/scheme_provider.dart';
import 'package:AgriGuide/providers/theme_provider.dart';
import 'package:AgriGuide/providers/weather_provider.dart';
import 'package:AgriGuide/screens/notification_Screen/notification_screen.dart';
import 'package:AgriGuide/services/message_service.dart';
import 'package:AgriGuide/utils/theme.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'providers/expense_provider.dart';
import 'screens/splash_screen.dart';
import 'screens/home_screen/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/registration_screen.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //locale
  await FlutterLocalization.instance.ensureInitialized();
  //localNotifications
  // await LocalNotifications.init();
  // await LocalNotifications.requestNotificationPermission();

  // Initialize Awesome Notifications
  AwesomeNotifications().initialize(null, [
    NotificationChannel(
      channelKey: 'basic_channel',
      channelName: 'Basic notifications',
      channelDescription: 'Notification channel for basic tests',
      defaultColor: Colors.green,
      ledColor: Colors.green,
      importance: NotificationImportance.High,
    ),
    NotificationChannel(
      channelKey: 'periodic_channel',
      channelName: 'Periodic notifications',
      channelDescription: 'Notification channel for periodic tests',
      defaultColor: Colors.green,
      ledColor: Colors.green,
      importance: NotificationImportance.High,
    ),
    NotificationChannel(
      channelKey: 'scheduled_channel',
      channelName: 'Scheduled notifications',
      channelDescription: 'Notification channel for scheduled tests',
      defaultColor: Colors.green,
      ledColor: Colors.green,
      importance: NotificationImportance.High,
    ),
  ]);

  LocalNotifications.init();

  //timezone
  tz.initializeTimeZones();
  const String timeZoneName = 'Asia/Kolkata'; //Ensure correct timezone name
  tz.setLocalLocation(tz.getLocation(timeZoneName));

  //firebase init
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final themeProvider = ThemeProvider(
    themeMode: ThemeMode.light, // Default theme mode
  );
  await themeProvider.loadThemePreference();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ExpenseProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ChangeNotifierProvider(create: (_) => NewsProvider()),
        ChangeNotifierProvider(create: (_) => SchemeProvider()),
        ChangeNotifierProvider(create: (_) => TweetProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => themeProvider),
        ChangeNotifierProvider(create: (_) => WeatherSettingsProvider()),
      ],
      child: const AgriGuideApp(),
    ),
  );
}

class AgriGuideApp extends StatefulWidget {
  const AgriGuideApp({super.key});

  static _AgriGuideAppState? of(BuildContext context) =>
      context.findAncestorStateOfType<_AgriGuideAppState>();

  @override
  State<AgriGuideApp> createState() => _AgriGuideAppState();
}

class _AgriGuideAppState extends State<AgriGuideApp> {
  FlutterLocalization localization = FlutterLocalization.instance;

  @override
  void initState() {
    configureLocalization();
    AwesomeNotifications().setListeners(
      onActionReceivedMethod: NotificationController.onActionReceived,
      onNotificationCreatedMethod: NotificationController.onNotificationCreated,
      onDismissActionReceivedMethod:
          NotificationController.onDismissedActionReceived,
      onNotificationDisplayedMethod:
          NotificationController.onNotificationDisplayed,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return GetMaterialApp(
      title: 'AgriGuide',
      navigatorKey: navigatorKey,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeProvider.themeMode,
      scaffoldMessengerKey: MessageService.scaffoldMessengerKey,
      supportedLocales: localization.supportedLocales,
      localizationsDelegates: localization.localizationsDelegates,
      locale: localization.currentLocale,
      home: const SplashScreen(), // Show the splash screen initially
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const HomeScreen(),
        '/notification': (context) => const NotificationScreen(),
      },
    );
  }

  void configureLocalization() {
    localization.init(mapLocales: LOCALES, initLanguageCode: 'en');
    localization.onTranslatedLanguage = onTranslatedLanguage;
  }

  void onTranslatedLanguage(Locale? locale) {
    setState(() {});
  }
}

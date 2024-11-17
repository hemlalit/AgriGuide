import 'package:AgriGuide/screens/crop_care_screen.dart';
import 'package:AgriGuide/screens/feed_screen.dart';
import 'package:AgriGuide/screens/marketplace_screen.dart';
import 'package:AgriGuide/screens/notification_screen.dart';
import 'package:AgriGuide/screens/weather_screen.dart';
import 'package:AgriGuide/widgets/bottom_navbar.dart';
import 'package:AgriGuide/widgets/post_item.dart';
import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
import '../widgets/hamburger_menu.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  static final List<Widget> _screens = [
    HomeScreenContent(),
    const CropCareScreen(),
    const MarketplaceScreen(),
    WeatherScreen(),
    FeedScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  AppBar selectAppBar(int selectedIndex) {
    return AppBar(
      title: Center(
        child: Text(
          selectedIndex == 0
              ? "AgriGuide"
              : selectedIndex == 1
                  ? "Crop Care"
                  : selectedIndex == 2
                      ? "Marketplace"
                      : selectedIndex == 3
                          ? "Weather"
                          : "AgriFeed",
          style: const TextStyle(
            color: Color.fromARGB(255, 84, 135, 85),
            fontWeight: FontWeight.w500,
            fontSize: 30,
          ),
        ),
      ),
      elevation: 3,
      leading: Builder(
        builder: (context) => IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        ),
      ),
      actions: [
        selectedIndex == 0
            ? IconButton(
                icon: const Icon(Icons.notifications),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => NotificationScreen()),
                  );
                },
              )
            : const SizedBox(
                width: 12,
              )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: selectAppBar(_selectedIndex),
      drawer: const HamburgerMenu(),
      body: _screens[_selectedIndex], // Default content
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: _selectedIndex, // Default index
        onItemTapped: _onItemTapped,
      ),
    );
  }
}

class HomeScreenContent extends StatelessWidget {
  HomeScreenContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Column(
        children: [
          PostItem(
            profileImageUrl: '',
            username: 'hem',
            content: 'This is a tweet-like post!',
          ),
          PostItem(
            profileImageUrl: '',
            username: 'ram',
            content: 'Another amazing post!',
          ),
          PostItem(profileImageUrl: '', username: 'ron', content: 'content'),
          PostItem(
              profileImageUrl: '', username: 'username', content: 'content'),
          PostItem(
              profileImageUrl: '', username: 'username', content: 'content'),
        ],
      ),
    );
  }
}

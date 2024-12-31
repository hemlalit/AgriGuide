import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const CustomBottomNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
      index: selectedIndex,
      height: 60.0,
      items: const <Widget>[
        Icon(Icons.home, size: 30, color: Colors.white),
        Icon(Icons.local_florist, size: 30, color: Colors.white),
        Icon(Icons.store, size: 30, color: Colors.white),
        Icon(Icons.cloud, size: 30, color: Colors.white),
        Icon(Icons.forum, size: 30, color: Colors.white),
      ],
      color: Colors.green,
      buttonBackgroundColor: Colors.lightGreen,
      backgroundColor: Colors.white,
      animationCurve: Curves.easeInOut,
      animationDuration: const Duration(milliseconds: 600),
      onTap: onItemTapped,
      letIndexChange: (index) => true,
    );
  }
}

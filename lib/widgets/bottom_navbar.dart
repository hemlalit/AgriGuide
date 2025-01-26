import 'package:AgriGuide/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:provider/provider.dart';
import 'package:AgriGuide/providers/theme_provider.dart';

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
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    // Extract theme-specific styles
    final _NavigationTheme theme = _getNavigationTheme(isDarkMode);

    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
        // gradient: LinearGradient(
        //   colors: theme.gradientColors,
        //   begin: Alignment.topLeft,
        //   end: Alignment.bottomRight,
        // ),
      ),
      child: CurvedNavigationBar(
        index: selectedIndex,
        height: 60.0,
        items: <Widget>[
          Icon(Icons.home, size: 30, color: theme.iconColor),
          Icon(Icons.local_florist, size: 30, color: theme.iconColor),
          Icon(Icons.store, size: 30, color: theme.iconColor),
          Icon(Icons.cloud, size: 30, color: theme.iconColor),
          Icon(Icons.forum, size: 30, color: theme.iconColor),
        ],
        color: isDarkMode
            ? AppTheme.darkBtnColor
            : Colors.green, // Transparent to show the gradient
        buttonBackgroundColor: theme.buttonBackgroundColor,
        backgroundColor: theme.backgroundColor,
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(
            milliseconds: 500), // Slightly faster for better responsiveness
        onTap: onItemTapped,
        letIndexChange: (index) => true, // Allow all index changes
      ),
    );
  }

  /// Helper method to get theme-specific navigation styles
  _NavigationTheme _getNavigationTheme(bool isDarkMode) {
    return isDarkMode
        ? const _NavigationTheme(
            // gradientColors: [Colors.grey.shade800, Colors.black87],
            backgroundColor: Colors.transparent,
            buttonBackgroundColor: AppTheme.darkBtnColor,
            iconColor: Colors.white,
          )
        : const _NavigationTheme(
            // gradientColors: [Colors.lightGreen, Color.fromARGB(255, 1, 128, 5)],
            backgroundColor: Colors.transparent,
            buttonBackgroundColor: Colors.green,
            iconColor: Colors.black,
          );
  }
}

/// A class to encapsulate theme-specific navigation styles
class _NavigationTheme {
  // final List<Color> gradientColors;
  final Color backgroundColor;
  final Color buttonBackgroundColor;
  final Color iconColor;

  const _NavigationTheme({
    // required this.gradientColors,
    required this.backgroundColor,
    required this.buttonBackgroundColor,
    required this.iconColor,
  });
}

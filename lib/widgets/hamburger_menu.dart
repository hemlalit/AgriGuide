import 'dart:convert';

import 'package:AgriGuide/models/user_model.dart';
import 'package:AgriGuide/providers/auth_provider.dart';
import 'package:AgriGuide/screens/hamburger_menu/help_screen.dart';
import 'package:AgriGuide/screens/hamburger_menu/profile_screen.dart';
import 'package:AgriGuide/screens/hamburger_menu/settings_screen.dart';
import 'package:AgriGuide/screens/hamburger_menu/track_expense_screen.dart';
import 'package:AgriGuide/widgets/custom_widgets/custom_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class HamburgerMenu extends StatefulWidget {
  const HamburgerMenu({super.key});

  @override
  _HamburgerMenuState createState() => _HamburgerMenuState();
}

class _HamburgerMenuState extends State<HamburgerMenu> {
  static const storage = FlutterSecureStorage();
  late Future<User> userData;

  @override
  void initState() {
    super.initState();
    userData = _readUserData();
  }

  Future<User> _readUserData() async {
    final data = await storage.read(key: 'userData');
    if (data != null) {
      return User.fromJson(jsonDecode(data));
    } else {
      throw Exception('No user data found');
    }
  }

  void _shareApp() {
    Share.share(
      'Check out this amazing app: https://example.com',
      subject: 'AgriGuide App',
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    return Drawer(
      child: ListView(
        children: [
          FutureBuilder<User>(
            future: userData,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const DrawerHeader(
                  decoration: BoxDecoration(color: Colors.green),
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              if (snapshot.hasError) {
                return const DrawerHeader(
                  decoration: BoxDecoration(color: Colors.green),
                  child: Center(child: Text('Error loading user data')),
                );
              }
              if (!snapshot.hasData) {
                return const DrawerHeader(
                  decoration: BoxDecoration(color: Colors.green),
                  child: Center(child: Text('User data not found')),
                );
              }

              final user = snapshot.data!;
              return DrawerHeader(
                decoration: const BoxDecoration(color: Colors.green),
                child: Column(
                  children: [
                    CircleAvatar(
                      // backgroundImage: NetworkImage(''),
                      radius: 30,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      user.name,
                      style: const TextStyle(color: Colors.black, fontSize: 20),
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            Text(
                              'following',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 12),
                            ),
                            Text(
                              '0',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 12),
                            ),
                          ],
                        ),
                        SizedBox(width: 20),
                        Column(
                          children: [
                            Text(
                              'followers',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 12),
                            ),
                            Text(
                              '0',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 12),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
          ListTile(
            leading: const CustomIcon(
              icon: Icons.person,
              color: Colors.black,
            ),
            title: const Text('Profile'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfileScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: const CustomIcon(
              icon: Icons.settings,
              color: Colors.black,
            ),
            title: const Text('Settings'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SettingsScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: const CustomIcon(
              icon: Icons.account_balance_wallet,
              color: Colors.black,
            ),
            title: const Text('Track Expense'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TrackExpenseScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: const CustomIcon(
              icon: Icons.share,
              color: Colors.black,
            ),
            title: const Text('Share AgriGuide'),
            onTap: () {
              _shareApp();
            },
          ),
          ListTile(
            leading: const CustomIcon(
              icon: Icons.help,
              color: Colors.black,
            ),
            title: const Text('Help'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HelpScreen(),
                ),
              );
            },
          ),
          ListTile(
  leading: const CustomIcon(
    icon: Icons.logout,
    color: Colors.black,
  ),
  title: const Text('Logout'),
  onTap: () {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              auth.logout();
              Navigator.of(context).pushNamedAndRemoveUntil(
                '/login',
                (route) => false,
              );
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  },
)

        ],
      ),
    );
  }
}

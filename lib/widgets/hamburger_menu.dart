import 'package:AgriGuide/local_database/database_helper.dart';
import 'package:AgriGuide/localization/locales.dart';
import 'package:AgriGuide/providers/auth_provider.dart';
import 'package:AgriGuide/screens/hamburger_menu/help_screen.dart';
import 'package:AgriGuide/screens/hamburger_menu/profile_screen.dart';
import 'package:AgriGuide/screens/hamburger_menu/settings_screen.dart';
import 'package:AgriGuide/screens/hamburger_menu/track_expense_screen.dart';
import 'package:AgriGuide/utils/constants.dart';
import 'package:AgriGuide/utils/read_user_data.dart';
import 'package:AgriGuide/widgets/custom_widgets/custom_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class HamburgerMenu extends StatefulWidget {
  const HamburgerMenu({super.key});

  @override
  _HamburgerMenuState createState() => _HamburgerMenuState();
}

class _HamburgerMenuState extends State<HamburgerMenu> {
  void _shareApp() {
    Share.share(
      context.formatString(
          LocaleData.title.getString(context), ['https://example.com']),
      subject: LocaleData.subject.getString(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    return Drawer(
      child: FutureBuilder<Map<String, dynamic>?>(
        future: readUserData(context), // Use the utility method
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              padding: const EdgeInsets.all(16.0),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.lightGreen, Color.fromARGB(255, 1, 128, 5)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: const Center(child: CircularProgressIndicator()),
            );
          }
          if (snapshot.hasError) {
            return Container(
              padding: const EdgeInsets.all(16.0),
              color: Colors.red,
              child: const Center(child: Text('Error loading user data')),
            );
          }
          if (!snapshot.hasData) {
            return Container(
              padding: const EdgeInsets.all(16.0),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.lightGreen, Color.fromARGB(255, 1, 128, 5)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: const Center(child: Text('User data not found')),
            );
          }

          final user = snapshot.data!;
          // Provide default values to avoid null errors
          final userName = user['name'] ?? 'Unknown';
          final userId = user['_id'] ?? 'unknown';

          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.only(top: 50.0, bottom: 20.0),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.lightGreen,
                          Color.fromARGB(255, 1, 128, 5)
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Column(
                      children: [
                        const CircleAvatar(
                          radius: 30,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          userName,
                          style: const TextStyle(
                              color: Colors.black, fontSize: 20),
                        ),
                        const SizedBox(height: 10), // Reduced gap
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _UserStat(
                                label: LocaleData.following.getString(context),
                                count: '0'),
                            const SizedBox(width: 10), // Reduced gap
                            _UserStat(
                                label: LocaleData.followers.getString(context),
                                count: '0'),
                          ],
                        ),
                      ],
                    ),
                  ),
                  _buildMenuOption(
                    icon: Icons.person,
                    label: LocaleData.profile.getString(context),
                    onTap: () => _navigateTo(
                        context,
                        ProfileScreen(
                          id: userId,
                          isAnotherUser: false,
                        )),
                  ),
                  _buildMenuOption(
                    icon: Icons.account_balance_wallet,
                    label: LocaleData.trackEx.getString(context),
                    onTap: () =>
                        _navigateTo(context, const TrackExpenseScreen()),
                  ),
                  _buildMenuOption(
                    icon: Icons.settings,
                    label: LocaleData.settings.getString(context),
                    onTap: () => _navigateTo(context, const SettingsScreen()),
                  ),
                  _buildMenuOption(
                    icon: Icons.share,
                    label: LocaleData.shareApp.getString(context),
                    onTap: _shareApp,
                  ),
                  _buildMenuOption(
                    icon: Icons.help,
                    label: LocaleData.help.getString(context),
                    onTap: () => _navigateTo(context, HelpScreen()),
                  ),
                  _buildMenuOption(
                    icon: Icons.logout,
                    label: LocaleData.logout.getString(context),
                    onTap: () => _showLogoutDialog(context, auth),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(8.0), // Reduced padding
                child: Text(
                  context.formatString(LocaleData.version, [agriguideVersion]),
                  style: const TextStyle(
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.end,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildMenuOption(
      {required IconData icon,
      required String label,
      required VoidCallback onTap}) {
    return ListTile(
      dense: true, // Reduced vertical padding
      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
      leading: CustomIcon(icon: icon, color: Colors.black),
      title: Text(
        label,
        style: const TextStyle(fontSize: 16.0),
      ),
      onTap: onTap,
    );
  }

  void _navigateTo(BuildContext context, Widget screen) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
  }

  void _showLogoutDialog(BuildContext context, AuthProvider auth) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(LocaleData.logout.getString(context)),
        content: Text(LocaleData.areYouSure.getString(context)),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: Text(LocaleData.cancel.getString(context)),
          ),
          TextButton(
            onPressed: () async {
              // When the user logs out
              DatabaseHelper().resetDatabase();
              await auth.logout();
              if (!auth.isAuthenticated) {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil('/login', (route) => false);
              }
            },
            child: Text(LocaleData.yes.getString(context)),
          ),
        ],
      ),
    );
  }
}

class _UserStat extends StatelessWidget {
  final String label;
  final String count;

  const _UserStat({required this.label, required this.count});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Colors.black, fontSize: 12)),
        Text(count, style: const TextStyle(color: Colors.black, fontSize: 12)),
      ],
    );
  }
}

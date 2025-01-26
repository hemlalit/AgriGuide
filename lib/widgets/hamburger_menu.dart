import 'package:AgriGuide/local_database/database_helper.dart';
import 'package:AgriGuide/localization/locales.dart';
import 'package:AgriGuide/providers/auth_provider.dart';
import 'package:AgriGuide/providers/theme_provider.dart';
import 'package:AgriGuide/screens/hamburger_menu/help_screen.dart';
import 'package:AgriGuide/screens/hamburger_menu/profile_screen.dart';
import 'package:AgriGuide/screens/hamburger_menu/settings_screen.dart';
import 'package:AgriGuide/screens/hamburger_menu/track_expense_screen.dart';
import 'package:AgriGuide/utils/constants.dart';
import 'package:AgriGuide/utils/read_user_data.dart';
import 'package:AgriGuide/utils/theme.dart';
import 'package:AgriGuide/widgets/custom_alert.dart';
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
  Map<String, dynamic>? _userData;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    _userData = await readData(context, 'userData');
    setState(() {});
  }

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
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    final backgroundColor = isDarkMode ? AppTheme.darkCardColor : Colors.white;
    final gradientColors = isDarkMode
        ? const [Color.fromARGB(255, 0, 128, 0), Color.fromARGB(255, 0, 96, 0)]
        : [Colors.lightGreen, const Color.fromARGB(255, 1, 128, 5)];
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final iconColor = isDarkMode ? Colors.white : Colors.black;

    if (_userData == null) {
      return Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    final userName = _userData!['name'] ?? 'Unknown';
    final userId = _userData!['_id'] ?? 'unknown';

    return Drawer(
      backgroundColor: backgroundColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Container(
                padding: const EdgeInsets.only(top: 50.0, bottom: 20.0),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: gradientColors,
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
                      style: TextStyle(color: textColor, fontSize: 20),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _UserStat(
                            label: LocaleData.following.getString(context),
                            count: '0',
                            textColor: textColor),
                        const SizedBox(width: 10),
                        _UserStat(
                            label: LocaleData.followers.getString(context),
                            count: '0',
                            textColor: textColor),
                      ],
                    ),
                  ],
                ),
              ),
              _buildMenuOption(
                icon: Icons.person,
                label: LocaleData.profile.getString(context),
                iconColor: iconColor,
                textColor: textColor,
                onTap: () => _navigateTo(
                  context,
                  ProfileScreen(
                    id: userId,
                    isAnotherUser: false,
                  ),
                ),
              ),
              _buildMenuOption(
                icon: Icons.account_balance_wallet,
                label: LocaleData.trackEx.getString(context),
                iconColor: iconColor,
                textColor: textColor,
                onTap: () => _navigateTo(context, const TrackExpenseScreen()),
              ),
              _buildMenuOption(
                icon: Icons.settings,
                label: LocaleData.settings.getString(context),
                iconColor: iconColor,
                textColor: textColor,
                onTap: () => _navigateTo(context, const SettingsScreen()),
              ),
              _buildMenuOption(
                icon: Icons.share,
                label: LocaleData.shareApp.getString(context),
                iconColor: iconColor,
                textColor: textColor,
                onTap: _shareApp,
              ),
              _buildMenuOption(
                icon: Icons.help,
                label: LocaleData.help.getString(context),
                iconColor: iconColor,
                textColor: textColor,
                onTap: () => _navigateTo(context, HelpScreen()),
              ),
              _buildMenuOption(
                icon: Icons.logout,
                label: LocaleData.logout.getString(context),
                iconColor: iconColor,
                textColor: textColor,
                onTap: () => _showLogoutDialog(context, auth),
              ),
            ],
          ),
          Column(
            children: [
              _buildMenuOption(
                icon: Icons.sunny,
                label: 'Dark mode',
                iconColor: iconColor,
                textColor: textColor,
                trailing: Switch(
                  activeColor: Colors.green,
                  inactiveThumbColor: Colors.green,
                  value: themeProvider.isDarkMode,
                  onChanged: (value) => _toggleTheme(context, value),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  context.formatString(LocaleData.version, [agriguideVersion]),
                  style: TextStyle(fontSize: 12, color: textColor),
                  textAlign: TextAlign.end,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMenuOption({
    required IconData icon,
    required String label,
    required Color iconColor,
    required Color textColor,
    VoidCallback? onTap,
    Widget? trailing,
  }) {
    return ListTile(
      dense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
      leading: CustomIcon(icon: icon, color: iconColor),
      title: Text(
        label,
        style: TextStyle(fontSize: 16.0, color: textColor),
      ),
      onTap: onTap,
      trailing: trailing,
    );
  }

  void _navigateTo(BuildContext context, Widget screen) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
  }

  void _toggleTheme(BuildContext context, bool isDarkMode) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    themeProvider.toggleTheme(isDarkMode);
  }

  void _showLogoutDialog(BuildContext context, AuthProvider auth) {
    showDialog(
      context: context,
      builder: (context) => CustomDialog(
        title: LocaleData.logout.getString(context),
        onSure: () async {
          DatabaseHelper().resetDatabase();
          await auth.logout();
          if (!auth.isAuthenticated) {
            Navigator.of(context)
                .pushNamedAndRemoveUntil('/login', (route) => false);
          }
        },
      ),
    );
  }
}

class _UserStat extends StatelessWidget {
  final String label;
  final String count;
  final Color textColor;

  const _UserStat({
    required this.label,
    required this.count,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: TextStyle(color: textColor, fontSize: 12)),
        Text(count, style: TextStyle(color: textColor, fontSize: 12)),
      ],
    );
  }
}

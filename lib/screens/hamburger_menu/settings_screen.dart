import 'package:AgriGuide/utils/appColors.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool notificationsEnabled = true;
  String language = 'English';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        backgroundColor: AppColors.primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SwitchListTile(
              title: Text('Enable Notifications'),
              value: notificationsEnabled,
              activeColor: AppColors.primaryColor,
              onChanged: (value) {
                setState(() {
                  notificationsEnabled = value;
                });
              },
            ),
            ListTile(
              title: Text('Language'),
              subtitle: Text(language),
              onTap: () async {
                final selectedLanguage = await showDialog<String>(
                  context: context,
                  builder: (context) => LanguageSelectionDialog(),
                );
                if (selectedLanguage != null) {
                  setState(() {
                    language = selectedLanguage;
                  });
                }
              },
            ),
            ListTile(
              title: Text('Theme Color'),
              subtitle: Text('Choose theme color'),
              trailing: Icon(Icons.color_lens, color: AppColors.primaryColor),
              onTap: () {
                // Implement a color picker here
              },
            ),
          ],
        ),
      ),
    );
  }
}


class LanguageSelectionDialog extends StatelessWidget {
  const LanguageSelectionDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select Language'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: ['English', 'Marathi', 'Hindi'].map((lang) {
          return ListTile(
            title: Text(lang),
            onTap: () => Navigator.of(context).pop(lang),
          );
        }).toList(),
      ),
    );
  }
}

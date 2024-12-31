import 'package:AgriGuide/localization/locales.dart';
import 'package:AgriGuide/utils/appColors.dart';
import 'package:AgriGuide/utils/read_user_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final storage = const FlutterSecureStorage();
  bool notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleData.settings.getString(context)),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.lightGreen, Color.fromARGB(255, 1, 128, 5)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: FutureBuilder<String?>(
        future: readData(context, 'ln'),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            String? language = snapshot.data ?? 'English'; // Default to English if no data

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  SwitchListTile(
                    title: Text(LocaleData.enableNoti.getString(context)),
                    value: notificationsEnabled,
                    activeColor: AppColors.primaryColor,
                    onChanged: (value) {
                      setState(() {
                        notificationsEnabled = value;
                      });
                    },
                  ),
                  ListTile(
                    title: Text(LocaleData.language.getString(context)),
                    subtitle: Text(language),
                    onTap: () async {
                      final selectedLanguage = await showDialog<String>(
                        context: context,
                        builder: (context) => const LanguageSelectionDialog(),
                      );
                      if (selectedLanguage != null) {
                        await storage.write(key: 'ln', value: selectedLanguage);
                        setState(() {
                          language = selectedLanguage;
                        });
                      }
                    },
                  ),
                  ListTile(
                    title: Text(LocaleData.theme.getString(context)),
                    subtitle: Text(LocaleData.chooseThemeColor.getString(context)),
                    trailing:
                        const Icon(Icons.color_lens, color: AppColors.primaryColor),
                    onTap: () {
                      // Implement a color picker here
                    },
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

class LanguageSelectionDialog extends StatelessWidget {
  const LanguageSelectionDialog({super.key});

  @override
  Widget build(BuildContext context) {
    // Language options
    final List<Map<String, String>> languages = [
      {'name': 'English', 'locale': 'en'},
      {'name': 'मराठी', 'locale': 'mr'},
      {'name': 'हिंदी', 'locale': 'hi'},
    ];

    return AlertDialog(
      title: Text(LocaleData.selectLanguage.getString(context)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: languages.map((lang) {
          return ListTile(
            title: Text(lang['name'] as String), // Explicit type casting
            onTap: () {
              // Update the app's locale using GetX
              FlutterLocalization.instance.translate(lang['locale']!);
              Navigator.of(context).pop(lang['name']); // Close the dialog and return the language name
            },
          );
        }).toList(),
      ),
    );
  }
}

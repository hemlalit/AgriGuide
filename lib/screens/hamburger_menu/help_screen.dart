import 'package:AgriGuide/utils/appColors.dart';
import 'package:flutter/material.dart';

class HelpScreen extends StatelessWidget {
  final List<Map<String, String>> faqs = [
    {
      'question': 'How to use the app?',
      'answer': 'You can refer to the guide on the Home screen.'
    },
    {
      'question': 'How to track expenses?',
      'answer': 'Go to the "Track Expense" section from the menu.'
    },
    // Add more FAQs here
  ];

  HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help'),
        backgroundColor: AppColors.primaryColor,
      ),
      body: ListView.builder(
        itemCount: faqs.length,
        itemBuilder: (context, index) {
          return Card(
            color: AppColors.backgroundColor,
            child: ExpansionTile(
              title: Text(faqs[index]['question']!),
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(faqs[index]['answer']!),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

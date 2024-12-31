import 'package:AgriGuide/localization/locales.dart';
import 'package:AgriGuide/screens/crop_care/crop_recog_screen.dart';
import 'package:AgriGuide/screens/crop_care/dieases_recog_scree.dart';
import 'package:AgriGuide/screens/chatbot/chatbot_screen.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter_localization/flutter_localization.dart'; // Import this for Timer

class CropCareScreen extends StatelessWidget {
  const CropCareScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final buttonSize = screenWidth * 0.4;
    final padding = screenWidth * 0.03;

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSearchBar(),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: screenWidth * 0.05,
                mainAxisSpacing: screenWidth * 0.05,
                children: [
                  _buildAnimatedButton(
                    context,
                    LocaleData.cropIden.getString(context),
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const CropRecognitionScreen()),
                    ),
                    buttonSize,
                  ),
                  _buildAnimatedButton(
                    context,
                    LocaleData.dieasesIden.getString(context),
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const DieasesRecogScreen()),
                    ),
                    buttonSize,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ChatbotScreen()),
          );
        },
        child: const Icon(Icons.smart_toy), // Use a robot icon here
        backgroundColor: Colors.green,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30.0),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: const Row(
        children: [
          Icon(Icons.search, color: Colors.grey),
          SizedBox(width: 10),
          Expanded(
            child: TypingTextField(
              hintText: "Ask AGbot...",
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedButton(BuildContext context, String title, VoidCallback onTap, double buttonSize) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: buttonSize,
        height: buttonSize,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Colors.lightGreen, Colors.green],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.eco, size: 48, color: Colors.white), // Add an icon here
            const SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(fontSize: buttonSize * 0.1, color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class TypingTextField extends StatefulWidget {
  final String hintText;

  const TypingTextField({required this.hintText, Key? key}) : super(key: key);

  @override
  _TypingTextFieldState createState() => _TypingTextFieldState();
}

class _TypingTextFieldState extends State<TypingTextField> {
  late String displayedText;
  late Timer _timer;
  int _index = 0;
  bool _isTyping = true;

  @override
  void initState() {
    super.initState();
    displayedText = "";
    _timer = Timer.periodic(const Duration(milliseconds: 300), (timer) {
      setState(() {
        if (_index < widget.hintText.length) {
          displayedText += widget.hintText[_index];
          _index++;
        } else {
          _index = 0;
          displayedText = "";
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _stopTyping() {
    setState(() {
      _isTyping = false;
    });
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _stopTyping,
      child: _isTyping
          ? Text(
              displayedText,
              style: const TextStyle(color: Colors.grey),
            )
          : const TextField(
              autofocus: true,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Ask AGbot...",
                hintStyle: TextStyle(color: Colors.grey),
              ),
              style: TextStyle(color: Colors.black),
            ),
    );
  }
}

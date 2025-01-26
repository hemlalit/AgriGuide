import 'package:AgriGuide/localization/locales.dart';
import 'package:AgriGuide/providers/theme_provider.dart';
import 'package:AgriGuide/screens/crop_care/crop_recog_screen.dart';
import 'package:AgriGuide/screens/crop_care/dieases_recog_scree.dart';
import 'package:AgriGuide/screens/chatbot/chatbot_screen.dart';
import 'package:AgriGuide/utils/theme.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:provider/provider.dart';

class CropCareScreen extends StatelessWidget {
  const CropCareScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final buttonSize = screenWidth * 0.4;
    final padding = screenWidth * 0.03;

    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Padding(
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
                        MaterialPageRoute(
                          builder: (_) => const CropRecognitionScreen(),
                        ),
                      ),
                      buttonSize,
                    ),
                    _buildAnimatedButton(
                      context,
                      LocaleData.dieasesIden.getString(context),
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const DieasesRecogScreen(),
                        ),
                      ),
                      buttonSize,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return const SearchBar();
  }

  Widget _buildAnimatedButton(BuildContext context, String title,
      VoidCallback onTap, double buttonSize) {
    return AnimatedButton(
      title: title,
      onTap: onTap,
      buttonSize: buttonSize,
    );
  }
}

class AnimatedButton extends StatefulWidget {
  final String title;
  final VoidCallback onTap;
  final double buttonSize;

  const AnimatedButton({
    Key? key,
    required this.title,
    required this.onTap,
    required this.buttonSize,
  }) : super(key: key);

  @override
  _AnimatedButtonState createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    )..forward();
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _animation,
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          width: widget.buttonSize,
          height: widget.buttonSize,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Colors.lightGreen, Color.fromARGB(255, 1, 128, 5)],
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
              const Icon(Icons.eco,
                  size: 48, color: Colors.white), // Add an icon here
              const SizedBox(height: 10),
              Text(
                widget.title,
                style: TextStyle(
                    fontSize: widget.buttonSize * 0.1, color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SearchBar extends StatefulWidget {
  const SearchBar({super.key});

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  bool _isTyping = true;
  late String displayedText;
  late Timer _timer;
  int _index = 0;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    displayedText = "";
    _timer = Timer.periodic(const Duration(milliseconds: 400), (timer) {
      setState(() {
        if (_index < LocaleData.askAgbot.getString(context).length) {
          displayedText += LocaleData.askAgbot.getString(context)[_index];
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
    _controller.dispose();
    super.dispose();
  }

  void _stopTyping() {
    setState(() {
      _isTyping = false;
    });
    _timer.cancel();
  }

  void _sendMessage() {
    String message = _controller.text;
    if (message.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChatbotScreen(
            initialMessage: message,
          ), // Pass the initial message to ChatbotScreen
        ),
      );
      _controller.text = '';
    }
  }

  @override
  Widget build(BuildContext context) {
     final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      padding: EdgeInsets.symmetric(
          horizontal: 20.0, vertical: _isTyping ? 12.0 : 0.0),
      decoration: BoxDecoration(
        color: isDarkMode ? AppTheme.darkInputFill : Colors.white,
        borderRadius: BorderRadius.circular(30.0),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.search, color: Colors.grey),
          const SizedBox(width: 10),
          Expanded(
            child: GestureDetector(
              onTap: _stopTyping,
              child: _isTyping
                  ? Text(
                      displayedText,
                      style: const TextStyle(color: Colors.grey),
                    )
                  : TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: LocaleData.askAgbot.getString(context),
                        hintStyle: const TextStyle(color: Colors.grey),
                      ),
                      style: const TextStyle(color: Colors.black),
                      onEditingComplete: _sendMessage, // Handle Enter key
                    ),
            ),
          ),
          if (!_isTyping)
            IconButton(
              icon: const Icon(Icons.send, color: Colors.green),
              onPressed: _sendMessage,
            ),
        ],
      ),
    );
  }
}

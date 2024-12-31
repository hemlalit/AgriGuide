import 'package:AgriGuide/screens/chatBot/msg_bubble.dart';
import 'package:AgriGuide/screens/chatBot/msg_input.dart';
import 'package:flutter/material.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final List<Map<String, String>> _messages = [];

  void _sendMessage(String message) async {
    setState(() {
      _messages.add({'user': message});
    });

    // Simulate API call
    final botResponse = await Future.delayed(
      const Duration(seconds: 1),
      () => "This is a bot response for: $message",
    );

    setState(() {
      _messages.add({'bot': botResponse});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AppBar(
          title: const Text('AGbot', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Color(0xFFE0FFE5)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                reverse: true,
                itemCount: _messages.length,
                itemBuilder: (ctx, index) {
                  final message = _messages[_messages.length - 1 - index];
                  final isUserMessage = message.containsKey('user');
                  return MessageBubble(
                    message: isUserMessage ? message['user']! : message['bot']!,
                    isUser: isUserMessage,
                  );
                },
              ),
            ),
            MessageInput(onSend: _sendMessage),
          ],
        ),
      ),
    );
  }
}
